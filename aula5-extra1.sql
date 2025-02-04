/* Chegou a hora de se desafiar a desenvolver ainda mais todo o conhecimento aprendido durante nossa jornada!

Aqui estão algumas atividades que vão te ajudar a praticar e fixar ainda mais cada conteúdo e caso você precise de ajuda, opções de solução das atividades estão disponíveis na seção “Opinião da pessoa instrutora”.

Considerando a mesma base de dados utilizada no curso: */

--- 01 - Qual é o número de Clientes que existem na base de dados ?
select count(*) from clientes;

--- 02 - Quantos produtos foram vendidos no ano de 2022 ?
select count(*) from vendas where strftime('%Y', data_venda) LIKE '2022';

--- 03 - Qual a categoria que mais vendeu em 2022 ?
select COUNT(*) as Qtd_Vendas, c.nome_categoria as Categoria
from itens_venda iv inner join produtos p
on iv.produto_id = p.id_produto
inner join categorias c
on p.categoria_id = c.id_categoria
inner join vendas v
on iv.venda_id = v.id_venda
where strftime('%Y', v.data_venda) LIKE '2022'
group by c.nome_categoria
order by Qtd_Vendas desc
limit 1;

--- 04 - Qual o primeiro ano disponível na base ?
select min(strftime('%Y', data_venda)) as ano from vendas

--- 05 - Qual o nome do fornecedor que mais vendeu no primeiro ano disponível na base ?
select f.nome as Fornecedor, COUNT(iv.venda_id) as Qtd_Vendas
from fornecedores f inner join produtos p
on f.id_fornecedor = p.fornecedor_id
inner join itens_venda iv
on iv.produto_id = p.id_produto
inner join vendas v
on v.id_venda = iv.venda_id
where strftime('%Y', v.data_venda) = (select min(strftime('%Y', data_venda)) as ano from vendas)
group by Fornecedor
order by Qtd_Vendas desc limit 1;

--- 06 - Quanto ele vendeu no primeiro ano disponível na base de dados ?
select count(*)
from itens_venda iv inner join produtos p
on iv.produto_id = p.id_produto
inner join fornecedores f
on p.fornecedor_id = f.id_fornecedor
inner join vendas v
on v.id_venda = iv.venda_id
where strftime('%Y', v.data_venda) = (select min(strftime('%Y', data_venda)) as ano from vendas)
	AND f.nome LIKE 'HorizonDistributors'
group by strftime('%Y', v.data_venda);

--- 07 - Quais as duas categorias que mais venderam no total de todos os anos ?
select c.nome_categoria, count(*) as Qtd_Vendas
from itens_venda iv inner join produtos p
on iv.produto_id = p.id_produto
inner join categorias c
on c.id_categoria = p.categoria_id
group by c.nome_categoria
order by Qtd_Vendas desc
limit 2;


--- 08 - Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais venderam no total de todos os anos.
select "Ano/Mes",
	sum(case when Categoria like 'Eletrônicos' then Qtd_Vendas else 0 END) as 'Eletrônicos_Vendas',
    sum(case when Categoria like 'Vestuário' then Qtd_Vendas else 0 END) as 'Vestuário_Vendas'
from (
  select strftime('%Y/%m', v.data_venda) as "Ano/Mes", c.nome_categoria as Categoria, COUNT(*) as Qtd_Vendas
  from itens_venda iv inner join produtos p
  on iv.produto_id = p.id_produto
  inner join categorias c
  on p.categoria_id = c.id_categoria
  inner join vendas v
  on iv.venda_id = v.id_venda
  group by "Ano/Mes", c.id_categoria
)
group by "Ano/Mes"
order by "Ano/Mes";

--- 09 - Calcule a porcentagem de vendas por categorias no ano de 2022.
with Vendas_Total as
  (select count(*) as Total from itens_venda iv inner join vendas v
  on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) like '2022'),
Vendas_Categorias as
  (SELECT c.nome_categoria as Categoria, count(*) as Qtd_Vendas
  from categorias c inner join produtos p
  on p.categoria_id = c.id_categoria
  inner join itens_venda iv
  on iv.produto_id = p.id_produto
  inner join vendas v
  on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) like '2022'
  group by c.id_categoria)
select vc.Categoria, vc.Qtd_Vendas,
	round((vc.Qtd_Vendas*100.0)/vt.Total, 2) || '%' as Porcentagem
from Vendas_Categorias as vc, Vendas_Total as vt;

--- 10 - Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria tem em relação a pior no ano de 2022.
with Vendas_Total as
  (select count(*) as Total from itens_venda iv inner join vendas v
  on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) like '2022'),
Vendas_Categorias as
  (SELECT c.nome_categoria as Categoria, count(*) as Qtd_Vendas
  from categorias c inner join produtos p
  on p.categoria_id = c.id_categoria
  inner join itens_venda iv
  on iv.produto_id = p.id_produto
  inner join vendas v
  on iv.venda_id = v.id_venda
  where strftime('%Y', v.data_venda) like '2022'
  group by c.id_categoria),
Melhor_Pior_Categorias as
  (SELECT 
   	min(Qtd_Vendas) as Pior_Vendas,
   	max(Qtd_Vendas) as Melhor_Vendas
  from Vendas_Categorias)
select
	vc.Categoria,
	vc.Qtd_Vendas,
    round((vc.Qtd_Vendas*100.0/vt.Total),2) || '%' as Porcentagem,
    round(((vc.Qtd_Vendas - mp.Melhor_Vendas)*100.0/mp.Melhor_Vendas),2) || '%' as Porcentagem_Relativa_Ao_Melhor
from Vendas_Categorias as vc, Vendas_Total as vt, Melhor_Pior_Categorias as mp
order by Categoria;

--SOLUCAO FORNECIDA:
WITH Total_Vendas AS (
  SELECT COUNT(*) as Total_Vendas_2022
  FROM itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  WHERE strftime('%Y', v.data_venda) = '2022'
),
Vendas_Por_Categoria AS (
  SELECT 
    c.nome_categoria AS Nome_Categoria, 
    COUNT(iv.produto_id) AS Qtd_Vendas
  FROM itens_venda iv
  JOIN vendas v ON v.id_venda = iv.venda_id
  JOIN produtos p ON p.id_produto = iv.produto_id
  JOIN categorias c ON c.id_categoria = p.categoria_id
  WHERE strftime('%Y', v.data_venda) = '2022'
  GROUP BY Nome_Categoria
),
Melhor_Pior_Categorias AS (
  SELECT 
    MIN(Qtd_Vendas) AS Pior_Vendas, 
    MAX(Qtd_Vendas) AS Melhor_Vendas
  FROM Vendas_Por_Categoria
)
-- O CROSS JOIN é utilizado aqui para combinar todas as linhas de Total_Vendas, 
-- Vendas_Por_Categoria e Melhor_Pior_Categorias, resultando em um único conjunto de dados.
SELECT 
  Nome_Categoria, 
  Qtd_Vendas, 
  ROUND(100.0*Qtd_Vendas/tv.Total_Vendas_2022, 2) || '%' AS Porcentagem,
  ROUND(100.0*(Qtd_Vendas - Melhor_Vendas) / Melhor_Vendas, 2) || '%' AS Porcentagem_Mais_Que_Melhor
FROM Vendas_Por_Categoria
CROSS JOIN Total_Vendas tv
CROSS JOIN Melhor_Pior_Categorias;