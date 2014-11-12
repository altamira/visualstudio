create procedure pr_atualiza_status_pedido_importacao
-------------------------------------------------------------------
--pr_atualiza_status_pedido_importacao
-------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                         2004 
-------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server
-- Autor(es)             : Igor Gama
-- Banco de Dados        : EGISSQL
-- Objetivo              : Atualiza o status do pedido de importação
-- Data                  : 18.03.2004
-- Parametros            : cd_pedido_importacao
-- Atualização           : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------
@cd_pedido_importacao int,
@cd_usuario int
as
  Declare 
    @qt_item_pedido  int,
	  @qt_item_cancelado int,
	  @qt_item_faturado  int

	--Atualiza o status do pedido de venda
	-- 21 - Cancelado
	-- 15 - Aberto
	-- 16 - Recebido Liquidado
	
	--Contagem de itens do pedido
	Select
		@qt_item_pedido = count('x') 
	from
		Pedido_Importacao_Item
	where
		cd_pedido_importacao = @cd_pedido_importacao


	--Contagem de itens do pedido cancelados
	Select
		@qt_item_cancelado = count('x') 
	from
		Pedido_Importacao_Item
	where
		cd_pedido_importacao = @cd_pedido_importacao
		and 
		dt_cancel_item_ped_imp is not null
	

	--Contagem de itens do pedido entregue
	Select
		@qt_item_faturado = count('x') 
	from
		Pedido_Importacao_Item
	where
		cd_pedido_importacao = @cd_pedido_importacao
		and 
		dt_cancel_item_ped_imp is null
		and
		IsNull(qt_saldo_item_ped_imp,0) <= 0

    --Atualiza o status do pedido	
  	--Cancelado
    if (@qt_item_pedido = @qt_item_cancelado)
	    update pedido_importacao set cd_status_pedido = 21 where cd_pedido_importacao = @cd_pedido_importacao
    --Liquidado
    else if (@qt_item_pedido = @qt_item_faturado) or ((@qt_item_pedido = @qt_item_faturado + @qt_item_cancelado) and (@qt_item_faturado > 0))
	    update pedido_importacao set cd_status_pedido = 16 where cd_pedido_importacao = @cd_pedido_importacao
    --Aberto
  	else
	    update pedido_importacao
      set cd_status_pedido = 15
      where cd_pedido_importacao = @cd_pedido_importacao

---------------------------------------------------------------------------------------
--Testando a Stored Procedure
---------------------------------------------------------------------------------------
--exec pr_atualiza_status_pedido_importacao
