
/****** Object:  Stored Procedure dbo.pr_movimento_contabil    Script Date: 13/12/2002 15:08:36 ******/

-----------------------------------------------------------------------------------
--pr_movimento_contabil
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                           2004
-----------------------------------------------------------------------------------
--Stored Procedure         : SQL Server Microsoft 2000  
--Autor                    : Elias Pereira da Silva
--Objetivo                 : Rotinas do Movimento Contábil
--Data                     : 18.06.2001 - Inclusao da Rotina de Novo Código
--Atualizado               : 15.08.2001 - Inclusao da Rotina de Atualizaçao do Plano_conta
--                                        através da Inclusao/Exclusao de Lançamentos
--                         : 28.12.2004 - Verificação / Ajuste
--                         : 30/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 17.05.2008 - Ajuste da Procedure - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_movimento_contabil
@ic_parametro           int,                   -- parametros desta stored procedure
@ic_atualiza_lote       char(1),               -- atualiza lote
@cd_empresa             int,                   -- empresa
@cd_exercicio           int,                   -- exercício corrente
@cd_lote                int,                   -- lote
@cd_lancamento_contabil int output,            -- lançamento contábil
@dt_lancamento_contabil datetime,              -- data do lançamento
@cd_reduzido_debito     int,                   -- conta débito  para atualizaçao
@cd_reduzido_credito    int,                   -- conta crédito para atualizaçao
@vl_lancamento_contabil float,                 -- valor do lançamento para atualizaçao 
@cd_usuario             int                    -- usuário

as

begin

  declare @cd_conta_debito   int
  declare @cd_conta_credito  int
  declare @cd_log            int 
  declare @ds_mensagem_log   varchar(50)
  declare @ic_atualiza_plano char(1)      

  set @cd_conta_debito   = 0
  set @cd_conta_credito  = 0
  set @cd_log            = 0
  set @ds_mensagem_log   = ''
  set @ic_atualiza_plano = 'N'

-----------------------------------------------------------------------------------
if @ic_parametro = 0     -- Geraçao de novo Código
-----------------------------------------------------------------------------------
begin

  declare @tabela        varchar(80)
  declare @cd_lancamento int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Movimento_Contabil' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_contabil', @codigo = @cd_lancamento output
	
  while exists(Select top 1 'x' from movimento_contabil where cd_lancamento_contabil = @cd_lancamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_lancamento output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'
  end

  --Verifica se existe o lançamento contabil

  if exists( select top 1 cd_lancamento_contabil from movimento_contabil where cd_lancamento_contabil = @cd_lancamento ) 
  begin

    select
      @cd_lancamento_contabil = isnull(max(cd_lancamento_contabil), 0)+1
    from
      Movimento_contabil tablock
    where
      cd_empresa   = @cd_empresa and
      cd_exercicio = @cd_exercicio and
      cd_lote      = @cd_lote
  end
  else
    set @cd_lancamento_contabil = @cd_lancamento

end  

-----------------------------------------------------------------------------------
if @ic_parametro = 1    --         Atualizaçao na Inclusao de Lançamentos
-----------------------------------------------------------------------------------
begin
  
  begin transaction      

  -- verifica se lote contábil está ativo

  if ((select 
         isnull(ic_ativa_lote,'S') as ic_ativa_lote 
       from
         lote_contabil
       where
         cd_empresa   = @cd_empresa and
         cd_exercicio = @cd_exercicio and
         cd_lote      = @cd_lote) = 'S')

    set @ic_atualiza_plano = 'S'

  print('Lote Ativo: '+@ic_atualiza_plano)

  -- atualiza plano de contas  

  if (@ic_atualiza_plano = 'S')
    begin
      -- atualiza débito
      if (isnull(@cd_reduzido_debito,0) <> 0)
        begin
          select
            @cd_conta_debito = cd_conta
          from
            plano_conta with (nolock) 
          where
            cd_empresa        = @cd_empresa and
            cd_conta_reduzido = @cd_reduzido_debito

          exec pr_atualiza_valor_plano_conta 1, 
                                             @cd_empresa, 
                                             @cd_conta_debito, 
                                             'I', 
                                             @vl_lancamento_contabil,
                                             'D', 
                                             'N', 
                                             @cd_usuario
        end 

      -- atualiza credito

      if (isnull(@cd_reduzido_credito,0) <> 0)
        begin

          select
            @cd_conta_credito = cd_conta
          from
            plano_conta with (nolock)
          where
            cd_empresa = @cd_empresa and
            cd_conta_reduzido = @cd_reduzido_credito

          exec pr_atualiza_valor_plano_conta 1, 
                                             @cd_empresa, 
                                             @cd_conta_credito, 
                                             'I', 
                                             @vl_lancamento_contabil,
                                             'C', 
                                             'N', 
                                             @cd_usuario
        end 

    end

  -- atualiza lote contabil

  if (@ic_atualiza_lote = 'S')

    exec pr_lote_contabil 2,
                          @cd_empresa,
                          @cd_exercicio,
                          @cd_lote,
                          @cd_lancamento_contabil, 
                          @cd_reduzido_debito,
                          @cd_reduzido_credito,
                          @vl_lancamento_contabil,
                          '',
                          '', 
                          @cd_usuario
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end   

end

-----------------------------------------------------------------------------------
if @ic_parametro = 2    --         Atualizaçao na Exclusao de Lançamentos
-----------------------------------------------------------------------------------
begin
  
  begin transaction

  -- verifica se lote contábil está ativo

  if ((select 
         isnull(ic_ativa_lote,'S')  as ic_ativa_lote 
       from
         lote_contabil
       where
         cd_empresa   = @cd_empresa and
         cd_exercicio = @cd_exercicio and
         cd_lote      = @cd_lote) = 'S')

    set @ic_atualiza_plano = 'S'

  -- atualiza plano de contas  

  if (@ic_atualiza_plano = 'S')
    begin
      -- atualiza débito
      if (isnull(@cd_reduzido_debito,0) <> 0)
        begin
          select
            @cd_conta_debito = cd_conta
          from
            plano_conta with (nolock)
          where
            cd_empresa = @cd_empresa and
            cd_conta_reduzido = @cd_reduzido_debito

          exec pr_atualiza_valor_plano_conta 1, 
                                             @cd_empresa, 
                                             @cd_conta_debito, 
                                             'E', 
                                             @vl_lancamento_contabil,
                                             'D', 
                                             'N', 
                                             @cd_usuario
        end 

      -- atualiza credito

      if (isnull(@cd_reduzido_credito,0) <> 0)
        begin
          select
            @cd_conta_credito = cd_conta
          from
            plano_conta with (nolock)
          where
            cd_empresa        = @cd_empresa and
            cd_conta_reduzido = @cd_reduzido_credito

          exec pr_atualiza_valor_plano_conta 1, 
                                             @cd_empresa, 
                                             @cd_conta_credito, 
                                             'E', 
                                             @vl_lancamento_contabil,
                                             'C', 
                                             'N', 
                                             @cd_usuario
        end 

    end

  -- atualiza lote contabil

  if (@ic_atualiza_lote = 'S')

    exec pr_lote_contabil 5,
                          @cd_empresa,
                          @cd_exercicio,
                          @cd_lote,
                          @cd_lancamento_contabil, 
                          @cd_reduzido_debito,
                          @cd_reduzido_credito,
                          @vl_lancamento_contabil,
                          '',
                          '',
                          @cd_usuario
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end   

end
end 

