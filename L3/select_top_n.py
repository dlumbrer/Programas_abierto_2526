"""
select_estudiantes.py
Consulta básica: leer top N estudiantes con psycopg (psycopg3)
"""
import configparser
import psycopg
from psycopg.rows import dict_row  # para obtener filas como dicts

def get_conn():
    cfg = configparser.ConfigParser()
    cfg.read("myconfig.ini")
    return psycopg.connect(
        host=cfg.get("DEFAULT", "host"),
        port=cfg.getint("DEFAULT", "port"),
        dbname=cfg.get("DEFAULT", "dbname"),
        user=cfg.get("DEFAULT", "user"),
        password=cfg.get("DEFAULT", "password"),
        row_factory=dict_row  # filas -> dicts: {'matricula':..., 'nombre':...}
    )

def main(limit=5):
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("""
                SELECT Matricula, Nombre, Apellido, Edad, CorreoElectronico
                FROM Estudiantes
                ORDER BY Apellido ASC
                LIMIT %s;
            """, (limit,))
            rows = cur.fetchall()
            print(f"Top {limit} estudiantes:")
            for r in rows:
                print(f"- {r['matricula']}: {r['nombre']} {r['apellido']} ({r['edad']} años) <{r['correoelectronico']}>")
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    main(limit=8)