import configparser
from sqlalchemy import create_engine, text

def dsn_from_ini():
    cfg = configparser.ConfigParser(); cfg.read("myconfig.ini")
    return (
        "postgresql+psycopg://"
        f"{cfg['DEFAULT']['user']}:{cfg['DEFAULT']['password']}@"
        f"{cfg['DEFAULT']['host']}:{cfg['DEFAULT']['port']}/"
        f"{cfg['DEFAULT']['dbname']}"
    )

def main():
    engine = create_engine(dsn_from_ini(), future=True)

    with engine.connect() as conn:
        res = conn.execute(text("""
            SELECT matricula, nombre, apellido, edad
            FROM estudiantes
            ORDER BY apellido ASC
            LIMIT :n
        """), {"n": 5})
        rows = res.mappings().all()
        print("Top 5 estudiantes (SQLAlchemy Core):")
        for r in rows:
            print(r["matricula"], r["nombre"], r["apellido"], r["edad"])

if __name__ == "__main__":
    main()