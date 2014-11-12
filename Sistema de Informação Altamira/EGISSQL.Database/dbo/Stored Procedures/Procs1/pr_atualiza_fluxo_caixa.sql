
CREATE PROCEDURE pr_atualiza_fluxo_caixa

----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
----------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Carrasco Neto/Elias Pereira da Silva
--Banco de Dados	: EGISSQL
--Objetivo		: Atualiza Fluxo de Caixa
--Data			: 25/06/2002
--Alteração		: 01/07/2002 a 04/07/2002 - Acerto de Erros - ELIAS
--                        05/07/2002 - Inclusão do percentual 
--                        de liquidez nos recebimentos previstros - ELIAS
-- 28.10.2007 - Acertos Diversos - Carlos Fernandes
-- 29.04.2008 - Ajuste para Considerar o rateio do documentos a pagar - Carlos Fernandes
------------------------------------------------------------------------------------------------------------

@cd_empresa int      = 0,
@cd_usuario int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = '' 

as

  delete from plano_financeiro_saldo
  delete from plano_financeiro_movimento

  -- Chave do Lançamento
  declare @Chave           int
  
  -- Variáveis usadas como chave p/ loop
  declare @TipoLcto        int
  declare @DataLcto        datetime
  declare @PlanoFinanceiro int

  -- Tabela usada p/ uso do PegaCodigo
  declare @Tabela varchar(100)

  set @Tabela = DB_NAME()+'.dbo.Plano_Financeiro_Movimento'

  create table #LctoAutomaticoRealizado(
    TipoLcto        int,		-- Tipo de Lcto (1) SCP-Débito (2) SCR-Crédito
    DataLcto        datetime,           -- Data de Lançamento (Vcto qdo Previsto/Pagto qdo Realizado)
    PlanoFinanceiro int,                -- Plano Financeiro cadastrado nos Documentos
    VlrLancamento   float,              -- Vlr do Saldo qdo Previso/Vlr do Pagto qdo Realizado
    Historico       varchar(20))        -- Histórico de Atualização Automática c/ sigla do Módulo

  create table #LctoAutomaticoPrevisto(
    TipoLcto        int,	  -- Tipo de Lcto (1) SCP-Débito (2) SCR-Crédito
    DataLcto        datetime,     -- Data de Lançamento (Vcto qdo Previsto/Pagto qdo Realizado)
    PlanoFinanceiro int,          -- Plano Financeiro cadastrado nos Documentos
    VlrLancamento   float,        -- Vlr do Saldo qdo Previso/Vlr do Pagto qdo Realizado
    Historico       varchar(20))  -- Histórico de Atualização Automática c/ sigla do Módulo


  -- 1 - apagar todos os registros de atualização automática existentes em 
  -- plano financeiro movimento

  -- 2 - apurar os novos lançamentos previstos não esquecendo de agrupar
  -- por Data de Vencimento e Plano Financeiro

  -- 3 - incluir os lançamentos no plano_financeiro_movimento e verificar
  -- se o saldo está sendo atualizado

  -- (1)
  delete from 
    plano_financeiro_movimento
  where
    isnull(ic_lancamento_automatico,'N') = 'S'

  -------------------------------------------------------------------------------
  -- PREVISTO
  -------------------------------------------------------------------------------

    -- CONTAS A PAGAR

    insert into
      #LctoAutomaticoPrevisto
    select    
      1					  			as 'TipoLcto',
      cast(cast(dt_vencimento_documento as int) as datetime)  	as 'DataLcto',
      cd_plano_financeiro		 			as 'PlanoFinanceiro',
      sum(isnull(vl_saldo_documento_pagar,0))			as 'VlrLancamento',
      'Lcto. Autom. SCP'		 			as 'Historico'
    from
      Documento_Pagar with (nolock)
    where
      dt_vencimento_documento between @dt_inicial and @dt_final and       
      isnull(vl_saldo_documento_pagar,0) > 0 and
      dt_cancelamento_documento is null and
      cd_plano_financeiro       is not null 
    group by 
      cast(cast(dt_vencimento_documento as int) as datetime),
      cd_plano_financeiro

    --CONTAS A PAGAR DOCUMENTOS RATEADOS
    --select * from documento_pagar_plano_financ 

    insert into
      #LctoAutomaticoPrevisto
    select    
      9					  			as 'TipoLcto',
      cast(cast(dp.dt_vencimento_documento as int) as datetime)	as 'DataLcto',
      df.cd_plano_financeiro		 			as 'PlanoFinanceiro',
      sum(isnull(df.vl_plano_financeiro,0))			as 'VlrLancamento',
      'Lcto. Autom. SCP - Rateio'                               as 'Historico'
    from
      Documento_Pagar dp with (nolock)
      inner join Documento_Pagar_Plano_Financ df with (nolock) on df.cd_documento_pagar = dp.cd_documento_pagar
    where
      dp.dt_vencimento_documento            between @dt_inicial and @dt_final and       
      isnull(dp.vl_saldo_documento_pagar,0) > 0     and
      dp.dt_cancelamento_documento          is null and
      isnull(dp.cd_plano_financeiro,0)=0            and
      isnull(df.cd_plano_financeiro,0)>0            and
      isnull(df.vl_plano_financeiro,0)>0            
      --and df.cd_plano_financeiro not in ( select PlanoFinanceiro from #LctoAutomaticoPrevisto )
    group by 
      cast(cast(dp.dt_vencimento_documento as int) as datetime),
      df.cd_plano_financeiro

    
    -- CONTAS A RECEBER

    insert into
      #LctoAutomaticoPrevisto
    select
      2				 	  			as 'TipoLcto',
      cast(cast(dt_vencimento_documento as int) as datetime) 	as 'DataLcto',
      cd_plano_financeiro		  			as 'PlanoFinanceiro',
      sum(isnull(vl_saldo_documento,0))				as 'VlrLancamento',
      'Lcto. Autom. SCR'		  			as 'Historico'
    from
      Documento_Receber with (nolock)
    where
      dt_vencimento_documento between @dt_inicial and @dt_final and       
      isnull(vl_saldo_documento,0) > 0 and
      dt_cancelamento_documento is null and
      cd_plano_financeiro is not null 
    group by 
      cast(cast(dt_vencimento_documento as int) as datetime),
      cd_plano_financeiro

    --select * from #LctoAutomaticoPrevisto     

    while exists(select top 1 TipoLcto from #LctoAutomaticoPrevisto)
      begin

        select
          @TipoLcto        = TipoLcto,
          @DataLcto        = DataLcto,
          @PlanoFinanceiro = PlanoFinanceiro
        from
          #LctoAutomaticoPrevisto

        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento', @codigo = @Chave output

        insert into Plano_Financeiro_Movimento (
          cd_movimento,			-- Chave
          cd_plano_financeiro,		
          cd_tipo_lancamento_fluxo,	-- (1) Previsto, (2) Realizado
          dt_movto_plano_financeiro,	
          vl_plano_financeiro,		
          nm_historico_movimento,
          cd_historico_financeiro,
          cd_tipo_operacao,	        -- (1) Débito, (2) Crédito
          cd_moeda,			-- usar (1) Real
          cd_usuario,
          dt_usuario,
          ic_lancamento_automatico )
        select 
          @Chave,
          PlanoFinanceiro,
          1,                            -- Previsto
          DataLcto,
          VlrLancamento,
          Historico,
          null,
          case when @TipoLcto=9 then 1 else TipoLcto end,
          1,
          @cd_usuario,
          GetDate(),
          'S'
        from
          #LctoAutomaticoPrevisto
        where
          TipoLcto        = @TipoLcto and
          DataLcto        = @DataLcto and
          PlanoFinanceiro = @PlanoFinanceiro  

        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @Chave, 'D'
     
        delete 
          #LctoAutomaticoPrevisto
        where
          TipoLcto = @TipoLcto and
          DataLcto = @DataLcto and
          PlanoFinanceiro = @PlanoFinanceiro

      end
  
  -------------------------------------------------------------------------------
  -- REALIZADO
  -------------------------------------------------------------------------------

    -- CONTAS A PAGAR
    insert into
      #LctoAutomaticoRealizado  
    select    
      1					  			as 'TipoLcto',
      cast(cast(p.dt_pagamento_documento as int) as datetime) 	as 'DataLcto',
      d.cd_plano_financeiro		   			as 'PlanoFinanceiro',
      sum(isnull(p.vl_pagamento_documento,0) + 
          isnull(p.vl_juros_documento_pagar,0) -
          isnull(p.vl_desconto_documento,0) +
          isnull(p.vl_abatimento_documento,0)) 			as 'VlrLancamento',
      'Lcto. Autom. SCP'		   			as 'Historico'
    from
      Documento_Pagar_Pagamento p      with (nolock)
      left outer join Documento_Pagar d with (nolock)
      on
      d.cd_documento_pagar = p.cd_documento_pagar
    where
      p.dt_pagamento_documento between @dt_inicial and @dt_final and       
      d.dt_cancelamento_documento is null and
      d.cd_plano_financeiro       is not null and
      p.dt_pagamento_documento    is not null
    group by
      d.cd_plano_financeiro, 
      cast(cast(p.dt_pagamento_documento as int) as datetime)

    -- CONTAS A PAGAR - RATEIO POR PLANO FINANCEIRO
    -- select * from documento_pagar_plano_financ

    insert into
      #LctoAutomaticoRealizado
    select    
      9					  			as 'TipoLcto',
      cast(cast(p.dt_pagamento_documento as int) as datetime)	as 'DataLcto',
      df.cd_plano_financeiro		 			as 'PlanoFinanceiro',
      --sum(isnull(df.vl_plano_financeiro,0))			as 'VlrLancamento',
      sum(isnull(p.vl_pagamento_documento,0) + 
          isnull(p.vl_juros_documento_pagar,0) -
          isnull(p.vl_desconto_documento,0) +
          isnull(p.vl_abatimento_documento,0) *
      (df.pc_plano_financeiro/100))      			as 'VlrLancamento',

      'Lcto.Autom.Realizado SCP Rateio' 			as 'Historico'
    from
      Documento_Pagar_Pagamento p                with (nolock)
      left outer join Documento_Pagar d          with (nolock) on d.cd_documento_pagar  = p.cd_documento_pagar
      inner join Documento_Pagar_Plano_Financ df with (nolock) on df.cd_documento_pagar = p.cd_documento_pagar
    where
      p.dt_pagamento_documento between @dt_inicial and @dt_final and       
      d.dt_cancelamento_documento is null     and
      --d.cd_plano_financeiro       is not null and
      p.dt_pagamento_documento    is not null and 
      isnull(d.cd_plano_financeiro,0)=0       and
      isnull(df.cd_plano_financeiro,0)>0      and
      isnull(df.vl_plano_financeiro,0)>0      and
      df.cd_plano_financeiro not in ( select PlanoFinanceiro from #LctoAutomaticoPrevisto )

    group by 
      df.cd_plano_financeiro, 
      cast(cast(p.dt_pagamento_documento as int) as datetime)

    -- CONTAS A RECEBER

    insert into
      #LctoAutomaticoRealizado
    select    
      2					                      as 'TipoLcto',
      cast(cast(p.dt_pagamento_documento as int) as datetime) as 'DataLcto',
      d.cd_plano_financeiro                                   as 'PlanoFinanceiro',
      sum(isnull(p.vl_pagamento_documento,0) - 
          isnull(p.vl_juros_pagamento,0) +
          isnull(p.vl_desconto_documento,0) +
          isnull(p.vl_abatimento_documento,0) -
          isnull(p.vl_despesa_bancaria,0) +
          isnull(p.vl_reembolso_documento,0) +
          isnull(p.vl_credito_pendente,0)) as 'VlrLancamento',
      'Lcto. Autom. SCR'		   as 'Historico'
    from
      Documento_Receber_Pagamento p with (nolock)
    left outer join
      Documento_Receber d
    on
      d.cd_documento_receber = p.cd_documento_receber
    where
      p.dt_pagamento_documento between @dt_inicial and @dt_final and       
      d.dt_cancelamento_documento is null and
      d.cd_plano_financeiro is not null   and
      p.dt_pagamento_documento is not null
    group by 
      d.cd_plano_financeiro,
      cast(cast(p.dt_pagamento_documento as int) as datetime)      

    while exists(select top 1 TipoLcto from #LctoAutomaticoRealizado)
      begin

        select
          @TipoLcto        = TipoLcto,
          @DataLcto        = DataLcto,
          @PlanoFinanceiro = PlanoFinanceiro
        from
          #LctoAutomaticoRealizado

        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento', @codigo = @Chave output

        insert into Plano_Financeiro_Movimento (
          cd_movimento,			-- Chave
          cd_plano_financeiro,		
          cd_tipo_lancamento_fluxo,	-- (1) Previsto, (2) Realizado
          dt_movto_plano_financeiro,	
          vl_plano_financeiro,		
          nm_historico_movimento,
          cd_historico_financeiro,
          cd_tipo_operacao,	        -- (1) Débito, (2) Crédito
          cd_moeda,			-- usar (1) Real
          cd_usuario,
          dt_usuario,
          ic_lancamento_automatico )
        select 
          @Chave,
          PlanoFinanceiro,
          2,   -- Realizado
          DataLcto,
          VlrLancamento,
          Historico,
          null,
          case when @TipoLcto=9 then 1 else TipoLcto end,
          1,
          @cd_usuario,
          GetDate(),
          'S'
        from
          #LctoAutomaticoRealizado
        where
          TipoLcto        = @TipoLcto and
          DataLcto        = @DataLcto and
          PlanoFinanceiro = @PlanoFinanceiro  

        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @Chave, 'D'
     
        delete 
          #LctoAutomaticoRealizado
        where
          TipoLcto = @TipoLcto and
          DataLcto = @DataLcto and
          PlanoFinanceiro = @PlanoFinanceiro

      end

    -- atualiza o flag de que é necessário atualizar o fluxo na empresa

    update
      Parametro_Financeiro
    set
      ic_fluxo_caixa_empresa = 'S'
    where
      cd_empresa = dbo.fn_Empresa()
  
