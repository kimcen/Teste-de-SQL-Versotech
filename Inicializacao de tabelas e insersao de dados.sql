DROP TABLE IF EXISTS CONFIG_PRECO_PRODUTO;
DROP TABLE IF EXISTS ITENS_PEDIDO;
DROP TABLE IF EXISTS PEDIDO;
DROP TABLE IF EXISTS CLIENTES;
DROP TABLE IF EXISTS VENDEDORES;
DROP TABLE IF EXISTS PRODUTOS;
DROP TABLE IF EXISTS EMPRESA;

-- Criação das Tabelas
CREATE TABLE EMPRESA
(
    id_empresa   SERIAL PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    inativo      BOOLEAN      NOT NULL
);

CREATE TABLE PRODUTOS
(
    id_produto SERIAL PRIMARY KEY,
    descricao  VARCHAR(255) NOT NULL,
    inativo    BOOLEAN      NOT NULL
);

CREATE TABLE VENDEDORES
(
    id_vendedor   SERIAL PRIMARY KEY,
    nome          VARCHAR(255)   NOT NULL,
    cargo         VARCHAR(100)   NOT NULL,
    salario       DECIMAL(10, 2) NOT NULL,
    data_admissao DATE           NOT NULL,
    inativo       BOOLEAN        NOT NULL
);

CREATE TABLE CONFIG_PRECO_PRODUTO
(
    id_config_preco_produto SERIAL PRIMARY KEY,
    id_vendedor             INTEGER REFERENCES VENDEDORES (id_vendedor),
    id_empresa              INTEGER REFERENCES EMPRESA (id_empresa),
    id_produto              INTEGER REFERENCES PRODUTOS (id_produto),
    preco_minimo            DECIMAL(10, 2) NOT NULL,
    preco_maximo            DECIMAL(10, 2) NOT NULL
);

CREATE TABLE CLIENTES
(
    id_cliente    SERIAL PRIMARY KEY,
    razao_social  VARCHAR(255) NOT NULL,
    data_cadastro DATE         NOT NULL,
    id_vendedor   INTEGER REFERENCES VENDEDORES (id_vendedor),
    id_empresa    INTEGER REFERENCES EMPRESA (id_empresa),
    inativo       BOOLEAN      NOT NULL
);

CREATE TABLE PEDIDO
(
    id_pedido    SERIAL PRIMARY KEY,
    id_empresa   INTEGER REFERENCES EMPRESA (id_empresa),
    id_cliente   INTEGER REFERENCES CLIENTES (id_cliente),
    valor_total  DECIMAL(10, 2) NOT NULL,
    data_emissao DATE           NOT NULL,
    situacao     VARCHAR(50)    NOT NULL
);

CREATE TABLE ITENS_PEDIDO
(
    id_item_pedido  SERIAL PRIMARY KEY,
    id_pedido       INTEGER REFERENCES PEDIDO (id_pedido),
    id_produto      INTEGER REFERENCES PRODUTOS (id_produto),
    preco_praticado DECIMAL(10, 2) NOT NULL,
    quantidade      INTEGER        NOT NULL
);

-- Inserção de Dados Fictícios
INSERT INTO EMPRESA (razao_social, inativo)
VALUES ('Empresa A', FALSE),
       ('Empresa B', FALSE),
       ('Empresa C', TRUE);

INSERT INTO PRODUTOS (descricao, inativo)
VALUES ('Produto 1', FALSE),
       ('Produto 2', FALSE);

INSERT INTO VENDEDORES (nome, cargo, salario, data_admissao, inativo)
VALUES ('Vendedor 1', 'Cargo 1', 5000.00, '2022-01-01', FALSE),
       ('Vendedor 2', 'Cargo 2', 6000.00, '2022-02-01', FALSE),
       ('Vendedor 3', 'Cargo 3', 7000.00, '2022-03-01', TRUE);   

INSERT INTO CLIENTES (razao_social, data_cadastro, id_vendedor, id_empresa, inativo)
VALUES ('Cliente A', '2022-01-15', 1, 1, FALSE),
       ('Cliente B', '2022-02-01', 2, 2, FALSE),
       ('Cliente C', '2022-03-05', 2, 2, FALSE),      
       ('Cliente D', '2022-04-09', 1, 1, TRUE);

INSERT INTO CONFIG_PRECO_PRODUTO (id_vendedor, id_empresa, id_produto, preco_minimo, preco_maximo)
VALUES (1, 1, 1, 50.00, 100.00),
       (2, 2, 2, 60.00, 120.00);

-- Inserção de 20 Pedidos Aleatórios
INSERT INTO PEDIDO (id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao)
VALUES (1, 1, 1, 150.00, '2022-03-03', 'Fechado'),
       (2, 1, 2, 90.00, '2022-03-04', 'Aberto'),
       (3, 2, 1, 296.00, '2022-03-05', 'Fechado'),
       (4, 2, 2, 233.25, '2022-03-06', 'Fechado'),
       (5, 1, 1, 41.00, '2022-03-07', 'Aberto'),
       (6, 2, 2, 145.75, '2022-03-08', 'Aberto'),
       (7, 1, 1, 375.00, '2022-03-09', 'Aberto'),
       (8, 2, 2, 62.50, '2022-03-10', 'Fechado'),
       (9, 1, 1, 196.50, '2022-03-11', 'Fechado'),
       (10, 1, 2, 153.25, '2022-03-12', 'Aberto'),
       (11, 2, 1, 136.50, '2022-03-13', 'Fechado'),
       (12, 2, 2, 90.50, '2022-03-14', 'Fechado'),
       (13, 1, 1, 223.00, '2022-03-15', 'Aberto'),
       (14, 1, 2, 100.50, '2022-03-16', 'Aberto'),
       (15, 2, 1, 106.50, '2022-03-17', 'Aberto'),
       (16, 2, 2, 65.50, '2022-03-18', 'Fechado'),
       (17, 1, 1, 250.00, '2022-03-19', 'Fechado'),
       (18, 1, 2, 91.25, '2022-03-20', 'Aberto'),
       (19, 2, 1, 211.25, '2022-03-21', 'Aberto'),
       (20, 2, 2, 194.00, '2022-03-22', 'Fechado');


-- Inserção de Itens para os 20 Pedidos Aleatórios
INSERT INTO ITENS_PEDIDO (id_pedido, id_produto, preco_praticado, quantidade)
VALUES
    -- Itens para o Pedido 1
    (1, 1, 75.00, 2),

    -- Itens para o Pedido 2
    (2, 2, 90.00, 1),

    -- Itens para o Pedido 3
    (3, 1, 55.00, 3),
    (3, 2, 65.50, 2),

    -- Itens para o Pedido 4
    (4, 2, 30.25, 1),
    (4, 1, 50.75, 4),

    -- Itens para o Pedido 5
    (5, 1, 20.50, 2),

    -- Itens para o Pedido 6
    (6, 2, 45.25, 3),
    (6, 1, 10.00, 1),

    -- Itens para o Pedido 7
    (7, 1, 75.00, 5),

    -- Itens para o Pedido 8
    (8, 2, 20.50, 2),
    (8, 1, 21.50, 1),

    -- Itens para o Pedido 9
    (9, 1, 30.00, 2),
    (9, 2, 45.50, 3),

    -- Itens para o Pedido 10
    (10, 2, 30.25, 1),
    (10, 1, 30.75, 4),

    -- Itens para o Pedido 11
    (11, 1, 45.50, 3),

    -- Itens para o Pedido 12
    (12, 2, 25.25, 2),
    (12, 1, 40.00, 1),

    -- Itens para o Pedido 13
    (13, 1, 55.75, 4),

    -- Itens para o Pedido 14
    (14, 2, 30.00, 2),
    (14, 1, 40.50, 1),

    -- Itens para o Pedido 15
    (15, 1, 35.50, 3),

    -- Itens para o Pedido 16
    (16, 2, 15.25, 2),
    (16, 1, 35.00, 1),

    -- Itens para o Pedido 17
    (17, 1, 50.00, 5),

    -- Itens para o Pedido 18
    (18, 2, 25.50, 2),
    (18, 1, 40.25, 1),

    -- Itens para o Pedido 19
    (19, 1, 30.75, 3),
    (19, 2, 59.50, 2),

    -- Itens para o Pedido 20
    (20, 2, 40.00, 1),
    (20, 1, 38.50, 4);

