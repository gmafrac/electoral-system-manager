from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect, url_for, flash, session, logging, jsonify
from db.utils import *

load_dotenv()

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
app.secret_key = 'your_secret_key'  # Defina uma chave secreta para segurança da sessão

db_initialization()

@app.route("/", methods=["GET", "POST"])
def index(selected_table = "candidato"):
    
    if request.method == "POST":
        selected_table = request.form.get("table")

    try:
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute(f"SELECT * FROM {selected_table};")
            data = cur.fetchall()
            colnames = [desc[0] for desc in cur.description]
            cur.close()
        conn.close()
        return render_template("index.html", data=data, colnames=colnames, tables=TABLES.keys(), selected_table=selected_table)
    
    except Exception as e:
        print(f"Ocorreu um erro: {e}")
        flash("Ocorreu um erro ao acessar o banco de dados", "error")
        return render_template("index.html", data=[], colnames=[], tables=TABLES.keys(), selected_table=selected_table)
    finally:
        if 'conn' in locals():
            conn.close()


@app.route("/delete", methods=["POST"])
def delete():
    table = request.form.get("table")
    ids_to_delete = request.form.getlist("row_ids")
    
    if not ids_to_delete:
        return jsonify({"status": "error", "message": "Nenhuma linha selecionada para exclusão"})

    id_string = ', '.join(ids_to_delete)
    
    try:
        with get_connection() as conn:
            
            cur = conn.cursor()
            try: 
                cur.execute(f"DELETE FROM {table} WHERE ({TABLES[table][0]}) IN ({id_string});")
            except (Exception, psycopg2.DatabaseError) as error:
                print(f"DELETE FROM {table} WHERE {TABLES[table][0]} IN ({id_string})")
            conn.commit()
            cur.close()
            
        return index(table) 
    
    except Exception as e:
        print(f"Ocorreu um erro: {e}")
        return index(table)
    finally:
        if 'conn' in locals():
            conn.close()

@app.route("/candidaturas")
def candidaturas():
    return render_template("candidaturas.html")

@app.route("/relatorios")
def relatorios():
    return render_template("relatorios.html")

@app.route("/ficha-limpa")
def ficha_limpa():
    return render_template("ficha_limpa.html")

if __name__ == "__main__":
    app.run(debug=True)