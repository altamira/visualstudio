

/****** Object:  Stored Procedure dbo.pr_cone_afiacao    Script Date: 13/12/2002 15:08:15 ******/
--pr_cone_afiacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton
--Quantidade de Ferramentas que estao
--Data         : 18.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_cone_afiacao
as
-- Cones que estao na Afiaçao
select a.cd_cone                    as 'cone',
       max(a.sg_cone)               as 'siglacone',
       --max(c.dt_montagem_cone)      as 'datamov',
       max(b.dt_movimento_cone)     as 'datamov',
       max(a.cd_usuario)            as 'codusuario',
       (select max(cd_movimento) from Movimento_cone where cd_cone=a.cd_cone) as 'movimento',
       max(c.cd_grupo_ferramenta)   as 'grupo',
       max(c.cd_ferramenta)         as 'ferramenta',
       max(c.qt_tempo_retorno_cone) as 'retorno'
into #ConeAux1
from 
  Cone a, Ferramenta_cone c,Movimento_cone b
where
  a.ic_status_cone      = 0                  and
  a.cd_cone             = c.cd_cone          and
  a.ic_cone_ativo       ='S'                 and
  b.cd_cone             = a.cd_cone          
  
group by 
  a.cd_cone
order by 
  a.cd_cone
      
--select * from #ConeAux
-- Mostra a Tabela final
select a.datamov                 as 'data',
       a.cone                    as 'cone',
       c.nm_fantasia_ferramenta  as 'fantasia_ferramenta',
       c.nm_ferramenta           as 'ferramenta',
       a.retorno                 as 'retorno',
       b.nm_fantasia_usuario     as 'usuario',                                            
       a.movimento               as 'movimento'
  
from 
  #ConeAux1 a,SapAdmin.dbo.usuario b,Ferramenta c
where
  a.codusuario        = b.cd_usuario          and
  a.grupo             = c.cd_grupo_ferramenta and
  a.ferramenta        = c.cd_ferramenta       
order by
  a.datamov desc,
  a.movimento desc
  


