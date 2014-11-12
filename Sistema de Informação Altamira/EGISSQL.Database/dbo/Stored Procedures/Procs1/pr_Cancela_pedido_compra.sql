-------------------------------------------------------------------------------------------
--pr_Cancela_pedido_compra
-------------------------------------------------------------------------------------------
-- GBS
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Cancelamento de Pedido de Compra
-- Data             : 27/04/2002	
-- Atualizado       : 10/11/2003 - Inclusão de Requisição de Compra. - Daniel C. Neto.
--                    12/12/2003 - Tratamento ic_pedido_compra_cotacao(Cotacao_Item), 
--                                 ic_pedido_item_req_compra(Requisicao_Compra_Item) - Daniel Duela/Daniel C. Neto
-- 07/01/2004 - Acerto nos loops de Requisicao e de Cotacao - Daniel C. Neto.
-- 18/03/2005 - Apagar a requisição e o item quando cancelar o pedido - Daniel C. Neto.
-- 10.08.2005 - Corrigir o Status da Requisição de Compra para -1- => Aberto - Carlos Fernandes
-- 24.10.2005 - Limpar os campos "cd_pedido_compra" e "cd_item_pedido_compra" na requisição de compra, para liberá-la de fato - FCM
------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_Cancela_pedido_compra
@ic_ativar              char(1),
@cd_pedido_compra       int,
@cd_item_pedido_compra  int,
@dt_cancelamento_pedido Datetime,
@ds_cancelamento_pedido varchar (60),
@cd_status_pedido       int

AS

declare
@cd_cotacao      int,
@cd_item_cotacao int

declare @cd_requisicao_compra int

--Tabela Temporária para Cotação

select 
  IsNull(cd_cotacao,0)      as cd_cotacao,
  IsNull(cd_item_cotacao,0) as cd_item_cotacao
into #Temp
from pedido_compra_item
where
  cd_pedido_compra = @cd_pedido_compra and
  (cd_item_pedido_compra = @cd_item_pedido_compra or
   @cd_item_pedido_compra=0) and
  IsNull(cd_cotacao,0) <> 0

  --Tabela Temporária para Requisição de Compra
  select
    isnull(cd_requisicao_compra,0) as cd_requisicao_compra
  into
    #ReqStatus
  from
    Pedido_Compra_item
  where
    cd_pedido_compra = @cd_pedido_compra

if not (@ic_ativar = 'S') 
begin

--CANCELAMENTO

    -- Atualizando tabela de Pedido de Compra.
    -- somente se todos os itens tiverem sido cancelados.
    UPDATE pedido_compra
    SET ds_cancel_ped_compra = @ds_cancelamento_pedido,
        dt_cancel_ped_compra = @dt_cancelamento_pedido,
        ds_ativacao_pedido_compra = '',
        dt_ativacao_pedido_compra = null,
        cd_status_pedido = @cd_status_pedido  
    where  cd_pedido_compra = @cd_pedido_compra and
	   (@cd_item_pedido_compra = 0)

    -- Atualizando os itens do pedido de compra.
    UPDATE pedido_compra_item 
    SET nm_item_motcanc_Ped_compr = @ds_cancelamento_pedido,
        dt_item_canc_ped_compra   = @dt_cancelamento_pedido,
        nm_item_ativ_ped_compra   = '',
        dt_Item_ativ_Ped_compra   = null
        --cd_requisicao_compra_item = null,
        --cd_requisicao_compra      = null 

    where  cd_pedido_compra = @cd_pedido_compra and
           (
            (cd_item_pedido_compra = @cd_item_pedido_compra) or
            (@cd_item_pedido_compra = 0)
           ) 

    -- Atualizando os itens da requisição.
    update Requisicao_Compra_item
    set cd_pedido_compra         = null,
        cd_item_pedido_compra    = null,
        ic_pedido_item_req_compra='N'
    where cd_Pedido_compra = @cd_pedido_compra and
	  (
	    (cd_item_pedido_compra = @cd_item_pedido_compra) or
	    (@cd_item_pedido_compra = 0)
	  )

    --select * from #Temp

     -- Atualizando os itens da cotação.
    while exists(select top 1 * from #Temp)
      begin
        select top 1
          @cd_cotacao= cd_cotacao,
          @cd_item_cotacao = cd_item_cotacao 
        from #Temp
         
        update Cotacao_Item
        set ic_pedido_compra_cotacao='N'
        where cd_cotacao = @cd_cotacao and
	      cd_item_cotacao = @cd_item_cotacao

        delete from #Temp 
        where
          cd_cotacao = @cd_cotacao and
          cd_item_cotacao= @cd_item_cotacao 
      end

    -- Atualizando a tabela de Requisição de compra, caso todos os itens tiverem sido cancelados.
    --update Requisicao_Compra
    --set cd_pedido_compra = null,
    --    cd_status_requisicao=1   --Aberto ( Carlos 10.08.2005 )
     --where cd_Pedido_compra = @cd_pedido_compra and
     --     (@cd_item_pedido_compra = 0)


    --Atualizando o status da Requisição de Compra
     while exists(select top 1 * from #ReqStatus)
     begin
       select top 1 @cd_requisicao_compra = cd_requisicao_compra from #ReqStatus 
       update
         requisicao_compra
       set
         cd_status_requisicao = 1, -- Aberto 
         cd_pedido_compra = null --Apaga o pedido de compra da requisição
       where
         cd_requisicao_compra = @cd_requisicao_compra

       delete from #ReqStatus where cd_requisicao_compra = @cd_requisicao_compra
  
     end 

end 
else 
begin

--ATIVAÇÃO

  UPDATE pedido_compra
  SET ds_ativacao_pedido_compra = @ds_cancelamento_pedido,
      dt_ativacao_pedido_compra = @dt_cancelamento_pedido,
      ds_cancel_ped_compra = '',
      dt_cancel_ped_compra = null,
      cd_status_pedido     = @cd_status_pedido  
  where 
      cd_pedido_compra = @cd_pedido_compra and
      (@cd_Item_pedido_compra = 0)


  UPDATE pedido_compra_item 
  SET nm_item_ativ_ped_compra = @ds_cancelamento_pedido,
      dt_Item_ativ_Ped_compra = @dt_cancelamento_pedido,
      nm_item_motcanc_Ped_compr = '',
      dt_item_canc_ped_compra = null
  where  
      cd_pedido_compra = @cd_pedido_compra and
      (
       (cd_item_pedido_compra = @cd_item_pedido_compra) or
       (@cd_item_pedido_compra = 0)
      )

    -- Atualizando os itens da requisição.
  select cd_requisicao_compra, cd_requisicao_compra_item, cd_item_pedido_compra
  into #Requisicao_Compra
  from
    Pedido_Compra_item
  where
    (cd_pedido_compra = @cd_pedido_compra) and
    ( (cd_item_pedido_compra = @cd_item_pedido_compra) or
      @cd_item_pedido_compra = 0 ) and
    IsNull(cd_requisicao_compra,0) <> 0 

  declare @cd_item_requisicao_compra int
  declare @cd_item_pedido            int

  while exists (select top 1 * from #Requisicao_Compra)
    begin

      set @cd_requisicao_compra = ( select top 1 
	                              cd_requisicao_compra 
                                    from #Requisicao_Compra )
      set @cd_item_requisicao_compra = ( select top 1
                                           cd_requisicao_compra_item
					 from #Requisicao_Compra)
      set @cd_item_pedido = ( select top 1 
			        cd_item_pedido_compra
			      from #Requisicao_Compra )

      update Requisicao_Compra_item
      set cd_pedido_compra         = @cd_pedido_compra,
          cd_item_pedido_compra    = @cd_item_pedido,
          ic_pedido_item_req_compra='S'
      where cd_requisicao_compra = @cd_requisicao_compra and
        cd_item_requisicao_compra = @cd_item_requisicao_compra

      delete from #Requisicao_Compra 
      where cd_requisicao_compra = @cd_requisicao_compra and
	    cd_requisicao_compra_item = @cd_item_requisicao_compra and
            cd_item_pedido_compra = @cd_item_pedido
    end

    -- Atualizando a tabela de Requisição de compra, caso todos os itens tiverem sido cancelados.
    --update Requisicao_Compra
    --set cd_pedido_compra     = null,
    --    cd_status_requisicao = 3        --Fechado ( Carlos 10.08.2005 )
    --where cd_Pedido_compra = @cd_pedido_compra and
    --     (@cd_item_pedido_compra = 0)

     -- Atualizando os itens da cotação.
    while exists(select top 1 * from #Temp)
      begin
        select top 1
          @cd_cotacao= cd_cotacao,
          @cd_item_cotacao = cd_item_cotacao 
        from #Temp
         
        update Cotacao_Item
        set ic_pedido_compra_cotacao='S'
        where cd_cotacao = @cd_cotacao and
	      cd_item_cotacao = @cd_item_cotacao

        delete from #Temp 
        where
          cd_cotacao = @cd_cotacao and
          cd_item_cotacao= @cd_item_cotacao 
      end

    --Atualizando o status da Requisição de Compra
     while exists(select top 1 * from #ReqStatus)
     begin
       select top 1 @cd_requisicao_compra = cd_requisicao_compra from #ReqStatus 
       update
         requisicao_compra
       set
         cd_status_requisicao = 3, -- Fechado
         cd_pedido_compra = @cd_pedido_compra
       where
         cd_requisicao_compra = @cd_requisicao_compra

       delete from #ReqStatus where cd_requisicao_compra = @cd_requisicao_compra
  
     end 



end


