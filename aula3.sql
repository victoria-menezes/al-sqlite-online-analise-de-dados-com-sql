-- 01. Preparando consultas para a reuniao sobre a black friday
/* PAUTAS:
- Papel dos fornecedores na black friday
- Categorias de produtos na black friday
- Performance das black fridays anteriores e a que vira
*/

--- Papel dos fornecedoes
select strftime('%Y/%m', v.data_venda) as data, f.nome, COUNT(v.id_venda) as vendas 
from produtos p inner join fornecedores f
on p.fornecedor_id = f.id_fornecedor
inner join itens_venda iv
on p.id_produto = iv.produto_id
inner join vendas v
on iv.venda_id = v.id_venda
where data like '%/11'
group by data, f.nome
order by data, vendas asc;

-- SOLUCAO FORNECIDA:
select strftime('%Y/%m', v.data_venda) as "ano/mes", f.nome as fornecedor, count(iv.produto_id) as qtd_vendas
from itens_venda iv
inner join vendas v
on v.id_venda = iv.venda_id
inner join produtos p
on iv.produto_id = p.id_produto
inner join fornecedores f
on f.id_fornecedor = p.fornecedor_id
where strftime('%m', v.data_venda) = '11'
group by "ano/mes", fornecedor 
order by "ano/mes", qtd_vendas


--- Categorias de produto na black friday
select strftime('%Y/%m', v.data_venda) as data, c.nome_categoria as categoria, count(v.id_venda) as vendas
from itens_venda iv inner join produtos p
on iv.produto_id = p.id_produto
inner join categorias c
on p.categoria_id = c.id_categoria
inner join vendas v
on iv.venda_id = v.id_venda
where data like '%/11'
group by data, categoria
order by data asc, vendas desc;

-- SOLUCAO FORNECIDA:
SELECT strftime('%Y', v.data_venda) AS "Ano", c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY Nome_Categoria, "Ano"
ORDER BY "Ano" asc, Qtd_Vendas DESC;


--- Informacoes de um certo fornecedor
select strftime('%Y/%m', v.data_venda) as data, COUNT(v.id_venda) as vendas 
from produtos p inner join fornecedores f
on p.fornecedor_id = f.id_fornecedor
inner join itens_venda iv
on p.id_produto = iv.produto_id
inner join vendas v
on iv.venda_id = v.id_venda
where f.nome like 'NebulaNetworks'
group by data, f.nome
order by data asc;

