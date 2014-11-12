








-----------------------------------------------------------------------------------
CREATE  procedure pr_lote_contabil
@ic_parametro int,                    -- Parametros destea Stored Procedure
@cd_empresa int,                      -- Empresa
@cd_exercicio int,                    -- Exercício Contábil
@cd_lote int output,                  -- Lote Contábil
@cd_lancamento_contabil int,          -- Código do Lançamento Contabil
@cd_reduzido_debito int,              -- Conta Devedora
@cd_reduzido_credito int,             -- Conta Credora
@vl_lancamento_contabil float,        -- Valor do Lançamento 
@ic_consistencia_lote char(1) output, -- Lotes Consistentes
@ic_ativa_lote        char(1) output, -- Lotes Ativos 
@cd_usuario int                       -- Código do Usuário
as
begin

declare @cd_log int                      -- Log de Movimento Contábil
declare @ds_mensagem_log varchar(20)     -- Mensagem gravada no Log
declare @cd_conta_debito int  	         -- conta débito 
declare @cd_conta_credito int	           -- conta crédito
declare @cd_ultimo_lote int	             -- Ultimo código do lote reservado em Lote Padrao	
declare @vl_lote_debito float            -- 
declare @vl_lote_credito float           -- Usados na Inclusao/Exclusao de Lançamentos
declare @vl_lote_debito_informado float  -- Usados na Inclusao/Exclusao de Lançamentos
declare @vl_lote_credito_informado float -- Usados na Inclusao/Exclusao de Lançamentos
declare @qt_total_lancamento_lote int    -- 
declare @nm_tabela varchar(100)	         -- usado na geração do código sequencial


set @cd_log                   = 0
set @ds_mensagem_log          = ''
set @cd_conta_debito          = 0
set @cd_conta_credito         = 0
set @cd_ultimo_lote           = 0
set @vl_lote_debito           = 0
set @vl_lote_credito          = 0
set @qt_total_lancamento_lote = 0

set @nm_tabela = DB_NAME()+'.dbo.log_lancamento_contabil'

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
        @cd_reduzido_debito     = isnull(cd_reduzido_debito,0),
        @cd_reduzido_credito    = isnull(cd_reduzido_credito,0),
        @vl_lancamento_contabil = vl_lancamento_contabil
      from 
        #Aux_Lote_contabil
      if ((select 
             ic_ativa_lote
           from
             lote_contabil
           where
             cd_empresa = @cd_empresa and
             cd_exercicio = @cd_exercicio and
             cd_lote = @cd_lote) = 'S')
        -- atualiza o movimento 
        exec pr_movimento_contabil 2,
                                   'N',
                                   @cd_empresa,
                                   @cd_exercicio,
                                   @cd_lote,       
                                   @cd_lancamento_contabil,
                                   0,
                                   @cd_reduzido_debito,
                                   @cd_reduzido_credito,
                                   @vl_lancamento_contabil,
                                   @cd_usuario
      -- atualiza log de lançamento
      
      -- gera numeraçao sequencial
      exec EgisAdmin.dbo.sp_PegaCodigo @nm_tabela,'cd_log_lancamento', @codigo = @cd_log output

      -- libera código usado
      exec EgisAdmin.dbo.sp_LiberaCodigo @nm_tabela, @cd_log, 'D'

      if ((select 
             ic_ativa_lote
           from
             lote_contabil
           where
             cd_empresa = @cd_empresa and
             cd_exercicio = @cd_exercicio and
             cd_lote = @cd_lote) = 'S')
        set @ds_mensagem_log = 'DEL P/ EXC LOTE ATIVO'
      else
        set @ds_mensagem_log = 'DEL P/ EXC LOTE INATIVO'      
        
      insert into log_lancamento_contabil (
        cd_empresa,
        cd_exercicio,
        cd_lote,
        cd_lancamento_contabil,
        cd_log_lancamento,
        nm_log_lancamento,
        cd_usuario,
        dt_usuario )
      values (
        @cd_empresa,
        @cd_exercicio,
        @cd_lote,
        @cd_lancamento_contabil,
        @cd_log,
        @ds_mensagem_log,
        @cd_usuario,
        getDate( ))
                                                                          
  
      -- Apaga Registro da Tabela Temporária    
      delete from 
        #Aux_lote_contabil
      where
        cd_lancamento_contabil = @cd_lancamento_contabil    
    end                     
  -- apaga movimentos do lote
  delete from 
    movimento_contabil
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
if (@ic_parametro = 2)  -- Atualizaçao de Lotes na inclusao de lançamentos
------------------------------------------------------------------------------------
begin
  begin transaction
  
  print('Acumulando Lançamento em Lote!')
  select 
    @vl_lote_debito = vl_lote_debito,
    @vl_lote_credito = vl_lote_credito,
    @vl_lote_debito_informado = vl_lote_debito_informado,
    @vl_lote_credito_informado = vl_lote_credito_informado,    
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
  
  -- Verifica se o lote é consistente
  if @vl_lote_debito <> @vl_lote_debito_informado
    set @ic_consistencia_lote = 'N'
  else
    set @ic_consistencia_lote = 'S'
            
  update 

    Lote_contabil
  set
    vl_lote_debito = @vl_lote_debito,
    vl_lote_credito = @vl_lote_credito,
    qt_total_lancamento_lote = @qt_total_lancamento_lote,
    ic_consistencia_lote = @ic_consistencia_lote
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
    @vl_lote_debito_informado = vl_lote_debito_informado,
    @vl_lote_credito_informado = vl_lote_credito_informado,     
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
  
  -- Verifica se o lote é consistente
  if @vl_lote_debito <> @vl_lote_debito_informado
    set @ic_consistencia_lote = 'N'
  else
    set @ic_consistencia_lote = 'S'
  
  update 
    Lote_contabil
  set
    vl_lote_debito = @vl_lote_debito,
    vl_lote_credito = @vl_lote_credito,
    qt_total_lancamento_lote = @qt_total_lancamento_lote,
    ic_consistencia_lote = @ic_consistencia_lote
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
  if exists(select 
              * 
            from 
              Lote_contabil
            where
              cd_empresa = @cd_empresa and
              cd_exercicio = @cd_exercicio and
              ic_consistencia_lote = 'N')
    set @ic_consistencia_lote = 'N'
  else
    set @ic_consistencia_lote = 'S'
  if exists(select 
              * 
            from 
              Lote_contabil
            where
              cd_empresa = @cd_empresa and
              cd_exercicio = @cd_exercicio and
              ic_ativa_lote = 'N')
    set @ic_ativa_lote = 'N'
  else
    set @ic_ativa_lote = 'S'
  update
    Parametro_contabil
  set
    ic_lote_fechado = @ic_consistencia_lote,
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



