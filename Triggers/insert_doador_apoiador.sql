CREATE OR REPLACE FUNCTION insert_into_apoiador_doador()
RETURNS TRIGGER AS $$
BEGIN
    -- Inserir em Apoiador se o tipo do indivíduo for 'Apoiador'
    IF NEW.ds_tipo = 'Apoiador' THEN
        INSERT INTO Apoiador (nr_cpf) VALUES (NEW.nr_cpf);
    END IF;

    -- Inserir em Doador se o tipo do indivíduo for 'Doador'
    IF NEW.ds_tipo = 'Doador' THEN
        INSERT INTO Doador (nr_cpf) VALUES (NEW.nr_cpf);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_apoiador_doador
AFTER INSERT ON Individuo
FOR EACH ROW
EXECUTE FUNCTION insert_into_apoiador_doador();
