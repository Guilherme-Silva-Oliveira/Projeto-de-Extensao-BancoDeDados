USE sax_bd;

-- =========================================================================
-- 1. TABELAS INDEPENDENTES (Não possuem chaves estrangeiras)
-- =========================================================================

-- Tabela: professor (Já possuía 1 registro, adicionando mais para testes)
INSERT INTO professor (nome, email, telefone) VALUES
('Ana Beatriz', 'ana.beatriz@escola.com', '11988887777'),
('Carlos Eduardo', 'carlos.edu@escola.com', '11977776666');

-- Tabela: tipo_fornecedor
INSERT INTO tipo_fornecedor (nome_tipo) VALUES
('Atacadista'),
('Distribuidor Local'),
('Fabricante');

-- Tabela: tipo_limite
INSERT INTO tipo_limite (tipo) VALUES
('Mínimo Permitido'),
('Máximo Permitido'),
('Alerta de Reposição');

-- Tabela: almoxarifado (Já possuía salas 1 e 123, adicionando mais uma)
INSERT INTO almoxarifado (numero_sala) VALUES 
(404);

-- Tabela: categoria (Já possuía 'categoria', adicionando mais específicas)
INSERT INTO categoria (nome_categoria) VALUES
('Papelaria'),
('Informática'),
('Limpeza');

-- Tabela: unidade_medida (Já possuía 'unidade', adicionando outras)
INSERT INTO unidade_medida (nome_unidade) VALUES
('Caixa'),
('Pacote'),
('Litro');

-- Tabela: escala (Já possuía 'Média', adicionando outras)
INSERT INTO escala (nome_escala) VALUES 
('Baixa'),
('Alta');


-- =========================================================================
-- 2. TABELAS COM DEPENDÊNCIAS DIRETAS (1 nível de Chave Estrangeira)
-- =========================================================================

-- Tabela: solicitacao (Depende de: professor)
-- Nota: professor_id 1 (Pedro Ferro), 2 (Ana), 3 (Carlos)
INSERT INTO solicitacao (professor_id, descricao, data_solicitacao) VALUES
(1, 'Material para aula de artes', '2026-05-20'),
(2, 'Resma de papel para provas', '2026-05-22'),
(3, 'Pincéis para quadro branco', '2026-05-25');

-- Tabela: fornecedor (Depende de: tipo_fornecedor)
INSERT INTO fornecedor (tipo_fornecedor_id, nome, email, telefone) VALUES
(1, 'Papelaria Central Ltda', 'vendas@papelariacentral.com', '1140028922'),
(2, 'Tech Suprimentos', 'contato@techsupri.com', '1133334444');

-- Tabela: almoxarife (Depende de: almoxarifado)
-- Nota: Sala 1 já possui o Guilherme. Adicionando na sala 123 e 404.
INSERT INTO almoxarife (almoxarifado_id, nome, email, telefone, senha) VALUES
(2, 'Mariana Costa', 'mariana.almoxarife@gmail.com', '11911112222', '$2a$10$ExemploHashSenha1'),
(3, 'Rodrigo Souza', 'rodrigo.almoxarife@gmail.com', '11922223333', '$2a$10$ExemploHashSenha2');


-- =========================================================================
-- 3. TABELAS DE PRODUTO E LIMITES (Dependem de múltiplos cadastros)
-- =========================================================================

-- Tabela: material (Depende de: categoria, almoxarifado, unidade_medida)
INSERT INTO material (categoria_id, almoxarifado_id, nome_material, unidade_medida_id, quantidade) VALUES
(2, 1, 'Folha A4 Sulfite', 3, 50),     -- Cat: Papelaria, Sala: 1, Un: Pacote
(3, 2, 'Mouse Óptico USB', 2, 20),     -- Cat: Informática, Sala: 123, Un: Caixa
(4, 3, 'Detergente Líquido', 4, 15);   -- Cat: Limpeza, Sala: 404, Un: Litro

-- Tabela: limite (Depende de: tipo_limite, material)
INSERT INTO limite (limite, tipo_limite_id, material_id) VALUES
('10', 1, 1), -- Limite Mínimo de 10 pacotes para Folha A4
('100', 2, 1), -- Limite Máximo de 100 pacotes para Folha A4
('5', 1, 2);  -- Limite Mínimo de 5 caixas para Mouse

-- Tabela: codigo_barras (Depende de: material)
INSERT INTO codigo_barras (codigo, material_id) VALUES
('7891234567890', 1), -- Código para Folha A4
('7899876543210', 2); -- Código para Mouse


-- =========================================================================
-- 4. TABELAS DE MOVIMENTAÇÃO / MUITOS-PARA-MUITOS (Entradas e Saídas)
-- =========================================================================

-- Tabela: pedido_entrada (Depende de: fornecedor, material)
INSERT INTO pedido_entrada (fornecedor_id, material_id, quantidade, data_entrada) VALUES
(1, 1, 30, '2026-05-10'), -- Fornecedor 1 entregou 30 Folhas A4
(2, 2, 10, '2026-05-12'); -- Fornecedor 2 entregou 10 Mouses

-- Tabela: pedido_saida (Depende de: material, solicitacao, escala)
-- Nota: escala_id (1='Média', 2='Baixa', 3='Alta')
INSERT INTO pedido_saida (material_id, solicitacao_id, escala_id, quantidade, data_solicitacao) VALUES
(1, 1, 1, 5, '2026-05-20'), -- 5 pacotes de Folha A4 para a solicitação 1 (Escala Média)
(2, 3, 3, 2, '2026-05-25'); -- 2 mouses para a solicitação 3 (Escala Alta)


select * from pedido_saida;
select * from solicitacao;
select * from inteligencia_artificial;