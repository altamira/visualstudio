

/****** Object:  Stored Procedure dbo.pr_localiza_ferramenta    Script Date: 13/12/2002 15:08:34 ******/
--pr_localiza_ferramenta
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton Marques de Souza
--Quantidade de Ferramentas que estao
--Data         : 21.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_localiza_ferramenta
@cd_grupo_ferramenta  int,
@cd_ferramenta        int,
@data                 datetime
AS 
select cd_cone
into
  #AUX1
from  
  ferramenta_cone
where  
  cd_grupo_ferramenta = @cd_grupo_ferramenta   and
  cd_ferramenta       = @cd_ferramenta
select MAX(B.cd_cone)               as 'cone',
       max(b.dt_movimento_cone)     as 'data',
       MAX(B.CD_MOVIMENTO)          AS 'MOVIMENTO',
       max(D.qt_tempo_retorno_cone)   as 'QtRet', 
       retorno =
       case 
         when convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone)))) > 0 then 
                  convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone))))
         when convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone)))) <= 0 then 0
       end,
       convert(int,(@Data - max(b.dt_movimento_cone))) as Operacao
INTO #AUX2
from 
  #Aux1 a,Movimento_cone b, CONE C, ferramenta_cone d
WHERe
  a.CD_CONE = C.CD_CONE AND
  a.CD_CONE = b.cd_cone and
  C.IC_STATUS_CONE = 1  and
  d.cd_cone=b.cd_cone
group by 
  B.CD_cone
order by
  b.cd_cone
Select t.cone                  as 'Cone',
       m.nm_fantasia_maquina   as 'Maquina',
       a.dt_movimento_cone     as 'Data',
       f.qt_tempo_retorno_cone as 'EstRetorno',
       u.nm_fantasia_usuario   as 'Usuario',
       t.retorno               as 'Retorno',
       t.operacao              as 'Operacao'
INTO #AUX3
from 
  #AUX2 t, Maquina m, Movimento_Cone a, SapAdmin.dbo.usuario u, Ferramenta_Cone f
where 
  a.cd_cone = t.cone           and
  a.cd_movimento = t.movimento and
  m.cd_maquina = a.cd_maquina  and
  f.cd_cone = a.cd_cone        and
  u.cd_usuario = a.cd_usuario
order by data desc
insert into #AUX3 
select a.cd_cone             as 'Cone',
       'AFIAÇAO'             as 'Maquina',
       a.dt_montagem_cone    as 'Data',
       0                     as 'EstRetorno',
       c.nm_fantasia_usuario as 'Usuario',
       0                     as 'Retorno',
       0                     as 'Operacao'
from
  Ferramenta_Cone a, Cone b, SapAdmin.dbo.usuario c 
where
  a.cd_grupo_ferramenta=@cd_grupo_ferramenta and
  a.cd_ferramenta = @cd_ferramenta           and
  a.cd_cone=b.cd_cone                        and
  b.ic_status_cone=0                         and
  a.cd_usuario=c.cd_usuario
select * 
from #AUX3
order by Data desc 


