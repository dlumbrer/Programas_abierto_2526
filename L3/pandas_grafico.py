"""
analytics_df_plot.py
Convierte una consulta a pandas DataFrame y grafica distribución de notas.
Requiere: pip install pandas matplotlib
"""
import configparser
import psycopg
from psycopg.rows import dict_row
import pandas as pd
import matplotlib.pyplot as plt

def get_conn():
    cfg = configparser.ConfigParser()
    cfg.read("myconfig.ini")
    return psycopg.connect(
        host=cfg.get("DEFAULT", "host"),
        port=cfg.getint("DEFAULT", "port"),
        dbname=cfg.get("DEFAULT", "dbname"),
        user=cfg.get("DEFAULT", "user"),
        password=cfg.get("DEFAULT", "password"),
        row_factory=dict_row
    )

def main():
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT a.Nombre AS Asignatura, m.NotaNumerica
            FROM Matriculas m
            JOIN Asignaturas a ON a.IDAsignatura = m.IDAsignatura;
        """)
        rows = cur.fetchall()

    df = pd.DataFrame(rows)
    print(df.head())

    # Forzar a número (convierte Decimal/str a float)
    df["notanumerica"] = pd.to_numeric(df["notanumerica"], errors="coerce")

    # Media por asignatura
    mean_df = df.groupby("asignatura", as_index=False)["notanumerica"].mean()
    print("\nMedia por asignatura:")
    print(mean_df)

    # Histograma
    plt.figure()
    df["notanumerica"].plot(kind="hist", bins=10, title="Distribución de notas")
    plt.xlabel("Nota")
    plt.ylabel("Frecuencia")
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    main()