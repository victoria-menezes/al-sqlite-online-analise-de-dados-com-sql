/*

Agora que você já concluiu os seus estudos no curso SQLite online: análise de dados com SQL,
chegou o momento de colocar em pratica todos os conhecimentos adquiridos durante os seus estudos.

Para desenvolver esse desafio, você irá utilizar o banco de dados criado no desafio 1, mas não se preocupe,
se você não construiu ou não tem mais o banco de dados disponível, baixe o banco já estruturado e importe no SQLite online!

Banco utlizado: aula5-extra2-BANCO.db

Contexto
Vamos concluir este desafio explorando uma variedade de consultas, das mais simples às mais complexas,
usando todos os recursos apresentados até o momento no contexto do nosso sistema de gerenciamento escolar.*/

--- Consulta 1: Retorne todas as disciplinas
select nome_disciplina from Disciplinas;


--- Consulta 2: Retorne os alunos que estão aprovados (nota >= 7.0) na disciplina de matemática
select a.Nome_Aluno, n.Nota
from Notas n inner join Disciplinas d
on n.ID_Disciplina = d.ID_Disciplina
inner join Alunos a
on n.ID_Aluno = a.ID_Aluno
where
	lower(d.Nome_Disciplina) like 'matemática'
    and n.Nota >= 7
order by a.Nome_Aluno asc;


--- Consulta 3: Identificar o total de disciplinas por turma
select t.Nome_Turma, count(id_disciplina) as 'Total de Disciplinas'
from Turmas t inner join Turma_Disciplinas td
on t.ID_Turma = td.ID_Turma
group by t.ID_Turma


--- Consulta 4: Porcentagem dos alunos que estão aprovados em pelo menos uma materia
select
	count(distinct a.ID_Aluno) as Qtd_Alunos,
	count(distinct case when n.Nota >= 7.0 then a.id_aluno end) as Qtd_Aprovados,
    (cast(round(count(distinct case when n.Nota >= 7.0 then a.id_aluno end)*100.0/count(distinct a.ID_Aluno),2) as text) || '%') as Porcentagem
from Notas n right join Alunos a -- Right join pois existem alunos sem notas
on n.ID_Aluno = a.ID_Aluno


--- Consulta 5: Porcentagem dos alunos que estão aprovados por disciplina
with Qtd_Alunos as 
	(select count(id_aluno) as Total from alunos)
select 
	d.Nome_Disciplina,
    (sum(case when n.Nota > 7.0 then 1 else 0 end)) as 'Qtd Alunos Aprovados',
    count(distinct a.id_aluno) as 'Qtd Alunos Matriculados',
	cast(round((sum(case when n.Nota > 7.0 then 1 else 0 end))*100.0/count(distinct a.id_aluno), 2) as text)|| '%' as 'Porcentagem de Aprovação'
from Disciplinas d inner join Notas n
on d.ID_Disciplina = n.ID_Disciplina
inner join alunos a
on a.ID_Aluno = n.ID_Aluno
group by d.Nome_Disciplina;


