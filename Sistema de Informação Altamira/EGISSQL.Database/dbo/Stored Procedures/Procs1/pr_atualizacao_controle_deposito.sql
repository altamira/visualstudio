
--use egissql
-------------------------------------------------------------------------------
--sp_helptext pr_atualizacao_controle_deposito
-------------------------------------------------------------------------------
--pr_atualizacao_controle_deposito
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Depósito para Contabilização / Conciliação
--Data             : 15.09.2008
--Alteração        : 
-- 07.07.2010 - Grava o Número do Depósito na Prestação de Conta - Carlos Fernandes
--
-----------------------------------------------------------------------------------
create procedure pr_atualizacao_controle_deposito
@cd_deposito    int = 0,
@cd_solicitacao int = 0,
@cd_prestacao   int = 0,
@cd_usuario     int = 0

as

  --controle_deposito
  --select * from controle_deposito

  declare @Tabela		varchar(80)
  declare @cd_controle_deposito int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Controle_Deposito' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle_deposito', @codigo = @cd_controle_deposito output
	
  while exists(Select top 1 'x' from controle_deposito where cd_controle_deposito = @cd_controle_deposito)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle_deposito', @codigo = @cd_controle_deposito output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle_deposito, 'D'
  end

  declare @insere int 

  set @insere = 0

  if @cd_solicitacao>0
  begin
    select
      @insere =  isnull(cd_solicitacao,0)
    from
      controle_deposito with (nolock) 
    where
      cd_solicitacao = @cd_solicitacao
  end

  if @cd_prestacao>0 
  begin
    select
      @insere =  isnull(cd_prestacao,0)
    from
      controle_deposito with (nolock) 
    where
      cd_solicitacao = @cd_prestacao

    --Atualiza o Número do Depósito na Prestação de Contas
    --Carlos - 07.07.2010

    update
       prestacao_conta
    set
      cd_deposito = @cd_deposito
    where
      cd_prestacao = @cd_prestacao

  end


  if @insere = 0  and @cd_solicitacao>0
  begin

    insert into
      controle_deposito
    select
      @cd_controle_deposito,
      @cd_solicitacao,
      @cd_prestacao,
      @cd_usuario,
      getdate(),
      @cd_deposito,
      '.'          

     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle_deposito, 'D'

  end

  else
   if @cd_solicitacao>0 
   begin
     update
       controle_deposito
     set
       cd_solicitacao = @cd_solicitacao,
       --cd_prestacao   = @cd_prestacao,
       cd_usuario     = @cd_usuario  
     from
       controle_deposito
     where
       cd_solicitacao = @cd_solicitacao
    

   end


  if @insere = 0  and @cd_prestacao>0
  begin

    insert into
      controle_deposito
    select
      @cd_controle_deposito,
      @cd_solicitacao,
      @cd_prestacao,
      @cd_usuario,
      getdate(),
      @cd_deposito,
      '.'          

     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle_deposito, 'D'

  end

  else
   if @cd_prestacao>0
   begin
     update
       controle_deposito
     set
       --cd_solicitacao = @cd_solicitacao,
       cd_prestacao   = @cd_prestacao,
       cd_usuario     = @cd_usuario  
     from
       controle_deposito
     where
       cd_prestacao = @cd_prestacao
    

   end



