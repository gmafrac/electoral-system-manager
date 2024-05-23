CREATE OR REPLACE FUNCTION atualizar_status_candidaturas()
RETURNS TRIGGER AS $$
DECLARE
    total_votes INTEGER;
BEGIN
    IF NEW.ds_status IS NULL THEN
        -- Verifica o cargo da candidatura
        CASE (SELECT nm_cargo FROM Cargo WHERE id_cargo = NEW.id_cargo)
            WHEN 'Presidente' THEN
                -- Determina o total de votos para o cargo de presidente no pleito atual
                SELECT COUNT(*)
                INTO total_votes
                FROM Voto
                WHERE nr_pleito = NEW.nr_pleito AND id_candidatura IN (
                    SELECT id_candidatura FROM Candidatura WHERE id_cargo = NEW.id_cargo
                );
                -- Atualiza o status do cargo de presidente para 'ELEITO' se for o mais votado, senão para 'NÃO ELEITO'
                IF NEW.id_candidatura IN (
                    SELECT id_candidatura
                    FROM Candidatura
                    WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito
                    ORDER BY total_votes DESC
                    LIMIT 1
                ) THEN
                    UPDATE Candidatura
                    SET ds_status = 'ELEITO'
                    WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito;
                ELSE
                    UPDATE Candidatura
                    SET ds_status = 'NÃO ELEITO'
                    WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito;
                END IF;

            WHEN 'Deputado Federal' THEN
                -- Determina o total de candidaturas para deputado federal no pleito atual
                SELECT COUNT(*)
                INTO total_votes
                FROM Candidatura
                WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito;
                -- Atualiza o status das 500 candidaturas mais votadas para 'ELEITO' e o restante para 'NÃO ELEITO'
                UPDATE Candidatura
                SET ds_status = CASE
                    WHEN id_candidatura IN (
                        SELECT id_candidatura
                        FROM Candidatura
                        WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito
                        ORDER BY nr_votos DESC
                        LIMIT 500
                    ) THEN 'ELEITO'
                    ELSE 'NÃO ELEITO'
                    END
                WHERE id_cargo = NEW.id_cargo AND nr_pleito = NEW.nr_pleito;
                
            -- Adicione mais casos para outros cargos, se necessário
            
            ELSE
                -- Não faz nada para outros cargos
                NULL;
        END CASE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_status_candidaturas
AFTER INSERT ON Voto
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_candidaturas();
