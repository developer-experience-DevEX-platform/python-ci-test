import pytest
from psycopg import connect
from testcontainers.postgres import PostgresContainer

pytestmark = pytest.mark.integration


def test_postgres_accepts_a_write_and_a_read() -> None:
    with (
        PostgresContainer("postgres:16-alpine") as postgres,
        connect(
            host=postgres.get_container_host_ip(),
            port=int(postgres.get_exposed_port(5432)),
            user=postgres.username,
            password=postgres.password,
            dbname=postgres.dbname,
        ) as client,
        client.cursor() as cursor,
    ):
        cursor.execute("CREATE TABLE notes (id serial PRIMARY KEY, body text NOT NULL)")
        cursor.execute("INSERT INTO notes (body) VALUES (%s)", ("hello",))
        cursor.execute("SELECT body FROM notes")
        assert cursor.fetchall() == [("hello",)]
