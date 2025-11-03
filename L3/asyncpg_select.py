import asyncio, configparser
import asyncpg

def cfg():
    c = configparser.ConfigParser(); c.read("myconfig.ini"); return c["DEFAULT"]

async def main():
    c = cfg()
    conn = await asyncpg.connect(
        user=c["user"], password=c["password"],
        database=c["dbname"], host=c["host"], port=int(c["port"])
    )
    try:
        rows = await conn.fetch(
            """
            SELECT matricula, nombre, apellido, edad
            FROM estudiantes
            ORDER BY apellido ASC
            LIMIT $1
            """,
            5
        )
        print("Top 5 estudiantes (asyncpg):")
        for r in rows:
            # r es un asyncpg.Record → convertir a dict para imprimir
            d = dict(r)
            print(d["matricula"], d["nombre"], d["apellido"], d["edad"])
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(main())