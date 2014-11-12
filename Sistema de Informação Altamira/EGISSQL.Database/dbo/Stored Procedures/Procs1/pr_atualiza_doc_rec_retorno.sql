
create procedure pr_atualiza_doc_rec_retorno
@cd_identificacao   varchar(15)   = '',
@cd_ocorrencia      char(2)       = '',
@cd_bancario        varchar(30)   = '',
@cd_banco           int           = 0,
@vl_tarifa_cobranca decimal(25,2) = 0,
@vl_abatimento      decimal(25,2) = 0,
@vl_desconto        decimal(25,2) = 0,
@vl_recebido        decimal(25,2) = 0,
@vl_juros_mora      decimal(25,2) = 0,
@vl_outro_credito   decimal(25,2) = 0,
@dt_credito         datetime      = '',
@cd_usuario         int           = 0,
@nm_conta_banco     varchar(30)   = ''

--sp_help conta_agencia_banco

as

  --Setar valores DEFAULT
  declare @cd_banco_aux int

  set @vl_tarifa_cobranca = isnull(@vl_tarifa_cobranca,0)
  set @vl_abatimento      = isnull(@vl_abatimento,0)
  set @vl_desconto        = isnull(@vl_desconto,0)
  set @vl_juros_mora      = isnull(@vl_juros_mora,0)
  set @vl_outro_credito   = isnull(@vl_outro_credito,0)
  set @cd_banco_aux       = isnull(@cd_banco,0)

  -- Variáveis utilizadas nesta procedure

  declare @cd_moeda                   int
  declare @cd_plano_financeiro        int
  declare @cd_conta_banco             int
  declare @cd_ocorrencia_empresa      int    
  declare @cd_documento_receber       int
  declare @cd_tipo_liquidacao         int
  declare @cd_item_documento_receber  int
  declare @vl_saldo_documento_receber decimal(25,2)
  declare @vl_reembolso               decimal(25,2)
  declare @vl_principal               decimal(25,2)
  declare @nm_mensagem                varchar(100)
  declare @cd_pedido_venda            int
  declare @cd_cliente                 int
  declare @dt_atualizacao             datetime
  declare @dt_usuario                 datetime
  declare @cd_portador                int
  declare @dt_devolucao_documento     datetime
  declare @dt_cancelamento_documento  datetime
  declare @vl_documento_receber       decimal(25,2)
  declare @cd_banco_documento_recebe  varchar(50)
  declare @sError                     varchar(1000)
  declare @cd_conta_banco_remessa     int
   
  set @dt_usuario = getDate()
  
  -- acerta valores para 2 casas decimais

  set @vl_tarifa_cobranca = cast(str(isnull(@vl_tarifa_cobranca,0),25,2) as decimal(25,2))
  set @vl_abatimento 	  = cast(str(isnull(@vl_abatimento,0),25,2)      as decimal(25,2))
  set @vl_desconto 	  = cast(str(isnull(@vl_desconto,0),25,2)        as decimal(25,2))
  set @vl_recebido 	  = cast(str(isnull(@vl_recebido,0),25,2)        as decimal(25,2))
  set @vl_juros_mora 	  = cast(str(isnull(@vl_juros_mora,0),25,2)      as decimal(25,2))
  set @vl_outro_credito   = cast(str(isnull(@vl_outro_credito,0),25,2)   as decimal(25,2))
  set @cd_conta_banco     = 0

  -- Verificar se existe Instrucao Bancanria
  declare @ic_instrucao_bancaria char(1)

  -- encontra a chave do documento_receber
 
  --select @cd_identificacao

  select
    top 1
    @cd_documento_receber       = isnull(dr.cd_documento_receber,0),
    @vl_documento_receber       = cast(str(dr.vl_documento_receber,25,2) as decimal(25,2)),
    @vl_saldo_documento_receber = cast(str(dr.vl_saldo_documento,25,2)   as decimal(25,2)),
    @cd_tipo_liquidacao         = dr.cd_tipo_liquidacao,
    @cd_pedido_venda            = dr.cd_pedido_venda,
    @cd_cliente                 = dr.cd_cliente,
    @vl_principal               = cast(str(dr.vl_documento_receber,25,2) as decimal(25,2)),
    @dt_devolucao_documento     = dr.dt_devolucao_documento,
    @dt_cancelamento_documento  = dr.dt_cancelamento_documento,
    @cd_banco_documento_recebe  = dr.cd_banco_documento_recebe,
    @cd_banco_aux               = isnull(p.cd_banco,0),
    @cd_moeda                   = isnull(dr.cd_moeda,1),
    @cd_plano_financeiro        = isnull(dr.cd_plano_financeiro,0), 
    @cd_conta_banco_remessa     = isnull(dr.cd_conta_banco_remessa,0)
  from
    Documento_Receber dr       with (nolock) 
    left outer join portador p with (nolock) on p.cd_portador = dr.cd_portador
  where
    replace(dr.cd_identificacao,'-','') = replace(@cd_identificacao,'-','')

  --select @cd_identificacao


  --Carlos / Diego Santiago - 28.11.2005
  --Verifica se o Código do Banco do Parâmetro é igual a Zero
  --

  if isnull(@cd_banco,0)=0
  begin
    set @cd_banco = @cd_banco_aux
  end

  if (isnull(@cd_banco,0)=0)
    begin
      set @sError = 'Problema: Portador falta banco p/fazer atualização ou Documento não Localizado !' 
      raiserror(@sError , 16, 1)
      return
    end    

  -- encontra ocorrencia na empresa

  select 
    @cd_ocorrencia_empresa    = cd_ocorrencia_retorno
  from 
    ocorrencia_retorno_banco with (nolock) 
  where
    cd_ocorrencia_retorno_ban = @cd_ocorrencia and
    cd_banco                  = @cd_banco

  if (isnull(@cd_ocorrencia_empresa,0)=0)
    begin
      set @sError = 'Cadastrar Ocorrência: ' + @cd_ocorrencia + ' para o banco: ' + cast(@cd_banco as varchar)
      raiserror(@sError , 16, 1)
      return
    end    

  --print('Ocorrência :'+cast(@cd_ocorrencia_empresa as varchar))

  -- encontra a chave do documento_receber

--   select
--     @cd_documento_receber       = isnull(cd_documento_receber,0),
--     @vl_documento_receber       = cast(str(vl_documento_receber,25,2) as decimal(25,2)),
--     @vl_saldo_documento_receber = cast(str(vl_saldo_documento,25,2) as decimal(25,2)),
--     @cd_tipo_liquidacao         = cd_tipo_liquidacao,
--     @cd_pedido_venda            = cd_pedido_venda,
--     @cd_cliente                 = cd_cliente,
--     @vl_principal               = cast(str(vl_documento_receber,25,2) as decimal(25,2)),
--     @dt_devolucao_documento     = dt_devolucao_documento,
--     @dt_cancelamento_documento  = dt_cancelamento_documento,
--     @cd_banco_documento_recebe  = cd_banco_documento_recebe
-- 
--   from
--     Documento_Receber
--   where
--     replace(cd_identificacao,'-','') = replace(@cd_identificacao,'-','')


----------------------------------------------------------------------------------------------------------------------
--Carlos 02.03.2006
--Busca o Código da Conta Corrente do retorno do Banco para geração da movimentação bancária
--
----------------------------------------------------------------------------------------------------------------------

  if @nm_conta_banco<>'' 
  begin

    select 
      @cd_conta_banco = isnull(cd_conta_banco,0)
    from
      Conta_Agencia_Banco with (nolock) 
    where
      nm_conta_banco = @nm_conta_banco    
   
  end

  -- verifica se o documento existe

  if @cd_documento_receber = 0 
    begin
      set @nm_mensagem = 'Documento '+@cd_identificacao+' não localizado!'
      raiserror(@nm_mensagem,16,1)
      return
    end
  else

  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 1  -- ENTRADA CONFIRMADA
  ----------------------------------------------------------------------------------------
    begin

      -- Atualiza o Documento Receber

      update
        Documento_Receber
      set    
        cd_banco_documento_recebe = @cd_bancario,
        cd_usuario                = @cd_usuario,
        dt_usuario                = @dt_usuario,
        dt_retorno_banco_doc      = getdate() -- Data do Retorno
      where
        cd_documento_receber = @cd_documento_receber

      -- Atualiza a Situação do Pedido de Venda

      set @nm_mensagem    = 'Duplicata n° '+@cd_identificacao+' em Banco.'
      set @dt_atualizacao = getDate()

      if isnull(@cd_pedido_venda,0) > 0
      begin
        exec pr_atualiza_situacao_pedido_venda 0,
                                               0,
                                               0,
                                               @cd_pedido_venda,
                                               0,
                                               @dt_atualizacao,
                                               43,
                                               @nm_mensagem,
                                               '',
                                               '', 
                                               '',
                                               @cd_usuario,
                                               1
       end -- if    
    end
  else
  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 2  -- ENTRADA REJEITADA
  ----------------------------------------------------------------------------------------
    begin

      -- verificar se não é instrução

      if @cd_identificacao not like '%INSTRUCAO%'
        begin

          -- Atualizar o portador para 999-CARTEIRA
          update
            documento_receber
          set
            --Não Mudar o Portador Carlos 28.1.2003
            --cd_portador = 999,     -- CARTEIRA (Futuramente da Tabela de Parâmetro Financeiro)
            dt_retorno_banco_doc     = getdate(), -- Data do Retorno
            cd_usuario               = @cd_usuario,
            dt_usuario               = @dt_usuario
          where
            cd_documento_receber = @cd_documento_receber

        end
      else
        begin

          select
            top 1
            @cd_portador = cd_portador
          from
            Portador
          where
            cd_banco = @cd_banco

          update 
            documento_receber
          set
            cd_portador          = @cd_portador,
            dt_retorno_banco_doc = getdate(), -- Data do Retorno
            cd_usuario           = @cd_usuario,
            dt_usuario           = @dt_usuario
          where
            cd_documento_receber = @cd_documento_receber

        end

      --Verifica se o Documento possui número bancário
      --Se não existir o Portador será mudado para Carteira Automaticamente pelo sistema

      if @cd_banco_documento_recebe is null
      begin
        -- Atualizar o portador para 999-CARTEIRA
        update
          documento_receber
        set
          cd_portador              = 999,       -- CARTEIRA (Futuramente da Tabela de Parâmetro Financeiro)
          dt_retorno_banco_doc     = getdate(), -- Data do Retorno
          dt_envio_banco_documento ='',         -- Permitir nova Seleção
          ic_emissao_documento     ='N',
          ic_envio_documento       ='N',        -- Documento Enviado para o Banco
          cd_usuario               = @cd_usuario,
          dt_usuario               = @dt_usuario
        where
          cd_documento_receber = @cd_documento_receber

      end

    end
  else    
  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 3    -- LIQUIDAÇÃO NORMAL
  ----------------------------------------------------------------------------------------
    begin 

      -- encontra o código do novo item de pagamento
      select
        @cd_item_documento_receber = (isnull(max(cd_item_documento_receber),0)+1)
      from
        documento_receber_pagamento with (nolock) 
      where
        cd_documento_receber = @cd_documento_receber

      -- verifica se o documento já foi baixado
      if (@vl_saldo_documento_receber <= 0)
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' já baixado!'
          raiserror(@nm_mensagem,16,1)
          return
        end

      -- verifica se o valor baixado é maior que o saldo

      if (@vl_saldo_documento_receber > (@vl_recebido+@vl_abatimento+@vl_desconto-@vl_juros_mora+@vl_tarifa_cobranca)) --+@vl_tarifa_cobranca
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' com saldo inferior ao valor da baixa!'
          raiserror(@nm_mensagem,16,1)
          return
        end

     --Colocar a rotina para a EVC
     --05.10.2007

     --Tipo da Carteira de Cobrançca
     if @vl_abatimento=0 and @vl_tarifa_cobranca>0
     begin
       set @vl_recebido = @vl_recebido + @vl_tarifa_cobranca
     end

     --Cálculo do Juros

      if @vl_juros_mora <> ( @vl_recebido-@vl_saldo_documento_receber ) and @vl_juros_mora>0 and @vl_tarifa_cobranca>0
      begin
         set @vl_juros_mora = @vl_juros_mora - @vl_tarifa_cobranca
      end

      set @vl_tarifa_cobranca = 0.00


--        print(cast(@vl_principal as varchar))
--        print(cast(@vl_recebido as varchar))
--        print(cast(@vl_total_recebido as varchar))

      -- Efetua a Baixa do Documento a Receber

      exec pr_documento_receber_pagamento
        2,
        @cd_documento_receber,
        @cd_item_documento_receber,
        @dt_credito,
        @vl_recebido,
        @vl_juros_mora,
        @vl_desconto,
        @vl_abatimento,
        @vl_tarifa_cobranca,
        '',
        '',
        '',    
        0.00,
        0.00,
        '',
        @cd_usuario,
        @dt_usuario,
        '',
        7,
        @cd_banco,
        @cd_conta_banco_remessa 

      -- Atualiza com a Data de Retorno

      update 
        documento_receber
      set
        dt_retorno_banco_doc     = getdate(), -- Data do Retorno
        cd_usuario               = @cd_usuario,
        dt_usuario               = @dt_usuario
      where
        cd_documento_receber     = @cd_documento_receber


      --Atualização da Movimentação Bancária
      --select * from parametro_financeiro

      declare @ic_retorno_mov_conta  char(1)
      declare @ic_tipo_ret_mov_conta char(1)
  
      select
        @ic_retorno_mov_conta  = isnull(ic_retorno_mov_conta ,'N'),
        @ic_tipo_ret_mov_conta = isnull(ic_tipo_ret_mov_conta,'N')
      from
        Parametro_Financeiro with (nolock) 
      where
        cd_empresa = dbo.fn_empresa()

      if ( @ic_retorno_mov_conta = 'S' and @ic_tipo_ret_mov_conta = 'A' )
      begin
        
         exec pr_geracao_movimentacao_bancaria_retorno 
           @cd_documento_receber,       
           @cd_item_documento_receber,  
           @cd_conta_banco,             
           @dt_usuario,                 
           @dt_credito,                 
           @vl_recebido,                
           @cd_plano_financeiro,        
           @cd_moeda,                   
           @cd_usuario,
           @cd_conta_banco_remessa,
           @cd_identificacao
      
      end
      
    end
  else  
  ----------------------------------------------------------------------------------------
  if (@cd_ocorrencia_empresa = 4)  -- LIQUIDAÇÃO PARCIAL
  ----------------------------------------------------------------------------------------
    begin
      set @nm_mensagem = 'Documento '+@cd_identificacao+' com processamento errado do Banco! Não pode haver baixa parcial.'
      raiserror(@nm_mensagem,16,1)
    end
  else

  ------------------------------------------------------------------------------------------
  if ((@cd_ocorrencia_empresa = 5) or (@cd_ocorrencia_empresa = 6))  -- BAIXA POR INSTRUÇÃO
  ------------------------------------------------------------------------------------------
    begin
          
      --Verifica se o Banco Baixou por Conta Própria sem Instrucao Bancaria
      --da Empresa - ccf - 31.01.2003
 
      if @vl_recebido = 0 
        begin
                   
          set @ic_instrucao_bancaria =
             case when ( select top 1 'S' 
                        from documento_instrucao_bancaria where 
                        @cd_documento_receber = cd_documento_receber )='S' then 'S' else 'N' end 
   
          if @ic_instrucao_bancaria = 'N'
            begin 

              --print('Não possui instrução!')

              update
                Documento_Receber
              set
                cd_portador              = 905,       -- Financeiro */
                dt_retorno_banco_doc     = getdate(), -- Data do Retorno
                cd_usuario               = @cd_usuario,
                dt_usuario               = @dt_usuario
              where
                cd_documento_receber = @cd_documento_receber
            end

        end

      -- quando o título já estiver devolvido então atualizar somente a data da devolução

      if (@dt_devolucao_documento is not null)
        begin

          --print(' Possui data de devolução ');

          -- no caso de existir instrução de Baixa p/ Pagto. em Carteira retornar ao portador 905

          if (14 in (select 
                       i.cd_instrucao
                     from
                       Documento_Instrucao_Bancaria d,
                       Doc_Instrucao_Banco_Composicao i
                     where
                       d.cd_doc_instrucao_banco = i.cd_doc_instrucao_banco and
                       d.cd_documento_receber = @cd_documento_receber)) 
            begin

              --print(' Possui instrução de remessa com instrução 14 ')
              --print(' Documento '+cast(@cd_documento_receber as varchar))

              update
                Documento_Receber
              set
                dt_devolucao_documento    = @dt_credito, 
                dt_retorno_banco_doc      = getdate(), -- Data do Retorno
                cd_portador               = 905,
                cd_banco_documento_recebe = null,
                /* Modificado p/ Elias, 27/01/2003 
                   dt_cancelamento_documento = @dt_credito,*/
                cd_usuario = @cd_usuario,
                dt_usuario = @dt_usuario
              where
                cd_documento_receber = @cd_documento_receber

            end
          else
            begin

              update
                Documento_Receber
              set
                dt_devolucao_documento   = @dt_credito, 
                dt_retorno_banco_doc     = getdate(), -- Data do Retorno
                /* Modificado p/ Elias, 27/01/2003 
                   dt_cancelamento_documento = @dt_credito,*/
                cd_usuario = @cd_usuario,
                dt_usuario = @dt_usuario
              where
                cd_documento_receber = @cd_documento_receber

            end
               
        end  
      else       
        -- quando o título estiver cancelado grava a data de cancelamento correta e portador 905
        if (@dt_cancelamento_documento is not null)
          begin

            update
              Documento_Receber
            set
              dt_cancelamento_documento = @dt_credito, -- Já está Lançado no Documento
              cd_portador               = 905,         -- FINANCEIRO  (Futuramente carregar do parâmetro financeiro)
              dt_retorno_banco_doc      = getdate(),   -- Data do Retorno
              cd_banco_documento_recebe = null,
              cd_usuario                = @cd_usuario,
              dt_usuario                = @dt_usuario
            where
              cd_documento_receber      = @cd_documento_receber

          end 
        else      
          -- atualização p/ Carteira Financeiro caso não seja devolução
          begin
              
            update
              Documento_Receber
            set
              /* Comentado p/ ELIAS 27/01/2003
              cd_portador = 905,      -- Financeiro */
              dt_retorno_banco_doc      = getdate(), -- Data do Retorno
              cd_banco_documento_recebe = null,
              cd_usuario                = @cd_usuario,
              dt_usuario                = @dt_usuario
            where
              cd_documento_receber      = @cd_documento_receber
                
          end
     
      -- encontra o código do novo item de pagamento

      select
        @cd_item_documento_receber = (isnull(max(cd_item_documento_receber),0)+1)
      from
        documento_receber_pagamento
      where
        cd_documento_receber = @cd_documento_receber

      -- verifica se o documento já foi baixado

      if (@vl_saldo_documento_receber <= 0)
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' já baixado!'
          raiserror(@nm_mensagem,16,1)
          return
        end

      -- verifica se o valor baixado é maior que o saldo

      if (@vl_saldo_documento_receber > (@vl_recebido+@vl_abatimento+@vl_desconto-@vl_juros_mora))
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' com saldo inferior ao valor da baixa!'
          raiserror(@nm_mensagem,16,1)
          return
        end

      --set @vl_recebido = (isnull(@vl_recebido,0) - isnull(@vl_juros_mora,0) + isnull(@vl_desconto,0) + isnull(@vl_abatimento,0) -
      --                    isnull(@vl_tarifa_cobranca,0) + isnull(@vl_outro_credito,0))

      -- Efetua a Baixa do Documento a Receber

      if @vl_recebido > 0 
        begin

          exec pr_documento_receber_pagamento
            2,
            @cd_documento_receber,
            @cd_item_documento_receber,
            @dt_credito,                 --Data de Pagamento
            @vl_recebido,
            0.00,
            0.00,
            0.00,
            0.00,
            '',
            '',
            '',    
            0.00,
            0.00,
            '',
            @cd_usuario,
            @dt_usuario,
            '',
            7,
            @cd_banco,
            0 

        end
  
      -- Atualiza a Situação do Pedido de Venda

      set @nm_mensagem    = 'Duplicata n° '+@cd_identificacao+' Liquidação Total.'
      set @dt_atualizacao = getDate()

      if isnull(@cd_pedido_venda,0) > 0
      begin
        exec pr_atualiza_situacao_pedido_venda 0,
                                               0,
                                               0,
                                               @cd_pedido_venda,
                                               0,
                                               @dt_atualizacao,
                                               45,
                                               @nm_mensagem,
                                               '',
                                               '', 
                                               '',
                                               @cd_usuario,
                                               1
      end -- if

    end
  else
  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 10  -- LIQUIDAÇÃO EM CARTÓRIO
  ----------------------------------------------------------------------------------------
    begin

      -- encontra o código do novo item de pagamento
      select
        @cd_item_documento_receber = (isnull(max(cd_item_documento_receber),0)+1)
      from
        documento_receber_pagamento
      where
        cd_documento_receber = @cd_documento_receber

      -- verifica se o documento já foi baixado

      if (@vl_saldo_documento_receber <= 0)
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' já baixado!'
          raiserror(@nm_mensagem,16,1)
          return
        end

      -- verifica se o valor baixado é maior que o saldo

      if (@vl_saldo_documento_receber > (@vl_recebido+@vl_abatimento+@vl_desconto-@vl_juros_mora)) 
        begin
          set @nm_mensagem = 'Documento '+@cd_identificacao+' com saldo inferior ao valor da baixa!'
          raiserror(@nm_mensagem,16,1)
          return
        end

      -- se o recebido for maior que o valor principal então a diferença é
      -- reembolso de despesa

      if @vl_recebido > @vl_principal   --@vl_principal = Valor Documento
      begin
        set @vl_reembolso  = @vl_recebido - @vl_principal
        set @vl_juros_mora = 0
      end
      else
        set @vl_reembolso = 0.00
  
      --set @vl_recebido = (isnull(@vl_recebido,0) - isnull(@vl_juros_mora,0) + isnull(@vl_desconto,0) + isnull(@vl_abatimento,0) -
      --                    isnull(@vl_tarifa_cobranca,0) + isnull(@vl_outro_credito,0))

      --print(cast(@vl_principal as varchar))
      --print(cast(@vl_recebido as varchar))

      -- Efetua a Baixa do Documento a Receber lançando
      -- juros de mora em reembolso, caso houver

      exec pr_documento_receber_pagamento
        2,
        @cd_documento_receber,
        @cd_item_documento_receber,
        @dt_credito,
        @vl_recebido,
        @vl_juros_mora,
        @vl_desconto,
        @vl_abatimento,
        @vl_tarifa_cobranca,
        '',
        '',
        '',    
        @vl_reembolso,
        0.00,
        '',
        @cd_usuario,
        @dt_usuario,
        '',
        7,       
        @cd_banco,
        0

      -- Atualiza a Situação do Pedido de Venda

      set @nm_mensagem    = 'Duplicata n° '+@cd_identificacao+' em Cartório.'
      set @dt_atualizacao = getDate()

      if isnull(@cd_pedido_venda,0) > 0
      begin
        exec pr_atualiza_situacao_pedido_venda 0,
                                               0,
                                               0,
                                               @cd_pedido_venda,
                                               0,
                                               @dt_atualizacao,
                                               45,
                                               @nm_mensagem,
                                               '',
                                               '', 
                                               '',
                                               @cd_usuario,
                                               1
      end

      -- Atualização da Informação de Crédito (Qtde de Títulos em Cartório)
      update  
        Cliente_Informacao_Credito
      set
        qt_titulo_cartorio = isnull(qt_titulo_cartorio,0)+1,
        cd_usuario         = @cd_usuario,
        dt_usuario         = @dt_usuario
      where
        cd_cliente = @cd_cliente

      -- Atualiza a Data de Retorno
      update 
        documento_receber
      set
        dt_retorno_banco_doc     = getdate(), -- Data do Retorno
        cd_usuario               = @cd_usuario,
        dt_usuario               = @dt_usuario
      where
        cd_documento_receber = @cd_documento_receber
        
    end
  else

  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 13  -- BAIXA POR TER SIDO PROTESTO
  ----------------------------------------------------------------------------------------
    begin

      update
        documento_receber
      set
        cd_portador               = 907,       -- PROTESTO
        cd_banco_documento_recebe = null,
        dt_retorno_banco_doc      = getdate(), -- Data do Retorno
        cd_usuario                = @cd_usuario,
        dt_usuario                = @dt_usuario
      where
        cd_documento_receber = @cd_documento_receber

      -- Atualiza a Situação do Pedido de Venda

      set @nm_mensagem    = 'Duplicata n° '+@cd_identificacao+' em Protesto.'
      set @dt_atualizacao = getDate()

      if isnull(@cd_pedido_venda,0) > 0
      begin
        exec pr_atualiza_situacao_pedido_venda 0,
                                               0,
                                               0,
                                               @cd_pedido_venda,
                                               0,
                                               @dt_atualizacao,
                                               51,
                                               @nm_mensagem,
                                               '',
                                               '', 
                                               '',
                                               @cd_usuario,
                                               1
      end -- if
    
    end        

  else

  ----------------------------------------------------------------------------------------
  if @cd_ocorrencia_empresa = 150  -- ANÁLISE DE CRÉDITO (93)
                                   -- GERA UMA TABELA DOCUMENTO_RECEBER_ANALISE
  ----------------------------------------------------------------------------------------
    begin

      set @nm_mensagem    = 'Documento n° '+@cd_identificacao+' Análise de Crédito'
      set @dt_atualizacao = getDate()


      if not exists( select cd_documento_receber from documento_receber_analise )
      begin
        --select * from documento_receber_analise
        insert into documento_receber_analise
          select
            @cd_documento_receber,
            getdate(),
            null,
            'S',
            'N',
            @nm_mensagem,
            @cd_usuario,
            getdate(),
            'N'                         
      end
      else
        begin
          update 
            documento_receber_analise
          set
            ic_analise_banco = 'S'   
          from
            documento_receber_analise
          where
            cd_documento_receber = @cd_documento_receber
      
        end
      

      -- Atualiza a Situação do Pedido de Venda

      if isnull(@cd_pedido_venda,0) > 0
      begin
        exec pr_atualiza_situacao_pedido_venda 0,
                                               0,
                                               0,
                                               @cd_pedido_venda,
                                               0,
                                               @dt_atualizacao,
                                               51,
                                               @nm_mensagem,
                                               '',
                                               '', 
                                               '',
                                               @cd_usuario,
                                               1
      end -- if
    
    end        
    
