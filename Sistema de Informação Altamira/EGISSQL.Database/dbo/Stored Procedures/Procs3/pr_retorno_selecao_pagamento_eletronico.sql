--------------------------------------------------------------------------------
--pr_retorno_selecao_pagamento_eletronico
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Retorno dos Documentos Selecionados para Envio do 
--                        Pagamento Eletrônico
--Data			: 30.03.2006
--Alteração             : 
----------------------------------------------------------------------------------
create procedure pr_retorno_selecao_pagamento_eletronico
@cd_portador  int = 0,
@dt_inicial   datetime,
@dt_final     datetime
as

--select * from documento_receber

update
  documento_pagar
set
  ic_envio_documento   = 'N',
  dt_selecao_documento = null,
  cd_portador          = 999 
where
  cd_portador = @cd_portador and
  dt_selecao_documento between @dt_inicial and @dt_final


