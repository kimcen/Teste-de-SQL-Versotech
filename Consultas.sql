-- Lista de funcionários ordenando pelo salário decrescente.
-- Assumiundo que o usuário tem interesse em apenas nos funcionários e os salários de cada. Persão se o padrão é listar todas as colunas de cada vendedor.
SELECT nome, salario
FROM public.VENDEDORES
WHERE inativo = false -- vendedores inativos provavelmente não são desejados 
ORDER BY salario DESC;




-- Lista de pedidos de vendas ordenado por data de emissão.
SELECT  data_emissao, valor_total, id_pedido, id_empresa, id_cliente, situacao
FROM public.PEDIDO
ORDER BY data_emissao;

-- Opcional: retornar o nome da empresa e do cliente ao invés de apenas os IDs
SELECT 
    p.data_emissao,
    p.valor_total,
    emp.razao_social AS nome_empresa,
    cli.razao_social AS nome_cliente,
    p.situacao,
	p.id_pedido
FROM public.PEDIDO p
JOIN public.EMPRESA emp ON p.id_empresa = emp.id_empresa
JOIN public.CLIENTES cli ON p.id_cliente = cli.id_cliente
ORDER BY p.data_emissao;




-- Valor de faturamento por cliente.
SELECT cli.id_cliente, cli.razao_social, SUM(p.valor_total) AS valor_faturamento
FROM public.CLIENTES cli
LEFT JOIN public.PEDIDO p ON cli.id_cliente = p.id_cliente --Left join garante que clientes sem pedidos sejam exibidos
--WHERE p.situacao = 'Fechado' -- Caso fosse requerido
GROUP BY cli.id_cliente, cli.razao_social
ORDER BY valor_faturamento;




-- Valor de faturamento por empresa.
SELECT emp.razao_social, SUM(p.valor_total) AS valor_faturamento
FROM public.EMPRESA emp
LEFT JOIN public.PEDIDO p ON p.id_empresa = emp.id_empresa
-- WHERE p.situacao = 'Fechado'
GROUP BY emp.razao_social
ORDER BY valor_faturamento;




-- Valor de faturamento por vendedor.
-- Assumindo que o valor total do pedido já é a soma dos itens dos pedidos
SELECT v.nome AS nome_vendedor, SUM(p.valor_total) AS faturamento_total
FROM public.VENDEDORES v
LEFT JOIN public.CLIENTES cli ON v.id_vendedor = cli.id_vendedor
LEFT JOIN public.PEDIDO p ON cli.id_cliente = p.id_cliente
GROUP BY v.nome;




-- Consulta de Junção
--"preco_base" possui o último valor que um cliente pagou por um produto, limitado pelas regras da configuração do produto.
-- A clausula "coalesce" garante que, caso não seja encontrado um valor final, o valor comparado nas regras de configuração será o preco mínimo
SELECT 
    p.id_produto,
    p.descricao,
    cli.id_cliente,
    cli.razao_social AS razao_social_cliente,
	e.id_empresa,
	e.razao_social AS razao_social_empresa, 
	v.id_vendedor, 
	v.nome,
    cpp.preco_minimo,
    cpp.preco_maximo,
	LEAST(
        GREATEST(
			COALESCE(
                (SELECT preco_praticado
                 FROM latest_prices lp
                 WHERE lp.id_produto = p.id_produto
                   AND lp.id_cliente = c.id_cliente
                   AND lp.rn = 1),
                cpp.preco_minimo
            ), 
            cpp.preco_minimo
        ), 
        cpp.preco_maximo
    ) AS preco_base
FROM 
    public.PRODUTOS p
JOIN 
    public.CONFIG_PRECO_PRODUTO cpp ON p.id_produto = cpp.id_produto
JOIN 
	public.ITENS_PEDIDO ip ON p.id_produto = ip.id_produto
JOIN
	public.PEDIDO ped ON ip.id_pedido = ped.id_pedido
JOIN 
    public.CLIENTES cli ON ped.id_cliente = cli.id_cliente
JOIN
	public.VENDEDORES v ON cli.id_vendedor = v.id_vendedor
JOIN
	public.EMPRESA e ON cli.id_empresa = e.id_empresa
GROUP BY 
    p.id_produto, cli.id_cliente, cpp.preco_minimo, cpp.preco_maximo, e.id_empresa, e.razao_social, v.id_vendedor, v.nome
