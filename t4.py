import IDGV

texto = "te voy hacer daño, mierda se me olvido limpiarme el culo"
res = IDGV.calcular_idvg(texto)

# Mostrar resultados
print("\nRESULTADOS DEL ANÁLISIS:\n")
print(f"Texto: {res['Texto']}")
print(f"Ins Text: {res['Ins Text']}")
print(f"Tox_a: {res['Tox_a']}")
print(f"Sent: {res['Sent']}")
print(f"Conf_Sent: {res['Conf_Sent']}")
print(f"Pers: {res['Pers']}")
print(f"Tox_b: {res['Tox_b']}")
print(f"Ins: {res['Ins']}")
print(f"eps: {res['eps']}")
print(f"IDVG: {res['IDVG']}")
