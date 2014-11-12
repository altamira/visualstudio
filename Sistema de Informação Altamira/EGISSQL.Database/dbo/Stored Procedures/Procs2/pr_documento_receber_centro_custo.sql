
-------------------------------------------------------------------------------
--pr_documento_receber_centro_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Obter Dados para tela de Documentos a Pagar por Centro de Custo
--Data             : 09/12/2004
--Alteração        : 09.07.2006 - Acertos Diversos
------------------------------------------------------------------------------
create procedure pr_documento_receber_centro_custo

@cd_centro_custo      int      = 0,
@cd_item_centro_custo int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''

AS

Select 
  dr.cd_documento_receber,
  p.nm_portador,
  cc.nm_centro_custo, 
  cc.cd_centro_custo,
  ccc.nm_item_centro_custo,
  ccc.cd_item_centro_custo,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente,
  dr.cd_identificacao,
  isnull(dr.vl_documento_receber,0) as vl_documento_receber,
  dr.dt_vencimento_documento,
  dr.dt_emissao_documento,
  isnull(drcc.vl_centro_custo,0) as vl_centro_custo,
  isnull(drcc.pc_centro_custo,0) as pc_centro_custo,
  drp.dt_pagamento_documento,
  isnull(drp.vl_pagamento_documento,0) as vl_pagamento_documento

From Centro_Custo cc
  left Join Documento_Receber_Centro_Custo drcc on cc.cd_centro_custo = drcc.cd_centro_custo  
  left Join Centro_Custo_Composicao ccc on cc.cd_centro_custo = ccc.cd_centro_custo and ccc.cd_item_centro_custo = drcc.cd_item_centro_custo  
  left Join Documento_Receber dr on dr.cd_documento_receber  = drcc.cd_documento_receber
  left Join Cliente c on dr.cd_cliente = c.cd_cliente 
  left Join Documento_Receber_Pagamento drp on dr.cd_documento_receber = drp.cd_documento_receber 
  left join portador p on dr.cd_portador = p.cd_portador

Where
   IsNull(cc.cd_centro_custo,0) = (case isnull (@cd_centro_custo,0)
  			when 0 then
   			    IsNull(cc.cd_centro_custo,0)
  			else 
			    @cd_centro_custo
  			end)

  and IsNull(ccc.cd_item_centro_custo,0) = (case isnull (@cd_item_centro_custo,0)
  			when 0 then
   			    IsNull(ccc.cd_item_centro_custo,0)
  			else 
			    @cd_item_centro_custo
  			end)

