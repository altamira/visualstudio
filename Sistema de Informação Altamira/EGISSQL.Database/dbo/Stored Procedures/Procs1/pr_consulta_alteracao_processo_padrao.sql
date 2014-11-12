
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_alteracao_processo_padrao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : consulta de processos padrão / formulas alteradas
--
--Data             : 14.09.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_alteracao_processo_padrao  
@dt_inicial datetime = '',  
@dt_final   datetime = '',  
@cd_usuario int      = 0  
as  
  
select  
  u.nm_fantasia_usuario,  
  pp.dt_usuario,  
  pp.cd_processo_padrao,  
  pp.nm_identificacao_processo,  
  pp.nm_processo_padrao  
   
from  
  processo_padrao pp                      with (nolock)   
  left outer join egisadmin.dbo.usuario u on u.cd_usuario = pp.cd_usuario  
  
where  
  pp.dt_usuario between @dt_inicial and @dt_final  
  
order by  
  u.nm_fantasia_usuario,  
  pp.dt_usuario desc  
  
  


