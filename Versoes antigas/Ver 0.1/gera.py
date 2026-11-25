import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

# se vier do PowerShell usa, senão fallback
csv_path = sys.argv[1] if len(sys.argv) > 1 else r"C:\Users\guilherme\Desktop\ping_log.csv"
img_path = sys.argv[2] if len(sys.argv) > 2 else r"C:\Users\guilherme\Desktop\grafico_ping.png"

print("=== LENDO CSV ===")

df = pd.read_csv(csv_path)
df.columns = df.columns.str.strip()

df = df[df["Status"] == "OK"]

if df.empty:
    print("Sem dados OK")
    exit()

df["Data"] = pd.to_datetime(df["Data"], errors="coerce")
df["Latencia"] = pd.to_numeric(df["Latencia"], errors="coerce")
df = df.dropna(subset=["Data", "Latencia"])

plt.figure(figsize=(12,5))
plt.plot(df["Data"], df["Latencia"], linewidth=1)

plt.title("Ping Monitoramento - 8.8.8.8")
plt.xlabel("Tempo")
plt.ylabel("Latência (ms)")
plt.grid(True)

plt.tight_layout()
plt.savefig(img_path, dpi=150)

print("GRÁFICO GERADO:", img_path)
print("Existe:", os.path.exists(img_path))