
create procedure pr_atualiza_conta_banco_saldo
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Atualiza a tabela de CONTA_BANCO_SALDO
--Data: 08/07/2002
--Atualização: 13/02/2003 - ELIAS (retirado a atualização por plano_financeiro)
---------------------------------------------------
@cd_conta_banco int,
@dt_lancamento DateTime,
@cd_plano_financeiro int,
@cd_tipo_lancamento_fluxo int,
@cd_moeda int,
@cd_usuario int
as

  Declare @dt_contador               DateTime
  Declare @vl_calcula                float
  Declare @vl_saldo_inicial          float
  Declare @cd_tipo_operacao_inicial  int
  Declare @vl_saldo_final            float
  Declare @cd_tipo_operacao_final    int
  Declare @vl_entrada                float
  Declare @vl_saida                  float    

    --Deleta todos os saldos desde até o @dt_lancamento até o último lançamento da tabela de Conta_Banco_Saldo
    Delete Conta_Banco_Saldo
    Where dt_saldo_conta_banco >= @dt_lancamento and
          cd_conta_banco = @cd_conta_banco and
          --cd_plano_financeiro = @cd_plano_financeiro and
          cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo

    --Cria tabela com todas as entradas deste a data do lancamento até a data de hoje    
    Select 
      cd_conta_banco,
      Cast(Cast(dt_lancamento as int) as DateTime) as dt_lancamento,
      Cast(SUM(vl_lancamento) as float) as 'vl_entrada',
      Cast(0 as float) as 'vl_saida'
    Into
      #ValorEntrada
    from 
      Conta_Banco_Lancamento
    Where
      cd_tipo_operacao = 1 and
      cd_conta_banco = @cd_conta_banco and 
--      cd_plano_financeiro = @cd_plano_financeiro and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      dt_lancamento >= @dt_lancamento
    Group By 
      cd_conta_banco, 
      Cast(Cast(dt_lancamento as int) as DateTime)

    --Cria tabela com todas as Saidas deste a data do lancamento até a data de hoje    
    Select 
      cd_conta_banco,
      Cast(Cast(dt_lancamento as int) as DateTime) as dt_lancamento,
      Cast(0 as float) as 'vl_entrada',
      Cast(SUM(vl_lancamento) as float) as 'vl_saida'
    Into
      #ValorSaida
    from 
      Conta_Banco_Lancamento
    Where
      cd_tipo_operacao = 2 and
      cd_conta_banco = @cd_conta_banco and 
--      cd_plano_financeiro = @cd_plano_financeiro and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      dt_lancamento >= @dt_lancamento
    Group By 
      cd_conta_banco, 
      Cast(Cast(dt_lancamento as int) as DateTime)

    -- Cria uma tabela com todas as entradas e saidas
    Select 
      IsNull(a.cd_conta_banco, b.cd_conta_banco) as 'cd_conta_banco',
      IsNull(a.dt_lancamento, b.dt_lancamento) as 'dt_lancamento',
      IsNull(a.vl_entrada,0) + IsNull(b.vl_entrada,0) as 'vl_entrada',
      (IsNull(a.vl_saida,0) + IsNull(b.vl_saida,0)) as 'vl_saida'
    Into
      #Lancamentos
    From 
      #ValorEntrada a Full Outer join 
      #ValorSaida b
        on a.cd_conta_banco = b.cd_conta_banco and
           a.dt_lancamento = b.dt_lancamento
    Order by
      dt_lancamento,
      cd_conta_banco

--     Set @dt_contador = @dt_lancamento

    -- Pega a data do lançamento mais antiga para atualizar
    -- a partir da data do lançamento
    Select @dt_contador = min(dt_lancamento)
    from Conta_Banco_Lancamento
    where 
--      cd_plano_financeiro = @cd_plano_financeiro and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      dt_lancamento >= @dt_lancamento

    --Atualização da Tabela
    While @dt_contador <= (Select Max(dt_lancamento) From Conta_Banco_Lancamento 
                           where cd_conta_banco = @cd_conta_banco and 
                                 cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo) -- and 
                                 --cd_plano_financeiro = @cd_plano_financeiro)
    Begin
       
      begin tran
        
      --Zera variáveis
      Set @vl_calcula       = 0
      Set @vl_saldo_inicial = 0  Set @vl_saldo_final   = 0
      Set @vl_entrada       = 0  Set @vl_saida         = 0

      --Pega o Saldo Anterior      
      Select @vl_saldo_inicial = IsNull(dbo.fn_getsaldo_ant_cb(@dt_contador, @cd_conta_banco, @cd_plano_financeiro, @cd_tipo_lancamento_fluxo),0)

      If @vl_saldo_inicial >= 0
      Begin
        Set @cd_tipo_operacao_inicial = 1
      End Else Begin
        Set @cd_tipo_operacao_inicial = 2
      End
       
      --Pega Valores a serem tratados
      Select
        @vl_entrada = IsNull(vl_entrada,0),
        @vl_saida   = IsNull(vl_saida,0)
      From #Lancamentos
      Where dt_lancamento = @dt_contador
        
      --Trata o Saldo Final
      Set @vl_calcula     = IsNull(@vl_entrada,0) - IsNull(@vl_saida,0)
      Set @vl_saldo_final = IsNull(@vl_Saldo_inicial,0) + IsNull(@vl_calcula,0)

      If @vl_saldo_final >= 0
      Begin
        Set @vl_saldo_final = @vl_saldo_final
        Set @cd_tipo_operacao_final = 1
      End Else Begin
        Set @vl_saldo_final = @vl_saldo_final * (-1)
        Set @cd_tipo_operacao_final = 2
      End
                 
      -- Verifica valores negativos
      If @vl_saldo_inicial < 0
        Set @vl_saldo_inicial = @vl_saldo_inicial *(-1)   

      If @vl_saldo_final < 0
        Set @vl_saldo_final = @vl_saldo_final *(-1)

      If @vl_entrada < 0
        Set @vl_entrada = @vl_entrada *(-1)

      If @vl_saida < 0
        Set @vl_saida = @vl_saida *(-1)

      -- atualização
      Insert Into
        Conta_Banco_Saldo
        (cd_conta_banco, 
         dt_saldo_conta_banco,
         vl_saldo_inicial_conta_banco,
         cd_tipo_operacao_inicial,
         vl_saldo_final_conta_banco,
         cd_tipo_operacao_final,
         vl_entrada_conta_banco,
         vl_saida_conta_banco,
         cd_tipo_lancamento_fluxo,
         --cd_plano_financeiro,
         cd_moeda,
         cd_usuario,
         dt_usuario)
      Values 
        (@cd_conta_banco, 
         @dt_contador,
         IsNull(@vl_saldo_inicial,0),
         @cd_tipo_operacao_inicial,
         IsNull(@vl_saldo_final,0),
         @cd_tipo_operacao_final,
         IsNull(@vl_entrada,0),
         IsNull(@vl_saida,0),
         @cd_tipo_lancamento_fluxo,         
         --@cd_plano_financeiro,
         @cd_moeda,
         @cd_usuario,
         GetDate())
      
      commit tran

      Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U')) 
      -- Tratar próxima data do saldo.....senão tiver lançamentos para o próximo dia 
      --   pegar o próximo com lançamento
      declare @valor int
      set @valor = -1

      if @dt_contador > (Select Max(dt_lancamento) From Conta_banco_Lancamento where cd_conta_banco = @cd_conta_banco and cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)-- and cd_plano_financeiro = @cd_plano_financeiro)
        set @valor = 1

      while @valor < 0
      begin
          
        if @dt_contador > (Select Max(dt_lancamento) From Conta_banco_Lancamento where cd_conta_banco = @cd_conta_banco and cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)-- and cd_plano_financeiro = @cd_plano_financeiro)
          set @valor = 1
        Else Begin
          if not exists(Select 'X' From Conta_Banco_Lancamento
                     Where dt_lancamento = @dt_contador and
                           cd_conta_banco = @cd_conta_banco and 
                           cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)-- and 
                           --cd_plano_financeiro = @cd_plano_financeiro)--'2002-07-03')
          begin
            Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U')) 
          end Else begin
            set @valor = 1
          end
        end
      End
    End
-- GO

-- =============================================
-- Testando a procedure
-- =============================================
-- EXECUTE pr_atualiza_conta_banco_saldo
-- @cd_conta_banco           = 1,
-- @dt_lancamento            = '2002-07-01',
-- @cd_plano_financeiro      = 1,
-- @cd_tipo_lancamento_fluxo = 1,
-- @cd_usuario               = 5
