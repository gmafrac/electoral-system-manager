CREATE OR REPLACE PROCEDURE sp_delete_processo_judicial(v_id_processo INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Processo_judicial WHERE id_processo = v_id_processo;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_individuo(v_nr_cpf NUMERIC(11))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Individuo WHERE nr_cpf = v_nr_cpf;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_partido(v_nr_partido NUMERIC(2))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Partido WHERE nr_partido = v_nr_partido;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_pais(v_nm_pais VARCHAR(100))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Pais WHERE nm_pais = v_nm_pais;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_estado(v_nm_pais VARCHAR(100), v_nm_estado VARCHAR(100))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Estado WHERE nm_pais = v_nm_pais AND nm_estado = v_nm_estado;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_cidade(v_nm_pais VARCHAR(100), v_nm_estado VARCHAR(100), v_nm_cidade VARCHAR(200))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Cidade WHERE nm_pais = v_nm_pais AND nm_estado = v_nm_estado AND nm_cidade = v_nm_cidade;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_candidatura(v_id_candidatura INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Candidatura WHERE id_candidatura = v_id_candidatura;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_empresa(v_nr_cnpj NUMERIC(14))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Empresa WHERE nr_cnpj = v_nr_cnpj;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_cargo(v_id_cargo INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Cargo WHERE id_cargo = v_id_cargo;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_candidatura_doacoes_pj(v_nr_cnpj_doador NUMERIC(11), v_id_candidatura INTEGER, v_dt_doacao DATE)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Candidatura_doacoes_PJ WHERE nr_cnpj_doador = v_nr_cnpj_doador AND id_candidatura = v_id_candidatura AND dt_doacao = v_dt_doacao;
END;
$$;
CREATE OR REPLACE PROCEDURE sp_delete_candidatura_doacoes_pf(v_nr_cpf_doador NUMERIC(11), v_id_candidatura INTEGER, v_dt_doacao DATE)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Candidatura_doacoes_PF WHERE nr_cpf_doador = v_nr_cpf_doador AND id_candidatura = v_id_candidatura AND dt_doacao = v_dt_doacao;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_equipe_de_apoio(v_id_equipe INTEGER, v_an_eleicao NUMERIC(4))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Equipe_de_apoio WHERE id_equipe = v_id_equipe AND an_eleicao = v_an_eleicao;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_delete_apoiador_equipe(v_nr_cpf NUMERIC(11), v_id_equipe INTEGER, v_an_eleicao NUMERIC(4))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Apoiador_Equipe WHERE nr_cpf = v_nr_cpf AND id_equipe = v_id_equipe AND an_eleicao = v_an_eleicao;
END;
$$;

