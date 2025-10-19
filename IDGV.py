import json
import re
import requests
from transformers import pipeline
import warnings
warnings.filterwarnings("ignore", category=FutureWarning)

# === Configuración ===
ROUTER_API_KEY = open("mnt/api/apikey_openroute.txt", "r", encoding="utf-8").read().strip()
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL = "deepseek/deepseek-chat"

# === Diccionario ofensivo ===
with open("mnt/data/diccionario_ok.json", "r", encoding="utf-8") as f:
    diccionario = json.load(f)["diccionario"]

# === Pipeline de sentimiento ===
sentiment_pipeline = pipeline("sentiment-analysis", model="finiteautomata/beto-sentiment-analysis")


# === Función para consulta a OpenRouter ===
def consulta_openrouter(prompt: str, model=MODEL) -> str:
    headers = {
        "Authorization": f"Bearer {ROUTER_API_KEY}",
        "Content-Type": "application/json"
    }
    data = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 200,
        "temperature": 0.2
    }

    response = requests.post(OPENROUTER_URL, headers=headers, json=data)
    response.raise_for_status()
    return response.json()["choices"][0]["message"]["content"]


# === Función principal para análisis ===
def calcular_idvg(text):
    # Paso 1: Detectar palabras ofensivas
    p = []
    for palabra in text.lower().split():
        for entrada in diccionario:
            if entrada["palabra_o_frase"].lower() in palabra:
                p.append([entrada["palabra_o_frase"], entrada["puntuacion_insulto"]])
    if not p:
        p = [["", 0]]

    l1 = [item[0] for item in p]
    l2 = [item[1] for item in p]
    Ins = sum(l2)
    print(f"Variable Ins: {Ins}")

    # Paso 2: Prompt A - Toxicidad inicial
    prompt_a = f"""
    Analiza el texto: "{text}" que contiene las palabras clasificadas como ofensivas {l1} y con base en esta información se requiere que la clasifiques como texto toxico o no toxico:
    
    1: Toxic (Si el contenido de text es toxico)
    2: No Toxic (Si el contenido de text no es toxico)

    Devuelve SOLO el formato: "Tox_a=X" (sin explicaciones).
    Donde X solo puede tener dos valores "Toxic" o "No Toxic"
    """
    Tox_a_text = consulta_openrouter(prompt_a)
    match_a = re.search(r"Tox_a=['\"]?(Toxic|No Toxic)['\"]?", Tox_a_text)
    Tox_a = match_a.group(1) if match_a else "No definido"
    print(f"Variable Tox_a: {Tox_a}")

    # Paso 3: Prompt B - Tipo de discurso violento
    prompt_b = f"""
Clasifica el siguiente mensaje según la 'Escala de Violencia del Discurso' (niveles del 0 al 3), basada en la siguiente taxonomía:

Instrucciones:
1. Analiza el mensaje en busca de lenguaje violento, ofensivo o de odio.
2. Asigna un nivel de acuerdo con los siguientes criterios:

- Nivel 3 (3): El mensaje contiene amenazas directas de daño físico, intimidación, chantaje o apología de la violencia física. 
  Ejemplo: "Te voy a matar".

- Nivel 2 (2): El mensaje incluye insultos graves, calumnias, descalificaciones personales o ataques a la dignidad. 
  Ejemplo: "Eres un corrupto sin vergüenza".

- Nivel 1 (1): El mensaje promueve daño moral colectivo: difamación, incitación a la discriminación, deshumanización o expresión de odio hacia grupos. 
  Ejemplo: "Los [grupo] son basura".

- Nivel 0 (0): El mensaje es neutro o no contiene violencia ni discurso de odio. 
  Ejemplo: "Buenos días".

Formato de respuesta requerido:
Devuelve únicamente el siguiente formato: 
Tox_b=X

Donde X es un número entre 0 y 3, correspondiente al nivel de violencia identificado.

Mensaje a clasificar: 
"{text}"
"""

    Tox_b_text = consulta_openrouter(prompt_b)
    match_b = re.search(r"Tox_b=(\d)", Tox_b_text)
    Tox_b = int(match_b.group(1)) if match_b else 0
    print(f"Variable Tox_b: {Tox_b}")

    # Paso 4: Prompt C - Persona gramatical
    prompt_c = f"""
    Clasifica la persona gramatical predominante de la siguiente oración: "{text}" y asigna una puntuación de acuerdo con los siguientes criterios:

    - Puntuación 3: Si la oración está escrita en primera persona del singular (yo) o segunda persona del singular (tú).
    - Puntuación 2: Si está en primera persona del plural (nosotros/nosotras) o segunda persona del plural (ustedes/vosotros).
    - Puntuación 1: Si se encuentra en tercera persona del singular o plural (él, ella, ellos, ellas).
    - Puntuación 0: Si la oración no contiene una persona gramatical clara o no tiene un destinatario específico.

    Devuelve únicamente la puntuación en el siguiente formato:
    Pers_b=X

    Donde X es un número entre 0 y 3.
    """

    persona_response = consulta_openrouter(prompt_c)
    # Nueva expresión regular para capturar el valor después de "Pers_b="
    match_puntuacion = re.search(r"Pers_b=(\d)", persona_response)
    # Si se encuentra la puntuación, asignarla; de lo contrario, devolver "0" por defecto
    Pers = match_puntuacion.group(1).strip() if match_puntuacion else "0"
    print(f"La respuesta es: {persona_response} -> Puntuación asignada: {Pers}")

    # Paso 5: Sentimiento BERT
    sentimiento = sentiment_pipeline(text)[0]
    Sent = sentimiento["label"]
    Conf = sentimiento["score"]
    print(f"Sent: {Sent} - Confianza: {Conf}")

    # Paso 6: Calcular IDVG
    alpha = 2*(0 if Tox_a == "Toxic" else 1)
    print(f"Variable alpha: {alpha}")
    beta = 1.5*({"NEG": -1.0, "NEU": 0.0, "POS": 1.0}.get(Sent, 1))*Conf
    print(f"Variable beta: {beta}")
    gamma = 1.1*(float(Pers)*Tox_b) 
    print(f"Variable gamma: {gamma}")
    delta = 0.5 * Ins*(0 if Tox_a == "Toxic" else 1)
    print(f"Variable delta: {delta}")
    # Ajuste de epsilon
    epsilon = alpha - (beta + 0.5)
    print(f"Variable epsilon: {epsilon}")
    IDVG = alpha + beta + gamma + delta - epsilon

    resultado = {
        "Texto": text,
        "Ins Text": p,
        "Tox_a": Tox_a,
        "Sent": Sent,
        "Conf_Sent": round(Conf, 3),
        "Pers": Pers,
        "Tox_b": Tox_b,
        "Ins": Ins,
        "eps": epsilon,
        "IDVG": round(IDVG, 3)
    }
    return resultado
