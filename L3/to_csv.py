"""
join_and_export.py
Join entre Estudiantes, Asignaturas y Matriculas. Pintado tabulado y export a CSV.
"""
import csv
import configparser
import psycopg
from psycopg.rows import dict_row

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
    query = """
    SELECT e.Matricula, e.Nombre AS estudiante, e.Apellido,
           a.IDAsignatura, a.Nombre AS asignatura,
           m.NotaNumerica, m.NotaTexto
    FROM Matriculas m
    JOIN Estudiantes e ON e.Matricula = m.Matricula
    JOIN Asignaturas a ON a.IDAsignatura = m.IDAsignatura
    ORDER BY e.Apellido, a.Nombre;
    """
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()

    # Pintado “bonito” sin librerías externas
    headers = rows[0].keys() if rows else []
    print(" | ".join(h for h in headers))
    print("-" * 80)
    for r in rows:
        print(" | ".join(str(r[h]) for h in headers))

    # Exportar a CSV
    with open("matriculas_export.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows(rows)
    print("\nCSV generado: matriculas_export.csv")

if __name__ == "__main__":
    main()