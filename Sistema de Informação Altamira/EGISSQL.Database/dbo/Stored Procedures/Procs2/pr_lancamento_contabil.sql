
CREATE PROCEDURE pr_lancamento_contabil
@ic_parametro           int,
@cd_empresa             int,
@cd_reduzido            int,
@dt_pesquisa            datetime,
@dt_inicial             datetime,
@dt_final               datetime,
@cd_historico_contabil  int,
@cd_lancamento_contabil int,
@cd_exercicio           int
as

declare @cd_conta int

begin
  -----------------------------------------------------------------------------
  if (@ic_parametro = 1)     -- pesquisa lançamentos por data passada
  -----------------------------------------------------------------------------
  begin
    select 
		  mc.*, pc.nm_conta as DescricaoContaDebito, pd.nm_conta as DescricaoContaCredito
  	from 
		  movimento_contabil mc 
		left outer join plano_conta pc 
		  on mc.cd_reduzido_debito = pc.cd_conta_reduzido
		left outer join plano_conta pd 
		  on mc.cd_reduzido_credito = pd.cd_conta_reduzido 
		where
		  mc.cd_empresa = @cd_empresa
		and
		  mc.dt_lancamento_contabil = @dt_pesquisa
    and
      mc.cd_exercicio = @cd_exercicio   
		and 
		  pc.cd_empresa = @cd_empresa
		and
		  pd.cd_empresa = @cd_empresa 
		order by 
		  mc.dt_lancamento_contabil
  end
  -----------------------------------------------------------------------------
  if (@ic_parametro = 2)  -- pesquisa lançamentos pela conta passada (reduzido)
  -----------------------------------------------------------------------------
  begin
    select 
		  mc.*, pc.nm_conta as DescricaoContaDebito, pd.nm_conta as DescricaoContaCredito
  	from 
		  movimento_contabil mc 
		left outer join plano_conta pc 
		  on mc.cd_reduzido_debito = pc.cd_conta_reduzido
		left outer join plano_conta pd 
		  on mc.cd_reduzido_credito = pd.cd_conta_reduzido 
    where
      mc.cd_empresa = @cd_empresa
    and
      mc.cd_exercicio = @cd_exercicio   
		and 
		  pc.cd_empresa = @cd_empresa
		and
		  pd.cd_empresa = @cd_empresa 
    and
      mc.dt_lancamento_contabil between @dt_inicial and @dt_final
    and
      (mc.cd_reduzido_debito = @cd_reduzido or mc.cd_reduzido_credito = @cd_reduzido)
    order by 
      mc.dt_lancamento_contabil
  end

  -----------------------------------------------------------------------------
  if (@ic_parametro = 3)  -- pesquisa saldos pela conta passada (reduzido)
  -----------------------------------------------------------------------------
  begin

    -- ATENÇÃO ESTE PARÂMETRO NÃO ESTA SENDO UTILIZADO...

    -- Localiza código reduzido da conta

		set @cd_conta = (select cd_conta 
		                   from plano_conta 
		                  where cd_conta_reduzido = @cd_reduzido)
		
		select 
		  me.nm_mes as Mes,
		  sc.vl_debito_saldo_conta as Debito,
		  sc.vl_credito_saldo_conta as Credito,
		  sc.vl_saldo_conta as Saldo,
		  sc.ic_saldo_conta as Tipo  
		from 
		  saldo_conta sc
		left outer join Mes me
		  on month(sc.dt_saldo_conta) = me.cd_mes   
		where 
		  cd_empresa = @cd_empresa 
		and 
		  cd_conta = @cd_conta

  end

  -----------------------------------------------------------------------------
  if (@ic_parametro = 4)  -- pesquisa lançamentos pelo histórico passado
  -----------------------------------------------------------------------------
  begin
    select 
		  mc.*, pc.nm_conta as DescricaoContaDebito, pd.nm_conta as DescricaoContaCredito
  	from 
		  movimento_contabil mc 
		left outer join plano_conta pc 
		  on mc.cd_reduzido_debito = pc.cd_conta_reduzido
		left outer join plano_conta pd 
		  on mc.cd_reduzido_credito = pd.cd_conta_reduzido 
    where
      mc.cd_empresa = @cd_empresa
    and
      mc.cd_exercicio = @cd_exercicio   
		and 
		  pc.cd_empresa = @cd_empresa
		and
		  pd.cd_empresa = @cd_empresa 
    and
      mc.cd_historico_contabil = @cd_historico_contabil
    order by 
      mc.dt_lancamento_contabil
  end

  -----------------------------------------------------------------------------
  if (@ic_parametro = 5)  -- pesquisa lançamentos pela código do lançamento
  -----------------------------------------------------------------------------
  begin
    select 
		  mc.*, pc.nm_conta as DescricaoContaDebito, pd.nm_conta as DescricaoContaCredito
  	from 
		  movimento_contabil mc 
		left outer join plano_conta pc 
		  on mc.cd_reduzido_debito = pc.cd_conta_reduzido
		left outer join plano_conta pd 
		  on mc.cd_reduzido_credito = pd.cd_conta_reduzido 
    where
      mc.cd_empresa = @cd_empresa
    and
      mc.cd_exercicio = @cd_exercicio   
		and 
		  pc.cd_empresa = @cd_empresa
		and
		  pd.cd_empresa = @cd_empresa 
    and
      mc.cd_lancamento_contabil = @cd_lancamento_contabil
    order by 
      mc.dt_lancamento_contabil
  end
end

