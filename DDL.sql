CREATE TABLE Processo_judicial (
    id_processo SERIAL PRIMARY KEY,
    dt_inicio DATE NOT NULL,
    dt_fim DATE,
    ds_procedencia VARCHAR(20) DEFAULT NULL,
    st_processo VARCHAR(20) DEFAULT 'Em tramitação',

    CONSTRAINT ck_procedencia_ds CHECK(ds_procedencia IN ('Procedente', 'Não Procedente') OR ds_procedencia IS NULL)
    CONSTRAINT ck_processo_st CHECK(st_processo IN ('Em tramitação', 'Julgado'))
);

CREATE TABLE Individuo (
    nr_cpf NUMERIC(11) PRIMARY KEY,
    nm_pessoa VARCHAR(200) NOT NULL,
    ds_tipo VARCHAR(10) DEFAULT NULL,
    CONSTRAINT ck_ds_tipo CHECK (ds_tipo IN ('Apoiador', 'Candidato', 'Doador') OR ds_tipo IS NULL)
);

CREATE TABLE Processo_individuo (
    id_processo INTEGER,
    nr_cpf NUMERIC(11),
    PRIMARY KEY (id_processo, nr_cpf),
    CONSTRAINT fk_processo_id FOREIGN KEY (id_processo) REFERENCES Processo_judicial(id_processo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf) REFERENCES Individuo(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Apoiador (
    nr_cpf NUMERIC(11) PRIMARY KEY,
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf) REFERENCES Individuo(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Doador (
    nr_cpf NUMERIC(11) PRIMARY KEY,
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf) REFERENCES Individuo(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Partido (
    nr_partido NUMERIC(2) PRIMARY KEY,
    nm_partido VARCHAR(200) NOT NULL,
    ds_sigla VARCHAR(10) NOT NULL,
    ds_programa VARCHAR(100) NOT NULL,
    ds_intencoes VARCHAR(100) NOT NULL
);

CREATE TABLE Candidato (
    nr_cpf NUMERIC(11),
    nr_partido NUMERIC(2),
    an_eleicao NUMERIC(4) NOT NULL,
    PRIMARY KEY (nr_cpf),
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf) REFERENCES Individuo(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_partido_nr FOREIGN KEY (nr_partido) REFERENCES Partido(nr_partido) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Pais (
    nm_pais VARCHAR(100) PRIMARY KEY,
    sigla_pais VARCHAR(3)
);

CREATE TABLE Estado (
    nm_pais VARCHAR(100),
    nm_estado VARCHAR(100),
    sigla_estado VARCHAR(2),
    PRIMARY KEY (nm_pais, nm_estado),
    CONSTRAINT fk_pais_nm FOREIGN KEY (nm_pais) REFERENCES Pais(nm_pais) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cidade (
    nm_pais VARCHAR(100),
    nm_estado VARCHAR(100),
    nm_cidade VARCHAR(200) PRIMARY KEY,
    CONSTRAINT fk_pais_estado_nm FOREIGN KEY (nm_pais, nm_estado) REFERENCES Estado(nm_pais, nm_estado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cargo (
    id_cargo SERIAL PRIMARY KEY,
    nm_pais VARCHAR(100),
    nm_estado VARCHAR(100) DEFAULT NULL,
    nm_cidade VARCHAR(100) DEFAULT NULL,
    nm_cargo VARCHAR(100) NOT NULL,
    ds_representacao VARCHAR(100) NOT NULL,
    CONSTRAINT fk_pais_nm FOREIGN KEY (nm_pais) REFERENCES Pais(nm_pais) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estado_nm FOREIGN KEY (nm_pais, nm_estado) REFERENCES Estado(nm_pais, nm_estado) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cidade_nm FOREIGN KEY (nm_pais, nm_estado, nm_cidade) REFERENCES Cidade(nm_pais, nm_estado, nm_cidade) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_representacao_ds CHECK (ds_representacao IN ('Federal', 'Estadual', 'Municipal')),
    CONSTRAINT ck_representacao_cargo CHECK (
        (nm_cargo = 'Presidente' AND ds_representacao = 'Federal') OR
        (nm_cargo = 'Vice Presidente' AND ds_representacao = 'Federal') OR
        (nm_cargo = 'Senador' AND ds_representacao = 'Estadual') OR
        (nm_cargo = 'Deputado Federal' AND ds_representacao = 'Federal') OR
        (nm_cargo = 'Governador' AND ds_representacao = 'Estadual') OR
        (nm_cargo = 'Deputado Estadual' AND ds_representacao = 'Estadual') OR
        (nm_cargo = 'Prefeito' AND ds_representacao = 'Municipal') OR
        (nm_cargo = 'Vice Prefeito' AND ds_representacao = 'Municipal') OR
        (nm_cargo = 'Vereador' AND ds_representacao = 'Municipal')
    )
);

CREATE TABLE Candidatura (
    id_candidatura SERIAL PRIMARY KEY,
    nr_cpf_candidato NUMERIC(11) NOT NULL UNIQUE,
    nr_cpf_vice NUMERIC(11),
    id_cargo INTEGER,
    an_eleicao NUMERIC(4),
    nr_pleito INTEGER,
    CONSTRAINT fk_cpf_candidato FOREIGN KEY (nr_cpf_candidato) REFERENCES Candidato(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cpf_vice FOREIGN KEY (nr_cpf_vice) REFERENCES Candidato(nr_cpf) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_cpf_dif CHECK (nr_cpf_candidato IS DISTINCT FROM nr_cpf_vice),
    CONSTRAINT fk_cargo_id FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Equipe_de_apoio (
    id_equipe SERIAL PRIMARY KEY,
    id_candidatura INTEGER,
    nm_equipe VARCHAR(200) NOT NULL,
    an_eleicao NUMERIC(4) NOT NULL,
    CONSTRAINT fk_candidatura_id FOREIGN KEY (id_candidatura) REFERENCES Candidatura(id_candidatura) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT un_equipe_ano UNIQUE (nm_equipe, an_eleicao)
);

CREATE TABLE Apoiador_Equipe (
    nr_cpf NUMERIC(11),
    id_equipe INTEGER,
    an_eleicao NUMERIC(4),
    PRIMARY KEY (nr_cpf, id_equipe),
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf) REFERENCES Apoiador(nr_cpf) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_equipe_eleicao FOREIGN KEY (id_equipe, an_eleicao) REFERENCES Equipe_de_apoio(id_equipe, an_eleicao) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT un_cpf_an UNIQUE (nr_cpf, an_eleicao)
);

CREATE TABLE Empresa (
    nr_cnpj NUMERIC(14) PRIMARY KEY,
    nm_empresa VARCHAR(200)
);

CREATE TABLE Candidatura_doacoes_PJ (
    nr_cnpj_doador NUMERIC(11),
    id_candidatura INTEGER,
    dt_doacao DATE NOT NULL,
    vl_doacao MONEY NOT NULL,
    PRIMARY KEY (nr_cnpj_doador, id_candidatura, dt_doacao),
    CONSTRAINT fk_cnpj_nr FOREIGN KEY (nr_cnpj_doador) REFERENCES Empresa(nr_cnpj) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_candidatura_id FOREIGN KEY (id_candidatura) REFERENCES Candidatura(id_candidatura) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Candidatura_doacoes_PF (
    nr_cpf_doador NUMERIC(11),
    id_candidatura INTEGER,
    dt_doacao DATE NOT NULL,
    vl_doacao MONEY NOT NULL,
    PRIMARY KEY (nr_cpf_doador, id_candidatura, dt_doacao),
    CONSTRAINT fk_cpf_nr FOREIGN KEY (nr_cpf_doador) REFERENCES Doador(nr_cpf) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_candidatura_id FOREIGN KEY (id_candidatura) REFERENCES Candidatura(id_candidatura) ON DELETE SET NULL ON UPDATE CASCADE
);




