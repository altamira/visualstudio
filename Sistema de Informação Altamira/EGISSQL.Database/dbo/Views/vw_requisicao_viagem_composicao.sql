
CREATE VIEW vw_requisicao_viagem_composicao
------------------------------------------------------------------------------------
--sp_help vw_requisicao_viagem_composicao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : View para Mostrar a Composição da Requisição de Viagem
--Data                  : 04.04.2008
--Atualização           : 11.04.2008 - Complemento de Campos - Carlos Fernandes
--
------------------------------------------------------------------------------------
as

--select * from funcionario
--select * from categoria_viagem

Select 

  isnull(cv.nm_categoria_viagem,'')      as nm_categoria_viagem, 
  rvc.cd_requisicao_viagem,
  rvc.cd_item_requisicao_viagem,
  isnull(rvc.nm_obs_item_req_viagem,'')  as nm_obs_item_req_viagem,
  isnull(rvc.qt_item_viagem,0)           as qt_item_viagem,
  isnull(rvc.vl_item_viagem,0)           as vl_item_viagem,
  isnull(rvc.vl_total_viagem,0)          as vl_total_viagem,
  isnull(rvc.nm_item_opcional_viagem,'') as nm_item_opcional_viagem,
  isnull(rvc.nm_item_motivo_viagem,'')   as nm_item_motivo_viagem,
  isnull(cv.ic_servico_categoria,'N')    as ic_servico_categoria

from
  Requisicao_Viagem_Composicao rvc    with (nolock)
  left outer join Categoria_Viagem cv with (nolock) on cv.cd_categoria_viagem = rvc.cd_categoria_viagem 
