
create procedure pr_atualiza_saldo_plano_conta

--------------------------------------------------------------------------------
--pr_atualiza_saldo_plano_conta
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Atualiza Saldo do Plano de Contas conforme o parâmetro
--Data			: 27/12/2004
--Alteração             : 27/12/2004
--                      : 28/12/2004 - Limpeza do Saldo das Contas de Implantação
--                                   - Encerramentos
--                      : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
----------------------------------------------------------------------------------

@ic_parametro        int = 1,
@cd_conta            int = 0,
@cd_usuario          int = 0,
@dt_inicial          datetime,
@dt_final            datetime

--------------------------------------------------------------------------------
-- Definição dos Parâmetros
--------------------------------------------------------------------------------
-- 1 --> Executa a Limpeza  Completa dos Saldos do Plano de Contas
-- 2 --> Executa a Limpeza  Completa da Tabela de Saldo das Contas
-- 3 --> Executa a Montagem do Saldo do Plano de Contas com o Saldo de Implantação
-- 4 --> Executa a Montagem do Saldo Atual e Total de Movimento Débito/Crédito a partir de um Movimento já digitado
-- 5 --> Executa o Encerramento do Período   
-- 6 --> Executa a Atualização dos Saldos do Plano de Contas com o Saldo de Contas de Encerramento
-- 7 --> Executa a Limpeza Completa dos Saldos da Conta de Implantação
-- 8 --> Executa o Encerramento das Despesas/Receitas
-- 9 --> Executa o Encerramento do  Exercício
---------------------------------------------------------------------------------------------------------------------

as

declare @cd_empresa     int
declare @dt_implantacao datetime

select @cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------------------------------
--Zeramento dos Saldos das Contas do Plano de Contas
-------------------------------------------------------------------------------------------------------

if @ic_parametro=1
begin

   update
      Plano_Conta
   set
      vl_saldo_inicial_conta = 0,
      ic_saldo_inicial_conta = '',
      vl_debito_conta        = 0,
      vl_credito_conta       = 0,
      qt_lancamento_conta    = 0,               
      vl_saldo_atual_conta   = 0,
      ic_saldo_atual_conta   = '',
      cd_usuario             = @cd_usuario,
      dt_usuario             = getdate()

    where
       cd_conta = case when @cd_conta = 0 then cd_conta else @cd_conta end

   --select * from plano_conta

end

-------------------------------------------------------------------------------------------------------
--Deleta as Contas da Tabela de Saldos de Encerramento
-------------------------------------------------------------------------------------------------------


if @ic_parametro=2
begin

  --select * from saldo_conta

  delete from saldo_conta   
  where
     cd_conta = case when @cd_conta = 0 then cd_conta else @cd_conta end

end

---------------------------------------------------------------------------------
--Atualiza os Saldos do Plano de Contas com SALDOS DE IMPLANTAÇÃO
---------------------------------------------------------------------------------


if @ic_parametro = 3
begin

   --Atualização Direto da Tabela -> Saldo_Conta_Implantação

   update
      Plano_Conta
   set
      vl_saldo_inicial_conta = vl_saldo_implantacao,
      ic_saldo_inicial_conta = ic_saldo_implantacao,
      vl_debito_conta        = 0,
      vl_credito_conta       = 0,
      qt_lancamento_conta    = 0,               
      vl_saldo_atual_conta   = vl_saldo_implantacao,
      ic_saldo_atual_conta   = ic_saldo_implantacao,
      cd_usuario             = @cd_usuario,
      dt_usuario             = getdate()
    from
       Plano_Conta pc, 
       Saldo_Conta_Implantacao sci
    where
       pc.cd_conta = sci.cd_conta
    
    -- 06/01/2004 Atualização da tabela saldo_conta com saldo_conta_implantação con saldo_final - psantos

   -- select * from saldo_conta
   -- select * from saldo_conta_implantacao

   select @dt_implantacao = max(dt_implantacao) from Saldo_Conta_Implantacao 

   delete from saldo_conta where dt_saldo_conta = @dt_implantacao

   insert 
      Saldo_Conta (
   cd_empresa,
   cd_conta,
   dt_saldo_conta,
   vl_saldo_conta,
   ic_saldo_conta,
   vl_debito_saldo_conta,
   vl_credito_saldo_conta,
   vl_inicial_saldo_conta,
   ic_inicial_saldo_conta,
   cd_usuario,
   dt_usuario )   
   select 
     cd_empresa,
     cd_conta,
     dt_implantacao,
     vl_saldo_implantacao,
     ic_saldo_implantacao,
     0,
     0,
     0,
     '',
     cd_usuario             = @cd_usuario,
     dt_usuario             = getdate()
    from
       Saldo_Conta_Implantacao sci
	where cd_conta=@cd_conta

    --select * from saldo_conta_implantacao

--  28.12.2004
--   --Montagem da Tabela Auxiliar com as Contas e os Saldos de Implantação
--   --drop table #Aux
--   --select * from saldo_conta_implantacao
-- 
--    select 
--      * 
--    into
--      #Aux
--    from
--      saldo_conta_implantacao 
-- 
--   --select * from #Aux
-- 
--   --Atualização dos Saldos Iniciais com os Saldos de Implantação
-- 
--   declare @cd_contax            int
--   declare @vl_saldo_implantacao float
--   declare @ic_saldo_implantacao char(1)
-- 
--   while exists ( select top 1 cd_conta from #aux )
--   begin
--     select
--       top 1
--       @cd_contax            = cd_conta,
--       @vl_saldo_implantacao = isnull(vl_saldo_implantacao,0),
--       @ic_saldo_implantacao = isnull(ic_saldo_implantacao,'')
--  
--     from
--       #aux
-- 
--      --Rotina de Explosão dos Saldos Conforme Níveis
-- 
--      exec pr_atualiza_valor_plano_conta
--         @ic_parametro   = 1,
--         @cd_empresa     = @cd_empresa,
--         @cd_conta       = @cd_contax, 
--         @ic_movimento   = 'I', 
--         @vl_lancamento  =  @vl_saldo_implantacao,
--         @ic_lancamento  =  @ic_saldo_implantacao,
--         @ic_implantacao = 'S',
--         @cd_usuario     = @cd_usuario
--   
--      delete from #Aux where cd_conta=@cd_contax
-- 
--    end

end

-------------------------------------------------------------------------------------
--Atualiza os Saldos Conforme os Lançamentos Contábeis - Movimento_Contabil
-------------------------------------------------------------------------------------


if @ic_parametro=4
begin

  --select * from movimento_contabil  
  --select * from plano_conta
  --drop table #AuxMov

  select
     identity(int,1,1) as cd_controle,
     mc.vl_lancamento_contabil,
     cd_contadeb  = ( select cd_conta from plano_conta where mc.cd_reduzido_debito  = cd_conta_reduzido ),
     cd_contacred = ( select cd_conta from plano_conta where mc.cd_reduzido_credito = cd_conta_reduzido ),     
     D = case when isnull(mc.cd_reduzido_debito,0)  > 0 then 'D' else '' end,                           
     C = case when isnull(mc.cd_reduzido_credito,0) > 0 then 'C' else '' end                           
  
  into 
     #AuxMov
  from
     Movimento_Contabil mc
  where
     dt_lancamento_contabil between @dt_inicial and @dt_final
--     dt_lancamento_contabil between '12/01/2004' and '12/31/2004'


--  select * from #AuxMov

  --Atualização dos Saldos Iniciais com os Saldos de Implantação

  declare @cd_controle              int
  declare @cd_contadeb              int
  declare @cd_contacred             int
  declare @vl_lancamento_contabil   float
  declare @ic_tipo_deb              char(1)
  declare @ic_tipo_cred             char(1)
  
  while exists ( select top 1 cd_controle from #AuxMov )
  begin

    select
      top 1
      @cd_controle            = cd_controle,
      @cd_contadeb            = cd_contadeb,
      @cd_contacred           = cd_contacred,
      @vl_lancamento_contabil = vl_lancamento_contabil,
      @ic_tipo_deb            = D,
      @ic_tipo_cred           = C
 
    from
      #AuxMov
 
    --select @ic_tipo_deb,@vl_lancamento_contabil,@cd_contadeb
  
    if @ic_tipo_deb='D' and @vl_lancamento_contabil>0 and @cd_contadeb>0
    begin
       
 
      --Rotina de Explosão dos Saldos Conforme Níveis

       exec pr_atualiza_valor_plano_conta
          @ic_parametro   = 1,
          @cd_empresa     = @cd_empresa,
          @cd_conta       = @cd_contadeb, 
          @ic_movimento   = 'I',
          @vl_lancamento  = @vl_lancamento_contabil,
          @ic_lancamento  = @ic_tipo_deb,
          @ic_implantacao = 'N',
          @cd_usuario     = @cd_usuario

     end

    if @ic_tipo_cred='C' and @vl_lancamento_contabil>0 and @cd_contacred>0
    begin
       
 
      --Rotina de Explosão dos Saldos Conforme Níveis

       exec pr_atualiza_valor_plano_conta
          @ic_parametro   = 1,
          @cd_empresa     = @cd_empresa,
          @cd_conta       = @cd_contacred, 
          @ic_movimento   = 'I',
          @vl_lancamento  = @vl_lancamento_contabil,
          @ic_lancamento  = @ic_tipo_cred,
          @ic_implantacao = 'N',
          @cd_usuario     = @cd_usuario

     end

     delete from #AuxMov where cd_controle = @cd_controle

  end 

end

-------------------------------------------------------------------------------------
--Encerramento do Período
-------------------------------------------------------------------------------------

if @ic_parametro=5
begin

  --Atualiza a Tabela de Parâmetros

  update
    parametro_contabil
  set
    --ic_exercicio_ativo     = 'N',
    ic_exercicio_aberto    = 'N',
    ic_exercicio_fechado   = 'S'
  where
    cd_empresa           = @cd_empresa and
    dt_inicial_exercicio = @dt_inicial and     
    dt_final_exercicio   = @dt_final

  --Deleta a atualização da Tabela Saldo Conta com a Data Final

  delete from saldo_conta where dt_saldo_conta = @dt_final

  --Atualiza o Arquivo de Saldo das Contas

  insert saldo_conta(
    cd_empresa,
    cd_conta,
    dt_saldo_conta,
    vl_saldo_conta,
    ic_saldo_conta,
    vl_inicial_saldo_conta,
    ic_inicial_saldo_conta,
    vl_debito_saldo_conta,
    vl_credito_saldo_conta,    
    cd_usuario,
    dt_usuario ) 
  select
    cd_empresa,
    cd_conta,
    @dt_final,
    isnull(vl_saldo_atual_conta,0),
    isnull(ic_saldo_atual_conta,0),
    isnull(vl_saldo_inicial_conta,0),
    isnull(ic_saldo_inicial_conta,''),
    isnull(vl_debito_conta,0),
    isnull(vl_credito_conta,0),   
    @cd_usuario,
    getdate()
   from
     Plano_Conta

   --Atualiza o Plano de Contas com o Saldo Incial sendo o Saldo Atual
  
   update
      Plano_Conta
   set
      vl_saldo_inicial_conta = isnull(vl_saldo_atual_conta,0),
      ic_saldo_inicial_conta = isnull(ic_saldo_atual_conta,''),
      vl_debito_conta        = 0,
      vl_credito_conta       = 0,
      qt_lancamento_conta    = 0,               
      vl_saldo_atual_conta   = isnull(vl_saldo_atual_conta,0),
      ic_saldo_atual_conta   = isnull(ic_saldo_atual_conta,''),
      cd_usuario             = @cd_usuario,
      dt_usuario             = getdate()

end

-------------------------------------------------------------------------------------
--Atualização do Saldo do Plano de Contas com o Saldo das Contas - Encerramento
-------------------------------------------------------------------------------------


if @ic_parametro = 6
begin

  --select * from saldo_conta

  --Montagem da Tabela Auxiliar com as Contas e os Saldos de Encerramento

   select 
     * 
   into
     #AuxSaldo
   from
     Saldo_Conta
   where
     dt_saldo_conta between @dt_inicial and @dt_final


  --Atualização dos Saldos Iniciais com os Saldos de Implantação

  declare @cd_contae            int
  declare @vl_saldo_conta       float
  declare @ic_saldo_conta       char(1)

  while exists ( select top 1 cd_conta from #AuxSaldo )
  begin
    select
      top 1
      @cd_contae            = cd_conta ,
      @vl_saldo_conta       = vl_saldo_conta,
      @ic_saldo_conta       = ic_saldo_conta
 
    from
      #AuxSaldo

     --Rotina de Explosão dos Saldos Conforme Níveis

     exec pr_atualiza_valor_plano_conta
        @ic_parametro   = 1,
        @cd_empresa     = @cd_empresa,
        @cd_conta       = @cd_contae, 
        @ic_movimento   = '', 
        @vl_lancamento  =  @vl_saldo_conta,
        @ic_lancamento  =  @ic_saldo_conta,
        @ic_implantacao = 'S',
        @cd_usuario     = @cd_usuario
  
     delete from #AuxSaldo where cd_conta=@cd_contae

   end
end

-------------------------------------------------------------------------------------------------------
--Zera as Contas de Implantação
-------------------------------------------------------------------------------------------------------

if @ic_parametro = 7
begin

  --select * from saldo_conta_implantacao

  delete from saldo_conta_implantacao   
  where
     cd_conta = case when @cd_conta = 0 then cd_conta else @cd_conta end


end

-------------------------------------------------------------------------------------------------------
--Encerramento das Despesas/Receitas
-------------------------------------------------------------------------------------------------------

if @ic_parametro = 8
begin

  --select * from parametro_contabil

  --Atualiza a Tabela de Parâmetros

  update
    parametro_contabil
  set
    ic_desp_rec_exercicio  = 'S'
  where
    cd_empresa           = @cd_empresa and
    dt_inicial_exercicio = @dt_inicial and     
    dt_final_exercicio   = @dt_final

end


-------------------------------------------------------------------------------------------------------
--Encerramento do Exercício
-------------------------------------------------------------------------------------------------------

if @ic_parametro = 9
begin

  --Atualiza a Tabela de Parâmetros

  update
    parametro_contabil
  set
    ic_exercicio_encerrado  = 'S'
  where
    cd_empresa           = @cd_empresa and
    dt_inicial_exercicio = @dt_inicial and     
    dt_final_exercicio   = @dt_final

end

