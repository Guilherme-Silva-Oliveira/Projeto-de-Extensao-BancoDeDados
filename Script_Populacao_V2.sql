USE sax_bd;

-- =========================================================================
-- SCRIPT DE POPULAÇÃO - BANCO DE DADOS SAX V2 (script_V2_sax.sql)
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. TABELAS DE CADASTRO BÁSICO (Sem FKs)
-- -------------------------------------------------------------------------

-- Tabela: professor
INSERT INTO professor (nome, email, telefone) VALUES
('Ana Beatriz Santos', 'ana.beatriz@escola.com', '11988887777'),
('Carlos Eduardo Lima', 'carlos.edu@escola.com', '11977776666'),
('Fernanda Oliveira', 'fernanda.oliveira@escola.com', '11966665555'),
('Roberto Alves', 'roberto.alves@escola.com', '11955554444');

-- Tabela: motivo
INSERT INTO motivo (descricao) VALUES
('Aula Prática em Laboratório'),
('Evento / Feira de Ciências'),
('Reposição de Material de Sala'),
('Projeto Integrador / Extensão'),
('Manutenção Interna');

-- Tabela: tipo_fornecedor
INSERT INTO tipo_fornecedor (nome_tipo) VALUES
('Atacadista'),
('Distribuidor Local'),
('Fabricante Direto'),
('Varejista');

-- Tabela: tipo_limite
INSERT INTO tipo_limite (tipo) VALUES
('Estoque Mínimo'),
('Estoque Máximo'),
('Ponto de Pedido');

-- Tabela: almoxarifado (Adicionando mais salas além da sala 123 que já existe no script de DDL)
INSERT INTO almoxarifado (numero_sala) VALUES 
(101),
(202),
(303);

-- Tabela: categoria
INSERT INTO categoria (nome_categoria) VALUES
('Papelaria e Escritório'),
('Informática e Eletrônicos'),
('Produtos de Limpeza'),
('Equipamentos Didáticos'),
('Ferramentas e Hardware');

-- Tabela: unidade_medida
INSERT INTO unidade_medida (nome_unidade) VALUES
('Unidade'),
('Caixa'),
('Pacote'),
('Litro'),
('Metro'),
('Quilo');

-- -------------------------------------------------------------------------
-- 2. TABELAS COM DEPENDÊNCIAS DIRETAS (1 Nível de FK)
-- -------------------------------------------------------------------------

-- Tabela: fornecedor (Depende de: tipo_fornecedor)
INSERT INTO fornecedor (tipo_fornecedor_id, nome, email, telefone) VALUES
(1, 'Papelaria Central Ltda', 'vendas@papelariacentral.com', '1140028922'),
(2, 'Tech Suprimentos Distribuidora', 'contato@techsupri.com', '1133334444'),
(3, 'Indústria Química Alvorada', 'comercial@alvorada.com', '1122221111'),
(4, 'Multiforros e Ferramentas', 'atendimento@multiforros.com', '1155556666');

-- Tabela: almoxarife (Depende de: almoxarifado)
-- Almoxarifados disponíveis: 1 (sala 123 - Guilherme), 2 (sala 101), 3 (sala 202), 4 (sala 303)
INSERT INTO almoxarife (almoxarifado_id, nome, email, telefone, senha) VALUES
(2, 'Mariana Costa', 'mariana.almoxarife@gmail.com', '11911112222', '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK'),
(3, 'Rodrigo Souza', 'rodrigo.almoxarife@gmail.com', '11922223333', '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK'),
(4, 'Camila Ribeiro', 'camila.almoxarife@gmail.com', '11933334444', '$2a$10$3uzNYzkwgxBp9Pt9bPjAMu3PLJNPTlcMMm5vG9rLUTAzxWpOBIkDK');

-- -------------------------------------------------------------------------
-- 3. MATERIAIS, LIMITES E CÓDIGOS DE BARRAS
-- -------------------------------------------------------------------------

-- Tabela: material (Depende de: categoria, almoxarifado, unidade_medida)
INSERT INTO material (categoria_id, almoxarifado_id, nome_material, unidade_medida_id, quantidade, descricao, deve_devolver) VALUES
(1, 1, 'Folha A4 Sulfite 75g', 3, 100, 'Pacote com 500 folhas brancas', 0),
(2, 1, 'Mouse Óptico USB', 1, 25, 'Mouse USB com fio preto', 1),
(2, 2, 'Cabo HDMI 2m', 1, 15, 'Cabo HDMI alta velocidade v2.0', 1),
(3, 3, 'Álcool Isopropílico 1L', 4, 10, 'Álcool 99.8% para limpeza de placas', 0),
(4, 1, 'Kit Projetor Multimídia', 1, 5, 'Projetor HD com cabos e controle', 1),
(5, 4, 'Jogo de Chaves de Fenda', 2, 8, 'Caixa com 10 chaves variadas', 1);

-- Tabela: limite (Depende de: tipo_limite, material)
INSERT INTO limite (limite, tipo_limite_id, material_id) VALUES
('15', 1, 1), -- Mínimo para Folha A4
('200', 2, 1), -- Máximo para Folha A4
('5', 1, 2),  -- Mínimo para Mouse
('30', 2, 2), -- Máximo para Mouse
('2', 1, 5);  -- Mínimo para Projetor

-- Tabela: codigo_barras (Depende de: material)
INSERT INTO codigo_barras (codigo, material_id) VALUES
('7891234567890', 1),
('7899876543210', 2),
('7894561230123', 3),
('7896549871234', 4),
('7891112223334', 5);

-- -------------------------------------------------------------------------
-- 4. MOVIMENTAÇÕES DE ENTRADA (pedidos de compras / devoluções)
-- -------------------------------------------------------------------------

-- Tabela: pedido_entrada (PK composta: fornecedor_id, material_id)
INSERT INTO pedido_entrada (professor_id, fornecedor_id, material_id, quantidade, data_entrada, is_devolucao) VALUES
(NULL, 1, 1, 50, '2026-05-10 10:00:00', 0),
(NULL, 2, 2, 10, '2026-05-12 14:30:00', 0),
(NULL, 2, 3, 10, '2026-05-15 09:15:00', 0),
(1, 1, 2, 2, '2026-05-27 11:00:00', 1); -- Entrada via Devolução pelo Professor 1

-- -------------------------------------------------------------------------
-- 5. SOLICITAÇÕES E PROCESSOS DE SAÍDA / HISTÓRICO
-- -------------------------------------------------------------------------

-- Tabela: solicitacao (Depende de: professor, motivo, inteligencia_artificial)
-- Nota: IA id 1 já foi inserida no DDL (llama-3.3-70b-versatile)
INSERT INTO solicitacao (professor_id, motivo_id, materiais, inteligencia_artificial_id, descricao, data_solicitacao, data_para_envio, alerta) VALUES
(1, 1, 'Folha A4 Sulfite 75g (2), Mouse Óptico USB (2)', 1, 'Material para laboratório de informática', '2026-05-20 08:30:00', '2026-05-21 10:00:00', NULL),
(2, 3, 'Folha A4 Sulfite 75g (5)', 1, 'Resmas para impressão de avaliações', '2026-05-22 09:00:00', '2026-05-22 14:00:00', NULL),
(3, 2, 'Kit Projetor Multimídia (1), Cabo HDMI 2m (1)', 1, 'Equipamentos para apresentação da feira', '2026-05-25 11:20:00', '2026-05-26 08:00:00', 'Verificar cabos extras'),
(4, 4, 'Jogo de Chaves de Fenda (1)', 1, 'Manutenção do protótipo do PI', '2026-05-26 15:45:00', '2026-05-27 09:30:00', NULL);

-- Tabela: lista_material (Depende de: solicitacao, material)
INSERT INTO lista_material (solicitacao_id, material_id, reservado, deve_devolver, quantidade) VALUES
(1, 1, 1, 0, 2),
(1, 2, 1, 1, 2),
(2, 1, 1, 0, 5),
(3, 5, 1, 1, 1),
(3, 3, 1, 1, 1),
(4, 6, 0, 1, 1);

-- Tabela: historico (Depende de: solicitacao)
INSERT INTO historico (solicitacao_id, data_alteracao, status_solicitacao) VALUES
(1, '2026-05-20 08:30:00', 'RECEBIDA'),
(1, '2026-05-20 10:00:00', 'ACEITA'),
(1, '2026-05-21 10:30:00', 'FINALIZADA'),
(2, '2026-05-22 09:00:00', 'RECEBIDA'),
(2, '2026-05-22 09:30:00', 'ACEITA'),
(3, '2026-05-25 11:20:00', 'RECEBIDA'),
(3, '2026-05-25 14:00:00', 'PENDENTE_ENTREGA'),
(4, '2026-05-26 15:45:00', 'RECEBIDA');

-- Tabela: alerta_devolucao (Depende de: solicitacao, professor)
INSERT INTO alerta_devolucao (solicitacao_id, professor_id, descricao, devolvido) VALUES
(1, 1, 'Devolução dos 2 Mouses Ópticos pendente pós-aula', 1),
(3, 3, 'Devolução de Kit Projetor e Cabo HDMI pendente', 0);

-- Tabela: alerta_solicitacao (Depende de: solicitacao)
INSERT INTO alerta_solicitacao (solicitacao_id, descricao, resolvido) VALUES
(3, 'Solicitação contendo item de alta demanda (Projetor)', 0),
(4, 'Solicitação aguardando liberação do almoxarife', 0);
