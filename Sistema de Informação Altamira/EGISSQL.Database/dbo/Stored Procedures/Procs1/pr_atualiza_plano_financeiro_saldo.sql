
CREATE PROCEDURE pr_atualiza_plano_financeiro_saldo
---------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Igor Gama
--Banco de Dados : SQL
--Objetivo       : Atualizar Plano_Financeiro_Saldo
--Data           : 26/06/2002
--Atualizado     : 08.03.2006 - Revisão Geral - Carlos Fernandes
--               : 28.10.2007 - Carlos Fernandes
-------------------------------------------------------------------
@cd_plano_financeiro      int,
@cd_tipo_lancamento_fluxo int,
@dt_lancamento            DateTime,
@cd_usuario               int

-- @vl_entrada          numeric(25,2),
-- @vl_saida            numeric(25,2)

AS

  Declare @dt_contador               DateTime
  Declare @vl_calcula                float
  Declare @dt_saldo_plano_financeiro DateTime
  Declare @vl_saldo_inicial          float
  Declare @cd_tipo_operacao_inicial  int
  Declare @vl_saldo_final            float
  Declare @cd_tipo_operacao_final    int
  Declare @vl_entrada                float
  Declare @vl_saida                  float

    --Deleta todos os saldos desde até o @dt_lancamento até o último lançamento da tabela de Plano_Financeiro_Movimento
--    Delete Plano_Financeiro_Saldo
--    Where dt_saldo_plano_financeiro >= @dt_lancamento and
--          cd_plano_financeiro = @cd_plano_financeiro and
--          cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo


    --Cria tabela com todas as entradas deste a data do lancamento até a data de hoje    

    Select 
      cd_plano_financeiro, 
      Cast(Cast(dt_movto_plano_financeiro as int) as DateTime) as 'dt_movto_plano_financeiro',
      Cast(SUM(isnull(vl_plano_financeiro,0))     as float   ) as 'vl_entrada',
      Cast(0 as float) as 'vl_saida'
    Into
      #ValorEntrada
    from 
      Plano_Financeiro_Movimento
    Where
      cd_tipo_operacao           = 2 and
      cd_plano_financeiro        = @cd_plano_financeiro and 
      cd_tipo_lancamento_fluxo   = @cd_tipo_lancamento_fluxo and
      dt_movto_plano_financeiro >= @dt_lancamento 
    Group By 
      cd_plano_financeiro, 
      cast(cast(dt_movto_plano_financeiro as int) as DateTime)

    --Cria tabela com todas as Saidas deste a data do lancamento até a data de hoje    
    Select 
      cd_plano_financeiro,
      Cast(Cast(dt_movto_plano_financeiro as int) as DateTime) as 'dt_movto_plano_financeiro',
      Cast(0 as float)                                         as 'vl_entrada',
      Cast(SUM(isnull(vl_plano_financeiro,0)) as float)        as 'vl_saida'
    into 
      #ValorSaida
    from 
      plano_financeiro_movimento
    Where
      cd_tipo_operacao           = 1 and
      cd_plano_financeiro        = @cd_plano_financeiro and 
      cd_tipo_lancamento_fluxo   = @cd_tipo_lancamento_fluxo and
      dt_movto_plano_financeiro >= @dt_lancamento
    Group By 
      cd_plano_financeiro, Cast(Cast(dt_movto_plano_financeiro as int) as DateTime)

    -- Cria uma tabela com todas as entradas e saidas
    Select 
      IsNull(a.cd_plano_financeiro,b.cd_plano_financeiro)             as 'cd_plano_financeiro',
      IsNull(a.dt_movto_plano_financeiro,b.dt_movto_plano_financeiro) as 'dt_movto_plano_financeiro',
      IsNull(a.vl_entrada,0) + IsNull(b.vl_entrada,0)                 as 'vl_entrada',
      (IsNull(a.vl_saida,0) + IsNull(b.vl_saida,0))                   as 'vl_saida'
    Into
      #Lancamentos
    From 
      #ValorEntrada a Full Outer join 
      #ValorSaida b
        on a.cd_plano_financeiro       = b.cd_plano_financeiro and
           a.dt_movto_plano_financeiro = b.dt_movto_plano_financeiro
    Order by
      dt_movto_plano_financeiro, cd_plano_financeiro 

--     Set @dt_contador = @dt_lancamento
    -- Pega a data do lançamento mais antiga para atualizar
    -- a partir da data do lançamento

    Select @dt_contador = min(dt_movto_plano_financeiro)
    from plano_financeiro_movimento
    where 
      cd_plano_financeiro      = @cd_plano_financeiro and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      dt_movto_plano_financeiro >= @dt_lancamento

    --Atualização da Tabela
    While @dt_contador <= (Select Max(dt_movto_plano_financeiro) From Plano_Financeiro_movimento where cd_plano_financeiro = @cd_plano_financeiro and cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
    Begin
         
      begin tran

      --Zera variáveis
      Set @vl_calcula       = 0
      Set @vl_saldo_inicial = 0 
      Set @vl_saldo_final   = 0
      Set @vl_entrada       = 0  
      Set @vl_saida         = 0

      --Pega o Saldo Anterior      
--       print(convert(varchar(20), @dt_contador) + ' data do saldo anteriro')
--       print(str(@cd_plano_financeiro) + ' plano financeiro')
--       print(str(@cd_tipo_lancamento_fluxo) + ' lancamento fluxo')

      Select @vl_saldo_inicial = IsNull(dbo.fn_getsaldo_ant_pf(@dt_contador,@cd_plano_financeiro,@cd_tipo_lancamento_fluxo),0)

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
      Where dt_movto_plano_financeiro = @dt_contador
        
      --Trata o Saldo Final
      Set @vl_calcula     = IsNull(@vl_entrada,0) - IsNull(@vl_saida,0)
      Set @vl_saldo_final = IsNull(@vl_Saldo_inicial,0) + IsNull(@vl_calcula,0)

      If @vl_saldo_final >= 0
      Begin
        Set @vl_saldo_final         = @vl_saldo_final
        Set @cd_tipo_operacao_final = 1
      End
      Else 
      Begin
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

      
      --Verificar se Existe o Saldo na Tabela Plano_Financeiro
    
      if ( not exists ( select top 1 cd_plano_financeiro from plano_financeiro_saldo 
                  where
                    cd_plano_financeiro       = @cd_plano_financeiro        and 
                    dt_saldo_plano_financeiro = @dt_contador                and
                    cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo ) ) and @cd_plano_financeiro>0
        
      begin
        -- inclusão na Tabela Saldo
        Insert Into
         Plano_Financeiro_Saldo
         (cd_plano_financeiro, 
          cd_tipo_lancamento_fluxo,
          dt_saldo_plano_financeiro,
          vl_saldo_inicial,
          cd_tipo_operacao_inicial,
          vl_saldo_final,
          cd_tipo_operacao_final,
          vl_entrada,
          vl_saida,
          cd_usuario,
          dt_usuario)
        Values 
         (@cd_plano_financeiro, 
          @cd_tipo_lancamento_fluxo,
          @dt_contador,
          IsNull(@vl_saldo_inicial,0),
          @cd_tipo_operacao_inicial,
          IsNull(@vl_saldo_final,0),
          @cd_tipo_operacao_final,
          IsNull(@vl_entrada,0),
          IsNull(@vl_saida,0),
          @cd_usuario,
          GetDate())
      end
      else
        begin
          update
            Plano_Financeiro_Saldo
          set
            vl_saldo_inicial         = @vl_saldo_inicial,
            cd_tipo_operacao_inicial = @cd_tipo_operacao_inicial,
            vl_saldo_final           = @vl_saldo_final,
            cd_tipo_operacao_final   = @cd_tipo_operacao_final,
            vl_entrada               = @vl_entrada,
            vl_saida                 = @vl_saida,
            cd_usuario               = @cd_usuario,
            dt_usuario               = getdate()
          where
            cd_plano_financeiro       = @cd_plano_financeiro        and 
            dt_saldo_plano_financeiro = @dt_contador                and
            cd_tipo_lancamento_fluxo  = @cd_tipo_lancamento_fluxo

        end
  
      commit tran

      print('Inserção, data lançamento '+Convert(char(10),@dt_contador, 21)) 

      Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U')) 

      -- Tratar próxima data do saldo.....senão tiver lançamentos para o próximo dia 
      --   pegar o próximo com lançamento

      declare @valor       int
      declare @cd_contador int
      
      Set @cd_contador = 1
      set @valor = -1

      if @dt_contador > (Select Max(dt_movto_plano_financeiro) From Plano_Financeiro_movimento where cd_plano_financeiro = @cd_plano_financeiro and cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
        set @valor = 1

      while @valor < 0
      begin
        if @dt_contador > (Select Max(dt_movto_plano_financeiro) From Plano_Financeiro_movimento where cd_plano_financeiro = @cd_plano_financeiro and cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
          Set @valor = 1
        Else Begin 
          if not exists(Select 'X' From Plano_Financeiro_Movimento 
                     Where dt_movto_plano_financeiro = @dt_contador and
                           cd_plano_financeiro = @cd_plano_financeiro and
                           cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)--'2002-07-03')
          begin
--             Set @dt_contador = (Select dbo.fn_dia_util(@dt_contador +1,'S','U'))
            Set @dt_contador = (@dt_contador +1)
          end Else begin
            set @valor = 1
          end
        End
      End
    End
-- GO
