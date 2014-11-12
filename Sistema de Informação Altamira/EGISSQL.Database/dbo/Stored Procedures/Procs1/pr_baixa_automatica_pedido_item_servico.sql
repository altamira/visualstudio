
-------------------------------------------------------------------------------
--sp_helptext pr_baixa_automatica_pedido_item_servico
-------------------------------------------------------------------------------
--pr_baixa_automatica_pedido_item_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Baixa dos Pedidos de Venda com Produto/Serviço Idênticos
--                     
--Data             : 01.04.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_baixa_automatica_pedido_item_servico
@cd_pedido_venda      int      = 0,
@cd_item_pedido_venda int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''

as

--select * from pedido_venda_item
--select * from nota_saida
--select * from nota_saida_item

select
  identity(int,1,1)        as cd_controle,
  ns.cd_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda,
  pvi.cd_produto_servico
into
  #ItemPedidoFaturado
from
  Nota_Saida_Item nsi              with (nolock)
  inner join nota_saida ns         with (nolock) on ns.cd_nota_saida         = nsi.cd_nota_saida
  inner join pedido_venda_item pvi with (nolock) on pvi.cd_pedido_venda      = nsi.cd_pedido_venda and
                                                    pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda
where
  pvi.cd_pedido_venda      = case when @cd_pedido_venda      = 0 then pvi.cd_pedido_venda      else @cd_pedido_venda      end and
  pvi.cd_item_pedido_venda = case when @cd_item_pedido_venda = 0 then pvi.cd_item_pedido_venda else @cd_item_pedido_venda end and
  isnull(nsi.cd_pedido_venda,0)>0       and
  isnull(nsi.cd_item_pedido_venda,0)>0  and
  isnull(pvi.cd_produto_servico,0)<>0

-- select 
--   *
-- from
--   #ItemPedidoFaturado


declare @cd_controle        int
declare @cd_produto_servico int

set @cd_controle = 0

while exists ( select top 1 cd_produto_servico from #ItemPedidoFaturado )
begin

  select 
    top 1
    @cd_controle        = isnull(cd_controle,0),
    @cd_produto_servico = cd_produto_servico
  from
    #ItemPedidoFaturado

  update
    pedido_venda_item
  set
    qt_saldo_pedido_venda = 0
  from
    pedido_venda_item pvi
  where
    cd_produto = @cd_produto_servico

  delete #ItemPedidoFaturado where cd_controle = @cd_controle

end

