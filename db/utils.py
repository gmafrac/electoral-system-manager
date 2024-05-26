import os
from contextlib import contextmanager
import psycopg2 
import sql.data_loader as data_loader
import pandas as pd 

BASE_PATH="sql/"
QUERIES_PATH="queries/"    
EXCEL_FILE_PATH="dados_bd.xlsx"
DROP_BD="drop_bd.sql"

SQL_PATHS={
    "DDL": "ddl_create_tables.sql",
    "SP_INSERT": "sp_insert.sql",
    "SP_UPDATE_RESULTS": "sp_update_election_results.sql",
    "SP_UPDATE": "sp_update.sql",
    "TR_CARGO_LOC": "tr_cargo_localizacao.sql",
    "TR_CHECK_CANDIDATO": "tr_check_candidato_eligibility.sql",
    "TR_INSERT_DOADOR": "tr_insert_doador_apoiador.sql",
    "TR_UPDATE_INDIVIDUO": "tr_update_individuo_on_procedente.sql",
    "TR_UPDATE_PROCESSO": "tr_update_processo_status.sql",
    "SP_DELETE": "sp_delete.sql",
}


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

cargos_vagas = {
    "Presidente": 1,
    "Vice Presidente": 1,
    "Senador": 81,  
    "Deputado Federal": 513,
    "Governador": 27,  
    "Deputado Estadual": 500,
    "Prefeito": 40,  
    "Vice Prefeito": 40,
    "Vereador": 300
}

def read_excel_file(file_path):
    xls = pd.ExcelFile(file_path)
    sheets_dict = {}

    for sheet_name in xls.sheet_names:
        df = pd.read_excel(file_path, sheet_name=sheet_name)
        for col in df.select_dtypes(include=['datetime64[ns]']).columns:
            df[col] = df[col].fillna("NULL").astype(str)

        df = df.fillna("NULL")
        sheets_dict[sheet_name] = df
    
    return sheets_dict

def insert_data_from_df(cursor, df, procedure_name):
    for row in df.itertuples(index=False, name=None):
        row = str(row).replace("'NULL'","NULL")
        cursor.execute(f"CALL {procedure_name} {row};")
        
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
                
                data_loader.execute_sql(BASE_PATH+QUERIES_PATH+DROP_BD, conn)
                cur = conn.cursor()
                cur.execute("CALL drop_bd();")

                for sql_path in SQL_PATHS.values():
                    try: 
                        data_loader.execute_sql(BASE_PATH+QUERIES_PATH+sql_path, conn)
                    except (Exception, psycopg2.DatabaseError) as error:
                        
                        print(f"Log: {error} from {sql_path}")
                
                sheets_dict = read_excel_file(BASE_PATH+EXCEL_FILE_PATH)
                
                for sheet_name, df in sheets_dict.items():
                    insert_data_from_df(cur, df, f"sp_insert_{sheet_name.lower()}")
                    print(f"LOG: Value was insered in the {sheet_name}..") 
                
                conn.commit()
                cur.close()
                
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Log: {error}")