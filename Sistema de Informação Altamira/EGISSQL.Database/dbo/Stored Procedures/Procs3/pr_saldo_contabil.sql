


/****** Object:  Stored Procedure dbo.pr_saldo_contabil    Script Date: 13/12/2002 15:08:42 ******/
CREATE  procedure pr_saldo_contabil
@ic_parametro int,
@cd_empresa   int,
@cd_exercicio int,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_reduzido  int 
as
-------------------------------------------------------------------------------
if @ic_parametro = 1     -- saldos mensais
-------------------------------------------------------------------------------
begin
  declare @vl_saldo_inicial numeric(25,2)
  declare @ic_saldo_inicial char(1)
  declare @vl_saldo_atual   numeric(25,2)
  declare @ic_saldo_atual   char(1)
  declare @vl_debito  numeric(25,2)
  declare @vl_debito_acum numeric(25,2)
  declare @vl_credito numeric(25,2)
  declare @vl_credito_acum numeric(25,2)
  declare @cd_unico int
  set @vl_saldo_inicial = 0
  set @ic_saldo_inicial = ''
  set @vl_saldo_atual   = 0   
  set @ic_saldo_atual   = ''
  set @vl_debito        = 0
  set @vl_debito_acum   = 0
  set @vl_credito       = 0
  set @vl_credito_acum  = 0
  set @cd_unico         = 0
  -- tabela de saldo anterior
  create table #SaldoAnterior (
    cd_conta int,
    vl_saldo_conta float,
    ic_saldo_conta char(1))
  insert
    #SaldoAnterior
  exec pr_saldo_anterior 2, @cd_empresa, @cd_exercicio, @dt_inicial, @cd_reduzido
  -- criaçao da tabela onde serao guardados os saldos mensais
  create table #SaldosMensais (
    dt_mes     datetime,
    vl_debito  numeric(25,2),
    vl_credito numeric(25,2),
    vl_saldo   numeric(25,2),
    ic_saldo   char(1))
  -- tabela vai ser preenchida com o saldo inicial e os meses existentes no período contábil
  -- saldo inicial
  insert 
    #SaldosMensais 
  select
    @dt_inicial - 1,
    0,
    0,
    vl_saldo_conta,
    ic_saldo_conta
  from
    #SaldoAnterior
  select
    @vl_saldo_inicial = vl_saldo_conta,
    @ic_saldo_inicial = ic_saldo_conta
  from
    #SaldoAnterior
  -- tabela de movimentos contábeis do período
  select 
    cast('1/'+cast(month(dt_lancamento_contabil) as varchar(2))+'/'+cast(year(dt_lancamento_contabil) as char(4)) as datetime) as 'dt_mes',
    case when cd_reduzido_debito = @cd_reduzido then
      vl_lancamento_contabil
    else
      0.00
    end as 'vl_debito',
    case when cd_reduzido_credito = @cd_reduzido then
      vl_lancamento_contabil
    else
      0.00
    end as 'vl_credito'    
  into
    #MovimentoContabil
  from    
    movimento_contabil 
  where 
    cd_empresa = @cd_empresa and
    ((cd_reduzido_debito = @cd_reduzido) or 
    (cd_reduzido_credito = @cd_reduzido)) and
    dt_lancamento_contabil between @dt_inicial and @dt_final   
  order by
    dt_mes
  select
    identity(int, 1, 1) as 'cd_unico',
    dt_mes,
    sum(vl_debito) as 'vl_debito',
    sum(vl_credito) as 'vl_credito'
  into
    #SaldosTemp
  from
    #MovimentoContabil
  group by
    dt_mes
  order by 
    dt_mes
  while exists(select top 1 'x' from #SaldosTemp)
    begin
      select
        @cd_unico = cd_unico,
        @vl_debito = vl_debito,
        @vl_credito = vl_credito
      from
        #SaldosTemp 
      order by
        cd_unico desc
      set @vl_saldo_atual = 0.00
      set @ic_saldo_atual = ''
      set @vl_debito_acum = @vl_debito_acum + @vl_debito
      set @vl_credito_acum = @vl_credito_acum + @vl_credito
      if ((@ic_saldo_inicial = 'D') or (@ic_saldo_inicial = ''))
        begin
          if ((@vl_saldo_inicial + @vl_debito_acum - @vl_credito_acum) > 0)
            begin
              set @vl_saldo_atual = @vl_saldo_inicial + @vl_debito_acum - @vl_credito_acum
              set @ic_saldo_atual = 'D'
            end
          if ((@vl_saldo_inicial + @vl_debito_acum - @vl_credito_acum) = 0)
            begin
              set @vl_saldo_atual = 0.00
              set @ic_saldo_atual = ''
            end
          if ((@vl_saldo_inicial + @vl_debito_acum - @vl_credito_acum) < 0)
            begin
              set @vl_saldo_atual = ((@vl_saldo_inicial + @vl_debito_acum - @vl_credito_acum) * (-1))
              set @ic_saldo_atual = 'C'
            end
        end 
      else
        begin
          if ((@vl_saldo_inicial + @vl_credito_acum - @vl_debito_acum) > 0) 
            begin
              set @vl_saldo_atual = @vl_saldo_inicial + @vl_credito_acum - @vl_debito_acum
              set @ic_saldo_atual = 'C'
            end
          if ((@vl_saldo_inicial + @vl_credito_acum - @vl_debito_acum) = 0)
            begin
              set @vl_saldo_atual = 0.00
              set @ic_saldo_atual = ''
            end
          if ((@vl_saldo_inicial + @vl_credito_acum - @vl_debito_acum) < 0)
            begin
              set @vl_saldo_atual = ((@vl_saldo_inicial + @vl_credito_acum - @vl_debito_acum) * (-1))
              set @ic_saldo_atual = 'D'
            end
        end
        
      insert into
        #SaldosMensais
      select
        dt_mes,
        vl_debito,
        vl_credito,
        @vl_saldo_atual,
        @ic_saldo_atual
      from
        #SaldosTemp
      where
        cd_unico = @cd_unico                       
      delete from
        #SaldosTemp
      where
        cd_unico = @cd_unico
    end
  select * from #SaldosMensais
end
   

---------------------------------------------------------------
--Testando a Stored Procedure
---------------------------------------------------------------
--exec pr_saldo_contabil

