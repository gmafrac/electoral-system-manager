CREATE OR REPLACE FUNCTION update_election_results(an_eleicao_in INTEGER)
RETURNS VOID AS $$
DECLARE
    candidate RECORD;
BEGIN
    -- Primeiro, resetar todos os status para 'Não Eleito'
    UPDATE Candidatura SET ds_status = 'Não Eleito' WHERE an_eleicao = an_eleicao_in;

    -- Processar cada tipo de cargo
    FOR candidate IN 
        SELECT c.id_candidatura, c.nr_cpf_candidato, c.nr_cpf_vice, c.id_cargo, c.nr_pleito, ca.nm_cargo, ca.nm_estado, ca.nm_cidade
        FROM Candidatura c
        JOIN Cargo ca ON c.id_cargo = ca.id_cargo
        WHERE c.an_eleicao = an_eleicao_in
        ORDER BY c.nr_pleito DESC
    LOOP
        -- Aplicar regras de eleição baseadas no cargo
        CASE
            WHEN candidate.nm_cargo = 'Presidente' OR candidate.nm_cargo = 'Governador' OR candidate.nm_cargo = 'Prefeito' THEN
                -- Eleger o candidato e seu vice (se houver)
                IF (SELECT count(*) FROM Candidatura 
                     WHERE id_cargo = candidate.id_cargo AND ds_status = 'Eleito' AND an_eleicao = an_eleicao_in) < 1 THEN
                    UPDATE Candidatura SET ds_status = 'Eleito'
                    WHERE id_candidatura = candidate.id_candidatura;

                    IF candidate.nr_cpf_vice IS NOT NULL THEN
                        UPDATE Candidatura SET ds_status = 'Eleito'
                        WHERE nr_cpf_candidato = candidate.nr_cpf_vice AND an_eleicao = an_eleicao_in;
                    END IF;
                END IF;

            WHEN candidate.nm_cargo = 'Senador' OR candidate.nm_cargo = 'Deputado Estadual' OR candidate.nm_cargo = 'Vereador' THEN
                -- Eleger os top N candidatos para cada estado ou cidade
                UPDATE Candidatura SET ds_status = 'Eleito'
                WHERE id_cargo = candidate.id_cargo AND (nm_estado = candidate.nm_estado OR nm_cidade = candidate.nm_cidade) AND an_eleicao = an_eleicao_in
                AND (SELECT count(*) FROM Candidatura
                     WHERE id_cargo = candidate.id_cargo AND (nm_estado = candidate.nm_estado OR nm_cidade = candidate.nm_cidade) AND ds_status = 'Eleito' AND an_eleicao = an_eleicao_in)
                     < CASE 
                        WHEN candidate.nm_cargo = 'Senador' THEN 3 
                        WHEN candidate.nm_cargo = 'Deputado Estadual' THEN 40 
                        ELSE 10 -- Vereador
                       END;

            WHEN candidate.nm_cargo = 'Deputado Federal' THEN
                -- Eleger os 513 mais votados independente do estado
                UPDATE Candidatura SET ds_status = 'Eleito'
                WHERE id_cargo = candidate.id_cargo AND an_eleicao = an_eleicao_in
                AND (SELECT count(*) FROM Candidatura
                     WHERE id_cargo = candidate.id_cargo AND ds_status = 'Eleito' AND an_eleicao = an_eleicao_in) < 513;
        END CASE;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;