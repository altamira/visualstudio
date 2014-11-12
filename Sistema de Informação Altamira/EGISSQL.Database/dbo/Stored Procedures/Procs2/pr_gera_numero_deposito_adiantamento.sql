
-------------------------------------------------------------------------------
--sp_helptext pr_gera_numero_deposito_adiantamento
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Número do Depósito do Adiantamento
--Data             : 05.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_numero_deposito_adiantamento
@cd_usuario int = 0

as

  declare @Tabela		     varchar(80)
  declare @cd_deposito_adiantamento  int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Deposito_Adiantamento' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_deposito_adiantamento', @codigo = @cd_deposito_adiantamento output
	
  while exists(Select top 1 'x' from deposito_adiantamento where cd_deposito_adiantamento = @cd_deposito_adiantamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_deposito_adiantamento', @codigo = @cd_deposito_adiantamento output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_deposito_adiantamento, 'D'
  end

  insert into
    deposito_adiantamento
  select
    @cd_deposito_adiantamento,
    getdate(),
    @cd_usuario,
    getdate()

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_deposito_adiantamento, 'D'

  select @cd_deposito_adiantamento as cd_deposito_adiantamento  

