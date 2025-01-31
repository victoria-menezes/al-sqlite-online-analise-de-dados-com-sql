/*
Em bases de dados reais, é comum encontrar erros e inconsistências, especialmente em valores numéricos como preços de produtos.
Identificar e corrigir esses erros é essencial para a validação das análises de dados.

Há uma necessidade de verificar e ajustar os preços dos produtos na base de dados,
já que alguns itens apresentam valores fora do intervalo considerado normal ou esperado.

Tarefa:
    Análise da base de dados de produtos para identificar preços que estão fora dos intervalos especificados.
    Atualize os registros de preços para assegurar que todos estejam dentro dos limites aceitáveis.

Tabela de Intervalos de Preços Aceitáveis:

PRODUTO 			MINIMO	MAXIMO
bola de futebol		20		100
chocolate			10		50
celular				80		5000
livro de ficcao		10		200
camisa				80		200
*/

-- identificar os produtos aceitaveis
create view vw_produtos_aceitaveis as
select * from produtos
where (lower(nome_produto) like 'bola de futebol') and (preco between 20 and 100)
union all
select * from produtos
where (lower(nome_produto) like 'chocolate') and (preco between 10 and 50)
union all
select * from produtos
where (lower(nome_produto) like 'celular') and (preco between 80 and 5000)
union all
select * from produtos
where (lower(nome_produto) like 'livro de ficção') and (preco between 10 and 200)
union all
select * from produtos
where (lower(nome_produto) like 'camisa') and (preco between 80 and 200)
order by id_produto asc;

-- identificar a media de preco dos produtos aceitaveis
create view vw_produto_media_preco as
select nome_produto, avg(preco) as media_preco from vw_produtos_aceitaveis group by nome_produto;

-- dar o update nos produtos inaceitaveis, fazendo seus precos serem igual a media dos produtos aceitaveis
begin TRANSACTION;
update produtos
set preco = m.media_preco
from vw_produto_media_preco m
where produtos.nome_produto = m.nome_produto
and produtos.id_produto not in (select id_produto from vw_produtos_aceitaveis);

COMMIT;
--rollback;