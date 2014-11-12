
-------------------------------------------------------------------------------
--pr_altera_status_emissao_documento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 15/03/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_altera_status_emissao_documento
  @cd_portador int = 0
AS
  update
    documento_receber
  set
    ic_emissao_documento = 'S'
  where
    cd_portador = @cd_portador and
    isnull( ic_emissao_documento, 'N' ) = 'N'
