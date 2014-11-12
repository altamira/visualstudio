
create procedure pr_bordero_pagar

@ic_parametro           int,
@cd_documento_pagar     int,
@cd_bordero             int,
@dt_emissao_bordero     datetime,
@dt_vencimento_bordero  datetime,
@dt_debito_bordero      datetime,
@ic_contabil_bordero    char(1),
@ic_baixado_bordero     char(1),
@dt_liquidacao_bordero  datetime,
@dt_inicial_bordero     datetime,
@dt_final_bordero       datetime,
@nm_obs_documento_pagar varchar(50),  
@cd_usuario             int,
@ic_tipo_bordero        char(1),
@ic_impresso		char(1),
@ic_deposito_conta      char(1),
@cd_empresa		int,
@ic_tipo_deposito       char(1) = 'N'

as

begin transaction

  declare @vl_total_bordero numeric(25,2)

  set @vl_total_bordero = 0.00


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- geração de borderô
-------------------------------------------------------------------------------
  begin
    
    declare @cd_conta_banco int
    declare @vl_saldo_documento_pagar numeric(25,2)
    declare @cd_tipo_documento_pagamento int
    declare @cd_identifica_documento varchar(50)

    declare @vl_juros_documento      float
    declare @vl_abatimento_documento float
    declare @vl_desconto_documento   float

    set @vl_saldo_documento_pagar    = 0.00
    set @cd_tipo_documento_pagamento = 0
    set @cd_identifica_documento     = ''

    set @vl_juros_documento      = 0
    set @vl_abatimento_documento = 0
    set @vl_desconto_documento   = 0
    set @cd_conta_banco = 0
    
    -- verificacao de código 
    if (isnull(@cd_bordero, 0) <> 0)
      begin
        if exists(select 
                    cd_bordero
                  from
                    bordero
                  where
                    cd_bordero = @cd_bordero and
                    ic_baixado_bordero = 'S')
          begin
            raiserror('Borderô já Liquidado! Operação Abortada!',16,1)
            goto TrataErro
          end 
      end
    else
      -- criação de novo código
      begin
        select
          @cd_bordero = max(isnull(cd_bordero,0))+1
        from
          bordero 
      end
        
    -- fazer todas as validações necessárias ( a definir )

    -- valor do pagamento
    select 
      @vl_saldo_documento_pagar = cast(isnull(vl_saldo_documento_pagar,0) as decimal(25,2))
    from
      documento_pagar
    where
      cd_documento_pagar = @cd_documento_pagar

    --print(cast(@vl_saldo_documento_pagar as varchar(25)))
  
    set @cd_tipo_documento_pagamento = 1

    -- identificacao do pagamento
    set @cd_identifica_documento = cast(@cd_bordero as varchar(50))

    -- localização dos valores de juros, desconto e abatimento no documento_pagar
    select 
      @vl_juros_documento      = vl_juros_documento,
      @vl_abatimento_documento = vl_abatimento_documento,
      @vl_desconto_documento   = vl_desconto_documento
    from
      documento_pagar
    where
      cd_documento_pagar = @cd_documento_pagar

    --Atualiza o tipo de depósito
    if @ic_tipo_deposito<>'N' 
    begin

    update
      documento_pagar
    set
      ic_tipo_deposito = @ic_tipo_deposito
    from
      documento_pagar
    where
      cd_documento_pagar = @cd_documento_pagar
  
    end

    -- se existir juros, abatimento ou desconto acertar o saldo de documento_pagar

    if ((@vl_juros_documento <> 0) or
      (@vl_abatimento_documento <> 0) or
      (@vl_desconto_documento <> 0))
      begin
        update
          documento_pagar
        set
          vl_juros_documento       = 0.00,
          vl_abatimento_documento  = 0.00,
          vl_desconto_documento    = 0.00,
          vl_saldo_documento_pagar = isnull(vl_documento_pagar,0) - isnull((select 
                                                                              sum(isnull(vl_pagamento_documento,0) +
                                                                                  isnull(vl_juros_documento_pagar,0) -
                                                                                  isnull(vl_desconto_documento,0) -
                                                                                  isnull(vl_abatimento_documento,0))
                                                                            from
                                                                              documento_pagar_pagamento
                                                                            where
                                                                              cd_documento_pagar = @cd_documento_pagar),0)
        where
          cd_documento_pagar = @cd_documento_pagar

        select
          @vl_saldo_documento_pagar = isnull(vl_documento_pagar,0) - isnull((select 
                                                                               sum(isnull(vl_pagamento_documento,0) +
                                                                                   isnull(vl_juros_documento_pagar,0) -
                                                                                   isnull(vl_desconto_documento,0) -
                                                                                   isnull(vl_abatimento_documento,0))
                                                                             from
                                                                               documento_pagar_pagamento
                                                                             where
                                                                               cd_documento_pagar = @cd_documento_pagar),0)
        from
          documento_pagar
        where
          cd_documento_pagar = @cd_documento_pagar

      end
               
    -- criação do registro de pagamento do documento
    exec pr_documento_pagar 1,                                -- parâmetro de inserção
                            'S',
                            @cd_documento_pagar, 
                            0,                                -- item do pagamento (gerado automaticamente)
                            null,                             -- data do pagamento
                            @vl_saldo_documento_pagar,        -- valor do pagamento
                            @cd_identifica_documento,
                            @vl_juros_documento,              -- valor de juros
                            @vl_desconto_documento,           -- valor de desconto
                            @vl_abatimento_documento,         -- valor de abatimento
                            '',                               -- recibo
                            @cd_tipo_documento_pagamento,
                            @nm_obs_documento_pagar,
                            @ic_deposito_conta,
                            @cd_usuario,
			    @cd_conta_banco

    if @@ERROR <> 0    
      goto TrataErro

    --???
    if exists(select * from  
                bordero 
              where 
                cd_bordero = @cd_bordero)
      begin
        -- atualização do registro de borderô

        update 
          bordero
        set
          dt_emissao_bordero = @dt_emissao_bordero,
          dt_vencimento_bordero = @dt_vencimento_bordero,
          dt_debito_bordero = @dt_debito_bordero,
          qt_documento_bordero = (select 
                                   (isnull(qt_documento_bordero,0)+1)
                                  from 
                                    bordero 
                                  where 
                                    cd_bordero = @cd_bordero),
          vl_total_documento_border = (select 
                                  (isnull(vl_total_documento_border, 0) + 
                                  @vl_saldo_documento_pagar) 
                                from 
                                  bordero 
                                where 
                                  cd_bordero = @cd_bordero),
          ic_contabil_bordero = @ic_contabil_bordero,
          ic_baixado_bordero = 'N',
          dt_inicial_bordero = @dt_inicial_bordero,
          dt_final_bordero = @dt_final_bordero,
          cd_usuario = @cd_usuario,
          dt_usuario = getDate(),
          ic_tipo_bordero = @ic_tipo_bordero
        where
          cd_bordero = @cd_bordero
      end
    else
      begin
        -- criação do registro de borderô
        insert into
           bordero
         values (
           @cd_bordero,
           @dt_emissao_bordero,
           @dt_vencimento_bordero,
           @dt_debito_bordero,
           1,
           @vl_saldo_documento_pagar,
           @ic_contabil_bordero,
           'N',
           null,
           @dt_inicial_bordero,
           @dt_final_bordero,
           @cd_usuario,
           getDate(),
           @ic_tipo_bordero,
           @ic_impresso)
      end
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- listagem dos documentos do borderô
-------------------------------------------------------------------------------
  begin

    declare @vl_liberacao_pedido_compra float

    -- carrega valor teto p/ liberação de pedido p/ gerência
    select 
      @vl_liberacao_pedido_compra = vl_lib_pedido_compra
    from
      EGISADMIN.DBO.Empresa
    where
      cd_empresa = @cd_empresa 
    
    select distinct
      d.dt_vencimento_documento,
      p.cd_identifica_documento,
      c.sg_tipo_conta_pagar,
      case when isnull(b.ic_tipo_bordero, '') <> '' then c.ic_tipo_bordero else b.ic_tipo_bordero
      end as 'ic_tipo_bordero',        
      case when (isnull((select x.cd_empresa_diversa from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
           when (isnull((select x.cd_contrato_pagar from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
           when (isnull((select x.cd_funcionario from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))
           when (isnull((select x.nm_fantasia_fornecedor from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))
      end                             as 'cd_favorecido',               
      case when (isnull((select x.cd_empresa_diversa from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
           when (isnull((select x.cd_contrato_pagar from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
           when (isnull((select x.cd_funcionario from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
           when (isnull((select x.nm_fantasia_fornecedor from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
      end                             as 'nm_favorecido',             
      d.cd_identificacao_document,
      p.nm_obs_documento_pagar,
      d.nm_observacao_documento,
    case when (isnull(d.cd_fornecedor, 0) <> 0) then (select top 1 f.cd_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor)
         when (isnull(d.cd_empresa_diversa, 0) <> 0) then (select top 1 z.cd_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa)
         when (isnull(d.cd_funcionario, 0) <> 0) then (select top 1 k.cd_banco from funcionario k where k.cd_funcionario = d.cd_funcionario)
         when (isnull(d.cd_contrato_pagar, 0) <> 0) then (select top 1 f.cd_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor)
    end as 'cd_banco',               
    case when (isnull(d.cd_fornecedor, 0) <> 0) then cast((select top 1f.cd_agencia_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
         when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.cd_agencia_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
         when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.cd_agencia_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20))
         when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 f.cd_agencia_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar(20))
    end as 'cd_agencia_banco',               
    case when (isnull(d.cd_fornecedor, 0) <> 0) then cast((select top 1 f.cd_conta_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
	 when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.cd_conta_corrente from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
         when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.cd_conta_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
         when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 f.cd_conta_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    end as 'cd_conta_banco',               
      p.vl_juros_documento_pagar +
      p.vl_abatimento_documento -
      p.vl_desconto_documento as 'vl_juros_abatimento',
      p.vl_pagamento_documento +
      p.vl_juros_documento_pagar -
      p.vl_desconto_documento - 
      p.vl_abatimento_documento as 'vl_documento_pagar',
      d.cd_pedido_compra,
      -- Verificação da Aprovação do Pedido de Compra -- ELIAS
      -- 1 - Somente é feito a validação caso existe pedido de compra, nos casos em que não
      -- existe (documentos diversos e etc..) default é liberado
     case when exists ( select top 1 x.cd_pedido_compra
                        from Pedido_Compra x 
                        where x.cd_pedido_compra = d.cd_pedido_compra ) and IsNull(d.cd_pedido_compra,0) <> 0 
          then
            ( SELECT ISNULL(IC_APROV_PEDIDO_COMPRA,'N')
              FROM 
                PEDIDO_COMPRA B 
              WHERE 
                D.CD_PEDIDO_COMPRA = B.CD_PEDIDO_COMPRA )
          else 'S' end
      as 'ic_pedido_compra_aprovado',         
      p.ic_deposito_conta

    into #TabelaDistinta

    from
      bordero b,
      documento_pagar_pagamento p,
      documento_pagar d 
    left outer join
      tipo_conta_pagar c
    on 
      d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar
    where     
      p.cd_documento_pagar = d.cd_documento_pagar and
      p.cd_identifica_documento = cast(@cd_bordero as varchar(50)) and
      p.cd_tipo_pagamento = (select
                               min(cd_tipo_pagamento)
                             from
                               tipo_pagamento_documento
                             where
                               sg_tipo_pagamento like 'BORDER%') and
     b.cd_bordero = @cd_bordero

    select * from #TabelaDistinta
    order by
      dt_vencimento_documento desc,
      sg_tipo_conta_pagar,
      cd_favorecido,
      cd_identificacao_document

    drop table #TabelaDistinta
      
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3   -- Atualização do Borderô.
-------------------------------------------------------------------------------
  begin


    update 
      bordero
    set
      qt_documento_bordero = (select count(*) from documento_pagar_pagamento 
                              where cd_identifica_documento = @cd_bordero and
                                    cd_tipo_pagamento = 1),
      vl_total_documento_border = (select sum(isnull(vl_pagamento_documento,0) +
                                              isnull(vl_juros_documento_pagar,0) -
                                              isnull(vl_desconto_documento,0) -
                                              isnull(vl_abatimento_documento,0))
                                    from documento_pagar_pagamento
                                    where cd_identifica_documento = @cd_bordero and
                                    cd_tipo_pagamento = 1)
    where
      cd_bordero = @cd_bordero

  end
else
  return

  -- atualizando banco de dados    
  TrataErro:
    if @@ERROR = 0
      begin
        commit tran
      end
    else
      begin
        --raiserror(@@ERROR, 16, 1)
        rollback tran
      end

