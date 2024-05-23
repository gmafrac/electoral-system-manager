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

