-- 01. Entendendo os dados:
SELECT * FROM categorias;
SELECT * FROM fornecedores;
SELECT * FROM marcas;
SELECT COUNT(*) as Qtd_Categorias FROM categorias;
SELECT COUNT(*) as Qtd_Clientes  FROM clientes;
SELECT COUNT(*) as Qtd_Fornecedores  FROM fornecedores;
SELECT COUNT(*) as Qtd_ItensVenda  FROM itens_venda;
SELECT COUNT(*) as Qtd_Marcas  FROM marcas;
SELECT COUNT(*) as Qtd_Produtos  from produtos;
SELECT COUNT(*) as Qtd_Vendas  from vendas;


-- 02. Analise temporal: ciclos de vendas
-- DISTINCT: pega apenas valores unicos
select DISTINCT strftime('%Y', data_venda) as ano from vendas order by ano asc;

-- quantidade de vendas por ano/mes:
-- NOTA: os dados foram fornecidos no meio de 2023
select strftime('%Y', data_venda) as ano, strftime('%m', data_venda) as mes, count(id_venda) as total_vendas
from vendas
group by ano, mes
order by ano asc;


-- 03. Analisar principais meses de vendas (janeiro, novembro, dezembro)
select strftime('%Y', data_venda) as ano, strftime('%m', data_venda) as mes, count(id_venda) as total_vendas
from vendas
where 
	mes = '01' or 
    mes = '11' OR
    mes = '12'
group by ano, mes
order by ano asc;

