def load_sql(file_path):
    with open(file_path, 'r') as file:
        return file.read()
    
def execute_sql(sql, conn):
    cur = conn.cursor()
    cur.execute(sql)
    conn.commit()