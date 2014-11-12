
-------------------------------------------------------------------------------  
--pr_previsao_reembolso 
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2004  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Rafael Santiago  
--Banco de Dados   : Egissql  
--Objetivo         :   
--Data             : 08/07/2005  
--Alteração        :   
------------------------------------------------------------------------------  
create procedure pr_previsao_reembolso  
  
@dt_inicial as datetime,  
@dt_final   as datetime  
  
  
as  
select  
  pv.nm_projeto_viagem         as 'Projeto',  
  cc.nm_centro_custo           as 'CentroCusto',    
  d.nm_departamento            as 'Departamento',  
  rv.cd_requisicao_viagem      as 'Req',  
  rv.dt_requisicao_viagem      as 'Data',  
  f.nm_funcionario             as 'Funcionario',  
  tdv.nm_despesa_viagem        as 'Despesa',  
  rvc.vl_custo_item_req_viagem as 'Valor'  
from   
  Requisicao_Viagem rv   
  left outer join  
  Projeto_Viagem pv on rv.cd_projeto_viagem = pv.cd_projeto_viagem  
  left outer join   
  Departamento d on rv.cd_departamento = d.cd_departamento  
  left outer join   
  Funcionario f on rv.cd_funcionario = f.cd_funcionario  
  left outer join  
  Moeda m on rv.cd_moeda = m.cd_moeda  
  left outer join   
  Requisicao_viagem_Composicao rvc on rv.cd_requisicao_viagem = rvc.cd_requisicao_viagem  
  left outer join   
  Centro_Custo cc on rv.cd_centro_custo = cc.cd_centro_custo  
  left outer join  
  Tipo_Despesa_Viagem tdv on rvc.cd_despesa_viagem = tdv.cd_despesa_viagem  
  
WHERE   
  rv.dt_fim_viagem is null    


