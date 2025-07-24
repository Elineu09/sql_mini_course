-- TABLE CRIATION
CREATE TABLE marcas (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    site VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE produtos (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco REAL,
    estoque INTEGER DEFAULT 0
);

-- MODIFYING TABLES
ALTER TABLE produtos ADD COLUMN id_marca INT NOT NULL;

ALTER TABLE produtos MODIFY COLUMN nome VARCHAR(150) NOT NULL;

ALTER TABLE produtos
ADD FOREIGN KEY (id_marca) REFERENCES marcas (id);

-- CREATING INDEX
CREATE INDEX indx_produtos_nome ON produtos (nome);

-- ADDIN DATAS INTO A TABLE
INSERT INTO
    marcas (nome, site, telefone)
VALUES (
        'Apple',
        'apple.com',
        '0800-761-0867'
    ),
    (
        'Dell',
        'dell.com.br',
        '0800-970-3355'
    ),
    (
        'Herman Miller',
        'hermanmiller.com.br',
        '(11) 3474-8043'
    ),
    (
        'Shure',
        'shure.com.br',
        '0800-970-3355'
    );

CREATE TABLE controle (id INT PRIMARY KEY, data DATE);

-- DELETING TABLE
DROP TABLE IF EXISTS controle;

-- ADDING DATAS INTO A TABLE
INSERT INTO
    produtos (
        nome,
        preco,
        estoque,
        id_marca
    )
VALUES (
        'iPhone 16 Pro Apple (256GB) - Titânio Preto',
        9299.99,
        100,
        1
    ),
    (
        'iPhone 15 Apple (128GB) - Preto',
        4599.00,
        50,
        1
    ),
    (
        'MacBook Air 15" M2 (8GB RAM , 512GB SSD) - Prateado',
        8899.99,
        23,
        1
    ),
    (
        'Notebook Inspiron 16 Plus',
        10398.00,
        300,
        2
    ),
    (
        'Cadeira Aeron - Grafite',
        15540.00,
        8,
        3
    ),
    (
        'Microfone MV7 USB',
        2999.99,
        70,
        4
    ),
    (
        'Microfone SM7B',
        5579.99,
        30,
        4
    );

SELECT id, nome FROM marcas WHERE id > 2;

-- TEMPORARAY TABLE TO TEST INSERT SELECT
CREATE TABLE produtos_apple (
    nome VARCHAR(150) NOT NULL,
    estoque INTEGER DEFAULT 0
);

-- TESTING INSERT SELECT
INSERT INTO
    produtos_apple
SELECT nome, estoque
FROM produtos
WHERE
    id_marca = 1;

SELECT * FROM produtos_apple;

TRUNCATE TABLE produtos_apple;

-- DELETING TABLE
DROP TABLE IF EXISTS produtos_apple;

SELECT * FROM produtos;

UPDATE produtos SET nome = "Microfone SM7B Preto" WHERE id = 7;

UPDATE produtos SET estoque = estoque + 1 WHERE id = 1;

DELETE FROM produtos WHERE id = 1;

INSERT INTO
    produtos
VALUES (
        1,
        'iPhone 16 Pro Apple (256GB) - Titânio Preto',
        9299.99,
        100,
        1
    );

SELECT * FROM produtos WHERE estoque < 80 AND preco > 3000;

SELECT * FROM produtos WHERE nome LIKE "%apple%";

SELECT * FROM produtos WHERE id > 4 ORDER BY estoque DESC LIMIT 5;

-- CRIATION AND INSERTION OF DATA IN TABLES
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cidade VARCHAR(200) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATE DEFAULT(NOW()),
    id_cliente INTEGER,
    valor_total REAL,
    FOREIGN KEY (id_cliente) REFERENCES clientes (id)
);

CREATE TABLE IF NOT EXISTS itens_pedido (
    id_pedido INTEGER,
    id_produto INTEGER,
    quantidade INTEGER,
    preco_unitario REAL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos (id),
    FOREIGN KEY (id_produto) REFERENCES produtos (id),
    PRIMARY KEY (id_pedido, id_produto)
);

INSERT INTO
    clientes (nome, email, cidade)
VALUES (
        'João Pereira',
        'joao@exemplo.com.br',
        'Rio de Janeiro'
    ),
    (
        'Ana Costa',
        'ana@costa.com',
        'São Paulo'
    ),
    (
        'Carlos Souza',
        'carlos@gmail.com',
        'Belo Horizonte'
    ),
    (
        'Vanessa Weber',
        'vanessa@codigofonte.tv',
        'São José dos Campos'
    ),
    (
        'Gabriel Fróes',
        'gabriel@codigofonte.tv',
        'São José dos Campos'
    );

INSERT INTO
    pedidos (id_cliente, valor_total)
VALUES (1, 5500.00),
    (2, 2000.00);

INSERT INTO
    pedidos (id_cliente, valor_total)
VALUES (4, 5500.00),
    (5, 2000.00);

INSERT INTO
    itens_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
VALUES (1, 1, 1, 3500.00),
    (1, 2, 1, 2000.00),
    (2, 2, 1, 2000.00);

INSERT INTO
    itens_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
VALUES (3, 1, 1, 3500.00),
    (3, 2, 1, 2000.00),
    (4, 2, 1, 2000.00);

-- INNER JOIN
SELECT clientes.nome, pedidos.valor_total
FROM clientes
    INNER JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- SUBQUERY
SELECT nome, preco
FROM produtos
WHERE
    id_marca IN (
        SELECT id
        from marcas
        WHERE
            nome = "apple"
            OR nome = "Dell"
    );

-- LEFT JOIN
SELECT clientes.nome, pedidos.valor_total
FROM clientes
    LEFT JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- RIGHT JOIN
SELECT clientes.nome, pedidos.valor_total
FROM clientes
    RIGHT JOIN pedidos ON clientes.id = pedidos.id_cliente;

-- FULL OUTER JOIN (USING UNION)
SELECT c.nome, p.valor_total
FROM clientes c
    LEFT JOIN pedidos p ON c.id = p.id_cliente
UNION
SELECT c.nome, p.valor_total
FROM clientes c
    RIGHT JOIN pedidos p ON c.id = p.id_cliente;


-- AGREGATION FUNCTIONS AND FILTERS
-- GROUP BY 
SELECT cidade, COUNT(*) AS numero_clientes
FROM clientes
GROUP BY
    cidade;

-- AVG
SELECT DATE_FORMAT(data_pedido, '%Y-%m') AS mes, AVG(valor_total)
FROM pedidos
GROUP BY
    mes;

-- SUM e COUNT = AVG
SELECT SUM(valor_total) / COUNT(*) FROM pedidos;

-- MAX
SELECT MAX(valor_total) FROM pedidos;

-- MIN
SELECT MIN(valor_total) FROM pedidos;

-- AVG, SUBQUERY
SELECT nome, estoque
FROM produtos
WHERE
    estoque < (
        SELECT AVG(estoque)
        FROM produtos
    );


SELECT pedidos.valor_total, clientes.cidade
FROM clientes
    INNER JOIN pedidos ON pedidos.id = clientes.id;

-- SUM, GROUP BY, HAVING
SELECT c.cidade, SUM(p.valor_total) AS total_vendas
FROM clientes AS c
    INNER JOIN pedidos AS p ON c.id = p.id_cliente
WHERE
    c.cidade IN (
        'São José dos Campos',
        'Rio de Janeiro'
    )
GROUP BY
    c.cidade
HAVING
    total_vendas < 7000;