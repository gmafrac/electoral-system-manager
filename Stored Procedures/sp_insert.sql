CREATE OR REPLACE PROCEDURE sp_insert_processo_judicial(
    v_dt_inicio DATE,
    v_dt_fim DATE,
    v_ds_procedencia VARCHAR,
    v_st_processo VARCHAR DEFAULT 'Em tramitação'
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Processo_judicial (dt_inicio, dt_fim, ds_procedencia, st_processo)
    VALUES (v_dt_inicio, v_dt_fim, v_ds_procedencia, v_st_processo);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_individuo(
    v_nr_cpf NUMERIC(11),
    v_nm_pessoa VARCHAR(200),
    v_ds_tipo VARCHAR(10) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Individuo (nr_cpf, nm_pessoa, ds_tipo)
    VALUES (v_nr_cpf, v_nm_pessoa, v_ds_tipo);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_processo_individuo(
    v_id_processo INTEGER,
    v_nr_cpf NUMERIC(11)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Processo_individuo (id_processo, nr_cpf)
    VALUES (v_id_processo, v_nr_cpf);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_apoiador(
    v_nr_cpf NUMERIC(11)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Apoiador (nr_cpf)
    VALUES (v_nr_cpf);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_doador(
    v_nr_cpf NUMERIC(11)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Doador (nr_cpf)
    VALUES (v_nr_cpf);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_partido(
    v_nr_partido NUMERIC(2),
    v_nm_partido VARCHAR(200),
    v_ds_sigla VARCHAR(10),
    v_ds_programa VARCHAR(100),
    v_ds_intencoes VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Partido (nr_partido, nm_partido, ds_sigla, ds_programa, ds_intencoes)
    VALUES (v_nr_partido, v_nm_partido, v_ds_sigla, v_ds_programa, v_ds_intencoes);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_candidato(
    v_nr_cpf NUMERIC(11),
    v_nr_partido NUMERIC(2),
    v_an_eleicao NUMERIC(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Candidato (nr_cpf, nr_partido, an_eleicao)
    VALUES (v_nr_cpf, v_nr_partido, v_an_eleicao);
END;
$$;

-- Pais
CREATE OR REPLACE PROCEDURE sp_insert_pais(
    v_nm_pais VARCHAR(100),
    v_sigla_pais VARCHAR(3)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Pais (nm_pais, sigla_pais)
    VALUES (v_nm_pais, v_sigla_pais);
END;
$$;

-- Estado
CREATE OR REPLACE PROCEDURE sp_insert_estado(
    v_nm_pais VARCHAR(100),
    v_nm_estado VARCHAR(100),
    v_sigla_estado VARCHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Estado (nm_pais, nm_estado, sigla_estado)
    VALUES (v_nm_pais, v_nm_estado, v_sigla_estado);
END;
$$;

-- Cidade
CREATE OR REPLACE PROCEDURE sp_insert_cidade(
    v_nm_pais VARCHAR(100),
    v_nm_estado VARCHAR(100),
    v_nm_cidade VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Cidade (nm_pais, nm_estado, nm_cidade)
    VALUES (v_nm_pais, v_nm_estado, v_nm_cidade);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_candidatura(
    v_nr_cpf_candidato NUMERIC(11),
    v_nr_cpf_vice NUMERIC(11),
    v_id_cargo INTEGER,
    v_an_eleicao NUMERIC(4),
    v_nr_pleito INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Candidatura (nr_cpf_candidato, nr_cpf_vice, id_cargo, an_eleicao, nr_pleito)
    VALUES (v_nr_cpf_candidato, v_nr_cpf_vice, v_id_cargo, v_an_eleicao, v_nr_pleito);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_equipe_de_apoio(
    v_id_candidatura INTEGER,
    v_nm_equipe VARCHAR(200),
    v_an_eleicao NUMERIC(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Equipe_de_apoio (id_candidatura, nm_equipe, an_eleicao)
    VALUES (v_id_candidatura, v_nm_equipe, v_an_eleicao);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_apoiador_equipe(
    v_nr_cpf NUMERIC(11),
    v_id_equipe INTEGER,
    v_an_eleicao NUMERIC(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Apoiador_Equipe (nr_cpf, id_equipe, an_eleicao)
    VALUES (v_nr_cpf, v_id_equipe, v_an_eleicao);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_empresa(
    v_nr_cnpj NUMERIC(14),
    v_nm_empresa VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Empresa (nr_cnpj, nm_empresa)
    VALUES (v_nr_cnpj, v_nm_empresa);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_candidatura_doacoes_pj(
    v_nr_cnpj_doador NUMERIC(11),
    v_id_candidatura INTEGER,
    v_dt_doacao DATE,
    v_vl_doacao MONEY
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Candidatura_doacoes_PJ (nr_cnpj_doador, id_candidatura, dt_doacao, vl_doacao)
    VALUES (v_nr_cnpj_doador, v_id_candidatura, v_dt_doacao, v_vl_doacao);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_insert_candidatura_doacoes_pf(
    v_nr_cpf_doador NUMERIC(11),
    v_id_candidatura INTEGER,
    v_dt_doacao DATE,
    v_vl_doacao MONEY
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Candidatura_doacoes_PF (nr_cpf_doador, id_candidatura, dt_doacao, vl_doacao)
    VALUES (v_nr_cpf_doador, v_id_candidatura, v_dt_doacao, v_vl_doacao);
END;
$$;
