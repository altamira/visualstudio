--------------------------------------------------------------------------------
--pr_consulta_documento_selecao_banco_cnab
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de documentos selecionados para banco CNAB
--Data			: 23.03.2006
--Alteração             : 
----------------------------------------------------------------------------------
create procedure pr_consulta_documento_selecao_banco_cnab
@dt_inicial datetime,
@dt_final   datetime

as

--select * from documento_receber

select
  d.dt_selecao_documento    as 'DataSelecao',
  p.nm_portador             as 'Portador',
  d.cd_identificacao        as 'Documento',
  d.dt_emissao_documento    as 'Emissao',
  d.dt_vencimento_documento as 'Vencimento',
  d.vl_documento_receber    as 'Valor'
from
  documento_receber d
  left outer join portador p on p.cd_portador = d.cd_portador
where
  d.dt_selecao_documento between @dt_inicial and @dt_final and
  isnull(d.ic_envio_documento,'N') = 'S'

