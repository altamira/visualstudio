
CREATE PROCEDURE pr_Cancela_pedido_importacao
-----------------------------------------------------------------
--pr_Cancela_pedido_importacao
-----------------------------------------------------------------
-- GBS - Global Business Solution Ltda                       2004 
-----------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server
-- Autor(es)            : Daniel C. Neto.
-- Banco de Dados       : EGISSQL
-- Objetivo             : Cancelamento de Pedido de Importação.
-- Data                 : 20/02/2004
-- Atualização          : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 02.09.2005 - Verificação - Carlos Fernandes
-- 
------------------------------------------------------------------------------------
@ic_ativar              char(1),
@cd_pedido_importacao   int,
@cd_item_ped_imp        int,
@dt_cancelamento_pedido datetime,
@ds_cancelamento_pedido varchar (100),
@cd_status_pedido       int,
@cd_motivo              int

AS
if not (@ic_ativar = 'S') 
begin
    -- Atualizando tabela de Pedido de Importação.
    -- somente se todos os itens tiverem sido cancelados.
    UPDATE pedido_importacao
    SET nm_canc_pedido_importacao     = @ds_cancelamento_pedido,
        dt_canc_pedido_importacao     = @dt_cancelamento_pedido,
        nm_ativacao_pedido_importacao = '',
        dt_ativacao_pedido_importacao = null,
        cd_status_pedido              = @cd_status_pedido,
        cd_motivo_ativacao_pedido     = null,
        cd_motivo_cancel_pedido       = @cd_motivo
    where  cd_pedido_importacao = @cd_pedido_importacao and
	   (@cd_item_ped_imp = 0)

    -- Atualizando os itens do pedido de compra.
    UPDATE pedido_importacao_item 
    SET nm_motivo_cancel_item_ped = @ds_cancelamento_pedido,
        dt_cancel_item_ped_imp    = @dt_cancelamento_pedido,
        nm_motivo_ativ_item_ped   = '',
        dt_ativ_item_ped_imp      = null,
        cd_motivo_ativacao_pedido = null,
        cd_motivo_cancel_pedido = @cd_motivo,
        qt_saldo_item_ped_imp = 0

    where  cd_pedido_importacao = @cd_pedido_importacao and
           (
            (cd_item_ped_imp = @cd_item_ped_imp) or
            (@cd_item_ped_imp = 0)
           ) 

    -- Atualizando os itens da requisição.
    update Requisicao_Compra_item
    set cd_pedido_importacao     = null,
        cd_item_ped_imp          = null,
        ic_pedido_item_req_compra='N'
    where cd_pedido_importacao = @cd_pedido_importacao and
	  (
	    (cd_item_ped_imp = @cd_item_ped_imp) or
	    (@cd_item_ped_imp = 0)
	  )


    --Atualizando a tabela produto Saldo


end 
else 
begin
  UPDATE pedido_importacao
  SET nm_ativacao_pedido_importacao = @ds_cancelamento_pedido,
      dt_ativacao_pedido_importacao = @dt_cancelamento_pedido,
      nm_canc_pedido_importacao = '',
      dt_canc_pedido_importacao = null,
      cd_status_pedido = @cd_status_pedido,
      cd_motivo_ativacao_pedido = @cd_motivo,
      cd_motivo_cancel_pedido = null

  where 
      cd_pedido_importacao = @cd_pedido_importacao and
      (@cd_item_ped_imp = 0)


  UPDATE pedido_importacao_item 
  SET nm_motivo_ativ_item_ped = @ds_cancelamento_pedido,
      dt_ativ_item_ped_imp = @dt_cancelamento_pedido,
      nm_motivo_cancel_item_ped = '',
      dt_cancel_item_ped_imp = null,
      qt_saldo_item_ped_imp = qt_item_ped_imp
  where  
      cd_pedido_importacao = @cd_pedido_importacao and
      (
       (cd_item_ped_imp = @cd_item_ped_imp) or
       (@cd_item_ped_imp = 0)
      )

    -- Atualizando os itens da requisição.
  select cd_requisicao_compra, cd_item_requisicao_compra as cd_requisicao_compra_item, cd_item_ped_imp
  into #Requisicao_Compra
  from
    Pedido_Importacao_item
  where
    (cd_pedido_importacao = @cd_pedido_importacao) and
    ( (cd_item_ped_imp = @cd_item_ped_imp) or
      @cd_item_ped_imp = 0 ) and
    IsNull(cd_requisicao_compra,0) <> 0 

  declare @cd_requisicao_compra int
  declare @cd_item_requisicao_compra int
  declare @cd_item_pedido int

  while exists (select top 1 * from #Requisicao_Compra)
    begin

      set @cd_requisicao_compra = ( select top 1 
	                              cd_requisicao_compra 
                                    from #Requisicao_Compra )
      set @cd_item_requisicao_compra = ( select top 1
                                           cd_requisicao_compra_item
					 from #Requisicao_Compra)
      set @cd_item_pedido = ( select top 1 
			        cd_item_ped_imp
			      from #Requisicao_Compra )

      update Requisicao_Compra_item
      set cd_pedido_importacao = @cd_pedido_importacao,
          cd_item_ped_imp = @cd_item_pedido,
          ic_pedido_item_req_compra='S'
      where cd_requisicao_compra = @cd_requisicao_compra and
        cd_item_requisicao_compra = @cd_item_requisicao_compra

      delete from #Requisicao_Compra 
      where cd_requisicao_compra = @cd_requisicao_compra and
	    cd_requisicao_compra_item = @cd_item_requisicao_compra and
            cd_item_ped_imp = @cd_item_pedido
    end


end
