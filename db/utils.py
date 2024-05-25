import os
from contextlib import contextmanager
import psycopg2 
import sql.data_loader as data_loader


@contextmanager
def get_connection():
    conn = None
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
        )
        yield conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Log: {error}")
        if conn is not None:
            conn.close()
    finally:
        if conn is not None:
            conn.close()
            
            
def db_initialization():    
    try:
        with get_connection() as conn:
            create_tables_sql = data_loader.load_sql('sql/queries/create_tables.sql')
            insert_rows_sql = data_loader.load_sql('sql/queries/insert_test.sql')
            
            data_loader.execute_sql(create_tables_sql, conn)
            data_loader.execute_sql(insert_rows_sql, conn)
            
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Log: {error}")

