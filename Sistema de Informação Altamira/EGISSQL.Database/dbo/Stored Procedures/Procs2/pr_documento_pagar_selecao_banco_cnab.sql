--------------------------------------------------------------------------------
--pr_documento_pagar_selecao_banco_cnab
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de documentos a pagar selecionados para banco CNAB
--Data			: 30.03.2006
--Alteração             : 
----------------------------------------------------------------------------------
create procedure pr_documento_pagar_selecao_banco_cnab
@dt_inicial datetime,
@dt_final   datetime

as

--select * from documento_pagar

select
  d.dt_selecao_documento         as 'DataSelecao',
  p.nm_portador                  as 'Portador',
  d.cd_identificacao_document    as 'Documento',
  d.dt_emissao_documento_paga    as 'Emissao',
  d.dt_vencimento_documento      as 'Vencimento',
  d.vl_documento_pagar           as 'Valor'
from
  documento_pagar d
  left outer join portador p on p.cd_portador = d.cd_portador
where
  cast( cast (d.dt_selecao_documento as int ) as datetime ) between @dt_inicial and @dt_final and
  isnull(d.ic_envio_documento,'N') = 'S'

