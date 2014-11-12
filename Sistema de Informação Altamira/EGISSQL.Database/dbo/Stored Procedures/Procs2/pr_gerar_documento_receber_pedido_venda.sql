
CREATE PROCEDURE pr_gerar_documento_receber_pedido_venda

@ic_parametro 			int,
@cd_pedido_venda            	int,
@dt_inicial			datetime,
@dt_final			datetime,
@cd_usuario			int

as

  declare @cd_documento_receber      int
  declare @cd_parcela_ped_venda     int
  declare @vl_parcela_ped_venda     float
  declare @dt_vcto_parcela_ped_venda     datetime
  declare @dt_pedido_venda	     datetime
  declare @cd_cliente		     int
  declare @cd_vendedor 		     int
  declare @cd_ident_parc_ped_venda  varchar(25)

  declare @Tabela		     varchar(50)
  declare @cd_plano_financeiro       int

  declare @cd_portador               int
  declare @cd_tipo_documento         int
  declare @cd_tipo_cobranca          int


  -- variáveis usadas somente no cancelamento e devolução
  declare @nm_mot_cancel_pedido_venda  varchar(50)
  declare @dt_cancel_pedido_venda      datetime

  -- campos default p/ documentos gerados automaticamente
  select
    @cd_portador       = cd_portador,
    @cd_tipo_documento = cd_tipo_documento,
    @cd_tipo_cobranca  = cd_tipo_cobranca
  from
    Parametro_Financeiro
  where
    cd_empresa = dbo.fn_empresa()
  

-----------------------------------------------------------------------------------------
if @ic_parametro = 1   -- Geração de Documentos à Receber Automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- Nesta geração é preciso verificar se é habilitado ao módulo a geração automática
    if ((select ic_auto_scr_empresa from parametro_comercial where cd_empresa = dbo.fn_empresa()) = 'N')
      begin
        print('Geração Automática não Habilitada p/ Módulo Comercial!')
        return
      end  

    -- Na geração automática excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualquer motivo tiveram de ser 
    -- geradas novamente
    delete
      Documento_Receber
    where
      cd_pedido_venda = @cd_pedido_venda and
      ic_tipo_lancamento = 'A' and
      vl_saldo_documento <> 0
    
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    --print('passou')
    
    -- Tabela temporária c/ todas as parcelas do pedido de venda
    select
      p.cd_parcela_ped_venda,
      cast(str(p.vl_parcela_ped_venda,25,2) as decimal(25,2)) as 'vl_parcela_ped_venda',
      p.dt_vcto_parcela_ped_venda,
      n.cd_cliente,
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.dt_pedido_venda,
      p.cd_ident_parc_ped_venda,
      f.cd_plano_financeiro, 
      n.cd_identificacao_empresa
    into
      #pedido_venda_Parcela
    from
      pedido_venda_Parcela p left outer join
      pedido_venda n  on  p.cd_pedido_venda = n.cd_pedido_venda left outer join
      Parametro_Financeiro f  on f.cd_empresa = dbo.fn_empresa()
    where
--      p.ic_scr_parcela_pedido_venda <> 'S' and
      p.cd_pedido_venda = @cd_pedido_venda and
      n.cd_pedido_venda is not null and
      n.dt_cancelamento_pedido is null
    order by
      p.cd_pedido_venda,
      p.cd_parcela_ped_venda

    while exists(select cd_pedido_venda from #pedido_venda_Parcela)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_pedido_venda            = cd_pedido_venda,
          @cd_parcela_ped_venda       = cd_parcela_ped_venda,
          @vl_parcela_ped_venda       = vl_parcela_ped_venda,
          @dt_vcto_parcela_ped_venda  = dt_vcto_parcela_ped_venda,
          @dt_pedido_venda            = dt_pedido_venda,
          @cd_cliente                 = cd_cliente,
          @cd_plano_financeiro        = cd_plano_financeiro,
          @cd_ident_parc_ped_venda    = dbo.fn_serie_documento_receber(cast(@cd_pedido_venda as varchar(25)), @dt_vcto_parcela_ped_venda, 'P')-- cd_ident_parc_ped_venda
        from
          #pedido_venda_Parcela
        order by   
          cd_pedido_venda,
          cd_parcela_ped_venda

        -- campo chave utilizando a tabela de códigos

        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

	while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
	begin
	     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
	     -- limpesa da tabela de código
	     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
	end


        -- montagem da identificação do documento

        --set @cd_identificacao_conv = dbo.fn_serie_documento_receber(cast(@cd_pedido_venda as varchar(25)), @dt_vcto_parcela_ped_venda)
       
        -- geração do documento à receber
        print 'Vou Passar Parametro 2'  
        exec pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento_receber, 
           @cd_ident_parc_ped_venda,
           @dt_pedido_venda, 
           @dt_vcto_parcela_ped_venda, 
           @dt_vcto_parcela_ped_venda, 
           @vl_parcela_ped_venda,
           @vl_parcela_ped_venda, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática p/ Pedido Venda.', 
           'N', 
           null,
           null, 
           null, 
           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_cliente, 
           @cd_tipo_documento, 
           @cd_pedido_venda, 
           @cd_pedido_venda, 
           @cd_vendedor,
           null, 
           0, 
           'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario, 
           '',
           0

        
        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        -- Atualização da Tabela de Parcelas
        --update 
        --  pedido_venda_Parcela
        --set
        --  ic_scr_parcela_pedido_venda = 'S',
        --  cd_ident_parc_ped_venda = @cd_identificacao_conv
        --where
        --  cd_pedido_venda = @cd_pedido_venda and
        --  cd_parcela_ped_venda = @cd_parcela_ped_venda
      
        -- exclusão do registro usado
        delete 
          #pedido_venda_Parcela
        where
          cd_pedido_venda         = @cd_pedido_venda and
          cd_parcela_ped_venda = @cd_parcela_ped_venda

      end

     drop table #pedido_venda_Parcela

   end
/*
-----------------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Gera as Duplicatas à Receber Manualmente
-----------------------------------------------------------------------------------------
  begin

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    -- Tabela temporária c/ todas as parcelas do período
    select
      p.cd_pedido_venda,
      p.cd_parcela_ped_venda,
      cast(str(p.vl_parcela_ped_venda,25,2) as decimal(25,2)) as 'vl_parcela_ped_venda',
      p.dt_vcto_parcela_ped_venda,
      n.cd_cliente,
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.dt_pedido_venda,
      p.cd_ident_parc_ped_venda,
      case when 
        o.cd_plano_financeiro is not null 
      then 
        o.cd_plano_financeiro 
      else 
        f.cd_plano_financeiro 
      end as cd_plano_financeiro
    into
      #pedido_venda_Parcela_Data
    from
      pedido_venda_Parcela p
    left outer join
      pedido_venda n
    on
      p.cd_pedido_venda = n.cd_pedido_venda
    left outer join
      Operacao_Fiscal o
    on
      n.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Parametro_Financeiro f
    on
      f.cd_empresa = dbo.fn_empresa()
    where
      p.ic_scr_parcela_pedido_venda <> 'S' and
      n.dt_pedido_venda between @dt_inicial and @dt_final and
      n.cd_pedido_venda is not null and
      n.dt_cancel_pedido_venda is null
    order by
      p.cd_pedido_venda,
      p.cd_parcela_ped_venda

    while exists(select top 1 cd_pedido_venda from #pedido_venda_Parcela_Data)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_pedido_venda            = cd_pedido_venda,
          @cd_parcela_ped_venda    = cd_parcela_ped_venda,
          @vl_parcela_ped_venda    = vl_parcela_ped_venda,
          @dt_vcto_parcela_ped_venda    = dt_vcto_parcela_ped_venda,
          @dt_pedido_venda            = dt_pedido_venda,
          @cd_cliente               = cd_cliente,
          @cd_plano_financeiro	    = cd_plano_financeiro,
          @cd_ident_parc_ped_venda = cd_ident_parc_ped_venda
        from
          #pedido_venda_Parcela_Data
        order by   
          cd_pedido_venda,
          cd_parcela_ped_venda

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

        -- montagem da identificação
        --set @cd_identificacao_conv = dbo.fn_serie_documento_receber(cast(@cd_pedido_venda as varchar(25)), @dt_vcto_parcela_ped_venda)

        -- geração do documento à receber
        print 'Vou Passar Parametro aqui'  
        exec dbo.pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento_receber, 
           @cd_ident_parc_ped_venda,
           @dt_pedido_venda, 
           @dt_vcto_parcela_ped_venda, 
           @dt_vcto_parcela_ped_venda, 
           @vl_parcela_ped_venda,
           @vl_parcela_ped_venda, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática p/ Faturamento.', 
           'N', 
           null,
           null, 
           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_cliente, 
           @cd_tipo_documento, 
           @cd_pedido_venda, 
           @cd_pedido_venda, 
           @cd_vendedor,
           null, 
           0, 
           'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario, 
           null

        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        -- Atualização da Tabela de Parcelas
        --update 
        --  pedido_venda_Parcela
        --set
        --  ic_scr_parcela_pedido_venda = 'S'
        --where
        --  cd_pedido_venda = @cd_pedido_venda and
        --  cd_parcela_ped_venda = @cd_parcela_ped_venda

        -- exclusão do registro usado
        delete 
          #pedido_venda_Parcela_Data
        where
          @cd_pedido_venda = cd_pedido_venda and
          @cd_parcela_ped_venda = cd_parcela_ped_venda

      end

     drop table #pedido_venda_Parcela_Data

   end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Cancelamento dos documentos gerados automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- tabela temporária com as informações p/ o cancelamento
    select
      d.cd_documento_receber,
      d.cd_cliente,
      n.cd_pedido_venda,
      n.nm_mot_cancel_pedido_venda,
      n.dt_cancel_pedido_venda
    into
      #pedido_venda_Parcela_Cancelada
    from
      Documento_Receber d
    left outer join
      pedido_venda n
    on
      d.cd_pedido_venda = n.cd_pedido_venda
    where
      n.cd_status_nota = 7 and
      n.cd_pedido_venda = @cd_pedido_venda
   
    while exists(select top 1 cd_pedido_venda from #pedido_venda_Parcela_Cancelada)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_pedido_venda            = cd_pedido_venda,
          @nm_mot_cancel_pedido_venda = nm_mot_cancel_pedido_venda,
          @dt_cancel_pedido_venda     = dt_cancel_pedido_venda,
          @cd_documento_receber     = cd_documento_receber
        from
          #pedido_venda_Parcela_Cancelada

        -- cancelamento do documento automático
        update 

          Documento_Receber 
        set
          cd_cliente = @cd_cliente, 
          vl_saldo_documento = 0.00,
          dt_cancelamento_documento = @dt_cancel_pedido_venda,
          nm_cancelamento_documento = @nm_mot_cancel_pedido_venda,
          cd_tipo_liquidacao = 2,  -- Cancelamento
          cd_usuario = @cd_usuario,
          dt_usuario = getDate()
        where
          cd_documento_receber = @cd_documento_receber          

        -- exclusão do registro usado
        delete 
          #pedido_venda_Parcela_Cancelada
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #pedido_venda_Parcela_Cancelada
                                       
  end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Devolução dos documentos gerados automaticamente
-----------------------------------------------------------------------------------------
  begin

    -- tabela temporária com as informações p/ o cancelamento
    select
      d.cd_documento_receber,
      d.cd_cliente,
      n.cd_pedido_venda,
      n.nm_mot_cancel_pedido_venda,
      n.dt_cancel_pedido_venda
    into
      #pedido_venda_Parcela_Devolvida
    from
      Documento_Receber d
    left outer join
      pedido_venda n
    on
      d.cd_pedido_venda = n.cd_pedido_venda
    where
      n.cd_status_nota = 4 and
      n.cd_pedido_venda = @cd_pedido_venda
   
    while exists(select top 1 cd_pedido_venda from #pedido_venda_Parcela_Devolvida)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_cliente               = cd_cliente,
          @cd_pedido_venda            = cd_pedido_venda,
          @nm_mot_cancel_pedido_venda = nm_mot_cancel_pedido_venda,
          @dt_cancel_pedido_venda     = dt_cancel_pedido_venda,
          @cd_documento_receber     = cd_documento_receber
        from
          #pedido_venda_Parcela_Devolvida

        -- devolução do documento automático
        update 
          Documento_Receber 
        set
          cd_cliente = @cd_cliente, 
          vl_saldo_documento = 0.00,
          dt_cancelamento_documento = @dt_cancel_pedido_venda,
          nm_cancelamento_documento = @nm_mot_cancel_pedido_venda,
          cd_tipo_liquidacao = 1,  -- Devolução
          cd_usuario = @cd_usuario,
          dt_usuario = getDate()
        where
          cd_documento_receber = @cd_documento_receber          

        -- exclusão do registro usado
        delete 
          #pedido_venda_Parcela_Devolvida
        where
          @cd_documento_receber = cd_documento_receber

      end

     drop table #pedido_venda_Parcela_Devolvida
                                       
  end
-----------------------------------------------------------------------------------------
else if @ic_parametro = 5 -- Reativação de Duplicata Cancelada/Devolvida Indevidamente
-----------------------------------------------------------------------------------------
  begin

    -- Na reativação excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualque motivo tiveram de ser 
    -- geradas novamente
    delete
      Documento_Receber
    where
      cd_pedido_venda = @cd_pedido_venda and
      ic_tipo_lancamento = 'A' and
      dt_cancelamento_documento is not null

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    -- Tabela temporária c/ todas as parcelas do período
    select
      p.cd_pedido_venda,
      p.cd_parcela_ped_venda,
      cast(str(p.vl_parcela_ped_venda,25,2) as decimal(25,2)) as 'vl_parcela_ped_venda',
      p.dt_vcto_parcela_ped_venda,
      n.cd_cliente,
      n.cd_pedido_venda,
      n.cd_vendedor,
      n.dt_pedido_venda,
      p.cd_ident_parc_ped_venda,
      case when 
        o.cd_plano_financeiro is not null 
      then 
        o.cd_plano_financeiro 
      else 
        f.cd_plano_financeiro 
      end as cd_plano_financeiro
    into
      #pedido_venda_Parcela_Reativacao
    from
      pedido_venda_Parcela p
    left outer join
      pedido_venda n
    on
      p.cd_pedido_venda = n.cd_pedido_venda
    left outer join
      Operacao_Fiscal o
    on
      n.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Parametro_Financeiro f
    on
      f.cd_empresa = dbo.fn_empresa()
    where
      p.cd_pedido_venda = @cd_pedido_venda and
      n.cd_pedido_venda is not null and
      n.dt_cancel_pedido_venda is null
    order by
      p.cd_pedido_venda,
      p.cd_parcela_ped_venda

    while exists(select top 1 cd_pedido_venda from #pedido_venda_Parcela_Reativacao)
      begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_pedido_venda            = cd_pedido_venda,
          @cd_parcela_ped_venda    = cd_parcela_ped_venda,
          @vl_parcela_ped_venda    = vl_parcela_ped_venda,
          @dt_vcto_parcela_ped_venda    = dt_vcto_parcela_ped_venda,
          @dt_pedido_venda            = dt_pedido_venda,
          @cd_cliente               = cd_cliente,
          @cd_plano_financeiro	    = cd_plano_financeiro,
          @cd_ident_parc_ped_venda = cd_ident_parc_ped_venda
        from
          #pedido_venda_Parcela_Reativacao
        order by   
          cd_pedido_venda,
          cd_parcela_ped_venda

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

        -- montagem da identificação
        --set @cd_identificacao_conv = dbo.fn_serie_documento_receber(cast(@cd_pedido_venda as varchar(25)), @dt_vcto_parcela_ped_venda)

        -- geração do documento à receber
        exec dbo.pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento_receber, 
           @cd_ident_parc_ped_venda,
           @dt_pedido_venda, 
           @dt_vcto_parcela_ped_venda, 
           @dt_vcto_parcela_ped_venda, 
           @vl_parcela_ped_venda,
           @vl_parcela_ped_venda, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática p/ Faturamento. - Reativação', 
           'N', 
           null,
           null, 
           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_cliente, 
           @cd_tipo_documento, 
           @cd_pedido_venda, 
           @cd_pedido_venda, 
           @cd_vendedor,
           null, 
           0, 
           'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario, 
           null

        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

        -- Atualização da Tabela de Parcelas
        --update 
        --  pedido_venda_Parcela
        --set
        --  ic_scr_parcela_pedido_venda = 'S'
        --where
        -- cd_pedido_venda = @cd_pedido_venda and
        --  cd_parcela_ped_venda = @cd_parcela_ped_venda

        -- exclusão do registro usado
        delete 
          #pedido_venda_Parcela_Reativacao
        where
          @cd_pedido_venda = cd_pedido_venda and
          @cd_parcela_ped_venda = cd_parcela_ped_venda

      end

     drop table #pedido_venda_Parcela_Reativacao

   end
else
  return
*/
