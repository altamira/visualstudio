
-------------------------------------------------------------------------------
--pr_documento_pagar_centro_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Obter Dados para tela de Documentos a Pagar por Centro de Custo
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_documento_pagar_centro_custo

@cd_centro_custo int        = 0,
@cd_item_centro_custo int   = 0

AS
Select 
  dp.cd_documento_pagar,
  cc.nm_centro_custo, 
  cc.cd_centro_custo,
  ccc.nm_item_centro_custo,
  ccc.cd_item_centro_custo,
  f.nm_fantasia_fornecedor,
  f.nm_razao_social,
  dp.cd_identificacao_document,
  dp.vl_documento_pagar,
  dp.dt_vencimento_documento,
  dp.dt_emissao_documento_paga,
  dpcc.vl_centro_custo,
  dpcc.pc_centro_custo,
  dpp.dt_pagamento_documento,
  dpp.vl_pagamento_documento

From Centro_Custo cc
  left Join Documento_Pagar_Centro_Custo dpcc on cc.cd_centro_custo = dpcc.cd_centro_custo  
  left Join Centro_Custo_Composicao ccc on cc.cd_centro_custo = ccc.cd_centro_custo and ccc.cd_item_centro_custo = dpcc.cd_item_centro_custo  
  left Join Documento_Pagar dp on dp.cd_documento_pagar  = dpcc.cd_documento_pagar
  left Join Fornecedor f on dp.cd_fornecedor = f.cd_fornecedor 
  left Join Documento_Pagar_Pagamento dpp on dp.cd_documento_pagar = dpp.cd_documento_pagar 

Where
   cc.cd_centro_custo = (case isnull (@cd_centro_custo,0)
  			when 0 then
   			    cc.cd_centro_custo
  			else 
			    @cd_centro_custo
  			end)

  and ccc.cd_item_centro_custo = (case isnull (@cd_item_centro_custo,0)
  			when 0 then
   			    ccc.cd_item_centro_custo
  			else 
			    @cd_item_centro_custo
  			end)
