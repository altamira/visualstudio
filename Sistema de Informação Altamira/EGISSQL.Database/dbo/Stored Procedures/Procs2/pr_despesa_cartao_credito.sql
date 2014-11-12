
-------------------------------------------------------------------------------
--pr_despesa_cartao_credito
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
create procedure pr_despesa_cartao_credito

@dt_inicial as datetime,
@dt_final as datetime


as
select
  tcc.nm_cartao_credito        as 'Cartao',
  pv.nm_projeto_viagem         as 'Projeto',
  f.nm_funcionario             as 'Funcionario',
  tdv.nm_despesa_viagem        as 'Despesa',
  rvp.vl_prestacao_req_viagem  as 'Valor'
  
from 
  Requisicao_Viagem rv 
  left outer join
  Projeto_Viagem pv on rv.cd_projeto_viagem = pv.cd_projeto_viagem
  left outer join 
  Funcionario f on rv.cd_funcionario = f.cd_funcionario
  left outer join 
  Requisicao_Viagem_Prestacao rvp on rv.cd_requisicao_viagem = rvp.cd_requisicao_viagem
  left outer join 
  Requisicao_Viagem_Composicao rvc on rv.cd_requisicao_viagem = rvc.cd_requisicao_viagem  
  left outer join 
  Tipo_Despesa_Viagem tdv on rvc.cd_despesa_viagem = tdv.cd_despesa_viagem
  left outer join
  Tipo_Cartao_Credito tcc on rvp.cd_tipo_cartao_credito = tcc.cd_cartao_credito
  
