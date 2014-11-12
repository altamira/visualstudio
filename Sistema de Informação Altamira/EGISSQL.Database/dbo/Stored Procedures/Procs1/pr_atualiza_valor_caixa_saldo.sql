
create procedure pr_atualiza_valor_caixa_saldo
------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Igor Gama
--Banco de Dados: EgisSql
--Objetivo      : Atualiza o Saldo do Caixa
--Data          : 01/07/2002
--Atualizado    : 04/07/2002 - reformular cálculo do saldo - Igor Gama
--Revisão       : 06.09.2005 - Revisão - Carlos Fernandes
--              : 02.01.2006 - Atualização do Valor do Saldo, não apagar o registro Manual - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------
@cd_plano_financeiro int = 0,
@dt_lancamento       dateTime,
@cd_moeda            int,
@cd_tipo_caixa       int,
@cd_usuario          int
as

  Declare @dt_contador               DateTime
  Declare @vl_calcula                float
  Declare @dt_saldo_caixa            DateTime
  Declare @vl_saldo_inicial          float
  Declare @cd_tipo_operacao_inicial  int
  Declare @vl_saldo_final            float
  Declare @cd_tipo_operacao_final    int
  Declare @vl_entrada                float
  Declare @vl_saida                  float

    --Deleta todos os saldos desde até o @dt_lancamento até o último lançamento da tabela de Plano_Financeiro_Movimento

    Delete Caixa_Saldo
    Where dt_saldo_caixa >= @dt_lancamento and
          cd_tipo_caixa  =  @cd_tipo_caixa and
          isnull(ic_manual_caixa_saldo,'N')='N'
          
          --cd_plano_financeiro = @cd_plano_financeiro

    --Cria tabela com todas as entradas deste a data do lancamento até a data de hoje    

    Select 
      cd_tipo_caixa,
--    cd_plano_financeiro,
      Cast(Cast(dt_lancamento_caixa as int) as DateTime) as dt_lancamento_caixa,
      Cast(SUM(isnull(vl_lancamento_caixa,0)) as float)  as 'vl_entrada',
      Cast(0 as float)                                   as 'vl_saida'
    Into
      #ValorEntrada
    from 
      Caixa_Lancamento
    Where
      cd_tipo_operacao    = 2 and      --Entrada/Receitas
      cd_tipo_caixa       = @cd_tipo_caixa and
      --cd_plano_financeiro = @cd_plano_financeiro and 
      dt_lancamento_caixa >= @dt_lancamento
    Group By 
      --cd_plano_financeiro, 
      cd_tipo_caixa,
      Cast(Cast(dt_lancamento_caixa as int) as DateTime)

    --select * from #ValorEntrada

    --Cria tabela com todas as Saidas deste a data do lancamento até a data de hoje    
    Select 
      --cd_plano_financeiro,
      cd_tipo_caixa,
      Cast(Cast(dt_lancamento_caixa as int) as DateTime) as dt_lancamento_caixa,
      Cast(0 as float)                                   as 'vl_entrada',
      Cast(SUM(isnull(vl_lancamento_caixa,0)) as float)  as 'vl_saida'
    Into
      #ValorSaida
    from 
      Caixa_Lancamento
    Where
      cd_tipo_operacao = 1 and    --Saída / Despesas
      cd_tipo_caixa    = @cd_tipo_caixa and
      --cd_plano_financeiro = @cd_plano_financeiro and 
      dt_lancamento_caixa >= @dt_lancamento
    Group By 
      --cd_plano_financeiro, 
      cd_tipo_caixa,
      Cast(Cast(dt_lancamento_caixa as int) as DateTime)

    --select * from #Valorsaida
    -- Cria uma tabela com todas as entradas e saidas

    Select 
      --IsNull(a.cd_plano_financeiro, b.cd_plano_financeiro) as 'cd_plano_financeiro',
      isnull(a.cd_tipo_caixa,b.cd_tipo_caixa)              as 'cd_tipo_caixa',
      IsNull(a.dt_lancamento_caixa, b.dt_lancamento_caixa) as 'dt_lancamento_caixa',
      IsNull(a.vl_entrada,0) + IsNull(b.vl_entrada,0)      as 'vl_entrada',
      (IsNull(a.vl_saida,0) + IsNull(b.vl_saida,0))        as 'vl_saida'
    Into
      #Lancamentos
    From 
      #ValorEntrada a Full Outer join 
      #ValorSaida b
        on --a.cd_plano_financeiro = b.cd_plano_financeiro and
           a.cd_tipo_caixa       = b.cd_tipo_caixa and
           a.dt_lancamento_caixa = b.dt_lancamento_caixa
    Order by
      dt_lancamento_caixa,
      --cd_plano_financeiro
      cd_tipo_caixa

    -- Set @dt_contador = @dt_lancamento
    -- Pega a data do lançamento mais antiga para atualizar
    -- a partir da data do lançamento

    --select * from #Lancamentos

    Select @dt_contador = min(dt_lancamento_caixa)
    from Caixa_Lancamento
    where 
    --cd_plano_financeiro = @cd_plano_financeiro and
      cd_tipo_caixa = @cd_tipo_caixa and
      dt_lancamento_caixa >= @dt_lancamento

    --Atualização da Tabela
    While @dt_contador <= (Select Max(dt_lancamento_caixa) From Caixa_Lancamento where cd_tipo_caixa = @cd_tipo_caixa)--cd_plano_financeiro = @cd_plano_financeiro)
    Begin
       
      begin tran
        
      --Zera variáveis
      Set @vl_calcula       = 0
      Set @vl_saldo_inicial = 0 
      Set @vl_saldo_final   = 0
      Set @vl_entrada       = 0  
      Set @vl_saida         = 0

      --Pega o Saldo Anterior      
      --Select @vl_saldo_inicial = IsNull(dbo.fn_getsaldo_ant_cx(@dt_contador,@cd_plano_financeiro),0)
      Select @vl_saldo_inicial = IsNull(dbo.fn_getsaldo_ant_cx(@dt_contador,@cd_tipo_caixa),0)
      --Select @vl_saldo_inicial

      If @vl_saldo_inicial >= 0
      Begin
        Set @cd_tipo_operacao_inicial = 2
      End Else Begin
        Set @cd_tipo_operacao_inicial = 1
      End
       
      --Pega Valores a serem tratados
      Select
        @vl_entrada = IsNull(vl_entrada,0),
        @vl_saida   = IsNull(vl_saida,0)
      From #Lancamentos
      Where dt_lancamento_caixa = @dt_contador
        
      --Trata o Saldo Final
      Set @vl_calcula     = IsNull(@vl_entrada,0) - IsNull(@vl_saida,0)
      Set @vl_saldo_final = IsNull(@vl_Saldo_inicial,0) + IsNull(@vl_calcula,0)

      --select @vl_Saldo_inicial, @vl_calcula, @vl_entrada, @vl_saida

      if @vl_saldo_final >= 0
      begin
        --Set @vl_saldo_final         = @vl_saldo_final
        Set @cd_tipo_operacao_final = 2
      End Else Begin
        --Set @vl_saldo_final         = @vl_saldo_final * (-1)
        Set @cd_tipo_operacao_final = 1
      End

      -- Verifica valores negativos
--       If @vl_saldo_inicial < 0
--         Set @vl_saldo_inicial = @vl_saldo_inicial *(-1)   
-- 
--       If @vl_saldo_final < 0
--         Set @vl_saldo_final = @vl_saldo_final *(-1)
-- 
--       If @vl_entrada < 0
--         Set @vl_entrada = @vl_entrada *(-1)
-- 
--       If @vl_saida < 0
--         Set @vl_saida = @vl_saida *(-1)

      --select @vl_saldo_final

      --Verifica se Existe o Registro na Tabela
      --Sim - Update
      --Não - Insert

      if not exists ( select top 1 cd_tipo_caixa from Caixa_Saldo where cd_tipo_caixa  = @cd_tipo_caixa and
                                                                        dt_saldo_caixa = @dt_contador )
      begin
        -- atualização
        Insert Into
          Caixa_Saldo
         (cd_tipo_caixa, 
          dt_saldo_caixa,
          vl_saldo_inicial_caixa,
          cd_tipo_operacao_inicial,
          vl_saldo_final_caixa,
          cd_tipo_operacao_final,
          vl_entrada,
          vl_saida,
          cd_moeda,
          cd_plano_financeiro,
          cd_usuario,
          dt_usuario,
          ic_manual_caixa_saldo)
       Values 
         (@cd_tipo_caixa, 
          @dt_contador,
          IsNull(@vl_saldo_inicial,0),
          @cd_tipo_operacao_inicial,
          IsNull(@vl_saldo_final,0),
          @cd_tipo_operacao_final,
          IsNull(@vl_entrada,0),
          IsNull(@vl_saida,0),
          @cd_moeda,
          @cd_plano_financeiro,         
          @cd_usuario,
          GetDate(),
          'N')
      end
      else
        begin
          Update
            Caixa_Saldo
          set
            vl_saldo_inicial_caixa  = @vl_saldo_inicial,
            vl_saldo_final_caixa    = @vl_saldo_final,
            vl_entrada              = @vl_entrada,
            vl_saida                = @vl_saida
          where 
           cd_tipo_caixa = @cd_tipo_caixa and dt_saldo_caixa = @dt_contador and
           isnull(ic_manual_caixa_saldo,'N') = 'N'

        end

      commit tran

      Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U')) 

      -- Tratar próxima data do saldo.....senão tiver lançamentos para o próximo dia 
      -- pegar o próximo com lançamento

      declare @valor int
      set @valor = -1

      if @dt_contador > (Select Max(dt_lancamento_caixa) From Caixa_Lancamento 
                         where cd_tipo_caixa = @cd_tipo_caixa)
        set @valor = 1

      while @valor < 0
      begin
        if @dt_contador > (Select Max(dt_lancamento_caixa) From Caixa_Lancamento 
                           where cd_tipo_caixa = @cd_tipo_caixa)
          set @valor = 1
        Else Begin
          if not exists(Select 'X' From Caixa_Lancamento
                     Where dt_lancamento_caixa = @dt_contador and
                           cd_tipo_caixa       = @cd_tipo_caixa)--'2002-07-03')
          begin
             Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U')) 
          end Else begin
            set @valor = 1
          end
        end
      End

    End

 