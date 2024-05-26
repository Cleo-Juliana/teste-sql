


-- 1 CONSULTAS BÁSICAS: 

-- a) Lista de funcionários ordenando pelo salário decrescente.

SELECT id_vendedor, nome, cargo, salario, data_admissao, inativo
FROM VENDEDORES
ORDER BY salario DESC;

--b) Lista de pedidos de vendas ordenado por data de emissão.

SELECT id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao
FROM PEDIDO
ORDER BY data_emissao;

--c) Valor de faturamento por cliente.

SELECT C.id_cliente, C.razao_social, SUM(P.valor_total) AS faturamento_total
FROM CLIENTES C
JOIN PEDIDO P ON C.id_cliente = P.id_cliente
GROUP BY C.id_cliente, C.razao_social
ORDER BY faturamento_total DESC;

--d) Valor de faturamento por empresa. 

SELECT E.id_empresa, E.razao_social, SUM(P.valor_total) AS faturamento_total
FROM EMPRESA E
JOIN PEDIDO P ON E.id_empresa = P.id_empresa
GROUP BY E.id_empresa, E.razao_social
ORDER BY faturamento_total DESC;

--e) Valor do faturamento por vendedor. 

SELECT V.id_vendedor, V.nome, SUM(P.valor_total) AS faturamento_total
FROM VENDEDORES V
JOIN CLIENTES C ON V.id_vendedor = C.id_vendedor
JOIN PEDIDO P ON C.id_cliente = P.id_cliente
GROUP BY V.id_vendedor, V.nome
ORDER BY faturamento_total DESC;



-- CONSULTA DE JUNÇÃO 

SELECT 
    P.id_produto,
    P.descricao,
    C.id_cliente,
    C.razao_social AS cliente_razao_social,
    E.id_empresa,
    E.razao_social AS empresa_razao_social,
    V.id_vendedor,
    V.nome AS vendedor_nome,
    CPP.preco_minimo,
    CPP.preco_maximo,
    COALESCE(
        (SELECT IP.preco_praticado
         FROM ITENS_PEDIDO IP
         JOIN PEDIDO PD ON IP.id_pedido = PD.id_pedido
         WHERE IP.id_produto = P.id_produto AND PD.id_cliente = C.id_cliente
         ORDER BY PD.data_emissao DESC
         LIMIT 1),
        CPP.preco_minimo
    ) AS preco_base
FROM PRODUTOS P
JOIN CONFIG_PRECO_PRODUTO CPP ON P.id_produto = CPP.id_produto
JOIN EMPRESA E ON CPP.id_empresa = E.id_empresa
JOIN CLIENTES C ON E.id_empresa = C.id_empresa
JOIN VENDEDORES V ON C.id_vendedor = V.id_vendedor
WHERE P.inativo = false AND C.inativo = false AND V.inativo = false
ORDER BY P.id_produto, C.id_cliente;
