
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina de ajuste dos Saldos de Fechamento
--Data: 01/08/2005
-----------------------------------------------------------------------------------------

create procedure pr_executar_ajuste_saldo
@dt_inicial datetime,
@dt_final datetime,
@cd_fase_produto int,
@cd_usuario int
as

begin

  declare @dt_processamento datetime
  declare @cd_mes int
  declare @cd_ano int

  set @dt_processamento = cast(cast(datepart(mm,@dt_inicial) as varchar(2))+'/01/'+cast(datepart(yy,@dt_inicial) as varchar(4)) as datetime)

  while (@dt_processamento < @dt_final) 
  begin

    set @cd_mes = month(@dt_processamento)
    set @cd_ano = year(@dt_processamento)

    print('Processando...: Fase '+cast(@cd_fase_produto as varchar)+' - '+cast(@cd_mes as varchar)+'/'+cast(@cd_ano as varchar))

    exec pr_diferenca_fechamento_produto 
      @cd_fase_produto, 
      @cd_mes,
      @cd_ano, 'S'

    set @dt_processamento = dateadd(mm, 1, @dt_processamento)

  end


end

