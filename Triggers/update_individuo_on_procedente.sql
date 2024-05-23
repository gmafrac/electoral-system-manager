CREATE OR REPLACE FUNCTION remove_candidato_on_procedente()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o processo inserido é 'Procedente'
    IF (SELECT ds_procedencia FROM Processo_judicial WHERE id_processo = NEW.id_processo) = 'Procedente' THEN
        -- Verifica se o indivíduo é 'Candidato'
        IF (SELECT ds_tipo FROM Individuo WHERE nr_cpf = NEW.nr_cpf) = 'Candidato' THEN
            -- Exclui o indivíduo da tabela Candidato
            DELETE FROM Candidato WHERE nr_cpf = NEW.nr_cpf;
            -- Atualiza o tipo para NULL na tabela Individuo
            UPDATE Individuo SET ds_tipo = NULL WHERE nr_cpf = NEW.nr_cpf;
            -- Registra uma mensagem no log do servidor PostgreSQL
            RAISE NOTICE 'Candidato com CPF % removido devido a processo judicial Procedente.', NEW.nr_cpf;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_remove_candidato_on_procedente
AFTER INSERT ON Processo_individuo
FOR EACH ROW
EXECUTE FUNCTION remove_candidato_on_procedente();
