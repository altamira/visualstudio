


CREATE PROCEDURE pr_plano_financeiro_saldo
@cd_plano_financeiro int,
@dt_inicial DateTime,
@dt_final Datetime  
AS

  Select *
  From Plano_Financeiro_Saldo
  Where
    cd_plano_financeiro = @cd_plano_financeiro
    and dt_saldo_plano_financeiro between @dt_inicial and @dt_final
  Order By
    dt_saldo_plano_financeiro


