--- 01. Analise de sazonalidade
-- Quadro geral de vendas
select strftime('%Y/%m', data_venda) as Data, count(*) as Qtd_Vendas
from vendas
group by Data
order by Data;
-- GRAFICO: GRAPH-Qtd_Vendas vs. Data

--- 02. Construir uma tabela que mostra o desempenho mensal ao longo dos anos
SELECT Mes,
	sum(case when Ano LIKE '2020' then Qtd_Vendas ELSE 0 END) as "2020",
    sum(case when Ano LIKE '2021' then Qtd_Vendas ELSE 0 END) as "2021",
    sum(case when Ano LIKE '2022' then Qtd_Vendas ELSE 0 END) as "2022",
    sum(Case when Ano LIKE '2023' then Qtd_Vendas ELSE 0 END ) as "2023"
FROM (
  select strftime('%m', data_venda) as Mes, strftime('%Y', data_venda) as Ano, count(*) as Qtd_Vendas
  from vendas
  group by Mes, Ano
  order by Mes, Ano
)
group by Mes order by Mes asc;
-- GRAFICO: GRAPH-quadro-geral-anual.pdf
-- SOLUCAO FORNECIDA:
SELECT Mes,
SUM(CASE WHEN Ano=='2020' THEN Qtd_Vendas ELSE 0 END) AS "2020",
SUM(CASE WHEN Ano=='2021' THEN Qtd_Vendas ELSE 0 END) AS "2021",
SUM(CASE WHEN Ano=='2022' THEN Qtd_Vendas ELSE 0 END) AS "2022",
SUM(CASE WHEN Ano=='2023' THEN Qtd_Vendas ELSE 0 END) AS "2023"
FROM(
    SELECT strftime('%m', data_venda) AS Mes, strftime('%Y', data_venda) AS Ano, COUNT(*) AS Qtd_Vendas
    FROM Vendas
    GROUP BY Mes, Ano
    ORDER BY Mes
    )
GROUP BY Mes
;


--- 03. Metrica - Acompanhar os desenvolvimentos da black friday (usando a de 2022 como exemplo)
-- Quanto vendeu, ne media, nas ultimas black fridays?
select avg(Qtd_Vendas) as Media_Qtd_Vendas
from (
	select count(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
	from vendas v
	where strftime('%m', v.data_venda) = '11' and strftime('%Y', v.data_venda) != '2022'
	group by Ano
);

-- Quanto vendeu nessa black friday?
select Qtd_Vendas as Qtd_Vendas_Atual from(
	select count(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
	from vendas v
	where strftime('%m', v.data_venda) = '11' and strftime('%Y', v.data_venda) = '2022'
	group by Ano
);

-- Juntar os dados e oferecer a porcentagem de crescimento/decaimento
with Media_Vendas_Anteriores as (
  select avg(Qtd_Vendas) as Media_Qtd_Vendas
  from (
      select count(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
      from vendas v
      where strftime('%m', v.data_venda) = '11' and strftime('%Y', v.data_venda) != '2022'
      group by Ano
  )
), Vendas_Atual as (
  select Qtd_Vendas as Qtd_Vendas_Atual from(
	select count(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
	from vendas v
	where strftime('%m', v.data_venda) = '11' and strftime('%Y', v.data_venda) = '2022'
	group by Ano
  )
)
SELECT
mva.Media_Qtd_Vendas,
va.Qtd_Vendas_Atual,
ROUND(((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas)/mva.Media_Qtd_Vendas)*100,2)|| '%' as Porcentagem
from Vendas_Atual as va, Media_Vendas_Anteriores as mva









