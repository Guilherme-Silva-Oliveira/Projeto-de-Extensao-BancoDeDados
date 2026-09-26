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

CREATE TABLE solicitacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT NOT NULL,
    motivo_id INT NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    data_solicitacao DATETIME NOT NULL,
    is_aceito BOOLEAN DEFAULT 0,
    CONSTRAINT fk_solicitacao_professor FOREIGN KEY (professor_id) REFERENCES professor(id),
    CONSTRAINT fk_solicitacao_motivo FOREIGN KEY (motivo_id) REFERENCES motivo(id)
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

-- Entradas e Saídas

-- tabelas de pedido (relacionamentos muitos para muitos) e escala da saída

CREATE TABLE pedido_entrada (
    fornecedor_id INT NOT NULL,
    material_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_entrada DATETIME NOT NULL,
    is_devolucao BOOLEAN DEFAULT 0,
    PRIMARY KEY (fornecedor_id, material_id),
    CONSTRAINT fk_pedido_entrada_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id),
    CONSTRAINT fk_pedido_entrada_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE escala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_escala VARCHAR(45) NOT NULL
);

CREATE TABLE inteligencia_artificial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_modelo VARCHAR(45) NOT NULL,
    tokens_utilizados BIGINT,
    ultima_utilizacao DATETIME
);

CREATE TABLE pedido_saida (
    material_id INT NOT NULL,
    solicitacao_id INT NOT NULL,
    escala_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_solicitacao DATETIME NOT NULL,
    inteligencia_artificial_id INT,
    PRIMARY KEY (material_id, solicitacao_id),
    CONSTRAINT fk_pedido_saida_material FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT fk_pedido_saida_solicitacao FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id),
    CONSTRAINT fk_pedido_saida_escala FOREIGN KEY (escala_id) REFERENCES escala(id),
    CONSTRAINT fk_pedido_saida_inteligencia_artificial FOREIGN KEY (inteligencia_artificial_id) REFERENCES inteligencia_artificial(id)
);

-- CADASTROS

INSERT INTO tipo_fornecedor (nome_tipo) VALUES
('Distribuidor'),
('Fabricante');

INSERT INTO tipo_limite (tipo) VALUES
('Mínimo'),
('Máximo');

INSERT INTO almoxarifado (numero_sala) VALUES
(1),
(123);

INSERT INTO categoria (nome_categoria) VALUES
('categoria');

INSERT INTO unidade_medida (nome_unidade) VALUES
('unidade');

INSERT INTO escala (nome_escala) VALUES
('Média');

INSERT INTO professor (nome, email, telefone) VALUES
('Pedro Ferro', 'Pedro@Xingu.com', '11945638342');

INSERT INTO motivo (descricao) VALUES
('Atividade Avaliativa'),
('Provas'),
('Projeto'),
('Trabalho em Grupo');

INSERT INTO fornecedor (tipo_fornecedor_id, nome, email, telefone) VALUES
(1, 'Fornecedor Exemplo', 'fornecedor@example.com', '11999999999');

INSERT INTO almoxarife (almoxarifado_id, nome, email, telefone, senha) VALUES
(1, 'Guilherme Silva', 'guilherme@gmail.com', '11988888888', '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK');

INSERT INTO material (categoria_id, almoxarifado_id, nome_material, unidade_medida_id, quantidade, descricao) VALUES
(1, 1, 'Papel Sulfite', 1, 100, 'Folha sulfite branca A4'),
(1, 1, 'Caneta Azul', 1, 50, 'Caneta esferografica azul');

INSERT INTO limite (limite, tipo_limite_id, material_id) VALUES
('10', 1, 1),
('200', 2, 1);

INSERT INTO codigo_barras (codigo, material_id) VALUES
('1234567890123', 1);

INSERT INTO pedido_entrada (fornecedor_id, material_id, quantidade, data_entrada, is_devolucao) VALUES
(1, 1, 20, '2026-05-26 14:30:00', 0);

INSERT INTO solicitacao (professor_id, motivo_id, descricao, data_solicitacao, is_aceito) VALUES
(1, 1, 'Atividade Avaliativa', '2026-05-26 15:45:12', 0);

INSERT INTO inteligencia_artificial (nome_modelo, tokens_utilizados, ultima_utilizacao) VALUES
('Modelo 01', 1250000, '2026-05-26 14:30:00'),
('Modelo 02', 850300, '2026-05-26 15:45:12'),
('llama-3.3-70b-versatile', 3200100, '2026-05-26 18:20:42'),
('chat gpt', 450000, '2026-05-25 09:15:30');

INSERT INTO pedido_saida (material_id, solicitacao_id, escala_id, quantidade, data_solicitacao, inteligencia_artificial_id) VALUES
(1, 1, 1, 5, '2026-05-26 15:45:12', 1);
