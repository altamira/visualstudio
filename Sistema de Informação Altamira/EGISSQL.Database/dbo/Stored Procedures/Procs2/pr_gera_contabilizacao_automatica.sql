------------------------------------------------------------------
--pr_gera_contabilizacao_automatica
------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Elias P. Silva
--                    : Carlos Cardoso Fernandes
--Banco de Dados      : EGISSQL
--Objetivo            : Executa rotina de Geração Automática dos Módulos do EGIS
--Data                : 31/01/2004
--                    : 17/02/2004 - Isnull nos valores contábeis - ELIAS
--                                 - Inclusão de Coluna Tipo de Contabilizacao - ELIAS
--                    : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                    : 28.03.2006 - Contabilização do Movimento de Caixa - Carlos Fernandes
-- 01.12.2007         : Contabilização da Solicitação de Adiantamento/Pagamento
--                      Prestação de Contas - Módulo Viagem - Carlos Fernandes
-- 28.05.2008 - Gera a contabilização do contas a pagar - Carlos Fernandes
---------------------------------------------------------------------------------------------

create procedure pr_gera_contabilizacao_automatica
@ic_parametro      int,
@ic_contabilizacao int,  
@dt_inicial        datetime,
@dt_final          datetime,
@cd_usuario        int,
@cd_modulo         int,
@cd_lote_contabil  int output

as

-- PARAMETROS
-- 1 - Geração de Lancamentos Automáticos
-- 2 - Retorna Tabela de Contabilização p/ Novo Processamento

-- TIPOS DE CONTABILIZACAO
-- 1 - Faturamento
-- 2 - Entradas
-- 3 - Contas a Receber
-- 4 - Contas a Pagar
-- 5 - Movimento de Caixa
-- 6 - Movimento de Banco  ** Fazer, precisa analisar porque o que está contabilizado no CP/CR
-- 7 - Movimento de Solicitação de Adiantamento
-- 8 - Movimento de Solicitação de Pagamento
-- 9 - Movimento de Prestação   de Contas
-- 10- Movimento do Ativo Fixo
-- 11 - Movimento da Folha de Pagamento
-- 12- Movimento do Controle de Estoque
-- 13- Movimento da Importação
-- 14- Movimento da Exportação
-- 15-

-------------------------------------------------------------------------------
-- GERAÇÃO DE MOVIMENTOS CONTÁBEIS
-------------------------------------------------------------------------------
if (@ic_parametro = 1) 
begin

  -- ESSAS LINHAS ATÉ A "IF @IC_CONTABIL... " SERÃO SEMPRE AS MESMAS
  -- CONTÊM DECLARAÇÕES DE VARIÁVEIS E PARAMETROS NECESSÁRIOS A 
  -- QUALQUER TIPO DE CONTABILIZACAO

  declare @cd_novo_lote        int
  declare @cd_exercicio_atual  int
  declare @vl_total_debito     decimal(25,2)
  declare @vl_total_credito    decimal(25,2)
  declare @qt_total_lancamento int

  -- EXERCÍCIO ATIVO ATUAL
  select 
    @cd_exercicio_atual = cd_exercicio 
  from 
    parametro_contabil  
  where
    cd_empresa = dbo.fn_empresa() and
    isnull(ic_exercicio_ativo,'N') = 'S'

  print('Exercicio Atual '+cast(@cd_exercicio_atual as varchar))

  -- GERA CÓDIGO DE LOTE CONTÁBIL
  -- não foi utilizado a rotina existente GeraCodigo 
  -- por que a tabela Lote_Contabil é por empresa e
  -- a rotina acima não faz distinção por empresas
  select 
    @cd_novo_lote = (isnull(max(cd_lote),0)+1)
  from
    lote_contabil
  where
    cd_empresa   = dbo.fn_empresa() and
    cd_exercicio = @cd_exercicio_atual

  print('Gerou Novo Lote '+cast(@cd_novo_lote as varchar))

  -- O código do movimento contábil é montado deacordo com
  -- a chave existente para a tabela, que no caso é:
  -- Empresa, Exercício, Lote e Movimento


  -----------------------------------------------------------------------------
  -- ROTINAS DE CONTABILIZAÇÃO DOS MÓDULOS DO EGIS
  -----------------------------------------------------------------------------

  -- ROTINA DE CONTABILIZAÇÃO DO FATURAMENTO

  if (@ic_contabilizacao = 1)
  begin

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()   	as cd_empresa,
      @cd_exercicio_atual 	as cd_exercicio,
      @cd_novo_lote 	        as cd_lote_contabil,  
      identity(int,1,1) 	as cd_lancamento_contabil,
      nsc.dt_contab_nota_saida  as dt_lancamento_contabil,
      pcd.cd_conta_reduzido     as cd_reduzido_debito,
      pcc.cd_conta_reduzido     as cd_reduzido_credito,
      case when (isnull(nsc.vl_contab_nota_saida,0)=0) then
        case when (isnull(nsc.vl_ipi_nota_saida,0)=0) then
          isnull(nsc.vl_icms_nota_saida,0)
        else
          isnull(nsc.vl_ipi_nota_saida,0)
        end
      else
        isnull(nsc.vl_contab_nota_saida,0)
      end			as vl_lancamento_contabil,
      nsc.cd_historico_contabil,
      nsc.nm_historico_nota_saida as ds_historico_contabil,
      @cd_usuario as cd_usuario,
      getDate() as dt_usuario,
      nsc.cd_lancamento_padrao,
      null as cd_centro_custo,
      null as cd_centro_receita,
      @cd_modulo as cd_modulo
    into
      #Nota_Saida_Contabil
    from
      Nota_Saida_Contabil nsc,
      Plano_Conta pcd,
      Plano_Conta pcc
    where
      dt_contab_nota_saida between @dt_inicial and @dt_final and
      pcc.cd_empresa = dbo.fn_empresa() and
      pcd.cd_empresa = dbo.fn_empresa() and
      nsc.cd_conta_credito = pcc.cd_conta and
      nsc.cd_conta_debito = pcd.cd_conta

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Saida
    from
      #Nota_Saida_Contabil


    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Saida

    print('Totais Gerados: ')
    print('DÉBITO '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Nota_Saida_Contabil

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DA NOTA_SAIDA_CONTABIL
    update
      Nota_Saida_Contabil
    set
      ic_sct_contab_nota_saida = 'S',
      dt_sct_contab_nota_saida = getDate()
    where
      dt_contab_nota_saida between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Faturamento ')

  end

  -- ROTINA DE CONTABILIZAÇÃO DAS ENTRADAS

  else if (@ic_contabilizacao = 2)
  begin

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()    	 as cd_empresa,
      @cd_exercicio_atual 	 as cd_exercicio,
      @cd_novo_lote 	         as cd_lote_contabil,  
      identity(int,1,1) 	 as cd_lancamento_contabil,
      nec.dt_contab_nota_entrada as dt_lancamento_contabil,
      pcd.cd_conta_reduzido as cd_reduzido_debito,
      pcc.cd_conta_reduzido as cd_reduzido_credito,
      case when (isnull(nec.vl_contab_nota_entrada,0)=0) then
        case when (isnull(nec.vl_ipi_nota_entrada,0)=0) then
          isnull(nec.vl_icms_nota_entrada,0)
        else
          isnull(nec.vl_ipi_nota_entrada,0)
        end
      else
        isnull(nec.vl_contab_nota_entrada,0)
      end			as vl_lancamento_contabil,
      nec.cd_historico_contabil,
      nec.nm_historico_nota_entrada as ds_historico_contabil,
      @cd_usuario as cd_usuario,
      getDate() as dt_usuario,
      nec.cd_lancamento_padrao,
      null as cd_centro_custo,
      null as cd_centro_receita,
      @cd_modulo as cd_modulo
    into
      #Nota_Entrada_Contabil
    from
      Nota_Entrada_Contabil nec,
      Plano_Conta pcd,
      Plano_Conta pcc
    where
      dt_contab_nota_entrada between @dt_inicial and @dt_final and
      pcc.cd_empresa       = dbo.fn_empresa() and
      pcd.cd_empresa       = dbo.fn_empresa() and
      nec.cd_conta_credito = pcc.cd_conta and
      nec.cd_conta_debito  = pcd.cd_conta

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE

    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Entrada
    from
      #Nota_Entrada_Contabil

    select
      @vl_total_debito = sum(vl_total_debito),
      @vl_total_credito = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Entrada

    print('Totais Gerados: ')
    print('DÉBITO '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Nota_Entrada_Contabil

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DA NOTA_ENTRADA_CONTABIL
    update
      Nota_Entrada_Contabil
    set
      ic_sct_contab_nt_entrada = 'S',
      dt_sct_contab_nt_entrada = getDate()
    where
      dt_contab_nota_entrada between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Faturamento ')

  end

  -- ROTINA DE CONTABILIZAÇÃO DO CONTAS A RECEBER

  else if (@ic_contabilizacao = 3)
  begin

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()   	as cd_empresa,
      @cd_exercicio_atual 	as cd_exercicio,
      @cd_novo_lote 	        as cd_lote_contabil,  
      identity(int,1,1) 	as cd_lancamento_contabil,
      drc.dt_contab_documento   as dt_lancamento_contabil,
      pcd.cd_conta_reduzido     as cd_reduzido_debito,
      pcc.cd_conta_reduzido     as cd_reduzido_credito,
      isnull(drc.vl_contab_documento,0)		as vl_lancamento_contabil,
      drc.cd_historico_contabil,
      drc.nm_historico_documento as ds_historico_contabil,
      @cd_usuario                as cd_usuario,
      getDate()                  as dt_usuario,
      drc.cd_lancamento_padrao,
      null                       as cd_centro_custo,
      null                       as cd_centro_receita,
      @cd_modulo                 as cd_modulo
    into
      #Documento_Receber_Contabil
    from
      Documento_Receber_Contabil drc,
      Plano_Conta pcd,
      Plano_Conta pcc
    where
      drc.dt_contab_documento between @dt_inicial and @dt_final and
      pcc.cd_empresa       = dbo.fn_empresa() and
      pcd.cd_empresa       = dbo.fn_empresa() and
      drc.cd_conta_credito = pcc.cd_conta and
      drc.cd_conta_debito  = pcd.cd_conta

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Documento_Receber
    from
      #Documento_Receber_Contabil

    select
      @vl_total_debito = sum(vl_total_debito),
      @vl_total_credito = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Documento_Receber

    print('Totais Gerados: ')
    print('DÉBITO '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Documento_Receber_Contabil

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DO DOCUMENTO_RECEBER_CONTABIL
    update
      Documento_Receber_Contabil
    set
      ic_sct_contab_documento = 'S',
      dt_sct_contabil_documento = getDate()
    where
      dt_contab_documento between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Contas a Receber ')

  end

  -- ROTINA DE CONTABILIZAÇÃO DO CONTAS A PAGAR
  -- 28.05.2008
  -- SELECT * from documento_pagar_contabil

  else if (@ic_contabilizacao = 4)
  begin

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()   	as cd_empresa,
      @cd_exercicio_atual 	as cd_exercicio,
      @cd_novo_lote 	        as cd_lote_contabil,  
      identity(int,1,1) 	as cd_lancamento_contabil,
      drc.dt_contab_documento   as dt_lancamento_contabil,
      pcd.cd_conta_reduzido     as cd_reduzido_debito,
      pcc.cd_conta_reduzido     as cd_reduzido_credito,
      isnull(drc.vl_contab_documento,0)		as vl_lancamento_contabil,
      drc.cd_historico_contabil,
      drc.nm_historico_documento as ds_historico_contabil,
      @cd_usuario                as cd_usuario,
      getDate()                  as dt_usuario,
      drc.cd_lancamento_padrao,
      null                       as cd_centro_custo,
      null                       as cd_centro_receita,
      @cd_modulo                 as cd_modulo
    into
      #Documento_Pagar_Contabil
    from
      Documento_Pagar_Contabil drc,
      Plano_Conta pcd,
      Plano_Conta pcc
    where
      drc.dt_contab_documento between @dt_inicial and @dt_final and
      pcc.cd_empresa       = dbo.fn_empresa() and
      pcd.cd_empresa       = dbo.fn_empresa() and
      drc.cd_conta_credito = pcc.cd_conta and
      drc.cd_conta_debito  = pcd.cd_conta

--    select * from       #Documento_Pagar_Contabil

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Documento_Pagar
    from
      #Documento_Pagar_Contabil

    --select * from #Total_Documento_Pagar

    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Documento_Pagar

    print('Totais Gerados: ')
    print('DÉBITO ' +cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE '   +cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Documento_Pagar_Contabil

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DO DOCUMENTO_RECEBER_CONTABIL
    update
      Documento_Pagar_Contabil
    set
      ic_sct_contab_documento = 'S',
      dt_sct_contab_documento = getDate()
    where
      dt_contab_documento between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Contas a Pagar ')

  end


  -- ROTINA DE CONTABILIZAÇÃO DO MOVIMENTO DE CAIXA
  -- CAIXA_LANCAMENTO
  -- CARLOS 28.03.2006

  else if (@ic_contabilizacao = 5)
  begin

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()  	        as cd_empresa,
      @cd_exercicio_atual 	        as cd_exercicio,
      @cd_novo_lote 	                as cd_lote_contabil,  
      identity(int,1,1)                 as cd_lancamento_contabil,
      cl.dt_lancamento_caixa            as dt_lancamento_contabil,
      pcd.cd_conta_reduzido             as cd_reduzido_debito,
      pcc.cd_conta_reduzido             as cd_reduzido_credito,
      isnull(cl.vl_lancamento_caixa,0)	as vl_lancamento_contabil,
      0                                 as cd_historico_contabil,
      cl.nm_historico_lancamento        as ds_historico_contabil,
      @cd_usuario                       as cd_usuario,
      getDate()                         as dt_usuario,
      cl.cd_lancamento_padrao,
      null                              as cd_centro_custo,
      null                              as cd_centro_receita,
      @cd_modulo                        as cd_modulo,
      cd_lancamento_caixa
    into
      #Caixa_Lancamento
    from
      Caixa_Lancamento cl
      left outer join Plano_Conta pcd on pcd.cd_conta = cl.cd_conta_debito
      left outer join Plano_Conta pcc on pcc.cd_conta = cl.cd_conta_credito
    where
      isnull(cl.cd_lote,0) = 0                                 and --Verifica se já foi contabilizado
      cl.dt_lancamento_caixa between @dt_inicial and @dt_final --
--and
--       pcc.cd_empresa       = dbo.fn_empresa() and
--       pcd.cd_empresa       = dbo.fn_empresa() and

    --select * from #Caixa_Lancamento

    --select * from caixa_lancamento

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Caixa_Lancamento
    from
      #Caixa_Lancamento

    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Caixa_Lancamento

    print('Totais Gerados: ')
    print('DÉBITO  '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE    '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Caixa_Lancamento

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DOS LANÇAMENTOS DE CAIXA
    update
      Caixa_Lancamento
    set
      cd_lote                   = @cd_novo_lote,
      cd_lancamento_contabil    = c.cd_lancamento_contabil,
      dt_contabilizacao         = getDate()
    from 
      Caixa_Lancamento cl, #Caixa_Lancamento c

    where
      cl.cd_lancamento_caixa = c.cd_lancamento_caixa and
      cl.dt_lancamento_caixa between @dt_inicial and @dt_final  


    print('Atualizou a Contabilização do Movimento de Caixa')


  end

  --Contabilização do Movimento de Viagem

  --Solicitação de Adiantamento

  else if (@ic_contabilizacao = 7)
  begin
    --select * from solicitacao_adiantamento_contabil

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()  	          as cd_empresa,
      @cd_exercicio_atual 	          as cd_exercicio,
      @cd_novo_lote 	                  as cd_lote_contabil,  
      identity(int,1,1)                   as cd_lancamento_contabil,
      sa.dt_contab_adiantamento           as dt_lancamento_contabil,
      pcd.cd_conta_reduzido               as cd_reduzido_debito,
      pcc.cd_conta_reduzido               as cd_reduzido_credito,
      isnull(sa.vl_contab_adiantamento,0) as vl_lancamento_contabil,
      sa.cd_historico_contabil            as cd_historico_contabil,
      sa.nm_historico_contabil            as ds_historico_contabil,
      @cd_usuario                         as cd_usuario,
      getDate()                           as dt_usuario,
      sa.cd_lancamento_padrao,
      null                                as cd_centro_custo,
      null                                as cd_centro_receita,
      @cd_modulo                          as cd_modulo,
      cd_contab_adiantamento
    into
      #Solicitacao_Adiantamento
    from
      Solicitacao_Adiantamento_Contabil sa
      left outer join Plano_Conta pcd on pcd.cd_conta = sa.cd_conta_debito
      left outer join Plano_Conta pcc on pcc.cd_conta = sa.cd_conta_credito
    where
      isnull(sa.cd_lote_contabil,0) = 0                                 and --Verifica se já foi contabilizado
      sa.dt_contab_adiantamento between @dt_inicial and @dt_final         and --
      isnull(sa.ic_sct_adiantamento,'N')='N' 

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Solicitacao_Adiantamento
    from
      #Solicitacao_Adiantamento

    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Solicitacao_Adiantamento

    print('Totais Gerados: ')
    print('DÉBITO  '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE    '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Solicitacao_Adiantamento

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DOS LANÇAMENTOS DE SOLICITAÇÃO DE ADIANTAMENTO

    update
      solicitacao_adiantamento_contabil
    set
      cd_lote_contabil          = @cd_novo_lote,
      cd_lancamento_contabil    = a.cd_lancamento_contabil,
      dt_sct_adiantamento       = getDate(),
      ic_contabilizado          = 'S'
    from 
      Solicitacao_Adiantamento_Contabil s, #Solicitacao_Adiantamento a

    where
      s.cd_contab_adiantamento = a.cd_contab_adiantamento and
      s.dt_contab_adiantamento between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Movimento de Solicitação de Adiantamento')

  end

  --Solicitação de Pagamento

  else if (@ic_contabilizacao = 8)
  begin
    --select * from solicitacao_pagamento_contabil

    -- TABELA COM DADOS PARA GERAÇÃO
    select
      dbo.fn_empresa()  	          as cd_empresa,
      @cd_exercicio_atual 	          as cd_exercicio,
      @cd_novo_lote 	                  as cd_lote_contabil,  
      identity(int,1,1)                   as cd_lancamento_contabil,
      sa.dt_contab_pagamento              as dt_lancamento_contabil,
      pcd.cd_conta_reduzido               as cd_reduzido_debito,
      pcc.cd_conta_reduzido               as cd_reduzido_credito,
      isnull(sa.vl_contab_pagamento,0) as vl_lancamento_contabil,
      sa.cd_historico_contabil            as cd_historico_contabil,
      sa.nm_historico_contabil            as ds_historico_contabil,
      @cd_usuario                         as cd_usuario,
      getDate()                           as dt_usuario,
      sa.cd_lancamento_padrao,
      null                                as cd_centro_custo,
      null                                as cd_centro_receita,
      @cd_modulo                          as cd_modulo,
      cd_contab_pagamento
    into
      #Solicitacao_Pagamento
    from
      Solicitacao_Pagamento_Contabil sa
      left outer join Plano_Conta pcd on pcd.cd_conta = sa.cd_conta_debito
      left outer join Plano_Conta pcc on pcc.cd_conta = sa.cd_conta_credito
    where
      isnull(sa.cd_lote_contabil,0) = 0                                 and --Verifica se já foi contabilizado
      sa.dt_contab_pagamento between @dt_inicial and @dt_final         and --
      isnull(sa.ic_sct_pagamento,'N')='N' 

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Solicitacao_Pagamento
    from
      #Solicitacao_Pagamento

    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Solicitacao_Pagamento

    print('Totais Gerados: ')
    print('DÉBITO  '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE    '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL
    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Solicitacao_Pagamento

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DOS LANÇAMENTOS DE SOLICITAÇÃO DE ADIANTAMENTO

    update
      solicitacao_pagamento_contabil
    set
      cd_lote_contabil          = @cd_novo_lote,
      cd_lancamento_contabil    = a.cd_lancamento_contabil,
      dt_sct_pagamento          = getDate(),
      ic_contabilizado          = 'S'
    from 
      Solicitacao_Pagamento_Contabil s, #Solicitacao_Pagamento a

    where
      s.cd_contab_pagamento = a.cd_contab_pagamento and
      s.dt_contab_pagamento between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Movimento de Solicitação de Pagamento !')

  end

  --Prestação de Contas

  else if (@ic_contabilizacao = 9)
  begin
    --select * from prestacao_conta_contabil

    -- TABELA COM DADOS PARA GERAÇÃO

    select
      dbo.fn_empresa()  	          as cd_empresa,
      @cd_exercicio_atual 	          as cd_exercicio,
      @cd_novo_lote 	                  as cd_lote_contabil,  
      identity(int,1,1)                   as cd_lancamento_contabil,
      sa.dt_contab_prestacao              as dt_lancamento_contabil,
      pcd.cd_conta_reduzido               as cd_reduzido_debito,
      pcc.cd_conta_reduzido               as cd_reduzido_credito,
      isnull(sa.vl_contab_prestacao,0)    as vl_lancamento_contabil,
      sa.cd_historico_contabil            as cd_historico_contabil,
      sa.nm_historico_contabil            as ds_historico_contabil,
      @cd_usuario                         as cd_usuario,
      getDate()                           as dt_usuario,
      sa.cd_lancamento_padrao,
      null                                as cd_centro_custo,
      null                                as cd_centro_receita,
      @cd_modulo                          as cd_modulo,
      cd_contab_prestacao
    into
      #Prestacao_Conta
    from
      Prestacao_Conta_Contabil sa
      left outer join Plano_Conta pcd on pcd.cd_conta = sa.cd_conta_debito
      left outer join Plano_Conta pcc on pcc.cd_conta = sa.cd_conta_credito
    where
      isnull(sa.cd_lote_contabil,0) = 0                                 and --Verifica se já foi contabilizado
      sa.dt_contab_prestacao between @dt_inicial and @dt_final         and --
      isnull(sa.ic_sct_prestacao,'N')='N' 

    print('Gerou Tabela de Movimentos')

    -- TOTAIS DE DÉBITO, CRÉDITO E QUANTIDADE
    select
      vl_total_debito = case when (isnull(cd_reduzido_debito,0)<>0) then
                           isnull(vl_lancamento_contabil,0)
                         else 0 end,
      vl_total_credito = case when (isnull(cd_reduzido_credito,0)<>0) then
                            isnull(vl_lancamento_contabil,0)
                          else 0 end
    into
      #Total_Prestacao_Conta
    from
      #Prestacao_Conta

    select
      @vl_total_debito     = sum(vl_total_debito),
      @vl_total_credito    = sum(vl_total_credito),
      @qt_total_lancamento = count(*)
    from
      #Total_Prestacao_Conta

    print('Totais Gerados: ')
    print('DÉBITO  '+cast(@vl_total_debito as varchar))
    print('CRÉDITO '+cast(@vl_total_credito as varchar))
    print('QTDE    '+cast(@qt_total_lancamento as varchar))
  
    -- GRAVAÇÃO DO MOVIMENTO_CONTABIL

    insert into Movimento_Contabil 
      (cd_empresa,
       cd_exercicio,
       cd_lote,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo)
    select 
       cd_empresa,
       cd_exercicio,
       cd_lote_contabil,
       cd_lancamento_contabil,
       dt_lancamento_contabil,
       cd_reduzido_debito,
       cd_reduzido_credito,
       vl_lancamento_contabil,
       cd_historico_contabil,
       ds_historico_contabil,
       cd_usuario,
       dt_usuario,
       cd_lancamento_padrao,
       cd_centro_custo,
       cd_centro_receita,
       cd_modulo
    from
      #Prestacao_Conta

    print('Gravou os Movimentos ')

    -- ATUALIZAÇÃO DOS LANÇAMENTOS DE SOLICITAÇÃO DE ADIANTAMENTO

    update
      prestacao_conta_contabil
    set
      cd_lote_contabil          = @cd_novo_lote,
      cd_lancamento_contabil    = a.cd_lancamento_contabil,
      dt_sct_prestacao          = getDate(),
      ic_contabilizado          = 'S'
    from 
      Prestacao_Conta_Contabil s, #Prestacao_Conta a

    where
      s.cd_contab_prestacao = a.cd_contab_prestacao and
      s.dt_contab_prestacao between @dt_inicial and @dt_final  

    print('Atualizou a Contabilização do Movimento de Prestação de Contas !')

  end


  -- FIM DAS ROTINAS DE CONTABILIZAÇÃO DO EGIS

  -- AS LINHAS ABAIXO SERÃO SEMPRE IGUAIS NÃO IMPORTANDO O TIPO DE CONTABILIZACAO

  -- GERAÇÃO DO LOTE CONTABIL

  insert into Lote_Contabil
    (cd_empresa,
     cd_exercicio,
     cd_lote,
     dt_lote,
     vl_lote_debito,
     vl_lote_credito, 
     qt_total_lancamento_lote,
     ic_consistencia_lote,
     vl_lote_debito_informado,
     vl_lote_credito_informado,
     cd_usuario,
     dt_usuario,
     ic_ativa_lote)
  values (
    dbo.fn_empresa(),
    @cd_exercicio_atual,
    @cd_novo_lote,
    getDate(),
    @vl_total_debito,
    @vl_total_credito,
    @qt_total_lancamento,
    case when (@vl_total_debito <> @vl_total_credito) then
      'N'
    else 
      'S'
    end,
    @vl_total_debito,
    @vl_total_credito,
    @cd_usuario,
    getDate(),
    'S')

  print('Gerou novo Lote Contabil '+cast(@cd_novo_lote as varchar))  

  -- LISTANDO OS MOVIMENTOS CRIADOS
  select * from
    Movimento_Contabil
  where
    cd_empresa   = dbo.fn_empresa() and
    cd_exercicio = @cd_exercicio_atual and
    cd_lote      = @cd_novo_lote


end 

-------------------------------------------------------------------------------
-- RETORNA TABELAS DE CONTABILIZAÇÃO PARA NOVO PROCESSAMENTO
-------------------------------------------------------------------------------

else if (@ic_parametro = 2)
begin

  if (@ic_contabilizacao = 1)  
    update Nota_Saida_Contabil
    set
      ic_sct_contab_nota_saida = 'N',
      dt_sct_contab_nota_saida = NULL
    where
      dt_contab_nota_saida between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 2)  
    update Nota_Entrada_Contabil
    set
      ic_sct_contab_nt_entrada = 'N',
      dt_sct_contab_nt_entrada = NULL
    where
      dt_contab_nota_entrada between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 3)  
    update Documento_Receber_Contabil
    set
      ic_sct_contab_documento = 'N',
      dt_sct_contabil_documento = NULL
    where
      dt_contab_documento between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 5)  
    update Caixa_Lancamento
    set
      cd_lote                = 0,
      cd_lancamento_contabil = 0,
      dt_contabilizacao      = NULL
    where
      dt_contabilizacao between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 7)  
    update Solicitacao_Adiantamento_Contabil
    set
      cd_lote_contabil       = 0,
      cd_lancamento_contabil = 0,
      ic_sct_adiantamento    = 'N',
      dt_sct_adiantamento    = NULL
    where
      dt_sct_adiantamento between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 8)  
    update Solicitacao_Pagamento_Contabil
    set
      cd_lote_contabil       = 0,
      cd_lancamento_contabil = 0,
      ic_sct_pagamento       = 'N',
      dt_sct_pagamento    = NULL
    where
      dt_sct_pagamento between @dt_inicial and @dt_final

  else if (@ic_contabilizacao = 9)  
    update Prestacao_Conta_Contabil
    set
      cd_lote_contabil       = 0,
      cd_lancamento_contabil = 0,
      ic_sct_prestacao       = 'N',
      dt_sct_prestacao       = NULL
    where
      dt_sct_prestacao between @dt_inicial and @dt_final


end

-------------------------------------------------------------------------------
-- LISTAGEM DAS TABELAS DE CONTABILIZAÇÃO QUE PODEM GERAR LANÇAMENTOS AUTOMÁTICOS
-------------------------------------------------------------------------------
else if (@ic_parametro = 3)
begin

  -- FATURAMENTO  
  select 
    'N'                         as ic_selecao,
    dt_contab_nota_saida        as DtContabil,
    count(*) 			as Qtde,
    'Faturamento'		as Contabilizacao,
    1				as TipoContabilizacao
  from 
    nota_saida_contabil
  where
    isnull(ic_sct_contab_nota_saida,'N') = 'N'
  group by
    dt_contab_nota_saida
  union all
  -- ENTRADAS
  select
    'N'                         as ic_selecao,
    dt_contab_nota_entrada 	as DtContabil,
    count(*)			as Qtde,
    'Entradas'			as Contabilizacao,
    2				as TipoContabilizacao
  from
    Nota_Entrada_Contabil
  where
    isnull(ic_sct_contab_nt_entrada,'N') = 'N'
  group by
    dt_contab_nota_entrada
  union all
  -- DOCUMENTOS A RECEBER
  select
    'N'                         as ic_selecao,
    dt_contab_documento 	as DtContabil,
    count(*)			as Qtde,
    'Contas a Receber'		as Contabilizacao,
    3				as TipoContabilizacao
  from
    Documento_Receber_Contabil
  where
    isnull(ic_sct_contab_documento,'N') = 'N'
  group by
    dt_contab_documento
  union all
  -- DOCUMENTOS A PAGAR
  select
    'N'                         as ic_selecao,
    dt_contab_documento 	as DtContabil,
    count(*)			as Qtde,
    'Contas a Pagar'		as Contabilizacao,
    4				as TipoContabilizacao
  from
    Documento_Pagar_Contabil
  where
    isnull(ic_sct_contab_documento,'N') = 'N'
  group by
    dt_contab_documento

  union all
  --CAIXA_LANCAMENTO
  select
    'N'                         as ic_selecao,
    dt_lancamento_caixa         as DtContabil,
    count(*)			as Qtde,
    'Movimento de Caixa'	as Contabilizacao,
    5				as TipoContabilizacao
  from
    Caixa_Lancamento
  where
    isnull(cd_lote,0) = 0
  group by
    dt_lancamento_caixa
 
 union all

  --SOLICITAÇÃO DE ADIANTAMENTO
  select
    'N'                           as ic_selecao,
    dt_contab_adiantamento        as DtContabil,
    count(*)			  as Qtde,
    'Solicitação de Adiantamento' as Contabilizacao,
    7				  as TipoContabilizacao
  from
    Solicitacao_Adiantamento_Contabil
  where
    isnull(cd_lote_contabil,0) = 0
  group by
    dt_contab_adiantamento

 union all

  --SOLICITAÇÃO DE PAGAMENTO

  select
    'N'                           as ic_selecao,
    dt_contab_pagamento           as DtContabil,
    count(*)			  as Qtde,
    'Solicitação de Pagamento'    as Contabilizacao,
    8				  as TipoContabilizacao
  from
    Solicitacao_Pagamento_Contabil
  where
    isnull(cd_lote_contabil,0) = 0
  group by
    dt_contab_pagamento

  union all

  --PRESTAÇÃO DE CONTAS
  
  select
    'N'                           as ic_selecao,
    dt_contab_prestacao           as DtContabil,
    count(*)			  as Qtde,
    'Prestação de Contas'         as Contabilizacao,
    9				  as TipoContabilizacao
  from
    Prestacao_Conta_Contabil
  where
    isnull(cd_lote_contabil,0) = 0
  group by
    dt_contab_prestacao

  
  order by
    DtContabil desc,Contabilizacao


end

-- 
