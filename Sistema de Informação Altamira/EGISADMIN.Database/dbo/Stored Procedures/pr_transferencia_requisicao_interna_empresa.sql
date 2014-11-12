
-------------------------------------------------------------------------------
--sp_helptext pr_transferencia_requisicao_interna_empresa
-------------------------------------------------------------------------------
--pr_transferencia_requisicao_interna_empresa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Transferência de Requisição de Interna de Empresa
--                   Estoque
--
--Data             : 24.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_transferencia_requisicao_interna_empresa
@cd_requisicao_interna int = 0,
@cd_empresa            int = 0

as

declare @nm_banco_empresa varchar(40)

if @cd_requisicao_interna > 0
begin

  --seleciona o Banco da Nova Empresa
  select
    @nm_banco_empresa = isnull(nm_banco_empresa,0) 
  from
    egisadmin.dbo.Empresa e
  where
    e.cd_empresa = @cd_empresa

  select @cd_empresa,@nm_banco_empresa

  select
    *
  from
    Requisicao_Interna i
  where
    cd_requisicao_interna = @cd_requisicao_interna


end

--select * from egisadmin.dbo.empresa

