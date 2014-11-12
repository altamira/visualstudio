
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
--Alteração        : 15.07.2006 - Acertos Gerais - Carlos Fernandes
-- 23.01.2009 - Ajustes Diversos - Carlos Fernandes
-- 26.01.2011 - Novo Campo / Plano Financeiro - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_documento_pagar_centro_custo

@cd_centro_custo      int      = 0,
@cd_item_centro_custo int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''
AS

select 
  dp.cd_documento_pagar,
  cc.nm_centro_custo, 
  cc.cd_centro_custo,
  ccc.nm_item_centro_custo,
  ccc.cd_item_centro_custo,
  (case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))    
       when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))    
       when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))    
       when (coalesce(f.nm_fantasia_fornecedor,dp.nm_fantasia_fornecedor,'') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))      
  end)                             as 'nm_favorecido', 

 (case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(30))    
      when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(30))    
      when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(30))    
      when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast(dp.nm_fantasia_fornecedor as varchar(30))    
 end)                             as 'cd_favorecido',

--  coalesce(f.nm_razao_social,dp.nm_fantasia_fornecedor,'')        as nm_razao_social,
  dp.cd_identificacao_document,
  dp.vl_documento_pagar,
  dp.dt_vencimento_documento,
  dp.dt_emissao_documento_paga,
  dpcc.vl_centro_custo,
  dpcc.pc_centro_custo,
  dpp.dt_pagamento_documento,
  dpp.vl_pagamento_documento,
  pf.nm_conta_plano_financeiro,
  cd_mascara_plano_financeiro




From 
  Documento_Pagar dp                          with (nolock) 
  left Join Documento_Pagar_Centro_Custo dpcc on dp.cd_documento_pagar    = dpcc.cd_documento_pagar

  left Join Centro_Custo            cc        on cc.cd_centro_custo       = case when isnull(dpcc.cd_centro_custo,0)=0
                                                                            then dp.cd_centro_custo 
                                                                            else dpcc.cd_centro_custo end 

  left Join Centro_Custo_Composicao ccc       on cc.cd_centro_custo       = ccc.cd_centro_custo and 
                                                 ccc.cd_item_centro_custo = dpcc.cd_item_centro_custo  
  left Join Fornecedor f                      on dp.cd_fornecedor         = f.cd_fornecedor 
  left Join Documento_Pagar_Pagamento dpp     on dp.cd_documento_pagar    = dpp.cd_documento_pagar 
  left Join Plano_Financeiro pf               on pf.cd_plano_financeiro   = dp.cd_plano_financeiro

where
   dp.dt_vencimento_documento between @dt_inicial and @dt_final 

   and cc.cd_centro_custo = (case isnull (@cd_centro_custo,0)
  			when 0 then
   			    cc.cd_centro_custo
  			else 
			    @cd_centro_custo
  			end)

  and isnull(dpcc.cd_item_centro_custo,0) = (case when isnull(@cd_item_centro_custo,0)=0 then
                                                  isnull(dpcc.cd_item_centro_custo,0)
  			                     else 
                                                  @cd_item_centro_custo
                                             end)

order by
  cc.nm_centro_custo, dp.dt_vencimento_documento desc


