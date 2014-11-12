CREATE PROCEDURE pr_cancela_pedido_venda
---------------------------------------------------------------------------------
--pr_Cancela_pedido_venda
---------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                      2004
--------------------------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server 2000
-- Autor(es)            : Sandro Campos
-- Banco de Dados       : EGISSQL
-- Objetivo             : Cancelamento de Pedido
-- Data                 : 27/04/2002	
-- Atualizado           : 08.01.2003 --Correção para marcar em todos os itens do pedido de venda como cancelados
--                        @ic_ativar  
--                        @ic_parametro : 1-> Pedido
--	                  2-> item
--                        @cd_pedido_venda 
--                        @cd_item_pedido_venda
--                        @ds_cancelamento_pedido
--                        @cd_status_pedido
--                        @cd_usuario    : Código do Usuário
-- Atualização          : 25.02.2003 - Revisão Carlos
--                      : 18/03/2003 - Inclusão para cálculo do Pedido de Venda, 
--                                     caso cancelar o item do pedido, recalcular o valor do pedido sem os itens cancelados.
--                      : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 27/01/2005 - Verificação para incluir a Liberação da Proposta Comercial - Carlos
--                      : 08/02/2005 - Verificação se Existe Movimento de Caixa
--                      : 05.06.2005 - Verificação - Carlos Fernandes
--                      : 20.06.2005 - Status da Proposta Comercial - Carlos Fernandes
--			                : 08/07/2005 - Atribui o motivo do cancelamento aos itens do pedido - Ricardo Vano
--                      : 18.01.2006 - Ao reativar um PV caso esse possua uma proposta que está em aberta realiza o vinculo novamente como PV - Fabio 
--                      : 14.09.2007 - Programação de Entrega - Carlos Fernandes
--                      : 27.10.2007 - Cancelamento da Remessa da Programação de Entrega - Carlos Fernandes
------------------------------------------------------------------------------------------------------------- 
@ic_ativar              char(1),
@cd_pedido_venda        int,
@cd_item_pedido_venda   int,
@dt_cancelamento_pedido datetime,
@ds_cancelamento_pedido varchar (60),
@cd_status_pedido       int,
@ic_libera_proposta     char(1) = 'N'

as
  --Variáveis para cálculo do pedido de Venda

  Declare @vl_total_pedido   numeric(18,2),
          @vl_total_ipi      numeric(18,2),
          @qt_peso_bruto     float,
      	  @qt_item_pedido    int,
      	  @qt_item_cancelado int,
      	  @qt_item_faturado  int,
          @cd_motivo_perda   int,
	  @ic_perda_cancelamento char(1),
          @cd_consulta       int,
          @cd_item_consulta  int

--Define se será realizado o cancelamento do item conforme parâmetro comercial
Select
	@cd_motivo_perda       = IsNull(cd_motivo_perda_cancel_pv,1),
	@ic_perda_cancelamento = IsNull(ic_perda_cancelamento,'N')
From
	Parametro_Comercial
where
	cd_empresa = dbo.fn_empresa()


--Verifica o item do Pedido

if (@cd_item_pedido_venda = 0) 
begin
    if not (@ic_ativar = 'S') 
    begin
       	--Cancela o pedido de venda, e já altera seu status
        UPDATE pedido_venda
        SET ds_cancelamento_pedido = @ds_cancelamento_pedido,
            dt_cancelamento_pedido = @dt_cancelamento_pedido,
            ds_ativacao_pedido     = '',
            dt_ativacao_pedido     = null,
            cd_status_pedido       = @cd_status_pedido
        where  
      	    cd_pedido_venda = @cd_pedido_venda

        --Atribui o motivo do cancelamento aos itens do pedido. 08/07/2005 - Ricardo Vano
        UPDATE pedido_venda_item 
        SET nm_mot_canc_item_pedido = @ds_cancelamento_pedido,
            dt_cancelamento_item    = @dt_cancelamento_pedido,
            nm_mot_ativ_item_pedido = '',
            dt_ativacao_item        = null
        where 
            cd_pedido_venda = @cd_pedido_venda

        update programacao_entrega
        set
           cd_pedido_venda      = null,
           cd_item_pedido_venda = null
        where 
           cd_pedido_venda     = @cd_pedido_venda

        delete from programacao_entrega_remessa 
        where
           cd_pedido_venda = @cd_pedido_venda


        --select * from programacao_entrega_remessa


    end
    else begin
        --Ativa o pedido de venda, e já altera seu status
        update pedido_venda 
        SET ds_ativacao_pedido     = @ds_cancelamento_pedido,
            dt_ativacao_pedido     = @dt_cancelamento_pedido,
            ds_cancelamento_pedido = '',
            dt_cancelamento_pedido = null,
            cd_status_pedido       = @cd_status_pedido
        where 
            cd_pedido_venda = @cd_pedido_venda

    end          
end
--Caso tenha sido selecionado um item especificamente
else
begin
  --Verifica se o item não já encontra-se vinculado a um pedido novamente
  if ( ( @ic_perda_cancelamento = 'S' ) and ( @ic_ativar = 'S') )
  begin
    --Define se o item da consulta está definido
    Select @cd_consulta      = IsNull(cd_consulta,0),
           @cd_item_consulta = IsNull(cd_item_consulta,0)
    from
      Pedido_Venda_Item with (nolock)
    where
      cd_pedido_venda          = @cd_pedido_venda 
      and cd_item_pedido_venda = @cd_item_pedido_venda
    
    if not ( ( ( @cd_consulta <> 0 ) and ( @cd_item_consulta <> 0) ) and 
             ( exists(Select 'x' from Pedido_Venda_Item 
                where cd_consulta = @cd_consulta and cd_item_consulta = @cd_item_consulta and 
                      cd_pedido_venda <> @cd_pedido_venda and 
                      dt_cancelamento_item is null )
             )
            )
    begin
      update
        Consulta
      set
        ic_fechada_consulta = 'S',
        cd_status_proposta  = 2 --Fechada
      from
        consulta c, consulta_itens ci
      where  
        c.cd_consulta       = ci.cd_consulta and
        ci.cd_consulta      = @cd_consulta and
        ci.cd_item_consulta = @cd_item_consulta

        update 
          consulta_itens
        set
          dt_fechamento_consulta = @dt_cancelamento_pedido,
      	  dt_perda_consulta_itens = null,
          ic_sel_fechamento      = 'S',
          cd_pedido_venda        = @cd_pedido_venda,
          cd_item_pedido_venda   = @cd_item_pedido_venda
        where
          cd_consulta      = @cd_consulta and
          cd_item_consulta = @cd_item_consulta
    end      
  end
end


if not (@ic_ativar = 'S') and (@cd_item_pedido_venda <> 0)
begin

  --Deixa o item com status de cancelado

  UPDATE pedido_venda_item 
  SET nm_mot_canc_item_pedido  = @ds_cancelamento_pedido,
      dt_cancelamento_item     = @dt_cancelamento_pedido,
      nm_mot_ativ_item_pedido  = '',
      dt_ativacao_item         = null,
      qt_saldo_pedido_venda    = 0, --Saldo
      qt_cancelado_item_pedido = qt_saldo_pedido_venda,  --Qtd. Cancelada
      qt_ativado_pedido_venda  = 0
  where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda 

  update 
     programacao_entrega
  set
     cd_pedido_venda      = null,
     cd_item_pedido_venda = null  
  where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda 


  delete from programacao_entrega_remessa
  where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda 
  

  --Libera o Movimento de Caixa Caso Exista

--   if exists ( select top 1 cd_pedido_venda from Movimento_Caixa_Item where cd_pedido_venda = @cd_pedido_venda )
--   begin
-- 
--     update
--       Movimento_Caixa_Item
--     set
--       cd_pedido_venda      = 0,
--       cd_item_pedido_venda = 0
--     where
--       cd_pedido_venda      = @cd_pedido_venda and
--       cd_item_pedido_venda = @cd_item_pedido_venda 
--    
--   end

end 

else If (@ic_ativar = 'S') 
begin

    --Atualiza o status do Pedido, pois o pedido fica em aberto tendo 
    --  somente um item em aberto e os demais podem estar cancelado
    --  18/03/2003 - Igor Gama

    update pedido_venda 
    SET ds_ativacao_pedido     = @ds_cancelamento_pedido,
        dt_ativacao_pedido     = @dt_cancelamento_pedido,
        ds_cancelamento_pedido = '',
        dt_cancelamento_pedido = null,
        cd_status_pedido       = @cd_status_pedido
    where 
        cd_pedido_venda = @cd_pedido_venda

    UPDATE pedido_venda_item 
    SET nm_mot_ativ_item_pedido  = @ds_cancelamento_pedido,
        dt_ativacao_item         = @dt_cancelamento_pedido,
        nm_mot_canc_item_pedido  = '',
        dt_cancelamento_item     = null,
        qt_saldo_pedido_venda    = qt_cancelado_item_pedido,
        qt_ativado_pedido_venda  = qt_cancelado_item_pedido,
        qt_cancelado_item_pedido = 0
    where  cd_pedido_venda    = @cd_pedido_venda and
        (cd_item_pedido_venda = @cd_item_pedido_venda)


    
    --Programacao de Entrega
 
    --Precisa ser Analisado como Fazer

    --Remessa da Programacao da Entrega

    --Precisa ser Analisado como Fazer

    -- Movimento de Caixa

--     declare @cd_movimento_caixa int
-- 
--     set @cd_movimento_caixa = 0
-- 
--     select @cd_movimento_caixa = cd_movimento_caixa
--     from
--       pedido_venda_item
--     where
--       cd_pedido_venda      = @cd_pedido_venda and
--       cd_item_pedido_venda = @cd_item_pedido_venda
--     
--     if isnull(@cd_movimento_caixa,0)>0 
--     begin
-- 
--       update
--         Movimento_Caixa_Item
--       set
--         cd_pedido_venda      = @cd_pedido_venda,
--         cd_item_pedido_venda = @cd_item_pedido_venda
--       where
--         cd_movimento_caixa   = @cd_movimento_caixa
--  
--     end
-- 
end

  --Cálculo do valor total do Pedido de venda sem os itens cancelados
	select
		@vl_total_pedido = sum(round(cast(vl_unitario_item_pedido as numeric(18,2)),2,1) * qt_item_pedido_venda),
		@vl_total_ipi    = sum((pc_ipi * round(cast(vl_unitario_item_pedido as numeric(18,2)),2,1) / 100) * qt_item_pedido_venda), 
		@qt_peso_bruto   = IsNull(sum(qt_bruto_item_pedido),0)
	from Pedido_Venda_Item
	where cd_pedido_venda = @cd_pedido_venda
        and dt_cancelamento_item is null

  --Atualizar o Valor Total do Pedido ded Venda
        UPDATE pedido_venda
        SET vl_total_pedido_venda  = @vl_total_pedido,
            qt_bruto_pedido_venda  = @qt_peso_bruto,
            vl_total_ipi           = @vl_total_ipi,
            vl_total_pedido_ipi    = @vl_total_ipi + @vl_total_pedido
        where  
      	    cd_pedido_venda = @cd_pedido_venda

---------------------------------------------------------------------------------------------------------- 
--Liberação da Proposta Comercial
---------------------------------------------------------------------------------------------------------- 
if ( @ic_libera_proposta='S' ) and ( not (@ic_ativar = 'S') ) and (@cd_item_pedido_venda <> 0)
begin

  --Acerta o Flag da Consulta

  update
    Consulta
  set
    ic_fechada_consulta = 'N',
    cd_status_proposta  = 1 --Aberta 
  from
    consulta c, consulta_itens ci
  where  
    c.cd_consulta           = ci.cd_consulta and
    ci.cd_pedido_venda      = @cd_pedido_venda and
    ci.cd_item_pedido_venda = @cd_item_pedido_venda

  --Acerta a tabela de consulta_itens

  update 
    consulta_itens
  set
    dt_fechamento_consulta = null,
    ic_sel_fechamento      = null,
    cd_pedido_venda        = 0,
    cd_item_pedido_venda   = 0
  where
    cd_pedido_venda      = @cd_pedido_venda and
    cd_item_pedido_venda = @cd_item_pedido_venda

end
else if ( ( @ic_perda_cancelamento = 'S' ) and ( @ic_libera_proposta='N' ) and ( not (@ic_ativar = 'S') ) 
  		  and ( @cd_item_pedido_venda <> 0 ) )
begin

  --Realiza o cancelamento do item, o qual poderá ser futuramente editado, caso o usuário queria
  --Fabio 23.11.2005
  Insert into Consulta_Item_Perda 
  (	
    cd_consulta,
	cd_item_consulta,
	dt_perda_consulta,
	ds_perda_consulta,
	cd_usuario,
	dt_usuario,
	cd_motivo_perda,
	dt_lancamento_perda
  )
  Select
	cd_consulta,
	cd_item_consulta,
	@dt_cancelamento_pedido,
	'Perda Automática: Cancelamento do PV.' + cast(@cd_pedido_venda as varchar) + ' devido: ' + @ds_cancelamento_pedido,
	cd_usuario,
	dt_usuario,
	@cd_motivo_perda,
	@dt_cancelamento_pedido
  From
	Consulta_Itens
  where
    cd_pedido_venda      = @cd_pedido_venda and
    cd_item_pedido_venda = @cd_item_pedido_venda


  update
    Consulta
  set
    ic_fechada_consulta = 'N',
    cd_status_proposta  = 3 --Perdida
  from
    consulta c, consulta_itens ci
  where  
    c.cd_consulta           = ci.cd_consulta and
    ci.cd_pedido_venda      = @cd_pedido_venda and
    ci.cd_item_pedido_venda = @cd_item_pedido_venda

  --Libera os itens
  update 
    consulta_itens
  set
    dt_fechamento_consulta = null,
	dt_perda_consulta_itens = @dt_cancelamento_pedido,
    ic_sel_fechamento      = null,
    cd_pedido_venda        = 0,
    cd_item_pedido_venda   = 0
  where
    cd_pedido_venda      = @cd_pedido_venda and
    cd_item_pedido_venda = @cd_item_pedido_venda
end

