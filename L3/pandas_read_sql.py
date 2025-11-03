import configparser
import pandas as pd
from sqlalchemy import create_engine

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

    df = pd.read_sql(
        """
        SELECT matricula, nombre, apellido, edad
        FROM estudiantes
        ORDER BY apellido ASC
        LIMIT 5
        """,
        engine
    )
    print("Top 5 estudiantes (pandas + SQLAlchemy):")
    print(df)

if __name__ == "__main__":
    main()