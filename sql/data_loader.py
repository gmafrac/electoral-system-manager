def load_sql(file_path):
    with open(file_path, 'r') as file:
        return file.read()  
    
def execute_sql(file_path, conn):
    sql = load_sql(file_path)
    cur = conn.cursor()
    cur.execute(sql)
    conn.commit()
    cur.close()