import IDGV

texto = "mierda se me olvido limpiarme el culo"
res = IDGV.calcular_idvg(texto)

# Mostrar resultados
print("\nRESULTADOS DEL ANÁLISIS:\n")
print(f"Texto: {res['Texto']}")
print(f"Insultos detectados: {res['Insultos detectados']}")
print(f"Toxicidad inicial (Tox_a): {res['Toxicidad inicial (Tox_a)']}")
print(f"Nivel de discurso violento (Tox_b): {res['Nivel de discurso violento (Tox_b)']}")
print(f"Persona gramatical: {res['Persona gramatical']}")
print(f"Sentimiento: {res['Sentimiento']}")
print(f"Confianza Sentimiento: {res['Confianza Sentimiento']}")
print(f"IDVG: {res['IDVG']}")
