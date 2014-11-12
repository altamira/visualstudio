
Create function fn_getsaldo_ant_cx
-----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-----------------------------------------------------------------------------------------------------------------
--Function       : Microsoft SQL Server       2000
--Autor(es)      : Igor Gama
--Banco de Dados : SQL
--Objetivo       : Trazer o saldo anterior da tabela 
--                 Caixa_Saldo
--Data           : 01/07/2002
--Atualizado     : 06.09.2005 - Modificação para busca do Saldo por Tipo de Caixa
-----------------------------------------------------------------------------------------------------------------
(@dt_saldo      datetime,
 @cd_tipo_caixa int)        --@cd_planoi_financeiro
RETURNS float
-- @vl_saldo int output
AS
BEGIN

  Declare @vl_saldo          float
  Declare @cd_tipo_operacao  int
  Declare @valor             float
  Declare @tentativas        int

  --
  Set @tentativas = 0
  Set @valor      = -1
  Set @dt_saldo   = (@dt_saldo-1)

  If Exists (Select 'X' From Caixa_Saldo where dt_saldo_caixa <= @dt_saldo)
  Begin
  
    While @valor < 0
    Begin

      If @tentativas < 100
      Begin
        If Exists (Select 'X' From Caixa_Saldo where dt_saldo_caixa = @dt_saldo)
        Begin
          select 
            @cd_tipo_operacao = cd_tipo_operacao_final,
            @vl_saldo         = isnull(vl_saldo_final_caixa,0)
          from 
            Caixa_Saldo 
          where 
            dt_saldo_caixa      = @dt_saldo and
            cd_tipo_caixa       = @cd_tipo_caixa
            --cd_plano_financeiro = @cd_plano_financeiro

          Set @valor = 1
        End Else
          set @dt_saldo = (@dt_saldo-1)
      
      End Else
        Set @valor = 1

      Set @tentativas = @tentativas + 1
    End
  end

  --If @cd_tipo_operacao = 2
  --  Set @vl_saldo = @vl_saldo * (-1)

  return(IsNULL(@vl_saldo,0))

End
