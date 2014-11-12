-------------------------------------------------------------------------- 
CREATE PROCEDURE pr_modifica_status_pedido_compra
--------------------------------------------------------------------------
--pr_modifica_status_pedido_compra
--------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                               2005
--------------------------------------------------------------------------
-- Stored Procedure     : SQL Server 2000
--
-- Autor(es)            : 
--                      : Carlos Fernandes
-- Banco de Dados       : EGISSQL
-- Objetivo             : Atualiza o status do pedido de compra 
--                        conforme parâmetros
-- Data                 : 11.11.2005
-- Atualização          : 16.04.2006 - Acertos Diversos
--                                   - Mudança da forma de atualização Manual ou Automática
--                                   - Novo Status - Parcialmente recebido - Carlos Fernandes
---------------------------------------------------------------------------------------------
@cd_pedido_compra int,
@cd_usuario       int=0,
@cd_status_pedido int=0,
@ic_automatico    char(1) = 'N'

as

--select * from status_pedido

  declare @qt_item_pedido    int,
       	  @qt_item_cancelado int,
      	  @qt_item_faturado  int,
          @qt_item_parcial   int

  --select * from status_pedido

  --Atualiza o status do pedido de venda

  --1  - Aberto
  --2  - Liquidado
  --7  - Cancelado
  --9  - Recebido
  --10 - Parcialmente Recebido

  --Contagem de itens do pedido

  select
  	@qt_item_pedido = count('x') 
  from
        Pedido_Compra_Item
  where
	cd_pedido_compra = @cd_pedido_compra

  --Contagem de itens do pedido cancelados

  select
    @qt_item_cancelado = count('x') 
  from
    Pedido_Compra_Item
  where
    cd_pedido_compra = @cd_pedido_compra and 
    dt_item_canc_ped_compra is not null
	
  --Contagem de itens do pedido recebido

  select
     @qt_item_faturado = count('x') 
  from
     Pedido_Compra_Item
  where
     cd_pedido_compra = @cd_pedido_compra and 
     dt_item_canc_ped_compra is null and
     IsNull(qt_saldo_item_ped_compra,0) <= 0

  select
     @qt_item_parcial = count('x') 
  from
     Pedido_Compra_Item
  where
     cd_pedido_compra = @cd_pedido_compra and 
     dt_item_canc_ped_compra is null and
     IsNull(qt_saldo_item_ped_compra,0)>0


--Verifica o Status de Atualização

if @ic_automatico='S' 
begin

  --Atualiza o status do pedido	cancelado

  if (@qt_item_pedido = @qt_item_cancelado)
  begin
    update Pedido_Compra 
    set 
      cd_status_pedido     = 14, 
      dt_cancel_ped_compra = cast((CONVERT(VARCHAR(10), GETDATE(), 105)) as datetime) 
    where 
      cd_pedido_compra = @cd_pedido_compra
    --select * from pedido_compra
  end
  -- Recebido
  else if (@qt_item_pedido  = @qt_item_faturado) or 
          ((@qt_item_pedido = @qt_item_faturado + @qt_item_cancelado) and 
           (@qt_item_faturado > 0))
  begin
    update Pedido_compra 
    set 
      cd_status_pedido = 9
    where 
      cd_pedido_compra = @cd_pedido_compra
  end
  -- Parcialmente Recebido
  else if (@qt_item_parcial>0) and (@qt_item_parcial>@qt_item_pedido)
  begin
    update Pedido_compra 
    set 
      cd_status_pedido = 10
    where 
      cd_pedido_compra = @cd_pedido_compra

  end

  --Aberto
  else
    begin
      update 
        Pedido_Compra 
      set 
        cd_status_pedido     = 8,
        dt_cancel_ped_compra = NULL   
    where 
        cd_pedido_compra = @cd_pedido_compra
  end

end

if @ic_automatico = 'N'
begin

  --Modifica o status selecionado pelo Usuário

  if @cd_status_pedido<> 0 
  begin
    update Pedido_Compra 
    set 
      cd_status_pedido = @cd_status_pedido
    where 
      cd_pedido_compra = @cd_pedido_compra

  end

end


