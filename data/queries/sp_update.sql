CREATE OR REPLACE PROCEDURE sp_update_processo_judicial(
    v_id_processo INTEGER,
    v_dt_inicio DATE DEFAULT NULL,
    v_dt_fim DATE DEFAULT NULL,
    v_ds_procedencia VARCHAR DEFAULT NULL,
    v_st_processo VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Processo_judicial
    SET dt_inicio = COALESCE(v_dt_inicio, dt_inicio),
        dt_fim = COALESCE(v_dt_fim, dt_fim),
        ds_procedencia = COALESCE(v_ds_procedencia, ds_procedencia),
        st_processo = COALESCE(v_st_processo, st_processo)
    WHERE id_processo = v_id_processo;
END;
$$;


CREATE OR REPLACE PROCEDURE sp_update_individuo(
    v_nr_cpf NUMERIC(11),
    v_nm_pessoa VARCHAR DEFAULT NULL,
    v_ds_tipo VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Individuo
    SET nm_pessoa = COALESCE(v_nm_pessoa, nm_pessoa),
        ds_tipo = COALESCE(v_ds_tipo, ds_tipo)
    WHERE nr_cpf = v_nr_cpf;
END;
$$;


CREATE OR REPLACE PROCEDURE sp_update_partido(
    v_nr_partido NUMERIC(2),
    v_nm_partido VARCHAR DEFAULT NULL,
    v_ds_sigla VARCHAR DEFAULT NULL,
    v_ds_programa VARCHAR DEFAULT NULL,
    v_ds_intencoes VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Partido
    SET nm_partido = COALESCE(v_nm_partido, nm_partido),
        ds_sigla = COALESCE(v_ds_sigla, ds_sigla),
        ds_programa = COALESCE(v_ds_programa, ds_programa),
        ds_intencoes = COALESCE(v_ds_intencoes, ds_intencoes)
    WHERE nr_partido = v_nr_partido;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_candidato(
    v_nr_cpf NUMERIC(11),
    v_nr_partido NUMERIC(2) DEFAULT NULL,
    v_an_eleicao NUMERIC(4) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Candidato
    SET nr_partido = COALESCE(v_nr_partido, nr_partido),
        an_eleicao = COALESCE(v_an_eleicao, an_eleicao)
    WHERE nr_cpf = v_nr_cpf;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_pais(
    v_nm_pais VARCHAR(100),
    v_sigla_pais VARCHAR(3)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pais
    SET sigla_pais = COALESCE(v_sigla_pais, sigla_pais)
    WHERE nm_pais = v_nm_pais;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_estado(
    v_nm_pais VARCHAR(100),
    v_nm_estado VARCHAR(100),
    v_sigla_estado VARCHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Estado
    SET sigla_estado = COALESCE(v_sigla_estado, sigla_estado)
    WHERE nm_pais = v_nm_pais AND nm_estado = v_nm_estado;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_cidade(
    v_nm_pais VARCHAR(100),
    v_nm_estado VARCHAR(100),
    v_nm_cidade VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Assume que não há atualização possível além do nome, já que são chaves primárias
    RETURN;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_cargo(
    v_id_cargo INTEGER,
    v_nm_pais VARCHAR(100),
    v_nm_estado VARCHAR DEFAULT NULL,
    v_nm_cidade VARCHAR DEFAULT NULL,
    v_nm_cargo VARCHAR(100),
    v_ds_representacao VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Cargo
    SET nm_pais = COALESCE(v_nm_pais, nm_pais),
        nm_estado = COALESCE(v_nm_estado, nm_estado),
        nm_cidade = COALESCE(v_nm_cidade, nm_cidade),
        nm_cargo = COALESCE(v_nm_cargo, nm_cargo),
        ds_representacao = COALESCE(v_ds_representacao, ds_representacao)
    WHERE id_cargo = v_id_cargo;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_candidatura(
    v_id_candidatura INTEGER,
    v_nr_cpf_candidato NUMERIC(11),
    v_nr_cpf_vice NUMERIC(11),
    v_id_cargo INTEGER,
    v_an_eleicao NUMERIC(4),
    v_nr_pleito INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Candidatura
    SET nr_cpf_candidato = COALESCE(v_nr_cpf_candidato, nr_cpf_candidato),
        nr_cpf_vice = COALESCE(v_nr_cpf_vice, nr_cpf_vice),
        id_cargo = COALESCE(v_id_cargo, id_cargo),
        an_eleicao = COALESCE(v_an_eleicao, an_eleicao),
        nr_pleito = COALESCE(v_nr_pleito, nr_pleito)
    WHERE id_candidatura = v_id_candidatura;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_equipe_de_apoio(
    v_id_equipe INTEGER,
    v_id_candidatura INTEGER,
    v_nm_equipe VARCHAR(200),
    v_an_eleicao NUMERIC(4)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Equipe_de_apoio
    SET id_candidatura = COALESCE(v_id_candidatura, id_candidatura),
        nm_equipe = COALESCE(v_nm_equipe, nm_equipe),
        an_eleicao = COALESCE(v_an_eleicao, an_eleicao)
    WHERE id_equipe = v_id_equipe;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_empresa(
    v_nr_cnpj NUMERIC(14),
    v_nm_empresa VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Empresa
    SET nm_empresa = COALESCE(v_nm_empresa, nm_empresa)
    WHERE nr_cnpj = v_nr_cnpj;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_candidatura_doacoes_pj(
    v_nr_cnpj_doador NUMERIC(11),
    v_id_candidatura INTEGER,
    v_dt_doacao DATE,
    v_vl_doacao MONEY
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Candidatura_doacoes_PJ
    SET vl_doacao = COALESCE(v_vl_doacao, vl_doacao)
    WHERE nr_cnpj_doador = v_nr_cnpj_doador AND id_candidatura = v_id_candidatura AND dt_doacao = v_dt_doacao;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_update_candidatura_doacoes_pf(
    v_nr_cpf_doador NUMERIC(11),
    v_id_candidatura INTEGER,
    v_dt_doacao DATE,
    v_vl_doacao MONEY
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Candidatura_doacoes_PF
    SET vl_doacao = COALESCE(v_vl_doacao, vl_doacao)
    WHERE nr_cpf_doador = v_nr_cpf_doador AND id_candidatura = v_id_candidatura AND dt_doacao = v_dt_doacao;
END;
$$;


