import psycopg2 
from psycopg2 import Error 
import data.data_loader as dl
from config.config import DATABASE_CONFIG

try:
    conn = psycopg2.connect(
        host = DATABASE_CONFIG['host'],
        database = DATABASE_CONFIG['dbname'],
        user = DATABASE_CONFIG['user'],
        password = DATABASE_CONFIG['password']
    )

    cur = conn.cursor()
    create_tables_sql = dl.load_sql('data/queries/create_tables.sql')
    insert_rows_sql = dl.load_sql('data/queries/insert_test.sql')
    
    dl.execute_sql(create_tables_sql, conn)
    dl.execute_sql(insert_rows_sql, conn)
    
    # cur.callproc('get_all_users')

except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error) 
finally:
    if (conn):
        cur.close()
        conn.close()
        print("PostgreSQL connection is closed")

