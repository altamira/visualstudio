


CREATE  function fn_getsaldo_ant_pf
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Function: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: SQL
--Objetivo: Trazer o saldo anterior da tabela 
--  Plano_Financeiro_Saldo
--Data: 26/06/2002
--Atualizado: 
---------------------------------------------------
(@dt_saldo datetime,
 @cd_plano_financeiro int,
 @cd_tipo_lancamento_fluxo int)
RETURNS float
-- @vl_saldo int output
AS
BEGIN

  Declare @vl_saldo float
  Declare @cd_tipo_operacao int
  Declare @valor float
  Declare @tentativas int

  Set @tentativas = 0
  Set @valor      = -1
  Set @dt_saldo   = (@dt_saldo-1)

  If Exists (Select top 1 'X' From dbo.Plano_Financeiro_Saldo 
             where dt_saldo_plano_financeiro <= @dt_saldo and
                   cd_plano_financeiro = @cd_plano_financeiro and
                   cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
  Begin

    While (@valor < 0) 
    Begin

      If @tentativas < 360
      Begin

        If Exists (Select top 1 'X' From dbo.Plano_Financeiro_Saldo 
                   where dt_saldo_plano_financeiro = @dt_saldo and
                     cd_plano_financeiro = @cd_plano_financeiro and
                     cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
        Begin
  
          Select 
            @cd_tipo_operacao = cd_tipo_operacao_final,
            @vl_saldo = vl_saldo_final
          From 
            dbo.Plano_Financeiro_saldo 
          Where 
            dt_saldo_plano_financeiro = @dt_saldo and
            cd_plano_financeiro = @cd_plano_financeiro and
            cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo

          Set @valor = 1
        End Else
          set @dt_saldo = (@dt_saldo-1)
      End Else
        Set @valor = 1  

      Set @tentativas = @tentativas + 1      
    End
  end


  If @cd_tipo_operacao = 1
    Set @vl_saldo = @vl_saldo * (-1)

  return(IsNULL(@vl_saldo,0))

End


