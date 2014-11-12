
-------------------------------------------------------------------------------
--sp_helptext pr_mrp_atualiza_processo_producao_pedido
-------------------------------------------------------------------------------
--pr_mrp_atualiza_processo_producao_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 09.11.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_mrp_atualiza_processo_producao_pedido
@cd_processo int = 0,
@cd_usuario  int = 0

as

--select * from plano_mrp_composicao

--processo_producao_pedido

insert into processo_producao_pedido
select
  p.cd_processo,
  p.cd_pedido_venda,
  p.qt_plano_mrp as qt_pedido_processo,
  @cd_usuario    as cd_usuario,
  getdate()      as dt_usuario,
  p.cd_item_pedido_venda
from
  plano_mrp_composicao p with (nolock)
where
  cd_processo = @cd_processo


