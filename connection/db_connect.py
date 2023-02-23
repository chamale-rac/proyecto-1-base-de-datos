
import psycopg2 as pg


def connect(_database, _host, _user, _password, _port):
    conn = pg.connect(database=_database,
                      host=_host,
                      user=_user,
                      password=_password,
                      port=_port)
    return conn


def create_cursor(conn):
    return conn.cursor()


def close_connection(conn):
    conn.close()
