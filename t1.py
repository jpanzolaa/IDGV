from transformers import pipeline

# Crear el pipeline de análisis de sentimiento
sentiment_pipeline = pipeline("sentiment-analysis", model="finiteautomata/beto-sentiment-analysis")

# Frase a evaluar
text = "Eres un inútil y deberías desaparecer"

# Realizar el análisis de sentimiento
sentiment_result = sentiment_pipeline(text)[0]

# Mostrar los resultados
print(f"Text: {text}")
print(f"Sentiment Analysis: {sentiment_result['label']} (Score: {sentiment_result['score']:.2f})")