

/****** Object:  Stored Procedure dbo.pr_cone_afiacao2    Script Date: 13/12/2002 15:08:15 ******/
--pr_cone_afiacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton
--Quantidade de Ferramentas que estao
--Data         : 18.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_cone_afiacao2
as
-- Traz o ultimo movimnto de cada cone na afiaçao.
select a.cd_cone,
       max(a.cd_movimento) as cd_movimento
into #MaxMovCone
from
  Movimento_Cone a, Cone b
where
  b.cd_cone=a.cd_cone and
  b.ic_status_cone=0
group by 
  a.cd_cone
order by 
  a.cd_movimento desc
-- pega os dados de Movimento_cone dos ultimos movimentos dos cones na afiacao
select a.dt_movimento_cone,
       a.cd_cone,
       a.cd_movimento,
       a.cd_grupo_ferramenta,
       a.cd_ferramenta,
       a.cd_usuario,
       c.qt_tempo_retorno_cone
       
into #ConeAux 
from 
  Movimento_Cone a, #MaxMovCone b, ferramenta_cone c 
where
  a.cd_movimento=b.cd_movimento  and
  a.cd_cone=c.cd_cone
-- Traz todos os dados dos cones na afiaçao sem movimento
select b.dt_montagem_cone          as 'dt_movimento_cone',
       b.cd_cone                   as 'cd_cone',
       0                           as 'cd_movimento',
       b.cd_grupo_ferramenta       as 'cd_grupo_ferramenta',
       b.cd_ferramenta             as 'cd_ferramenta',
       b.cd_usuario                as 'cd_usuario',
       b.qt_tempo_retorno_cone     as 'qt_tempo_retorno_cone'            
into #ConeAux2
from cone a,ferramenta_cone b
where a.cd_cone not in(select cd_cone from #MaxMovCone) and
      a.cd_cone=b.cd_cone and
      a.ic_status_cone=0
--insere na mesma tabela cones com movimento e sem movimento
insert into #ConeAux 
select * 
from #ConeAux2
--Mostra tabela final
select a.dt_movimento_cone       as 'data',
       a.cd_cone                 as 'cone',
       c.nm_fantasia_ferramenta  as 'fantasia_ferramenta',
       c.nm_ferramenta           as 'ferramenta',
       a.qt_tempo_retorno_cone   as 'retorno',
       b.nm_fantasia_usuario     as 'usuario',
       a.cd_movimento            as 'movimento'
  
from 
  #ConeAux a,SapAdmin.dbo.usuario b,Ferramenta c
where
  a.cd_usuario          = b.cd_usuario          and
  a.cd_grupo_ferramenta = c.cd_grupo_ferramenta and
  a.cd_ferramenta       = c.cd_ferramenta
order by 
   a.dt_movimento_cone desc,
   a.cd_movimento desc   


