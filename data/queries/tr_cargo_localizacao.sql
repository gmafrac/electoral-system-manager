CREATE OR REPLACE FUNCTION add_federal_positions()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Cargo (nm_pais, nm_cargo, ds_representacao) VALUES 
    (NEW.nm_pais, 'Presidente', 'Federal'),
    (NEW.nm_pais, 'Vice Presidente', 'Federal'),
    (NEW.nm_pais, 'Deputado Federal', 'Federal');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_add_federal_positions
AFTER INSERT ON Pais
FOR EACH ROW
EXECUTE FUNCTION add_federal_positions();

CREATE OR REPLACE FUNCTION add_state_positions()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Cargo (nm_pais, nm_estado, nm_cargo, ds_representacao) VALUES 
    (NEW.nm_pais, NEW.nm_estado, 'Senador', 'Estadual'),
    (NEW.nm_pais, NEW.nm_estado, 'Governador', 'Estadual'),
    (NEW.nm_pais, NEW.nm_estado, 'Deputado Estadual', 'Estadual');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_add_state_positions
AFTER INSERT ON Estado
FOR EACH ROW
EXECUTE FUNCTION add_state_positions();

CREATE OR REPLACE FUNCTION add_municipal_positions()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Cargo (nm_pais, nm_estado, nm_cidade, nm_cargo, ds_representacao) VALUES 
    (NEW.nm_pais, NEW.nm_estado, NEW.nm_cidade, 'Prefeito', 'Municipal'),
    (NEW.nm_pais, NEW.nm_estado, NEW.nm_cidade, 'Vice Prefeito', 'Municipal'),
    (NEW.nm_pais, NEW.nm_estado, NEW.nm_cidade, 'Vereador', 'Municipal');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_add_municipal_positions
AFTER INSERT ON Cidade
FOR EACH ROW
EXECUTE FUNCTION add_municipal_positions();

