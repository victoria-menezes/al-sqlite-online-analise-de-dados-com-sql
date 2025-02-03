/*
Contexto:
Na aula, aprendemos a calcular a porcentagem de vendas de cada categoria de produtos, uma técnica valiosa para entender a participação de mercado de diferentes categorias.
Agora, vamos expandir essa abordagem para obter insights semelhantes sobre marcas e fornecedores.

Objetivo:
O objetivo deste desafio é aplicar a mesma lógica que usamos para categorias, mas agora para calcular a porcentagem de vendas de cada marca e cada fornecedor.
Isso nos ajudará a entender melhor quais marcas e fornecedores são mais significativos em termos de volume de vendas.
*/

--- CODIGO FORNECIDO:
SELECT Nome_Categoria, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM (
    SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN categorias c ON c.id_categoria = p.categoria_id
    GROUP BY Nome_Categoria
    ORDER BY Qtd_Vendas DESC
    )
;

--- TAREFA:
/* Análise de Marcas:
	Modifique a consulta acima para calcular a porcentagem de vendas de cada marca de produtos.
    Substitua as junções e seleções para focar nas marcas em vez de categorias.
*/
select Marca, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
from (
  select m.nome as Marca, count(iv.venda_id) as Qtd_Vendas
  from marcas m inner join produtos p
  on p.marca_id = m.id_marca
  inner join itens_venda iv
  on p.id_produto  = iv.produto_id
  group by Marca
  order by Qtd_Vendas desc
);
-- SOLUCAO FORNECIDA:
SELECT Nome_Marca, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM(
    SELECT m.nome AS Nome_Marca, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN marcas m ON m.id_marca = p.marca_id
    GROUP BY Nome_Marca
    ORDER BY Qtd_Vendas DESC
    )
;


/* Análise de Fornecedores:
	Realize uma alteração semelhante na consulta para calcular a porcentagem de vendas atribuídas a cada fornecedor.
*/
select Fornecedor, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
from (
  select f.nome as Fornecedor, count(iv.venda_id) as Qtd_Vendas
  from fornecedores f inner join produtos p
  on f.id_fornecedor = p.fornecedor_id
  inner join itens_venda iv
  on p.id_produto  = iv.produto_id
  group by Fornecedor
  order by Qtd_Vendas desc
);
-- SOLUCAO FORNECIDA:
SELECT Nome_Fornecedor, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM(
    SELECT f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    GROUP BY Nome_Fornecedor
    ORDER BY Qtd_Vendas DESC
    )
;