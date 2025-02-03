--- 01. Extraindo dados de outros fornecedores para uma comparacao grafica
select strftime('%Y/%m', v.data_venda) as Data, f.nome as Nome_Fornecedor, COUNT(v.id_venda) as Vendas 
from produtos p inner join fornecedores f
on p.fornecedor_id = f.id_fornecedor
inner join itens_venda iv
on p.id_produto = iv.produto_id
inner join vendas v
on iv.venda_id = v.id_venda
where f.nome like 'NebulaNetworks' OR f.nome like 'HorizonDistributors' OR f.nome like 'AstroSupply'
group by data, f.nome
order by data asc;

-- reformatando esses dados para facilitar a criacao de um grafico no google sheets
SELECT 
  Data, 
  SUM(
    CASE WHEN Nome_Fornecedor like 'NebulaNetworks' THEN Vendas
    ELSE 0 END
    ) AS Vendas_Nebula,
  SUM(
    CASE WHEN Nome_Fornecedor like 'HorizonDistributors' THEN Vendas
    ELSE 0 END
    ) AS Vendas_Horizon,
  SUM(
    CASE WHEN Nome_Fornecedor like 'AstroSupply' THEN Vendas
    ELSE 0 END
    ) AS Vendas_Astro
FROM (
  select strftime('%Y/%m', v.data_venda) as Data, f.nome as Nome_Fornecedor, COUNT(v.id_venda) as Vendas 
  from produtos p inner join fornecedores f
  on p.fornecedor_id = f.id_fornecedor
  inner join itens_venda iv
  on p.id_produto = iv.produto_id
  inner join vendas v
  on iv.venda_id = v.id_venda
  where f.nome like 'NebulaNetworks' OR f.nome like 'HorizonDistributors' OR f.nome like 'AstroSupply'
  group by data, f.nome
  order by data asc
)
group by Data;
-- GRAFICO GERADO: GRAPH-Vendas_Nebula, Vendas_Horizon and Vendas_Astro.pdf


--- 02. identificar a porcentagem de representacao de cada categoria
select
categoria,
vendas,
round(vendas*100.0/(select count(*) from itens_venda),2) || '%' as porcentagem -- vendas/total de registros em itens_venda - ou seja, a porcentagem. se o *100 nao for incluido, deve se especificar o tipo de dado (numerico) de alguma outra formacategorias
from (
select c.nome_categoria as categoria, count(v.id_venda) as vendas
from itens_venda iv inner join produtos p
on iv.produto_id = p.id_produto
inner join categorias c
on p.categoria_id = c.id_categoria
inner join vendas v
on iv.venda_id = v.id_venda
group by categoria
order by vendas desc
);




