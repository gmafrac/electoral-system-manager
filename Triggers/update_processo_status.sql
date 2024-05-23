CREATE OR REPLACE FUNCTION update_processo_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.dt_fim IS NOT NULL AND OLD.dt_fim IS NULL THEN
        NEW.st_processo := 'Julgado';
        IF NEW.ds_procedencia IS NULL THEN
            RAISE EXCEPTION 'Ao finalizar um processo, a procedência (ds_procedencia) deve ser especificada.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_processo_status
BEFORE UPDATE ON Processo_judicial
FOR EACH ROW
EXECUTE FUNCTION update_processo_status();
