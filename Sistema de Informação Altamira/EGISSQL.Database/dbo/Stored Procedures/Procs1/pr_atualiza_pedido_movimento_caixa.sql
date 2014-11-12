
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_pedido_movimento_caixa
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualiza o Status do Pedido de Venda Movimento Caixa
--Data             : 01/05/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualiza_pedido_movimento_caixa
@cd_pedido_venda      int = 0,
@cd_item_pedido_venda int = 0,
@cd_movimento_caixa   int = 0,
@ic_parametro         int = 0
as

--Gera tabela auxiliar com o Pedido de Venda

select
 cd_pedido_venda,
 cd_item_pedido_venda
into
  #PedidoVenda
from
  Movimento_Caixa_item
where
 cd_movimento_caixa = @cd_movimento_caixa


-------------------------------------------------------------------------------
--Cancelamento
-------------------------------------------------------------------------------

if @ic_parametro = 1 --Cancelamento
begin
--Movimento de Caixa
  if @cd_movimento_caixa>0
  begin

--   update
--     movimento_caixa_item
--   set
--     cd_pedido_venda = 0
--   where
--     cd_movimento_caixa = @cd_movimento_caixa

  while exists ( select top 1 cd_pedido_venda from #PedidoVenda )
  begin

    select top 1 
      @cd_pedido_venda      = cd_pedido_venda,
      @cd_item_pedido_venda = cd_item_pedido_venda
    from
      #PedidoVenda

    --Atualiza o Pedido de Venda

    update
      pedido_venda
    set
      cd_status_pedido = 1
    where
      cd_pedido_venda = @cd_pedido_venda

    update
      pedido_venda_item
    set
      qt_saldo_pedido_venda = qt_item_pedido_venda
    where
       cd_pedido_venda      = @cd_pedido_venda and
       cd_item_pedido_venda = @cd_item_pedido_venda

    delete from #PedidoVenda where cd_pedido_venda      = @cd_pedido_venda and
                                   cd_item_pedido_venda = @cd_item_pedido_venda   

  end

 end

end

-------------------------------------------------------------------------------
--Ativação
-------------------------------------------------------------------------------

if @ic_parametro = 2 --Ativação
begin

--Atualiza o Pedido de Venda

  while exists ( select top 1 cd_pedido_venda from #PedidoVenda )
  begin

    select top 1 
      @cd_pedido_venda      = cd_pedido_venda,
      @cd_item_pedido_venda = cd_item_pedido_venda
    from
      #PedidoVenda


    update
      pedido_venda
    set
      cd_status_pedido = 2 --Liquidado
    where
      cd_pedido_venda  = @cd_pedido_venda

    update
      pedido_venda_item
    set
      qt_saldo_pedido_venda = 0
    where
      cd_pedido_venda = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda

    delete from #PedidoVenda where cd_pedido_venda      = @cd_pedido_venda and
                                   cd_item_pedido_venda = @cd_item_pedido_venda   

  end

end

