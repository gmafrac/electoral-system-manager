CREATE OR REPLACE FUNCTION check_candidato_eligibility()
RETURNS TRIGGER AS $$
DECLARE
    v_proc_ano_eleicao NUMERIC(4);
BEGIN
    -- Verifica se o indivíduo está sendo atualizado para 'Candidato'
    IF NEW.ds_tipo = 'Candidato' AND OLD.ds_tipo <> 'Candidato' THEN
        -- Verifica se existem processos 'Procedente'
        IF EXISTS (
            SELECT 1 FROM Processo_individuo pi
            JOIN Processo_judicial pj ON pi.id_processo = pj.id_processo
            WHERE pi.nr_cpf = NEW.nr_cpf AND pj.ds_procedencia = 'Procedente'
        ) THEN
            -- Verifica se há processos procedentes com data de término 5 anos antes ou mais do ano da eleição
            SELECT INTO v_proc_ano_eleicao EXTRACT(YEAR FROM pj.dt_fim) - 5
            FROM Processo_individuo pi
            JOIN Processo_judicial pj ON pi.id_processo = pj.id_processo
            WHERE pi.nr_cpf = NEW.nr_cpf AND pj.ds_procedencia = 'Procedente'
            ORDER BY pj.dt_fim DESC
            LIMIT 1;

            IF v_proc_ano_eleicao IS NOT NULL AND v_proc_ano_eleicao <= NEW.an_eleicao THEN
                -- Se houver, permite a candidatura
                RETURN NEW;
            ELSE
                -- Se não, lança uma exceção
                RAISE EXCEPTION 'Não é possível definir o indivíduo como Candidato devido a processos judiciais Procedentes recentes.';
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;