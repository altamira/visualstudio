
CREATE PROCEDURE pr_atualiza_informacao_comercial
-------------------------------------------------------------------------
--pr_atualiza_informacao_comercial
-------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                  2004
-------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Elias P. Silva
--Banco de Dados       : SapSql
--Objetivo             : Executada via trigger p/ atualizar 
--                       cliente_informacao_credito
--Data                 : 28/02/2002
--Atualizado           : 13/03/2002 - Modificado vl_saldo_documento - Daniel C. Neto
--                     : 01/04/2002 - Migração p/ EGISSQL - Elias
--                     : 24/10/2002 - Acertos no cálculo de última fatura. - Daniel C. Neto.
--                     : 13/11/2002 - Calculo do maior acumulo
--                     : 03/12/2004 - Atualiza o Total de Documentos Pagos - Carlos
--                     : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 13.05.2005 - Verificação - Carlos Fernandes
--                       11/07/2005 - Buscar Valor de Maior Fatura da Nota Fiscal e não
--                                    da Parcela - ELIAS
--                       09/08/2005 - Acerto na Busca da Maior Fatura - ELIAS
--                       21.10.2005 - Acerto no saldo de crédito - Rafael/Carlos
--                       12.11.2006 - Correção para fazer Geral todos os Cliente - Carlos Fernandes
--                       25.11.2006 - Cálculo da Maior Faturamento não zera - Carlos Fernandes
--                       21.12.2006 - Correção da Ultima Fatura do Cliente - Anderson
--                       10.05.2007 - Checagem do tipo de destinário somente para atualizar cliente
--                                    da nota de saída - carlos Fernandes.
--                       25.06.2007 - Verificação da CFOP com valor comercial para Gerar Maior Fatura - Carlos Fernandes
----------------------------------------------------------------------------------------------------
@ic_parametro            int,
@cd_cliente              int,
@vl_documento_receber    float,
@dt_emissao_documento    datetime,
@dt_vencimento_documento datetime,
@qt_cliente_processado   int output,
@cd_cliente_processado   int output,
@cd_usuario              int

as

  -- variáveis da informação comercial

  declare @vl_maior_fatura_cliente    numeric(25,2)
  declare @dt_maior_fatura_cliente    datetime
  declare @vl_ultimo_faturamento      numeric(25,2)
  declare @dt_ultimo_faturamento      datetime
  declare @vl_maior_acumulo           numeric(25,2)
  declare @dt_maior_acumulo           datetime
  declare @vl_saldo_atual_aberto      numeric(25,2)
  declare @qt_titulo_aberto           int
  declare @qt_media_atraso_cliente    int
  declare @qt_maior_atraso            int
  declare @vl_nota_debito             numeric(25,2)
  declare @qt_nota_debito             int
  declare @qt_documento_pago          int
  declare @qt_documento_pago_atraso   int
  declare @qt_documento_pago_protesto int
  declare @vl_total_documento_pago    numeric(25,2)
  declare @vl_limite_credito_cliente  numeric(25,2)
  declare @vl_saldo_credito_cliente   numeric(25,2)
  declare @vl_nota_saida              numeric(25,2)
  declare @vl_saldo_credito           numeric(25,2)
  declare @ic_nota_saida              int

  -- inicialização das variáveis
  set     @vl_maior_fatura_cliente    = 0.00
  set     @dt_maior_fatura_cliente    = null
  set     @vl_ultimo_faturamento      = 0.00
  set     @dt_ultimo_faturamento      = null
  set     @vl_maior_acumulo           = 0.00
  set     @dt_maior_acumulo           = null
  set     @vl_saldo_atual_aberto      = 0.00
  set     @qt_titulo_aberto           = 0
  set     @qt_media_atraso_cliente    = 0
  set     @qt_maior_atraso            = 0
  set     @vl_nota_debito             = 0.00
  set     @qt_nota_debito             = 0
  set     @qt_documento_pago          = 0
  set     @qt_documento_pago_atraso   = 0
  set     @qt_documento_pago_protesto = 0
  set     @vl_total_documento_pago    = 0
  set     @ic_nota_saida              = 0

  --set     @vl_saldo_aberto            = 0.00
  --set     @qt_saldo_aberto            = 0

  set     @vl_limite_credito_cliente  = 0.00
  set     @vl_saldo_credito_cliente   = 0.00
  set     @vl_saldo_credito           = 0.00

  -- carregando as variáveis de informação comercial

  select
    @vl_limite_credito_cliente = IsNull(vl_limite_credito_cliente, 0),
    @vl_saldo_credito_cliente  = IsNull(vl_limite_credito_cliente, 0),
    @vl_maior_fatura_cliente   = IsNull(vl_maior_fatura_cliente   ,0),
    @dt_maior_fatura_cliente   = dt_maior_fatura_cliente,
    @dt_maior_acumulo          = isnull(dt_maior_acumulo, isnull(@dt_emissao_documento,null) )
  from
    Cliente_Informacao_Credito
  where
    cd_cliente = @cd_cliente

  -- 1 - calculando maior fatura
  -- Carregando o valor da Nota Fiscal - Atualizado Fábio César

--  select @vl_maior_fatura_cliente

  Select top 1
      @vl_maior_fatura_cliente = isnull(vl_total,0),
      @dt_maior_fatura_cliente = dt_nota_saida,
      @ic_nota_saida           = 1     
  from 
    nota_saida ns with (nolock)
    inner join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where 
    ns.cd_cliente = @cd_cliente
    and ns.dt_cancel_nota_saida is null and
    ns.cd_tipo_destinatario = 1         and --cliente
    isnull(opf.ic_comercial_operacao,'N') = 'S'
  order by 
    ns.vl_total      desc, 
    ns.cd_nota_saida desc

	--select * from nota_Saida

  --Verifica se Existe Nota de Saída para o Cliente
  --Se Não, Zera a Maior Fatura e Data

  if @ic_nota_saida = 0
  begin
    set @vl_maior_fatura_cliente = 0.00
    set @dt_maior_fatura_cliente = null
  end

  --select @ic_nota_saida,@vl_maior_fatura_cliente,@dt_maior_fatura_cliente
          
  -- 2 - calculando ultima fatura
  -- 21/12/2006 - Corrigindo Ultima Fatura do Cliente - Anderson
      
  set @ic_nota_saida = 0

  Select top 1
    @vl_ultimo_faturamento = isnull(vl_total,0),
    @dt_ultimo_faturamento = dt_nota_saida,
    @ic_nota_saida         = 1     
  from 
    nota_saida ns with (nolock)
    inner join operacao_fiscal op with (nolock) on ns.cd_operacao_fiscal = op.cd_operacao_fiscal and
    ns.cd_tipo_destinatario = 1 --cliente

  where 
    ns.cd_cliente = @cd_cliente
    and ns.dt_cancel_nota_saida is null and
    isnull(op.ic_comercial_operacao,'N') = 'S'

  order by 
    ns.dt_nota_saida desc, 
    ns.cd_nota_saida desc

  --Verifica se Existe Nota de Saída para o Cliente
  --Se Não, Zera o Último Faturamento

  if @ic_nota_saida = 0
  begin
    set @vl_ultimo_faturamento = 0
    set @dt_ultimo_faturamento = null
  end
 
-------------------------------------------------------------------------------
  if @ic_parametro = 1 -- na inclusão de documento_receber
-------------------------------------------------------------------------------
  begin
    
    -- 3 - calculando maior acúmulo
    exec pr_maior_acumulo_cliente 
      @cd_cliente, 
      @vl_maior_acumulo = @vl_maior_acumulo output,     
      @dt_maior_acumulo = @dt_maior_acumulo output
          
    -- 4 - calculando saldo em aberto
    -- set @vl_saldo_atual_aberto = @vl_saldo_aberto + @vl_documento_receber
    -- set @qt_titulo_aberto = @qt_saldo_aberto + 1
    select 
      @vl_saldo_atual_aberto = sum( isnull(vl_saldo_documento,0)),
      @qt_titulo_aberto      = count('x')
    from documento_receber with (nolock)
    where IsNull(vl_saldo_documento,0) > 0 and
          dt_cancelamento_documento is null and
          dt_devolucao_documento    is null and
          cd_cliente = @cd_cliente

    --Caso o cliente tenha um limite de crédito definido, 
    -- tirar o saldo em aberto do saldo do limite do mesmo.
    if @vl_limite_credito_cliente <> 0
    begin
      set @vl_saldo_credito_cliente = @vl_limite_credito_cliente - @vl_saldo_atual_aberto
    end

    -- 5 - calculando as notas de débito em aberto (valor e quantidade)
    select 
      @vl_nota_debito = isnull(sum(vl_nota_debito),0),
      @qt_nota_debito = count(cd_nota_debito)
    from
      Nota_debito with (nolock)
    where
      cd_cliente = @cd_cliente and
      dt_pagamento_nota_debito is null
 
    -- 6 - calculando a quantidade de duplicatas pagas
    select 
      @qt_documento_pago       = count(cd_documento_receber),
      @vl_total_documento_pago = sum( isnull(vl_documento_receber,0) )
    from 
      documento_receber with (nolock)
    where 
      cd_cliente = @cd_cliente and 
      cast(str(vl_saldo_documento,25,2) as decimal(25,2)) = 0 and 
      dt_cancelamento_documento is null

    -- 7 - calculando a quantidade de duplicatas pagas em atraso
    select 
      @qt_documento_pago_atraso = count(p.cd_documento_receber)
    from 
      documento_receber d with (nolock)
      inner join documento_receber_pagamento p with (nolock)
        on d.cd_documento_receber = p.cd_documento_receber
    where 
      d.cd_cliente = @cd_cliente and 
      p.dt_pagamento_documento > d.dt_vencimento_documento

    -- 8 - calculando média e o maior atraso do cliente
    select 
      @qt_media_atraso_cliente = avg(cast((isnull(p.dt_pagamento_documento, getdate()) - d.dt_vencimento_documento) as int)),
      @qt_maior_atraso = max(cast((isnull(p.dt_pagamento_documento, getdate()) - d.dt_vencimento_documento) as int))
    from
      documento_receber d with (nolock)
    left outer join
      documento_receber_pagamento p with (nolock)
    on 
      d.cd_documento_receber = p.cd_documento_receber      
    where
      d.cd_cliente = @cd_cliente and
      d.dt_vencimento_documento < getdate() and
      d.dt_vencimento_documento < p.dt_pagamento_documento

    -- 9 - calculando a quantidade de duplicatas pagas em cartório
    -- esta rotina somente será cálculada no momento do recebimento da informação de 
    -- liquidação p/ arquivo de retorno do banco

    -- 10 - calculando a quantidade de duplicatas pagas em protesto (cart 907)
    select
      @qt_documento_pago_protesto = count(p.cd_documento_receber)
    from
      documento_receber_pagamento p,
      documento_receber d
    where
      d.cd_cliente = @cd_cliente and
      d.cd_documento_receber = p.cd_documento_receber and
      d.cd_portador = 907

    goto GravarInformacaoComercial

  end
-------------------------------------------------------------------------------
  else if @ic_parametro = 2 -- na exclusão de documento_receber ou na atualização sem inclusão
-------------------------------------------------------------------------------
  begin

    ExecutarParametro2:
    begin
         
      -- 3 - calculando saldo em aberto

      select 
        @vl_saldo_atual_aberto = sum( isnull(vl_saldo_documento,0)),
        @qt_titulo_aberto = count('X')      
      from
        documento_receber with (nolock, INDEX(IX_documento_receber_info))
      where
        cd_cliente = @cd_cliente           and
        IsNull(vl_saldo_documento,0) > 0   and
        dt_cancelamento_documento is null  and
        dt_devolucao_documento    is null
      

      -- Caso o cliente tenha um limite de crédito definido, 
      -- tirar o saldo em aberto do saldo do limite do mesmo.
      if @vl_limite_credito_cliente <> 0
      begin
        set @vl_saldo_credito_cliente = isNull(@vl_limite_credito_cliente,0) - isnull(@vl_saldo_atual_aberto,0)
      end

      -- 4 - calculando maior acúmulo
      --ANALISAR

      exec pr_maior_acumulo_cliente 
        @cd_cliente, 
        @vl_maior_acumulo = @vl_maior_acumulo output,     
        @dt_maior_acumulo = @dt_maior_acumulo output
      
      -- 5 - calculando as notas de débito em aberto (valor e quantidade)
      select 
        @vl_nota_debito = isnull(sum(vl_nota_debito),0),
        @qt_nota_debito = count(cd_nota_debito)
      from
        Nota_debito WITH (NOLOCK)
      where
        cd_cliente = @cd_cliente and
        dt_pagamento_nota_debito is null
 
      -- 6 - calculando a quantidade de duplicatas pagas

      select 
        @qt_documento_pago       = count(cd_documento_receber),
        @vl_total_documento_pago = sum( isnull(vl_documento_receber,0))
      from 
        documento_receber with (nolock, INDEX(IX_documento_receber_info))
      where 
        cd_cliente = @cd_cliente          and 
        dt_cancelamento_documento is null and
        dt_devolucao_documento    is null and
        vl_saldo_documento = 0   

      -- 7 - calculando a quantidade de duplicatas pagas em atraso
      -- 8 - calculando média e o maior atraso do cliente
      select 
        @qt_documento_pago_atraso = count(p.cd_documento_receber),
        @qt_media_atraso_cliente = avg(DATEDIFF ( d , d.dt_vencimento_documento , p.dt_pagamento_documento )),
        @qt_maior_atraso = max(DATEDIFF ( d , d.dt_vencimento_documento , p.dt_pagamento_documento ))
      from 
        documento_receber d with (nolock , INDEX(IX_documento_receber_info))
        inner join documento_receber_pagamento p with (nolock)
          on d.cd_documento_receber = p.cd_documento_receber 
      where 
        d.cd_cliente = @cd_cliente and 
        d.dt_vencimento_documento < getdate() and
        p.dt_pagamento_documento > d.dt_vencimento_documento

      -- 9 - calculando a quantidade de duplicatas pagas em cartório
      -- esta rotina somente será cálculada no momento do recebimento da informação de 
      -- liquidação p/ arquivo de retorno do banco

      -- 10 - calculando a quantidade de duplicatas pagas em protesto (cart 907)
      select
        @qt_documento_pago_protesto = count(d.cd_documento_receber)
      from
        documento_receber d  with (nolock)
      where
        d.cd_cliente = @cd_cliente and
        d.cd_portador = 907 and
        exists (Select 'x' from documento_receber_pagamento p with (nolock)
            where p.cd_documento_receber = d.cd_documento_receber)           
    end

    goto GravarInformacaoComercial   

  end
--------------------------------------------------------------------------------
  else if @ic_parametro = 3 -- Atualização geral da Cliente_Informacao_comercial
--------------------------------------------------------------------------------
  begin

    -- criação da tabela de códigos dos clientes p/ o loop
    select
      cd_cliente
    into
      #Codigo_Cliente
    from
      Cliente
    order by cd_cliente
        
    -- rotina de leitura e chamada da execução da atualização

    ExecutarParametro3:
    begin
     
      if exists(select top 1 * from #Codigo_Cliente)
      begin

        select top 1
          @cd_cliente = cd_cliente
        from
          #Codigo_Cliente

        delete from
          #Codigo_Cliente
        where
          cd_cliente = @cd_cliente

        goto ExecutarParametro2

      end
      else
        goto Fim

    end
            
  end                           

  GravarInformacaoComercial:
  begin
 
    begin tran

    if exists(select top 1 
                cd_cliente
              from 
                cliente_informacao_credito
              where
                cd_cliente = @cd_cliente)
    begin
   
      -- atualização
      update 
        Cliente_Informacao_Credito
      set
--            vl_limite_credito_cliente = @vl_limite_credito_cliente,      
        vl_saldo_credito_cliente  = @vl_saldo_credito_cliente, 
--            ic_cobranca_eletronica    = @ic_cobranca_eletronica,
--            ic_informacao_credito     = @ic_informacao_credito,
--            qt_dia_atraso_cliente     = @qt_dia_atraso_cliente,
        qt_media_atraso_cliente   = @qt_media_atraso_cliente,
        qt_pagamento_atraso       = @qt_documento_pago_atraso,
        vl_maior_fatura_cliente   = @vl_maior_fatura_cliente,
        dt_maior_fatura_cliente   = @dt_maior_fatura_cliente,
        vl_ultimo_faturamento     = @vl_ultimo_faturamento,
        dt_ultimo_faturamento     = @dt_ultimo_faturamento,
        qt_titulo_aberto_cliente  = @qt_titulo_aberto,
        qt_titulo_protesto        = @qt_documento_pago_protesto,
--            qt_titulo_cartorio        = @qt_titulo_cartorio,
--            ds_observacao_credito     = @ds_observacao_credito,
--            ic_credito_suspenso       = @ic_credito_suspenso,
--            ds_suspensao_credito      = @ds_suspensao_credito,
        qt_titulo_pago            = @qt_documento_pago,
        qt_maior_atraso           = @qt_maior_atraso,
        cd_usuario                = @cd_usuario,
        dt_usuario                = getDate(),
--            dt_ultimo_pagamento_atras = @dt_ultimo_pagamento_atras,
--            vl_total_faturamento      = @vl_total_faturamento,
        vl_saldo_atual_aberto     = @vl_saldo_atual_aberto,
--            nm_credito_suspenso       = @nm_credito_suspenso,
--            qt_total_documentos       = @qt_total_documentos,
--            cd_usuario_credito_susp   = @cd_usuario_credito_susp,
        vl_maior_acumulo          = @vl_maior_acumulo,
        dt_maior_acumulo          = @dt_maior_acumulo,
        qt_nota_debito            = @qt_nota_debito,
        vl_nota_debito            = @vl_nota_debito, 
        vl_total_documento_pago   = @vl_total_documento_pago  
      where
        cd_cliente = @cd_cliente 

    end
    else
    begin
                 
      -- inclusao
      insert into  Cliente_Informacao_Credito
        (cd_cliente,
--             vl_limite_credito_cliente,
        vl_saldo_credito_cliente,
--             ic_cobranca_eletronica,
--             ic_informacao_credito,
--             qt_dia_atraso_cliente,
        qt_media_atraso_cliente,
        qt_pagamento_atraso,
        vl_maior_fatura_cliente,
        dt_maior_fatura_cliente,
        vl_ultimo_faturamento,
        dt_ultimo_faturamento,
        qt_titulo_aberto_cliente,
        qt_titulo_protesto,
--            qt_titulo_cartorio,
--            ds_observacao_credito,
--            ic_credito_suspenso,
--            ds_suspensao_credito,
        qt_titulo_pago,
        qt_maior_atraso,
        cd_usuario,
        dt_usuario,
--            dt_ultimo_pagamento_atras ,
--            vl_total_faturamento,
        vl_saldo_atual_aberto,
--            nm_credito_suspenso,
--            qt_total_documentos,
--            cd_usuario_credito_susp,
        vl_maior_acumulo,
        dt_maior_acumulo,
        qt_nota_debito,
        vl_nota_debito,
        vl_total_documento_pago)
      values (
        @cd_cliente,  
--            @vl_limite_credito_cliente,      
        @vl_saldo_credito_cliente,
--            @ic_cobranca_eletronica,
--            @ic_informacao_credito,
--            @qt_dia_atraso_cliente,
        @qt_media_atraso_cliente,
        @qt_documento_pago_atraso,
        @vl_maior_fatura_cliente,
        @dt_maior_fatura_cliente,
        @vl_ultimo_faturamento,
        @dt_ultimo_faturamento,
        @qt_titulo_aberto,
        @qt_documento_pago_protesto,
--            @qt_titulo_cartorio,
--            @ds_observacao_credito,
--            @ic_credito_suspenso,
--            @ds_suspensao_credito,
        @qt_documento_pago,
        @qt_maior_atraso,
        @cd_usuario,
        getDate(),
--            @dt_ultimo_pagamento_atras,
--            @vl_total_faturamento,
        @vl_saldo_atual_aberto,
--            @nm_credito_suspenso,
--            @qt_total_documentos,
--            @cd_usuario_credito_susp,
        @vl_maior_acumulo,
        @dt_maior_acumulo,
        @qt_nota_debito,
        @vl_nota_debito,
        @vl_total_documento_pago)
    end

    if @@ERROR = 0
      commit tran
    else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end 

    if @ic_parametro = 3
      goto ExecutarParametro3

  end

  Fim:
 --   begin

 --     if @@ERROR = 0
 --       commit tran
 --     else
 --       begin
          --RAISERROR @@ERROR
 --         rollback tran
 --     end 

 --   end

  

--  print('Maior Fatura:'+cast(@vl_maior_fatura_cliente as varchar(25)))
--  print('Data da Maior Fatura:'+cast(@dt_maior_fatura_cliente as varchar(11)))
--  print('Último Faturamento:'+cast(@vl_ultimo_faturamento as varchar(25)))
--  print('Data do Último Faturamento:'+cast(@dt_ultimo_faturamento as varchar(11)))
--  print('Maior Acúmulo:'+cast(@vl_maior_acumulo as varchar(25)))
--  print('Data do Maior Acúmulo:'+cast(@dt_maior_acumulo as varchar(11)))
--  print('Saldo Atual em Aberto:'+cast(@vl_saldo_atual_aberto as varchar(25)))
--  print('Títulos em Aberto:'+cast(@qt_titulo_aberto as varchar(6)))
--  print('Média de Atraso:'+cast(@qt_media_atraso_cliente as varchar(6)))
--  print('Maior Atraso:'+cast(@qt_maior_atraso as varchar(6)))
--  print('Notas de Débito:'+cast(@vl_nota_debito as varchar(25)))
--  print('Qtde. de Notas de Débito:'+cast(@qt_nota_debito as varchar(6)))
--  print('Qtde. Documentos Pagos:'+cast(@qt_documento_pago as varchar(6)))
--  print('Qtde. Documentos Pagos em Atraso:'+cast(@qt_documento_pago_atraso as varchar(6)))
--  print('Qtde. Documentos Pagos em Protesto:'+cast(@qt_documento_pago_protesto as varchar(6)))
