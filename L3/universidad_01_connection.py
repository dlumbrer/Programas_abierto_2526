"""Simple example: connect to PostgreSQL database

This scripts provides a very simple example on using the
psycopg3 module to connect to a PostgreSQL database
"""

import configparser
import psycopg


def main():
    config = configparser.ConfigParser()
    config.read("myconfig.ini")

    # Connect to an existing database
    try:
        with psycopg.connect(host=config.get("DEFAULT", "host"), port=config.getint("DEFAULT", "port"),
                             dbname=config.get("DEFAULT", "dbname"), user=config.get("DEFAULT", "user"),
                             password=config.get("DEFAULT", "password")
                             ) as conn:

            print("Conexion Existosa")

    except Exception as e:
        print(f"Error al conectar: {e}")

    finally:
        if conn:
            conn.close()
            print('Conexion Cerrada.')


if __name__ == "__main__":
    main()
