
-------------------------------------------------------------------------------
--pr_verifica_data_requisicao_aberto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Verifica a Data de Requisição mais Antiga que não gerou virou pedido de Compra
--Data             : 24/12/2004
--Atualizado       
----------------------------------------------------------------------------------------------------
create procedure pr_verifica_data_requisicao_aberto

as

select 
  top 1
  min( rc.dt_emissao_req_compra ) as DataReqAberto,
  rc.cd_requisicao_compra
from 
  requisicao_compra rc left outer join requisicao_compra_item rci on rc.cd_requisicao_compra = rci.cd_requisicao_compra
where
  isnull(rc.ic_liberado_proc_compra,'N') = 'S' and isnull(rci.cd_pedido_venda,0) = 0 
group by
  rc.cd_requisicao_compra



