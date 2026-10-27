DROP DATABASE IF EXISTS sax_bd;
CREATE DATABASE IF NOT EXISTS sax_bd;
USE sax_bd;
SELECT *
FROM mysql.user;
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

CREATE TABLE almoxarifado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_sala INT NOT NULL
);

CREATE TABLE almoxarife (
    id INT AUTO_INCREMENT PRIMARY KEY,
    almoxarifado_id INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    role VARCHAR(45),
    email VARCHAR(45) NOT NULL,
    telefone VARCHAR(45) NOT NULL,
    data_criacao DATE,
    ultimo_acesso DATETIME,
    status_usuario TINYINT(1),
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

CREATE TABLE setor_estoque (
	id INT AUTO_INCREMENT PRIMARY KEY,
    almoxarifado_id INT,
    identificador_setor VARCHAR(255) NOT NULL,
    CONSTRAINT fk_almoxarifado_setor FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id)
);

CREATE TABLE material (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    almoxarifado_id INT NOT NULL,
    setor_id INT NOT NULL,
    nome_material VARCHAR(45) NOT NULL,
    unidade_medida_id INT NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(200),
    deve_devolver TINYINT(1),
    data_vencimento DATE,
    CONSTRAINT fk_material_setor FOREIGN KEY (setor_id) REFERENCES setor_estoque(id),
    CONSTRAINT fk_material_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    CONSTRAINT fk_material_almoxarifado FOREIGN KEY (almoxarifado_id) REFERENCES almoxarifado(id),
    CONSTRAINT fk_material_unidade FOREIGN KEY (unidade_medida_id) REFERENCES unidade_medida(id)
);

CREATE TABLE limite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    desc_limite VARCHAR(45) NOT NULL,
    limite DECIMAL(10,2),
    material_id INT NOT NULL,
    CONSTRAINT fk_limite_material FOREIGN KEY (material_id) REFERENCES material(id)
);

CREATE TABLE pedido_entrada (
	id INT PRIMARY KEY AUTO_INCREMENT,
	professor_id INT,
    fornecedor_id INT,
    material_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_entrada DATETIME NOT NULL,
    is_devolucao BOOLEAN DEFAULT 0,
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
    inteligencia_artificial_id INT,
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
    motivo_reprovacao VARCHAR(500),
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

CREATE TABLE alerta_verificacao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data_criacao DATETIME,
    solicitacao_id INT,
	CONSTRAINT fk_verificacao_solicitacao FOREIGN KEY (solicitacao_id) REFERENCES solicitacao(id)
);
SELECT * FROM alerta_verificacao;

-- CADASTROS
INSERT INTO almoxarifado (numero_sala) VALUES (123);

INSERT INTO almoxarife (almoxarifado_id, nome, role , email, telefone, data_criacao, ultimo_acesso, status_usuario, senha) VALUES
(1, 'Guilherme Silva','ADMIN', 'guilherme@gmail.com', '11988888888', '2026-05-21 18:20:42' , '2026-05-26 18:20:42' , 1 ,'$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK');

INSERT INTO inteligencia_artificial (nome_modelo, tokens_utilizados, ultima_utilizacao) VALUES
('llama-3.3-70b-versatile', 3200100, '2026-05-26 18:20:42');

INSERT INTO status_historico (desc_status) VALUES ("RECEBIDA"), ("ACEITA"),("REJEITADA"),("PENDENTE_ENTREGA"),("PRAZO_EXPIRADO"),("CANCELADA"),("FINALIZADA"),("PENDENTE_DEVOLUÇÃO");

INSERT INTO setor_estoque (almoxarifado_id, identificador_setor) VALUES
(1,'Setor A'),(1,'Setor B'),(1,'Setor C');



-- SELECTS DE TODAS AS TABELAS (Testadas)
SELECT * FROM almoxarifado;
SELECT * FROM almoxarife;
SELECT * FROM categoria;
SELECT * FROM tipo_fornecedor;
SELECT * FROM fornecedor;
SELECT * FROM unidade_medida;
SELECT * FROM material;
SELECT * FROM pedido_entrada;
SELECT * FROM professor;
SELECT * FROM motivo;
SELECT * FROM limite;
SELECT * FROM inteligencia_artificial;
SELECT * FROM solicitacao;
SELECT * FROM lista_material;
SELECT * FROM historico;
SELECT * FROM status_historico;
SELECT * FROM alerta_devolucao;
SELECT * FROM alerta_solicitacao;
SELECT * FROM alerta_verificacao;


USE sax_bd;

-- =====================================================
-- 1. PROFESSORES
-- =====================================================

INSERT INTO professor (nome, email, telefone) VALUES
('Ana Carolina Souza', 'ana.souza@escola.com', '11987651001'),
('Bruno Henrique Lima', 'bruno.lima@escola.com', '11987651002'),
('Camila Ferreira Alves', 'camila.alves@escola.com', '11987651003'),
('Diego Martins Costa', 'diego.costa@escola.com', '11987651004'),
('Eduarda Oliveira Santos', 'eduarda.santos@escola.com', '11987651005'),
('Felipe Rodrigues Melo', 'felipe.melo@escola.com', '11987651006'),
('Mariana Ribeiro Lopes', 'mariana.lopes@escola.com', '11987651007'),
('Rafael Gomes Pereira', 'rafael.pereira@escola.com', '11987651008');

-- =====================================================
-- 2. MOTIVOS DAS SOLICITAÇÕES
-- =====================================================

INSERT INTO motivo (descricao) VALUES
('Aula prática'),
('Reposição de materiais'),
('Projeto interdisciplinar'),
('Atividade avaliativa'),
('Evento escolar'),
('Manutenção'),
('Experimento de laboratório'),
('Uso administrativo');

-- =====================================================
-- 3. TIPOS DE FORNECEDOR
-- =====================================================

INSERT INTO tipo_fornecedor (nome_tipo) VALUES
('Papelaria'),
('Informática'),
('Laboratório'),
('Material de limpeza'),
('Distribuidora geral');

-- =====================================================
-- 4. FORNECEDORES
-- =====================================================

INSERT INTO fornecedor
(tipo_fornecedor_id, nome, email, telefone) VALUES
(1, 'Papelaria Central', 'vendas@papelariacentral.com', '1130011001'),
(1, 'Mundo do Papel', 'contato@mundodopapel.com', '1130011002'),
(2, 'Tech Escolar', 'vendas@techescolar.com', '1130011003'),
(3, 'Lab Solutions', 'contato@labsolutions.com', '1130011004'),
(4, 'Limpeza Total', 'vendas@limpezatotal.com', '1130011005'),
(5, 'Distribuidora Paulista', 'pedidos@distribuidorapaulista.com', '1130011006');

-- =====================================================
-- 5. CATEGORIAS
-- =====================================================

INSERT INTO categoria (nome_categoria) VALUES
('Papelaria'),
('Informática'),
('Laboratório'),
('Limpeza'),
('Escritório'),
('Artes'),
('Segurança'),
('Consumo geral');

-- =====================================================
-- 6. UNIDADES DE MEDIDA
-- =====================================================

INSERT INTO unidade_medida (nome_unidade) VALUES
('Unidade'),
('Pacote'),
('Caixa'),
('Resma'),
('Litro'),
('Quilograma'),
('Metro'),
('Par');

-- =====================================================
-- 7. MATERIAIS
-- Pressupõe almoxarifado ID 1 e setores ID 1, 2 e 3
-- =====================================================

INSERT INTO material
(categoria_id, almoxarifado_id, setor_id, nome_material,
 unidade_medida_id, quantidade, descricao, deve_devolver,
 data_vencimento) VALUES

(1, 1, 1, 'Papel A4', 4, 120,
 'Resma de papel sulfite A4', 0, NULL),

(1, 1, 1, 'Caneta azul', 1, 250,
 'Caneta esferográfica azul', 0, NULL),

(1, 1, 1, 'Lapis grafite', 1, 180,
 'Lápis grafite para atividades escolares', 0, NULL),

(5, 1, 1, 'Borracha branca', 1, 100,
 'Borracha branca escolar', 0, NULL),

(6, 1, 2, 'Tinta guache', 3, 35,
 'Caixa de tintas guache coloridas', 0, '2027-12-31'),

(6, 1, 2, 'Pincel escolar', 1, 60,
 'Pincel para atividades artísticas', 0, NULL),

(2, 1, 2, 'Mouse USB', 1, 25,
 'Mouse USB para uso em laboratório de informática', 1, NULL),

(2, 1, 2, 'Teclado USB', 1, 18,
 'Teclado USB para computadores da escola', 1, NULL),

(3, 1, 3, 'Bequer 250ml', 1, 40,
 'Recipiente de vidro para experimentos', 1, NULL),

(3, 1, 3, 'Proveta 100ml', 1, 20,
 'Proveta graduada para laboratório', 1, NULL),

(3, 1, 3, 'Luvas descartaveis', 2, 15,
 'Pacote de luvas para experimentos', 0, '2027-06-30'),

(4, 1, 3, 'Detergente', 5, 8,
 'Detergente para limpeza geral', 0, '2027-02-28'),

(4, 1, 3, 'Alcool 70', 5, 12,
 'Álcool 70 para higienização', 0, '2027-03-31'),

(5, 1, 1, 'Grampeador', 1, 12,
 'Grampeador de mesa', 1, NULL),

(5, 1, 1, 'Grampo metalico', 3, 30,
 'Caixa de grampos para grampeador', 0, NULL),

(7, 1, 3, 'Oculos protecao', 1, 22,
 'Óculos de proteção para laboratório', 1, NULL),

(8, 1, 2, 'Extensao eletrica', 1, 6,
 'Extensão elétrica para atividades escolares', 1, NULL),

(1, 1, 1, 'Marcador quadro', 1, 45,
 'Marcador para quadro branco', 0, NULL);

-- =====================================================
-- 8. LIMITES DE ESTOQUE
-- =====================================================

INSERT INTO limite (desc_limite, limite, material_id) VALUES
('Estoque minimo', 30, 1),
('Estoque minimo', 50, 2),
('Estoque minimo', 40, 3),
('Estoque minimo', 20, 4),
('Estoque minimo', 10, 5),
('Estoque minimo', 15, 6),
('Estoque minimo', 10, 7),
('Estoque minimo', 8, 8),
('Estoque minimo', 15, 9),
('Estoque minimo', 10, 10),
('Estoque minimo', 20, 11),
('Estoque minimo', 10, 12),
('Estoque minimo', 10, 13),
('Estoque minimo', 5, 14),
('Estoque minimo', 10, 15),
('Estoque minimo', 10, 16),
('Estoque minimo', 5, 17),
('Estoque minimo', 15, 18);

select * from alerta_solicitacao;
select * from alerta_devolucao;
select * from alerta_verificacao;