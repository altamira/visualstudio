
-------------------------------------------------------------------------------
--sp_helptext pr_gera_gravacao_validacao_nfe
-------------------------------------------------------------------------------
--pr_gera_gravacao_validacao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
-- 
--Objetivo         : Grava a Tabela de Validação
--                   Controle de Validação de Implantação da 
--                   Nota Fiscal Eletrônica
--
--Data             : 28.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_gravacao_validacao_nfe
@cd_usuario             int = 0,
@cd_tipo_validacao      int,
@nm_validacao           varchar(60),
@cd_registro            int,
@nm_fantasia            varchar(30),
@nm_registro_validacao  varchar(60),
@cd_tabela              int,
@ds_validacao           varchar(256)


as

declare @cd_controle           int 
declare @Tabela                varchar(80)

set @Tabela            = cast(DB_NAME()+'.dbo.NFE_Validacao' as varchar(80))


exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle', @codigo = @cd_controle output
	
while exists(Select top 1 'x' from NFE_Validacao where cd_controle = @cd_controle )
begin
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle', @codigo = @cd_controle output
  -- limpeza da tabela de código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle, 'D'
end


--Gravação da Tabela

  insert into NFE_Validacao
  select
    @cd_controle            as cd_controle,
    getdate()               as dt_validacao,
    @cd_usuario             as cd_usuario_validacao,
    @cd_tipo_validacao      as cd_tipo_validacao,
    @nm_validacao           as nm_validacao,
    @cd_registro            as cd_registro,
    @nm_fantasia            as nm_fantasia,
    @nm_registro_validacao  as nm_registro_validacao,
    @cd_tabela              as cd_tabela,
    @ds_validacao           as ds_validacao,
    @cd_usuario             as cd_usuario,
    getdate()               as dt_usuario

  --Liração do Código

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle, 'D'



