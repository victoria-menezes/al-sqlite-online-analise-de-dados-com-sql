/*
Frequentemente, é necessário verificar a quantidade de registros presentes em diversas tabelas de um banco de dados.
Executar consultas individuais para cada tabela é um processo trabalhoso e não facilita a comparação direta entre os resultados obtidos.

Desenvolva uma solução que permita visualizar a quantidade de registros de várias tabelas em uma única consulta, consolidando os resultados em uma tabela única.
Isso irá otimizar o processo de verificação e comparação, tornando-o mais eficiente e menos suscetível a erros.
*/
SELECT COUNT(*) as Qtd, 'Categorias' as Tabela FROM categorias
UNION ALL
SELECT COUNT(*) as Qtd, 'Clientes' as Tabela FROM clientes
UNION ALL
SELECT COUNT(*) as Qtd, 'Fornecedores' as Tabela FROM fornecedores
UNION ALL
SELECT COUNT(*) as Qtd, 'ItensVenda' as Tabela FROM itens_venda
UNION ALL
SELECT COUNT(*) as Qtd, 'Marcas' as Tabela FROM marcas
UNION ALL
SELECT COUNT(*) as Qtd, 'Produtos' as Tabela FROM produtos
UNION ALL
SELECT COUNT(*) as Qtd, 'Vendas' as Tabela FROM vendas;
