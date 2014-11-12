--------------------------------------------------------------------------------
--pr_retorno_selecao_documento_banco_cnab
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de documentos selecionados para banco CNAB
--Data			: 23.03.2006
--Alteração             : 26.01.2011 - Ajuste Carlos/Márcio M.
--
----------------------------------------------------------------------------------
create procedure pr_retorno_selecao_documento_banco_cnab
@cd_portador  int = 0,
@dt_inicial   datetime,
@dt_final     datetime
as

--select * from documento_receber

update
  documento_receber
set
  ic_envio_documento   = 'N',
  ic_emissao_documento = 'N',
  dt_selecao_documento = null,
  cd_portador          = 999 
where
  cd_portador = @cd_portador and
  dt_selecao_documento between @dt_inicial and @dt_final


