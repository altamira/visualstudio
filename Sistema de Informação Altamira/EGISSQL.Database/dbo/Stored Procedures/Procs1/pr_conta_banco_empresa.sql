
create procedure pr_conta_banco_empresa
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias Pereira da Silva
--Banco de Dados: EgisSql
--Objetivo: Consulta do extrato por Empresa
--Data: 09/04/2003
--Atualizado: 
---------------------------------------------------
@ic_parametro int,
@cd_empresa int,
@dt_inicial datetime,
@dt_final datetime

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Lista o extrato bancário p/ Empresa (Analítico)
-------------------------------------------------------------------------------
  begin

    select
      l.cd_lancamento,
      e.nm_empresa,
      cast(b.cd_numero_banco as varchar) + '/' +
      cast(a.cd_numero_agencia_banco as varchar) + '/' +
      cast(c.nm_conta_banco as varchar) as 'cd_conta_banco',
      p.cd_mascara_plano_financeiro+' - '+p.nm_conta_plano_financeiro as 'nm_conta_plano_financeiro',
      l.dt_lancamento,
      l.nm_historico_lancamento,
      case when l.cd_tipo_operacao = 2 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_debito',
      case when l.cd_tipo_operacao = 1 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_credito'
    from
      conta_banco_lancamento l
    left outer join
      conta_agencia_banco c
    on
      c.cd_conta_banco = l.cd_conta_banco 
    left outer join
      banco b
    on
      b.cd_banco = c.cd_banco
    left outer join
      agencia_banco a
    on
      a.cd_agencia_banco = c.cd_agencia_banco      
    left outer join
      plano_financeiro p
    on
      p.cd_plano_financeiro = l.cd_plano_financeiro
    left outer join
      moeda m
    on
      m.cd_moeda = l.cd_moeda
    left outer join
      EgisAdmin.dbo.Empresa e
    on
      e.cd_empresa = l.cd_empresa
    where
      cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_inicial,103) as datetime) and cast(convert(int,@dt_final,103) as datetime) and
      ((l.cd_empresa = @cd_empresa) or (@cd_empresa=0))
    order by
      l.dt_lancamento,
      l.cd_conta_banco,
      l.cd_lancamento
  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Lista o extrato bancário p/ Empresa (Sintético)
-------------------------------------------------------------------------------
  begin
    select
      e.nm_empresa as 'Empresa',
    (select sum(cast(t.vl_lancamento  as numeric(25,2))) from conta_banco_lancamento t 
     where (t.cd_empresa = e.cd_empresa) and
      t.cd_tipo_operacao = 2 and cast(convert(int,t.dt_lancamento,103) as datetime) between cast(convert(int,@dt_inicial,103) as datetime) and cast(convert(int,@dt_final,103) as datetime)) as 'vl_debito',
    (select sum(cast(t.vl_lancamento  as numeric(25,2))) from conta_banco_lancamento t 
     where (t.cd_empresa = e.cd_empresa) and
      t.cd_tipo_operacao = 1 and cast(convert(int,t.dt_lancamento,103) as datetime) between cast(convert(int,@dt_inicial,103) as datetime) and cast(convert(int,@dt_final,103) as datetime)) as 'vl_credito'

--       case when l.cd_tipo_operacao = 2 then sum(cast(l.vl_lancamento  as numeric(25,2))) else 0 end as 'vl_debito',
--       case when l.cd_tipo_operacao = 1 then sum(cast(l.vl_lancamento  as numeric(25,2))) else 0 end as 'vl_credito'
    from
      conta_banco_lancamento l 
    left outer join
      EgisAdmin.dbo.Empresa e
    on
      e.cd_empresa = l.cd_empresa
    where
      ((l.cd_empresa = @cd_empresa) or (@cd_empresa=0)) and
      cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_inicial,103) as datetime) and cast(convert(int,@dt_final,103) as datetime)
    group by 
      e.nm_empresa, --l.cd_tipo_operacao     
      e.cd_empresa
    order by
      e.nm_empresa

  end

