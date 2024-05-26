from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect, url_for, flash, session, logging, jsonify
from db.utils import *

load_dotenv()

app = Flask(__name__)
app.secret_key = 'DJAOIJODIAJ7818'

db_initialization()

def execute_query(query, params=None):
    try:
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute(query, params)
            data = cur.fetchall()
            colnames = [dicionario_campos[desc[0]] for desc in cur.description]
            cur.close()
        return data, colnames
    except Exception as e:
        print(f"Ocorreu um erro: {e}")
        flash("Ocorreu um erro ao acessar o banco de dados", "error")
        return [], []

@app.route("/", methods=["GET", "POST"])
def index(selected_table="individuo"):
    if request.method == "POST":
        selected_table = request.form.get("table")
    data, colnames = execute_query(f"SELECT * FROM {selected_table};")
    return render_template("index.html", data=data, colnames=colnames, tables=TABLES.keys(), selected_table=selected_table)

@app.route("/delete", methods=["POST"])
def delete():
    table = request.form.get("table")
    ids_to_delete = request.form.getlist("row_ids")
    if not ids_to_delete:
        return index(table)
    id_string = ', '.join(ids_to_delete)
    try:
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute(f"CALL sp_delete_{table} ({id_string});")
            conn.commit()
            cur.close()
        return index(table)
    except Exception as e:
        print(f"Ocorreu um erro: {e}")
        flash("Ocorreu um erro ao acessar o banco de dados", "error")
        return [], []

@app.route("/candidaturas")
def candidaturas(order="id_candidatura"):
    query = """
        SELECT nm_pessoa, nr_cpf, nm_cargo, nr_pleito, ds_status, an_eleicao
        FROM CANDIDATURA AS A
        LEFT JOIN INDIVIDUO ON nr_cpf_candidato = nr_cpf
        LEFT JOIN CARGO AS B on A.id_cargo = B.id_cargo
        ORDER BY {} DESC;
    """.format(order)
    data, colnames = execute_query(query)
    return render_template("candidaturas.html", data=data, colnames=colnames)

@app.route("/candidatura_order", methods=["POST"])
def candidatura_order():
    order = request.form.get("column")
    return candidaturas(dicionario_campos_inv[order])

@app.route("/relatorios", methods=["GET", "POST"])
def relatorios(public_office="Presidente"):
    if request.method == "POST":
        public_office = request.form.get("table")
    query = """
        SELECT nm_pessoa, nr_cpf, nm_cargo, nr_pleito, an_eleicao
        FROM CANDIDATURA AS A
        LEFT JOIN INDIVIDUO ON nr_cpf_candidato = nr_cpf
        LEFT JOIN CARGO AS B on A.id_cargo = B.id_cargo
        WHERE nm_cargo = '{}'
        ORDER BY nr_pleito DESC LIMIT({});
    """.format(public_office, cargos_vagas[public_office])
    data, colnames = execute_query(query)
    return render_template("relatorios.html", data=data, colnames=colnames, tables=TABLES.keys(), public_office=public_office)

@app.route("/ficha_limpa", methods=["GET", "POST"])
def ficha_limpa():
    query = """
        SELECT i.nm_pessoa, c.nr_cpf, b.nm_cargo, cand.nr_pleito, cand.ds_status, cand.an_eleicao
        FROM candidato AS c
        LEFT JOIN individuo AS i ON i.nr_cpf = c.nr_cpf
        LEFT JOIN candidatura AS cand ON cand.nr_cpf_candidato = i.nr_cpf
        LEFT JOIN cargo AS b ON cand.id_cargo = b.id_cargo
        WHERE c.nr_cpf NOT IN (
            SELECT pi.nr_cpf
            FROM processo_individuo AS pi
            LEFT JOIN processo_judicial AS pj ON pi.id_processo = pj.id_processo
            WHERE EXTRACT(YEAR FROM pj.dt_inicio) <= 2023
        );
    """
    data, colnames = execute_query(query)
    return render_template("ficha_limpa.html", data=data, colnames=colnames, tables=TABLES.keys())

if __name__ == "__main__":
    app.run(debug=True)