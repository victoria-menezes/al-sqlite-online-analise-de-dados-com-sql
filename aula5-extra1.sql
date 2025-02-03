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

--- 10 - Crie uma métrica mostrando a porcentagem de vendas a mais que a melhor categoria tem em relação a pior no ano de 2022.
