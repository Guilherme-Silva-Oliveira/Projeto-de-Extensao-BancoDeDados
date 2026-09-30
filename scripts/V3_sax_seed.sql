USE sax_bd;

-- =========================================================
-- PROFESSORES
-- =========================================================

INSERT INTO professor (nome, email, telefone) VALUES
('Carlos Eduardo Silva', 'carlos.silva@escola.com', '(11) 99911-2233'),
('Mariana Oliveira Santos', 'mariana.santos@escola.com', '(11) 99822-3344'),
('Rafael Almeida Costa', 'rafael.costa@escola.com', '(11) 99733-4455'),
('Juliana Martins Souza', 'juliana.souza@escola.com', '(11) 99644-5566'),
('Fernanda Rodrigues Lima', 'fernanda.lima@escola.com', '(11) 99555-6677');


-- =========================================================
-- MOTIVOS
-- =========================================================

INSERT INTO motivo (descricao) VALUES
('Material para aula'),
('Reposição de material'),
('Projeto escolar'),
('Atividade prática'),
('Evento escolar');


-- =========================================================
-- TIPOS DE FORNECEDOR
-- =========================================================

INSERT INTO tipo_fornecedor (nome_tipo) VALUES
('Fabricante'),
('Distribuidor'),
('Papelaria'),
('Atacadista');


-- =========================================================
-- FORNECEDORES
-- =========================================================

INSERT INTO fornecedor
(tipo_fornecedor_id, nome, email, telefone)
VALUES
(1, 'Faber-Castell Brasil', 'contato@faber-castell.com.br', '(11) 4000-1000'),
(2, 'Kalunga', 'vendas@kalunga.com.br', '(11) 4000-2000'),
(3, 'Papelaria Santo André', 'contato@papelariasa.com.br', '(11) 4000-3000'),
(4, 'Atacado Escolar ABC', 'vendas@atacadoabc.com.br', '(11) 4000-4000');


-- =========================================================
-- TIPOS DE LIMITE
-- =========================================================

INSERT INTO tipo_limite (tipo) VALUES
('Mínimo'),
('Máximo'),
('Alerta');


-- =========================================================
-- ALMOXARIFADOS
-- =========================================================

INSERT INTO almoxarifado (numero_sala) VALUES
(101),
(102);


-- =========================================================
-- ALMOXARIFES
-- =========================================================

INSERT INTO almoxarife
(almoxarifado_id, nome, role, email, telefone,
 data_criacao, ultimo_acesso, status_usuario, senha)
VALUES
(
    1,
    'João da Silva',
    'ADMIN',
    'joao.almoxarife@escola.com',
    '(11) 98811-1111',
    '2026-01-10',
    '2026-09-25 08:30:00',
    1,
    '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK'
),
(
    1,
    'Ana Paula Mendes',
    'ALMOXARIFE',
    'ana.almoxarife@escola.com',
    '(11) 98822-2222',
    '2026-02-15',
    '2026-09-24 14:20:00',
    1,
    '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK'
),
(
    2,
    'Lucas Ferreira',
    'ALMOXARIFE',
    'lucas.almoxarife@escola.com',
    '(11) 98833-3333',
    '2026-03-01',
    '2026-09-23 10:15:00',
    1,
    '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK'
);


-- =========================================================
-- CATEGORIAS
-- =========================================================

INSERT INTO categoria (nome_categoria) VALUES
('Papelaria e Escritório'),
('Informática e Eletrônicos'),
('Produtos de Limpeza'),
('Equipamentos Didáticos'),
('Ferramentas e Hardware');


-- =========================================================
-- UNIDADES DE MEDIDA
-- =========================================================

INSERT INTO unidade_medida (nome_unidade) VALUES
('Unidade'),
('Caixa'),
('Pacote'),
('Litro'),
('Metro'),
('Quilo');


-- =========================================================
-- SETORES DO ESTOQUE
-- =========================================================

INSERT INTO setor_estoque
(almoxarifado_id, identificador_setor)
VALUES
(1, 'A-01 - Papelaria'),
(1, 'A-02 - Pintura'),
(1, 'A-03 - Artesanato'),
(2, 'B-01 - Material Didático');


-- =========================================================
-- MATERIAIS
-- =========================================================

INSERT INTO material
(
    categoria_id,
    almoxarifado_id,
    setor_id,
    nome_material,
    unidade_medida_id,
    quantidade,
    descricao,
    deve_devolver,
    data_vencimento
)
VALUES
(
    1,
    1,
    1,
    'Papel Sulfite A4',
    3,
    150,
    'Pacote com 500 folhas',
    0,
    NULL
),
(
    2,
    1,
    2,
    'Tinta Guache',
    1,
    25,
    'Tinta guache 250ml',
    0,
    '2027-06-30'
),
(
    2,
    1,
    2,
    'Tinta Acrílica',
    1,
    8,
    'Tinta acrílica escolar',
    0,
    '2026-11-30'
),
(
    3,
    1,
    3,
    'Cola Branca',
    1,
    12,
    'Cola branca escolar 110g',
    0,
    '2027-03-15'
),
(
    3,
    1,
    3,
    'Tesoura Escolar',
    1,
    30,
    'Tesoura sem ponta',
    1,
    NULL
),
(
    4,
    2,
    4,
    'Lápis de Cor',
    1,
    5,
    'Caixa com 12 cores',
    0,
    NULL
),
(
    4,
    2,
    4,
    'Caneta Hidrográfica',
    3,
    3,
    'Pacote com 12 unidades',
    0,
    NULL
),
(
    5,
    2,
    4,
    'Cartolina',
    1,
    80,
    'Cartolina escolar colorida',
    0,
    NULL
);


-- =========================================================
-- LIMITES
-- =========================================================

INSERT INTO limite
(limite, tipo_limite_id, material_id)
VALUES
('20', 1, 1),
('300', 2, 1),

('5', 1, 2),
('50', 2, 2),

('10', 1, 3),
('40', 2, 3),

('5', 1, 4),
('30', 2, 4),

('10', 1, 5),
('50', 2, 5),

('10', 1, 6),
('100', 2, 6),

('10', 1, 7),
('100', 2, 7),

('20', 1, 8),
('200', 2, 8);


-- =========================================================
-- CÓDIGOS DE BARRAS
-- =========================================================

INSERT INTO codigo_barras
(codigo, material_id)
VALUES
('7891234560011', 1),
('7891234560028', 2),
('7891234560035', 3),
('7891234560042', 4),
('7891234560059', 5),
('7891234560066', 6),
('7891234560073', 7),
('7891234560080', 8);


-- =========================================================
-- PEDIDOS DE ENTRADA
-- =========================================================

INSERT INTO pedido_entrada
(professor_id, fornecedor_id, material_id, quantidade,
 data_entrada, is_devolucao)
VALUES
(
    NULL,
    2,
    1,
    100,
    '2026-08-10 09:00:00',
    0
),
(
    NULL,
    1,
    2,
    30,
    '2026-08-15 10:30:00',
    0
),
(
    1,
    2,
    5,
    5,
    '2026-09-01 14:00:00',
    1
),
(
    NULL,
    3,
    4,
    20,
    '2026-09-05 11:15:00',
    0
);


-- =========================================================
-- INTELIGÊNCIA ARTIFICIAL
-- =========================================================

INSERT INTO inteligencia_artificial
(nome_modelo, tokens_utilizados, ultima_utilizacao)
VALUES
(
    'gpt-4o-mini',
    15420,
    '2026-09-25 10:30:00'
),
(
    'gpt-4.1',
    8730,
    '2026-09-24 16:45:00'
);


-- =========================================================
-- SOLICITAÇÕES
-- =========================================================

INSERT INTO solicitacao
(
    professor_id,
    motivo_id,
    materiais,
    inteligencia_artificial_id,
    descricao,
    data_solicitacao,
    data_para_envio,
    alerta
)
VALUES
(
    1,
    1,
    'Papel Sulfite A4, Tinta Guache',
    1,
    'Material para aula',
    '2026-09-20 08:30:00',
    '2026-09-20 09:00:00',
    NULL
),
(
    2,
    4,
    'Tinta Acrílica, Cartolina',
    1,
    'Aula de artes',
    '2026-09-21 10:15:00',
    '2026-09-21 11:00:00',
    'Material com estoque baixo'
),
(
    3,
    3,
    'Tesoura Escolar, Cola Branca',
    2,
    'Projeto escolar',
    '2026-09-22 13:00:00',
    '2026-09-22 14:00:00',
    NULL
),
(
    4,
    1,
    'Lápis de Cor, Caneta Hidrográfica',
    1,
    'Atividade artística',
    '2026-09-23 09:20:00',
    '2026-09-23 10:00:00',
    NULL
),
(
    5,
    5,
    'Cartolina',
    2,
    'Evento escolar',
    '2026-09-24 15:30:00',
    '2026-09-24 16:00:00',
    NULL
);


-- =========================================================
-- LISTA DE MATERIAIS DAS SOLICITAÇÕES
-- =========================================================

INSERT INTO lista_material
(
    solicitacao_id,
    material_id,
    reservado,
    deve_devolver,
    quantidade
)
VALUES
-- Solicitação 1
(1, 1, 1, 0, 5),
(1, 2, 1, 0, 3),

-- Solicitação 2
(2, 3, 1, 0, 4),
(2, 8, 1, 0, 10),

-- Solicitação 3
(3, 5, 1, 1, 2),
(3, 4, 1, 0, 2),

-- Solicitação 4
(4, 6, 0, 0, 2),
(4, 7, 0, 0, 1),

-- Solicitação 5
(5, 8, 1, 0, 20);


-- =========================================================
-- STATUS DO HISTÓRICO
-- =========================================================

INSERT INTO status_historico (desc_status) VALUES
('PENDENTE'),
('APROVADA'),
('SEPARANDO'),
('DISPONIVEL'),
('ENVIADA'),
('ENTREGUE'),
('DEVOLVIDA'),
('CANCELADA');


-- =========================================================
-- HISTÓRICO DAS SOLICITAÇÕES
-- =========================================================

INSERT INTO historico
(solicitacao_id, data_alteracao, status_solicitacao)
VALUES
-- Solicitação 1
(1, '2026-09-20 08:30:00', 'PENDENTE'),
(1, '2026-09-20 09:10:00', 'APROVADA'),
(1, '2026-09-20 10:00:00', 'SEPARANDO'),
(1, '2026-09-20 11:00:00', 'ENTREGUE'),

-- Solicitação 2
(2, '2026-09-21 10:15:00', 'PENDENTE'),
(2, '2026-09-21 11:30:00', 'APROVADA'),
(2, '2026-09-21 12:00:00', 'SEPARANDO'),

-- Solicitação 3
(3, '2026-09-22 13:00:00', 'PENDENTE'),
(3, '2026-09-22 14:00:00', 'APROVADA'),
(3, '2026-09-22 15:00:00', 'ENTREGUE'),

-- Solicitação 4
(4, '2026-09-23 09:20:00', 'PENDENTE'),

-- Solicitação 5
(5, '2026-09-24 15:30:00', 'PENDENTE');


-- =========================================================
-- ALERTAS DE DEVOLUÇÃO
-- =========================================================

INSERT INTO alerta_devolucao
(
    solicitacao_id,
    professor_id,
    descricao,
    devolvido
)
VALUES
(
    3,
    3,
    'Tesouras utilizadas no projeto escolar devem ser devolvidas.',
    0
),
(
    1,
    1,
    'Materiais da solicitação foram entregues.',
    1
);


-- =========================================================
-- ALERTAS DE SOLICITAÇÃO
-- =========================================================

INSERT INTO alerta_solicitacao
(
    solicitacao_id,
    descricao,
    resolvido
)
VALUES
(
    2,
    'Estoque de Tinta Acrílica está próximo do limite mínimo.',
    0
),
(
    4,
    'Alguns materiais solicitados não estão reservados.',
    0
),
(
    1,
    'Solicitação processada com sucesso.',
    1
);
