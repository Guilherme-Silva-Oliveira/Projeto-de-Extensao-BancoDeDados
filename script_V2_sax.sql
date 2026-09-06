DROP DATABASE IF EXISTS sax_bd;
CREATE DATABASE IF NOT EXISTS sax_bd;
USE sax_bd;

-- class app

CREATE TABLE professor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    telefone VARCHAR(45) NOT NULL
);

CREATE TABLE motivo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

-- fornecedor

CREATE TABLE tipo_fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(45) NOT NULL
);

CREATE TABLE fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_fornecedor_id INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    telefone VARCHAR(45) NOT NULL,
    CONSTRAINT fk_fornecedor_tipo FOREIGN KEY (tipo_fornecedor_id) REFERENCES tipo_fornecedor(id)
);

-- almoxarifado e limites

CREATE TABLE tipo_limite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(45) NOT NULL
);

CREATE TABLE almoxarifado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_sala INT NOT NULL
);

CREATE TABLE almoxarife (
    id INT AUTO_INCREMENT PRIMARY KEY,
    almoxarifado_id INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    telefone VARCHAR(45) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    CONSTRAINT fk_almoxarife_almoxarifado FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id)
);

-- material (unidade de medida e categoria)

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(45) NOT NULL
);

CREATE TABLE unidade_medida (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_unidade VARCHAR(45) NOT NULL
);

CREATE TABLE material (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    almoxarifado_id INT NOT NULL,
    nome_material VARCHAR(45) NOT NULL,
    unidade_medida_id INT NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(200),
    deve_devolver TINYINT(1),
    CONSTRAINT fk_material_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    CONSTRAINT fk_material_almoxarifado FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id),
    CONSTRAINT fk_material_unidade FOREIGN KEY (unidade_medida_id) REFERENCES unidade_medida(id)
);

CREATE TABLE limite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    limite VARCHAR(45) NOT NULL,
    tipo_limite_id INT NOT NULL,
    material_id INT NOT NULL,
    CONSTRAINT fk_limite_material FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT fk_limite_tipo FOREIGN KEY (tipo_limite_id) REFERENCES tipo_limite(id)
);

CREATE TABLE codigo_barras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL,
    material_id INT NOT NULL,
    CONSTRAINT fk_codigo_barras_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE pedido_entrada (
	professor_id INT,
    fornecedor_id INT NOT NULL,
    material_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_entrada DATETIME NOT NULL,
    is_devolucao BOOLEAN DEFAULT 0,
    PRIMARY KEY (fornecedor_id, material_id),
    CONSTRAINT fk_pedido_entrada_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id),
    CONSTRAINT fk_pedido_entrada_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE inteligencia_artificial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_modelo VARCHAR(45) NOT NULL,
    tokens_utilizados BIGINT,
    ultima_utilizacao DATETIME
);

CREATE TABLE solicitacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT NOT NULL,
    motivo_id INT NOT NULL,
    materiais VARCHAR(255) NOT NULL,
    inteligencia_artificial_id INT NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    data_solicitacao DATETIME NOT NULL,
    data_para_envio DATETIME NOT NULL,
    alerta VARCHAR(255),
    CONSTRAINT fk_solicitacao_professor FOREIGN KEY (professor_id) REFERENCES professor(id),
    CONSTRAINT fk_solicitacao_motivo FOREIGN KEY (motivo_id) REFERENCES motivo(id)
);

CREATE TABLE lista_material (
	id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT,
    material_id INT,
    reservado TINYINT(1),
    deve_devolver TINYINT(1),
    quantidade INT,
    CONSTRAINT fk_material_lista FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT fk_solicitacao_lista FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id)
);

CREATE TABLE historico (
	id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT NOT NULL,
    data_alteracao DATETIME NOT NULL,
    status_solicitacao VARCHAR(45) NOT NULL,
    CONSTRAINT fk_solicitacao_historico FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id)
);

CREATE TABLE alerta_devolucao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT,
    professor_id INT,
    descricao VARCHAR(255) NOT NULL,
    devolvido TINYINT(1) NOT NULL,
    CONSTRAINT fk_solicitacao_devolucao FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id),
    CONSTRAINT fk_professor_devolucao FOREIGN KEY (professor_id) REFERENCES professor(id)
);

CREATE TABLE status_historico (
	id INT AUTO_INCREMENT PRIMARY KEY,
    desc_status VARCHAR(45) NOT NULL
);

CREATE TABLE alerta_solicitacao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    solicitacao_id INT,
    descricao VARCHAR(255) NOT NULL,
    resolvido TINYINT(1) NOT NULL,
    CONSTRAINT fk_solicitacao_alerta FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id)
);

-- CADASTROS
INSERT INTO almoxarifado (numero_sala) VALUES (123);
INSERT INTO almoxarife (almoxarifado_id, nome, email, telefone, senha) VALUES
(1, 'Guilherme Silva', 'guilherme@gmail.com', '11988888888', '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK');

INSERT INTO inteligencia_artificial (nome_modelo, tokens_utilizados, ultima_utilizacao) VALUES
('llama-3.3-70b-versatile', 3200100, '2026-05-26 18:20:42');

INSERT INTO status_historico (desc_status) VALUES ("RECEBIDA"), ("ACEITA"),("REJEITADA"),("PENDENTE_ENTREGA"),("PRAZO_EXPIRADO"),("CANCELADA"),("FINALIZADA"),("PENDENTE_DEVOLUÇÃO");

-- SELECTS DE TODAS AS TABELAS (Testadas)
SELECT * FROM almoxarifado;
SELECT * FROM almoxarife;
SELECT * FROM categoria;
SELECT * FROM tipo_fornecedor;
SELECT * FROM fornecedor;
SELECT * FROM unidade_medida;
SELECT * FROM material;
SELECT * FROM codigo_barras;
SELECT * FROM pedido_entrada;
SELECT * FROM professor;
SELECT * FROM motivo;
SELECT * FROM tipo_limite;
SELECT * FROM limite;
SELECT * FROM inteligencia_artificial;
SELECT * FROM solicitacao;
SELECT * FROM lista_material;
SELECT * FROM historico;
SELECT * FROM status_historico;
SELECT * FROM alerta_devolucao;
SELECT * FROM alerta_solicitacao;