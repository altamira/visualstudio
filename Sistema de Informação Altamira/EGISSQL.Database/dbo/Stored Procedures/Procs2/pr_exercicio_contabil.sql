
--drop procedure pr_exercicio_contabil

--pr_exercicio_contabil
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes
--Elias Pereira da Silva         
--Rotinas para o Exercicio Contabil
--Data         : 24.05.2001
--Atualizado   : 01.06.2001 - Inclusão dos Saldos de Implantação/Exercício Anterior
--             : 27.06.2001 - Encerramento do Exercício Contábil 
--             : 17.08.2001 - Geração de lançamento de lucro/prezuíjo 
--             : 26.02.2003 - Mudança na geração do código sequencial - ELIAS
-----------------------------------------------------------------------------------

create procedure pr_exercicio_contabil
@ic_parametro            int,          -- Parametros de Stored Procedure
@cd_empresa              int,          -- Empresa 
@cd_exercicio            int,          -- Exercício Contábil
@cd_lote                 int,          -- Lote
@dt_inicial              datetime,     -- Data Inicial (p/ Novo Período)
@dt_final                datetime,     -- Data Final   (p/ Novo Período)
@dt_lancamento           datetime,     -- Data do Lançamento de Encerramento
@cd_reduzido_resultado   int,          -- Contrapartida dos Lançamentos de Resultado
@cd_historico_resultado  int,          -- Código do Histórico de Resultado
@ds_historico_resultado  text,         -- Descrição do Histórico de Resultado
@cd_reduzido_lucro       int,          -- Contrapartida do lançamento de Lucro
@cd_historico_lucro      int,          -- Histórico do lançamento de lucro
@ds_historico_lucro      text,         -- descrição do histórico
@cd_usuario              int           -- Usuário 
as

begin tran


  declare @cd_conta int                         -- Código da conta (Chave)
  declare @nm_tabela varchar(100)		-- Nome da Tabela utilizada para encontrar código
  
  set @cd_conta = 0
  set @nm_tabela = DB_NAME()+'.dbo.log_lancamento_contabil'


-----------------------------------------------------------------------------------
if (@ic_parametro = 0)  -- Inclusão dos Saldos de Implantação/Exercício Anterior
-----------------------------------------------------------------------------------
begin

  declare @dt_saldo_conta datetime              -- Saldos do Exercício Anterior
  declare @vl_saldo float                       -- Saldo de Implantação/Exercício Anterior
  declare @ic_saldo char(1)                     -- D/C do Saldo  

  update
    Plano_conta
  set
    vl_saldo_inicial_conta = 0,
    ic_saldo_inicial_conta = '',
    vl_debito_conta        = 0,
    vl_credito_conta       = 0,
    qt_lancamento_conta    = 0,
    vl_saldo_atual_conta   = 0,
    ic_saldo_atual_conta   = ''
  where
    cd_empresa = @cd_empresa    

  -- Atualização dos Saldos Iniciais das conta

  -- Saldos de Implantação

  -- Criaçao da Tabela Auxiliar com saldos de Implantação

  select
    cd_conta,
    vl_saldo_implantacao,
    ic_saldo_implantacao
  into 
    #Aux_Saldo_Implantacao
  from
    Saldo_conta_implantacao
  where
    cd_empresa = @cd_empresa and
    ic_implantado = 'N'

  if exists(select * from #Aux_Saldo_Implantacao)
    begin
      
      while exists(select * from #Aux_Saldo_Implantacao)
        begin
 
          -- Guarda os campos necessários
          select @cd_conta = cd_conta,
                 @vl_saldo = vl_saldo_implantacao,
                 @ic_saldo = ic_saldo_implantacao  from #Aux_Saldo_Implantacao
      
          -- Atualiza o Plano de Contas com os Saldos de Implantação
          update 
            Plano_conta
          set
            vl_saldo_inicial_conta = @vl_saldo,
            ic_saldo_inicial_conta = @ic_saldo,
            vl_saldo_atual_conta = @vl_saldo,
            ic_saldo_atual_conta = @ic_saldo
          where
            cd_empresa = @cd_empresa and
            cd_conta = @cd_conta      
 
          -- Atualiza o registro de Saldo de Implantação
          update
            Saldo_conta_implantacao
          set
            ic_implantado = 'S'
          where
            cd_empresa = @cd_empresa and
            cd_conta = @cd_conta 
      
          -- apaga registro usado na Tabela Auxiliar
          delete from #Aux_Saldo_Implantacao
            where cd_conta = @cd_conta
        end
    end
  else
    begin

      -- Saldo do Último Exercício

      -- Guardo o último período existente na tabela de Saldos da Conta
      select @dt_saldo_conta = (max(dt_saldo_conta)) from Saldo_conta

      -- Criação da Tabela com Saldos do Exercício Anterior
      select
        cd_conta,
        vl_saldo_conta,
        ic_saldo_conta
      into 
        #Aux_Saldo_Conta
      from
        Saldo_conta
      where
        cd_empresa = @cd_empresa and
        dt_saldo_conta = @dt_saldo_conta

      while exists(select * from #Aux_Saldo_Conta)
        begin
 
          -- Guarda o campo chave
          select @cd_conta = cd_conta,
                 @vl_saldo = vl_saldo_conta,
                 @ic_saldo = ic_saldo_conta from #Aux_Saldo_Conta
      
          -- Atualiza o Plano de Contas com os Saldos de Implantação
          update 
            Plano_conta
          set
            vl_saldo_inicial_conta = @vl_saldo,
            ic_saldo_inicial_conta = @ic_saldo,
            vl_saldo_atual_conta = @vl_saldo,
            ic_saldo_atual_conta = @ic_saldo
          where
            cd_empresa = @cd_empresa and
            cd_conta = @cd_conta        

          -- apaga registro usado na Tabela Auxiliar
          delete from #Aux_Saldo_Conta
            where cd_conta = @cd_conta

        end
    end
end    

-----------------------------------------------------------------------------------
if (@ic_parametro = 1)     -- Encerramento do Período Contábil
-----------------------------------------------------------------------------------
begin

  declare @cd_reduzido_auxiliar    int
  declare @vl_lancamento_auxiliar  numeric(25,2)
  declare @vl_lancamento_corrigido numeric(25,2)
  declare @ic_conta_auxiliar       char(1)
  declare @cd_lancamento_auxiliar  int 
  declare @vl_debito_auxiliar      numeric(25,2)
  declare @vl_credito_auxiliar     numeric(25,2)
  declare @vl_debito_lucro         numeric(25,2)
  declare @vl_credito_lucro        numeric(25,2)
  declare @cd_log                   int
  declare @qt_lancamento          int

  set @cd_reduzido_auxiliar    = 0
  set @vl_lancamento_auxiliar  = 0
  set @vl_lancamento_corrigido = 0
  set @ic_conta_auxiliar       = ''
  set @cd_lancamento_auxiliar  = 0
  set @vl_debito_auxiliar      = 0
  set @vl_credito_auxiliar     = 0
  set @cd_log                  = 0
  set @qt_lancamento           = 0

/* 
  1-Criar Tabela Temporária com todas as contas de resultado (Flag ic_resultado = 'S')
  1.1 - Criar Lote
  2-Gerar Registro em Movimento_contabil do lançamento de encerramento
  2.2 - Atualizar Lote
  3-Atualizar Saldos do Plano de Contas (somente contas de resultado)
  4-Armazenar valor de débito e crédito da conta de contrapartida
  5-Criar Log de Lançamento
  6-Ao final atualizar Saldo de Plano de Contas com os valores da conta de Contapartida
  7-Criar Log de Lançamento do último lançamento (contrapartida)
*/

  --Criação da tabela temporária das contas de resultado(Flag ic_resultado = 'S')
  select
    cd_conta as 'conta',
    cd_conta_reduzido as 'reduzido',
    cast(vl_saldo_atual_conta as numeric(15, 2)) as 'saldoatu',
    ic_saldo_atual_conta as 'tipoatu'
  into
    #Aux_PlanoConta
  from
    Plano_conta
  where
    cd_empresa = @cd_empresa and
    ic_conta_resultado = 'S' and
    ic_conta_analitica = 'a' and
    vl_saldo_atual_conta <> 0

  if not exists(select * from #Aux_PlanoConta)
    begin
      raiserror ('Não Existe Resultado a ser Encerrado !',16,1)
      rollback tran
    end

  -- Cria o Lote Contabil de Encerramento
  insert into Lote_contabil (
    cd_empresa,
    cd_exercicio,
    cd_lote,
    dt_lote,
    vl_lote_debito,
    vl_lote_credito,
    qt_total_lancamento_lote,
    ic_consistencia_lote,
    ic_ativa_lote, 
    vl_lote_debito_informado,
    vl_lote_credito_informado,
    cd_usuario,
    dt_usuario )
  values (
    @cd_empresa,
    @cd_exercicio,
    @cd_lote,
    @dt_lancamento,
    0,
    0,
    0,
    'S',
    'S',
    0,
    0,
    @cd_usuario,
    getDate() )      

  while exists(select * from #Aux_PlanoConta)
    begin

      select 
        @cd_conta               = conta,
        @cd_reduzido_auxiliar   = reduzido,
        @vl_lancamento_auxiliar = saldoatu,
        @ic_conta_auxiliar      = tipoatu      
      from
        #Aux_PlanoConta

      -- Pega um novo código para uso na tabela de Movimento_contabil
      select
        @cd_lancamento_auxiliar = isnull(max(cd_lancamento_contabil), 0)+1
      from
        Movimento_contabil tablock
      where
        cd_empresa = @cd_empresa and
        cd_exercicio = @cd_exercicio and
        cd_lote = @cd_lote 

      print('Empresa:'+cast(@cd_empresa as varchar(20)))
      print('Exercicio:'+cast(@cd_exercicio as varchar(20)))
      print('Lote:'+cast(@cd_lote as varchar(20)))    

      -- Saldo Devedor
      if (@ic_conta_auxiliar = 'D')
        begin
          print('Saldo devedor')
          insert into Movimento_contabil (
            cd_empresa,             
            cd_exercicio,
            cd_lote,
            cd_lancamento_contabil,
            dt_lancamento_contabil,
            cd_reduzido_debito,
            cd_reduzido_credito,
            vl_lancamento_contabil,
            cd_historico_contabil,
            ds_historico_contabil,
            cd_usuario,
            dt_usuario)
          values (
            @cd_empresa,
            @cd_exercicio,
            @cd_lote,
            @cd_lancamento_auxiliar,
            @dt_lancamento,            @cd_reduzido_resultado,
            @cd_reduzido_auxiliar,
            @vl_lancamento_auxiliar,
            @cd_historico_resultado,
            @ds_historico_resultado,
            @cd_usuario,
            getDate() )

          -- Atualiza movimento
          exec pr_movimento_contabil 1,
                                     'S',
                                     @cd_empresa,
                                     @cd_exercicio,
                                     @cd_lote,
                                     @cd_lancamento_auxiliar,
                                     @dt_lancamento,
                                     @cd_reduzido_resultado,
                                     @cd_reduzido_auxiliar,
                                     @vl_lancamento_auxiliar,
                                     @cd_usuario

          -- atualiza lote
          exec pr_lote_contabil 2,
                                @cd_empresa,
                                @cd_exercicio,
                                @cd_lote,
                                @cd_lancamento_auxiliar, 
                                @cd_reduzido_resultado,
                                @cd_reduzido_auxiliar,
                                @vl_lancamento_auxiliar,
                                '',
                                '', 
                                @cd_usuario                                     

          -- Guarda valor do lançamento de encerramento
          set @vl_debito_auxiliar = @vl_debito_auxiliar + @vl_lancamento_auxiliar

          print('Vl Débito Enc:'+cast(@vl_debito_auxiliar as varchar(20)))
          print('Vl Conta:'+cast(@vl_lancamento_auxiliar as varchar(20)))

        end                                                                    
      
      -- Saldo Credor    
      if (@ic_conta_auxiliar = 'C')
        begin
          print('Saldo Credor')
          insert into Movimento_contabil (
            cd_empresa,             
            cd_exercicio,
            cd_lote,
            cd_lancamento_contabil,
            dt_lancamento_contabil,
            cd_reduzido_debito,
            cd_reduzido_credito,
            vl_lancamento_contabil,
            cd_historico_contabil,
            ds_historico_contabil,
            cd_usuario,
            dt_usuario)
          values (
            @cd_empresa,
            @cd_exercicio,
            @cd_lote,
            @cd_lancamento_auxiliar,
            @dt_lancamento,            @cd_reduzido_auxiliar,
            @cd_reduzido_resultado,
            @vl_lancamento_auxiliar,
            @cd_historico_resultado,
            @ds_historico_resultado,
            @cd_usuario,
            getDate() )

          -- Atualiza movimento
          exec pr_movimento_contabil 1,
                                     'S',
                                     @cd_empresa,
                                     @cd_exercicio,
                                     @cd_lote,
                                     @cd_lancamento_auxiliar,
                                     @dt_lancamento,
                                     @cd_reduzido_auxiliar,
                                     @cd_reduzido_resultado,
                                     @vl_lancamento_auxiliar,
                                     @cd_usuario 

          -- atualiza lote
          exec pr_lote_contabil 2,
                                @cd_empresa,
                                @cd_exercicio,
                                @cd_lote,
                                @cd_lancamento_auxiliar, 
                                @cd_reduzido_auxiliar,
                                @cd_reduzido_resultado,
                                @vl_lancamento_auxiliar,
                                '',
                                '', 
                                @cd_usuario                                      

          -- Guarda valor do lançamento de encerramento
          set @vl_credito_auxiliar = @vl_credito_auxiliar + @vl_lancamento_auxiliar

          print('Vl Credito Enc:'+ cast(@vl_credito_auxiliar as varchar(20)))
          print('Vl Conta:'+cast(@vl_lancamento_auxiliar as varchar(20)))   

        end

      -- Pega um novo código para uso na tabela de Log 
      exec EgisAdmin.DBO.sp_PegaCodigo @nm_tabela, 'cd_log_lancamento', @codigo = @cd_log OUTPUT             

      -- libera código usado
      exec EgisAdmin.dbo.sp_LiberaCodigo @nm_tabela, @cd_log, 'D'

      print('Log: '+cast(@cd_log as varchar(20)))
        
      -- Atualiza a tabela de Log com a Operação de Encerramento
      insert into Log_lancamento_contabil (
        cd_empresa,
        cd_exercicio,
        cd_lote,
        cd_lancamento_contabil,
        cd_log_lancamento,
        nm_log_lancamento,
        cd_usuario,
        dt_usuario)
      values (
        @cd_empresa,
        @cd_exercicio,
        @cd_lote,
        @cd_lancamento_auxiliar,
        @cd_log,
        'Apuração do Resultado',
        @cd_usuario,
        getDate())               

      -- Armazena quantidade de lançamentos
      set @qt_lancamento = @qt_lancamento + 1
        
      -- Apaga registro da tabela auxiliar
      delete from
        #Aux_PlanoConta
      where
        conta = @cd_conta

    end -- while
    
  -- lançamento de lucro ou prejuízo acumulado

  -- Pega um novo código para uso na tabela de Movimento_contabil
  select
    @cd_lancamento_auxiliar = isnull(max(cd_lancamento_contabil), 0)+1
  from
    Movimento_contabil tablock
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote 

  set @vl_lancamento_auxiliar = @vl_credito_auxiliar - @vl_debito_auxiliar

  -- lançamento de prejuízo

  if (@vl_lancamento_auxiliar < 0)
    begin

      set @vl_lancamento_corrigido = @vl_lancamento_auxiliar * -1

      insert into Movimento_contabil (
        cd_empresa,             
        cd_exercicio,
        cd_lote,
        cd_lancamento_contabil,
        dt_lancamento_contabil,
        cd_reduzido_debito,
        cd_reduzido_credito,
        vl_lancamento_contabil,
        cd_historico_contabil,
        ds_historico_contabil,
        cd_usuario,
        dt_usuario )
      values (
        @cd_empresa,
        @cd_exercicio,
        @cd_lote,
        @cd_lancamento_auxiliar,
        @dt_lancamento,        @cd_reduzido_lucro,
        @cd_reduzido_resultado,
        @vl_lancamento_corrigido,
        @cd_historico_lucro,
        @ds_historico_lucro,
        @cd_usuario,
        getDate() )

      exec pr_movimento_contabil 1,
                                 'S',
                                 @cd_empresa,
                                 @cd_exercicio,
                                 @cd_lote,
                                 @cd_lancamento_auxiliar,
                                 @dt_lancamento,
                                 @cd_reduzido_lucro,
                                 @cd_reduzido_resultado,
                                 @vl_lancamento_corrigido,
                                 @cd_usuario                                     

      -- atualiza lote
      exec pr_lote_contabil 2,
                            @cd_empresa,
                            @cd_exercicio,
                            @cd_lote,
                            @cd_lancamento_auxiliar,
                            @cd_reduzido_lucro,
                            @cd_reduzido_resultado,
                            @vl_lancamento_corrigido,
                            '',
                            '', 
                            @cd_usuario  

    end

  if (@vl_lancamento_auxiliar > 0)
  -- lançamento de lucro
    begin

      insert into Movimento_contabil (
        cd_empresa,             
        cd_exercicio,
        cd_lote,
        cd_lancamento_contabil,
        dt_lancamento_contabil,
        cd_reduzido_debito,
        cd_reduzido_credito,
        vl_lancamento_contabil,
        cd_historico_contabil,
        ds_historico_contabil,
        cd_usuario,
        dt_usuario)
      values (
        @cd_empresa,
        @cd_exercicio,
        @cd_lote,
        @cd_lancamento_auxiliar,
        @dt_lancamento,
        @cd_reduzido_resultado,
        @cd_reduzido_lucro,
        @vl_lancamento_auxiliar,
        @cd_historico_lucro,
        @ds_historico_lucro,
        @cd_usuario,
        getDate() )

      exec pr_movimento_contabil 1,
                                 'S',
                                 @cd_empresa,
                                 @cd_exercicio,
                                 @cd_lote,
                                 @cd_lancamento_auxiliar,
                                 @dt_lancamento,
                                 @cd_reduzido_resultado,
                                 @cd_reduzido_lucro,
                                 @vl_lancamento_auxiliar,
                                 @cd_usuario                                     

      -- atualiza lote
      exec pr_lote_contabil 2,
                            @cd_empresa,
                            @cd_exercicio,
                            @cd_lote,
                            @cd_lancamento_auxiliar, 
                            @cd_reduzido_resultado,
                            @cd_reduzido_lucro,
                            @vl_lancamento_auxiliar,
                            '',
                            '', 
                            @cd_usuario  
    end

  if (@vl_lancamento_auxiliar = 0)
    return

  -- Pega um novo código para uso na tabela de Log 
  exec EgisAdmin.DBO.sp_PegaCodigo @nm_tabela, 'cd_log_lancamento', @codigo = @cd_log OUTPUT             

  -- libera código usado
  exec EgisAdmin.dbo.sp_LiberaCodigo @nm_tabela, @cd_log, 'D'

  print('Log: '+cast(@cd_log as varchar(20)))
        
  -- Atualiza a tabela de Log com a Operação de Encerramento
  insert into Log_lancamento_contabil (
    cd_empresa,
    cd_exercicio,
    cd_lote,
    cd_lancamento_contabil,
    cd_log_lancamento,
    nm_log_lancamento,
    cd_usuario,
    dt_usuario)
  values (
    @cd_empresa,
    @cd_exercicio,
    @cd_lote,
    @cd_lancamento_auxiliar,
    @cd_log,
    'Apuração do Lucro/Prejuízo',
    @cd_usuario,
    getDate())               

end

if @@error = 0
   begin
     commit tran
   end
else
   begin
     raiserror ('',16,1)
     rollback tran
   end

--go

--exec pr_exercicio_contabil 1, 5, 0, 0, 0, 1, 20, 108, '12/31/2000', 13, 'Apuracao do Resultado do Exercício'; 

--select * from plano_conta

