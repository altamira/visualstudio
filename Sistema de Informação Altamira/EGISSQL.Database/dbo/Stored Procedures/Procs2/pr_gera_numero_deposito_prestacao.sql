﻿
-------------------------------------------------------------------------------
--sp_helptext pr_gera_numero_deposito_prestacao
-------------------------------------------------------------------------------
--pr_gera_numero_deposito_prestacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Número do Depósito de Prestação de Contas
--Data             : 05.11.2007
--Alteração        : 14.11.2007
-- 07.07.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_numero_deposito_prestacao
@cd_usuario int = 0

as

  declare @Tabela		     varchar(80)
  declare @cd_deposito_prestacao  int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Deposito_prestacao' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_deposito_prestacao', @codigo = @cd_deposito_prestacao output
	
  while exists(Select top 1 'x' from deposito_prestacao where cd_deposito_prestacao = @cd_deposito_prestacao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_deposito_prestacao', @codigo = @cd_deposito_prestacao output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_deposito_prestacao, 'D'
  end

  insert into
    deposito_prestacao
  select
    @cd_deposito_prestacao,
    getdate(),
    @cd_usuario,
    getdate()

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_deposito_prestacao, 'D'

  select @cd_deposito_prestacao as cd_deposito_prestacao  

