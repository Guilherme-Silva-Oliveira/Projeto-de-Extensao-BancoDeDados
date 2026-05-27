 drop database if exists sax_bd;
CREATE DATABASE IF NOT EXISTS sax_bd;
USE sax_bd;

-- class app

CREATE TABLE professor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    email VARCHAR(45),
    telefone VARCHAR(45)
);

CREATE TABLE solicitacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT,
    descricao VARCHAR(45),
    data_solicitacao DATE,
    CONSTRAINT fk_solicitacao_professor FOREIGN KEY (professor_id) REFERENCES professor(id)
);

-- fornecedor

CREATE TABLE tipo_fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(45)
);

CREATE TABLE fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_fornecedor_id INT,
    nome VARCHAR(45),
    email VARCHAR(45),
    telefone VARCHAR(45),
    CONSTRAINT fk_fornecedor_tipo FOREIGN KEY (tipo_fornecedor_id) REFERENCES tipo_fornecedor(id)
);

-- almoxarifado e limites

CREATE TABLE tipo_limite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(45)
);

CREATE TABLE almoxarifado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_sala INT
);

CREATE TABLE almoxarife (
    id INT AUTO_INCREMENT PRIMARY KEY,
    almoxarifado_id INT,
    nome VARCHAR(45),
    email VARCHAR(45),
    telefone VARCHAR(45),
    senha VARCHAR(255),
    CONSTRAINT fk_almoxarife_almoxarifado FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id)
);

-- material (unidade de medida e categoria)

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(45)
);

CREATE TABLE unidade_medida (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_unidade VARCHAR(45)
);

CREATE TABLE material (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT,
    almoxarifado_id INT,
    nome_material VARCHAR(45),
    unidade_medida_id INT,
    quantidade INT,
    CONSTRAINT fk_material_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    CONSTRAINT fk_material_almoxarifado FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id),
    CONSTRAINT fk_material_unidade FOREIGN KEY (unidade_medida_id) REFERENCES unidade_medida(id)
);

CREATE TABLE limite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    limite VARCHAR(45),
    tipo_limite_id INT,
    material_id INT,
    CONSTRAINT fk_material FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT fk_limites_tipo FOREIGN KEY (tipo_limite_id) REFERENCES tipo_limite(id)
);

CREATE TABLE codigo_barras(
	id INT PRIMARY KEY AUTO_INCREMENT,
	codigo VARCHAR(100),
    material_id INT,
    CONSTRAINT fk_material_codigo FOREIGN KEY (material_id) REFERENCES material(id)
);

-- Entradas e Saídas

-- tabelas de pedido (relacionamentos muitos para muitos) e escala da saída
CREATE TABLE pedido_entrada (
    fornecedor_id INT,
    material_id INT,
    quantidade INT,
    data_entrada DATE,
    PRIMARY KEY (fornecedor_id, material_id),
    CONSTRAINT fk_ped_ent_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id),
    CONSTRAINT fk_ped_ent_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE escala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_escala VARCHAR(45)
);

CREATE TABLE pedido_saida (
    material_id INT,
    solicitacao_id INT,
    escala_id INT,
    quantidade INT,
    data_solicitacao DATE,
    PRIMARY KEY (material_id, solicitacao_id),
    CONSTRAINT fk_ped_sai_material FOREIGN KEY (material_id) REFERENCES material(id),
    CONSTRAINT fk_ped_sai_solicitacao FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id),
    CONSTRAINT fk_ped_sai_escala FOREIGN KEY (escala_id) REFERENCES escala(id)
);

CREATE TABLE inteligencia_artificial(
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome_modelo VARCHAR(45),
    tokens_utilizados BIGINT,
    ultima_utilizacao DATETIME
    );
    
INSERT INTO inteligencia_artificial (nome_modelo, tokens_utilizados, ultima_utilizacao) VALUES
('Modelo 01', 1250000, '2026-05-26 14:30:00'),
('Modelo 02', 850300, '2026-05-26 15:45:12'),
('llama-3.3-70b-versatile', 3200100, '2026-05-26 18:20:42'),
('chat gpt', 450000, '2026-05-25 09:15:30');


-- CADASTROS
select * from solicitacao;
insert into almoxarifado (numero_sala) values (1);
insert into almoxarife (almoxarifado_id,nome,email,senha) values (1,"Guilherme Silva","guilherme@gmail.com","$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK");
insert into categoria (nome_categoria) values ('categoria');
insert into unidade_medida (nome_unidade) values ('unidade');
insert into almoxarifado (numero_sala) values (123);

select * from material;

select * from almoxarife;