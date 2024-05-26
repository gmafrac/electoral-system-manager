from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect, url_for, flash, session, logging, jsonify
from db.utils import *

load_dotenv()

dicionario_campos = {
    "id_processo": "ID do Processo",
    "dt_inicio": "Data de Início",
    "dt_fim": "Data de Fim",
    "ds_procedencia": "Procedência",
    "st_processo": "Status do Processo",
    "nr_cpf": "CPF",
    "nm_pessoa": "Nome",
    "ds_tipo": "Tipo",
    "nr_partido": "Número do Partido",
    "nm_partido": "Nome do Partido",
    "ds_sigla": "Sigla",
    "ds_programa": "Programa",
    "ds_intencoes": "Intenções",
    "an_eleicao": "Ano da Eleição",
    "nm_pais": "País",
    "sigla_pais": "Sigla do País",
    "nm_estado": "Estado",
    "sigla_estado": "Sigla do Estado",
    "nm_cidade": "Cidade",
    "id_cargo": "ID do Cargo",
    "nm_cargo": "Nome do Cargo",
    "ds_representacao": "Representação",
    "id_candidatura": "ID da Candidatura",
    "nr_cpf_candidato": "CPF do Candidato",
    "nr_cpf_vice": "CPF do Vice",
    "nr_pleito": "Número do Pleito",
    "ds_status": "Status",
    "id_equipe": "ID da Equipe",
    "nm_equipe": "Nome da Equipe",
    "nr_cnpj": "CNPJ",
    "nm_empresa": "Nome da Empresa",
    "nr_cnpj_doador": "CNPJ do Doador",
    "dt_doacao": "Data da Doação",
    "vl_doacao": "Valor da Doação",
    "nr_cpf_doador": "CPF do Doador",
    "id_candidatura": "ID da Candidatura"
}

dicionario_campos_inv = {v: k for k, v in dicionario_campos.items()}

TABLES = {
    "processo_judicial": ["id_processo"],
    "individuo": ["nr_cpf"],
    "processo_individuo": ["id_processo", "nr_cpf"],
    "apoiador": ["nr_cpf"],
    "doador": ["nr_cpf"],
    "partido": ["nr_partido"],
    "candidato": ["nr_cpf"],
    "pais": ["nm_pais"],
    "estado": ["nm_pais", "nm_estado"],
    "cidade": ["nm_pais", "nm_estado", "nm_cidade"],
    "cargo": ["id_cargo"],
    "candidatura": ["id_candidatura"],
    "equipe_de_apoio": ["id_equipe", "an_eleicao"],
    "apoiador_Equipe": ["nr_cpf", "id_equipe"],
    "empresa": ["nr_cnpj"],
    "candidatura_doacoes_PJ": ["nr_cnpj_doador", "id_candidatura", "dt_doacao"],
    "candidatura_doacoes_PF": ["nr_cpf_doador", "id_candidatura", "dt_doacao"]
}

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
def index(selected_table="candidato"):
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
    execute_query(f"DELETE FROM {table} WHERE ({TABLES[table][0]}) IN ({id_string});")
    return index(table)

@app.route("/candidaturas")
def candidaturas(order="id_candidatura"):
    data, colnames = execute_query(f"""SELECT nm_pessoa, nr_cpf, nm_cargo, nr_pleito, ds_status  FROM CANDIDATURA AS A
	LEFT JOIN INDIVIDUO ON nr_cpf_candidato = nr_cpf
	LEFT JOIN CARGO AS B on A.id_cargo = B.id_cargo
	ORDER BY {order} DESC;""")
    return render_template("candidaturas.html", data=data, colnames=colnames)

@app.route("/candidatura_order", methods=["POST"])
def candidatura_order():
    order = request.form.get("column")
    print(dicionario_campos_inv[order])
    return candidaturas(dicionario_campos_inv[order])

@app.route("/relatorios", methods=["GET", "POST"])
def relatorios(public_office="all"):
    if request.method == "POST":
        public_office = request.form.get("table")
    data, colnames = execute_query("SELECT * FROM CANDIDATURA;")
    return render_template("relatorios.html", data=data, colnames=colnames, tables=TABLES.keys(), public_office=public_office)

@app.route("/ficha_limpa", methods=["GET", "POST"])
def ficha_limpa():
    data, colnames = execute_query("SELECT * FROM CANDIDATURA;")
    return render_template("ficha_limpa.html", data=data, colnames=colnames, tables=TABLES.keys())

if __name__ == "__main__":
    app.run(debug=True)