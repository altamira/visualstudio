
-------------------------------------------------------------------------------
--sp_helptext pr_gera_baixa_solicitacao_adiantamento
-------------------------------------------------------------------------------
--pr_gera_baixa_solicitacao_adiantamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera a Baixa dos Adiantamentos de Viagem
--Data             : 05.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_baixa_solicitacao_adiantamento
@ic_parametro   int = 0,
@cd_solicitacao int = 0,
@cd_prestacao   int = 0,
@cd_usuario     int = 0

as

  declare @Tabela		     varchar(80)
  declare @cd_solicitacao_baixa      int
  declare @vl_baixa_adiantamento     decimal(25,2)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_Adiantamento_Baixa' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao_baixa', @codigo = @cd_solicitacao_baixa output
	
  while exists(Select top 1 'x' from solicitacao_adiantamento_baixa where cd_solicitacao_baixa = @cd_solicitacao_baixa)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao_baixa', @codigo = @cd_solicitacao_baixa output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao_baixa, 'D'
  end

  insert into
    solicitacao_adiantamento_baixa
  select
    @cd_solicitacao_baixa,
    @cd_solicitacao,
    1,
    getdate(),   
    @vl_baixa_adiantamento,
    'PC '+cast(@cd_solicitacao as varchar),
    @cd_usuario,
    getdate()

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao_baixa, 'D'


