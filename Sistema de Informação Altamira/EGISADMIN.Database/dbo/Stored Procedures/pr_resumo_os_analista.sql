-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2004  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server       2000  
--Autor(es)        : Carlos Cardoso Fernandes  
--Banco de Dados   : EgisAdmin  
--Objetivo         : Resumo de OS por Cliente  
--Data             : 08/12/2004  
--Atualizado         
--------------------------------------------------------------------------------------------------  
CREATE procedure pr_resumo_os_analista  
@dt_inicial datetime,  
@dt_final   datetime  
  
as  
  
select  
  mh.nm_analista                as Analista,  
  count(*)                      as 'TotalAberto',  
  min(mh.dt_usuario)            as 'Primeira',  
  max(mh.dt_usuario)            as 'Ultima',  
  count(DISTINCT mh.cd_modulo)  as 'QtdModulo',  
  count(DISTINCT mh.nm_empresa) as 'QtdCliente'  
from  
  Menu_historico mh  
where  
  mh.dt_fim_desenvolvimento between @dt_inicial + '00:01' and @dt_final + '23:59' and  
  isnull(mh.ic_status_menu,'N') in ('H','F','C') and  
  mh.nm_analista is not null 
group by   
  mh.nm_analista  
order by  
  mh.nm_analista
