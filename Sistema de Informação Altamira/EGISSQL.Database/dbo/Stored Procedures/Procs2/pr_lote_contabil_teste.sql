

/****** Object:  Stored Procedure dbo.pr_lote_contabil_teste    Script Date: 13/12/2002 15:08:34 ******/
--pr_lote_contabil
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Elias Pereira da Silva
--Lotes Contábeis
--Data         : 26.04.2001
--Atualizado   : 06.06.2001 - Exclusao de Lotes e seus lançamentos (Elias)
--             : 07.06.2001 - Atualizaçao de Lotes na inclusao de lançamentos (Elias)
--             : 07.06.2001 - Liberaçao de Lotes e Atualizaçao do Plano de Contas (Elias)
--             : 12.06.2001 - Alteraçao dos campos que antes guardavam o código da conta
--                            e que passaram a guardar o código reduzido (Elias)
--             : 13.06.2001 - Rotina para encontrar código de novo lote (Elias)
--             : 19.06.2001 - Atualizaçao de Lotes na Exclusao de Lançamentos (Elias)
--             : 28.06.2001 - Atualizacao do flag "ic_lote_fechado" na tabela Parametro_contabil
--                            quando todos os lotes estiverem fechados
--             : 15.08.2001 - Mudança na lógica usada para atualizaçao dos saldos. Nova Lógica:
--                            Todas as inclusoes/exclusoes de lançamentos atualizarao o saldo do
--                            Plano de Contas, com excessao dos lotes indicados 
--                            como nao liberados flag ic_lote_liberado = 'N'
-----------------------------------------------------------------------------------
create procedure pr_lote_contabil_teste
@ic_parametro int,              -- Parametros destea Stored Procedure
@cd_empresa int,                -- Empresa
@cd_exercicio int,              -- Exercício Contábil
@cd_lote int output,            -- Lote Contábil
@cd_lancamento_contabil int,    -- Código do Lançamento Contabil
@cd_reduzido_debito int,        -- Conta Devedora
@cd_reduzido_credito int,       -- Conta Credora
@vl_lancamento_contabil float,  -- Valor do Lançamento 
@cd_usuario int                 -- Código do Usuário
as
begin
declare @cd_log_lancamento int         -- Log de Movimento Contábil
declare @ic_consistencia_lote char(1)  -- Status do Lote
declare @ds_mensagem_log varchar(20)   -- Mensagem gravada no Log
declare @cd_conta_debito int  	       -- conta débito 
declare @cd_conta_credito int	       -- conta crédito
declare @cd_ultimo_lote int	       -- Ultimo código do lote reservado em Lote Padrao	
declare @vl_lote_debito float          -- 
declare @vl_lote_credito float         -- Usados na Inclusao/Exclusao de Lançamentos
declare @qt_total_lancamento_lote int  -- 
set @cd_log_lancamento        = ''
set @ic_consistencia_lote     = ''
set @ds_mensagem_log          = ''
set @cd_conta_debito          = 0
set @cd_conta_credito         = 0
set @cd_ultimo_lote           = 0
set @vl_lote_debito           = 0
set @vl_lote_credito          = 0
set @qt_total_lancamento_lote = 0
------------------------------------------------------------------------------------  
if (@ic_parametro = 1)  -- Exclusao dos Movimentos Contábeis dos Lotes
------------------------------------------------------------------------------------
begin
  begin transaction
  -- Cria uma tabela temporária com as informaçoes do Lote Contábil
  select 
    cd_lancamento_contabil,
    cd_reduzido_debito,
    cd_reduzido_credito,
    vl_lancamento_contabil
  into
    #Aux_Lote_contabil
  from
    Movimento_contabil
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote
  while exists(select * from #Aux_Lote_contabil)
    begin
      select 
        @cd_lancamento_contabil = cd_lancamento_contabil,
        @cd_reduzido_debito        = isnull(cd_reduzido_debito,0),
        @cd_reduzido_credito       = isnull(cd_reduzido_credito,0),
        @vl_lancamento_contabil = vl_lancamento_contabil
      from 
        #Aux_Lote_contabil
      -- exclui os lançamentos 
      exec pr_movimento_contabil 2,
                                 'N',
                                 @cd_empresa,
                                 @cd_exercicio,
                                 @cd_lote,       
                                 @cd_lancamento_contabil,
                                 0,
                                 @cd_reduzido_debito,
                                 @cd_reduzido_credito,
                                 0,
                                 '',
                                 @vl_lancamento_contabil,
                                 @cd_usuario                                    
  
      -- Apaga Registro da Tabela Temporária    
      delete from 
        #Aux_lote_contabil
      where
        cd_lancamento_contabil = @cd_lancamento_contabil
    
    end                     
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end
------------------------------------------------------------------------------------  
if (@ic_parametro = 2)  -- Atualizaçao de Lotes na inclusao de lançamentos
------------------------------------------------------------------------------------
begin
  begin transaction
  select 
    @vl_lote_debito = vl_lote_debito,
    @vl_lote_credito = vl_lote_credito,
    @qt_total_lancamento_lote = qt_total_lancamento_lote
  from
    Lote_contabil
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote
  if @cd_reduzido_debito <> 0 
    set @vl_lote_debito = @vl_lote_debito + @vl_lancamento_contabil
  if @cd_reduzido_credito <> 0
   set  @vl_lote_credito = @vl_lote_credito + @vl_lancamento_contabil
  set @qt_total_lancamento_lote = @qt_total_lancamento_lote + 1
  
  update 
    Lote_contabil
  set
    vl_lote_debito = @vl_lote_debito,
    vl_lote_credito = @vl_lote_credito,
    qt_total_lancamento_lote = @qt_total_lancamento_lote
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end
------------------------------------------------------------------------------------  
if (@ic_parametro = 3)  -- Liberaçao de Lotes e Atualizaçao do Plano de Contas
------------------------------------------------------------------------------------
begin
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end        
------------------------------------------------------------------------------------  
if (@ic_parametro = 4)  -- Geraçao de novo código de lote
------------------------------------------------------------------------------------
begin
  begin transaction
  
  select 
    @cd_lote = isnull(max(cd_lote),0)
  from
    Lote_contabil tablock
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio
  set @cd_lote = @cd_lote + 1 
    
  select
    @cd_ultimo_lote = isnull(max(qt_final_lote_contabil), @cd_lote)
  from
    lote_contabil_padrao tablock
  where
    @cd_empresa = cd_empresa and
    @cd_lote between qt_inicial_lote_contabil and qt_final_lote_contabil
         
  if (@cd_ultimo_lote <> @cd_lote)     
    set @cd_lote = @cd_ultimo_lote + 1
  if @@error = 0
    commit tran
  else
  begin
    --RAISERROR @@ERROR
    rollback tran
  end
end
------------------------------------------------------------------------------------  
if (@ic_parametro = 5)  -- Atualizaçao de Lotes na exclusao de lançamentos
------------------------------------------------------------------------------------
begin
  begin transaction
  select 
    @vl_lote_debito = vl_lote_debito,
    @vl_lote_credito = vl_lote_credito,
    @qt_total_lancamento_lote = qt_total_lancamento_lote
  from
    Lote_contabil
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote
  if @cd_reduzido_debito <> 0 
    set @vl_lote_debito = @vl_lote_debito - @vl_lancamento_contabil
  if @cd_reduzido_credito <> 0
   set  @vl_lote_credito = @vl_lote_credito - @vl_lancamento_contabil
  set @qt_total_lancamento_lote = @qt_total_lancamento_lote - 1
  
  update 
    Lote_contabil
  set
    vl_lote_debito = @vl_lote_debito,
    vl_lote_credito = @vl_lote_credito,
    qt_total_lancamento_lote = @qt_total_lancamento_lote
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    cd_lote = @cd_lote
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
end
------------------------------------------------------------------------------------
if @ic_parametro = 6  -- Atualizaçao do Flag "ic_lote_fechado" no Parametro_contabil
------------------------------------------------------------------------------------
begin
  begin transaction
  declare @ic_lote_ok char(1)
  set @ic_lote_ok = 'S'
  if exists(select 
              * 
            from 
              Lote_contabil
            where
              cd_empresa = @cd_empresa and
              cd_exercicio = @cd_exercicio and
              ic_consistencia_lote = 'N')
    set @ic_lote_ok = 'N'
  update
    Parametro_contabil
  set
    ic_lote_fechado = @ic_lote_ok,
    cd_usuario = @cd_usuario,
    dt_usuario = getDate()
  where
    cd_empresa = @cd_empresa and
    cd_exercicio = @cd_exercicio and
    ic_exercicio_ativo = 'S'      
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end
     
end
 
end
--go
---exec pr_lote_contabil 1, 1, 1, 14, 0, 0, 0, 0, 0
---select * from lote_contabil
--select * from log_lancamento_contabil
   
---select * from lote_contabil
--select * from plano_conta where cd_conta = 6
--select * from movimento_contabil
--update lote_contabil set ic_consistencia_lote = 'N'


