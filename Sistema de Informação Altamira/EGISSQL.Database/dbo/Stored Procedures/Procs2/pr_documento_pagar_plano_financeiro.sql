
-------------------------------------------------------------------------------
--sp_helptext pr_documento_pagar_plano_financeiro
-------------------------------------------------------------------------------
--pr_documento_pagar_plano_financeiro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Obter Dados para tela de Documentos a Pagar por Plano Financeiro
--Data             : 15.06.2007
--Alteração        : 15.06.2007
--                 : 02.08.2007 - Mostrar o plano financeiro solicitado - Carlos Fernandes
--                 : 03.09.2007 - Acerto do valor do documento qdo pgto parcial - Carlos Fernandes
-- 05.06.2008 - Verificação do Plano Financeiro - Carlos Fernandes
-- 26.11.2011 - Centro de Custo - Carlos Fernandes
------------------------------------------------------------------------------------------
create procedure pr_documento_pagar_plano_financeiro

@cd_plano_financeiro  int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''

as

select 

  dp.cd_documento_pagar,

  case when dp.cd_plano_financeiro>0 
  then pfd.cd_plano_financeiro 
  else pf.cd_plano_financeiro 
  end                                          as cd_plano_financeiro,

  case when dp.cd_plano_financeiro>0 
  then
    pfd.nm_conta_plano_financeiro
  else
    pf.nm_conta_plano_financeiro
  end                                          as nm_conta_plano_financeiro,

  case when dp.cd_plano_financeiro>0 
  then
    pfd.cd_mascara_plano_financeiro
  else
    pf.cd_mascara_plano_financeiro
  end                                          as  cd_mascara_plano_financeiro,

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
  dp.vl_saldo_documento_pagar,
  dp.dt_vencimento_documento,
  dp.dt_emissao_documento_paga,

  case when dp.cd_plano_financeiro>0 and isnull(dpf.vl_plano_financeiro,0)=0
  then
    isnull(dp.vl_documento_pagar,0)
  else
    isnull(dpf.vl_plano_financeiro,0)
  end                                                as vl_plano_financeiro,

  case when isnull(dp.cd_plano_financeiro,0)>0
  then
    100
  else
    dpf.pc_plano_financeiro
  end                                                as pc_plano_financeiro,
  dpf.nm_obs_documento_plano,
  dpp.dt_pagamento_documento,
  isnull(dpp.vl_pagamento_documento,0)               as vl_pagamento_documento,

  case when isnull(dp.cd_plano_financeiro,0)>0
  then
    cast(pfd.cd_mascara_plano_financeiro as varchar(30))+' - '+ pfd.nm_conta_plano_financeiro 
  else
    cast(pf.cd_mascara_plano_financeiro as varchar(30))+' - '+ pf.nm_conta_plano_financeiro
  end  as 'PLANOFINANCEIRO',

  case when isnull(dp.cd_plano_financeiro,0)>0
  then
    isnull(dp.vl_documento_pagar,0)
  else
    isnull(dpf.vl_plano_financeiro,0)
  end                                                as vl_total_plano,

  cc.cd_mascara_centro_custo,  
  cc.nm_centro_custo

--select * from documento_pagar_plano_financ

From 
  Documento_Pagar dp                                with (nolock) 
  left outer Join Documento_Pagar_Pagamento dpp     with (nolock) on dp.cd_documento_pagar    = dpp.cd_documento_pagar 
  left outer Join Documento_Pagar_Plano_Financ dpf  with (nolock) on dpf.cd_documento_pagar   = dp.cd_documento_pagar
  left outer Join Fornecedor f                      with (nolock) on dp.cd_fornecedor         = f.cd_fornecedor 

  left outer Join Plano_Financeiro             pfd  with (nolock) on pfd.cd_plano_financeiro  = dp.cd_plano_financeiro                                           
  left outer Join Plano_Financeiro             pf   with (nolock) on pf.cd_plano_financeiro   = dpf.cd_plano_financeiro
  left outer Join Centro_Custo cc                   with (nolock) on cc.cd_centro_custo       = dp.cd_centro_custo

where
   dp.dt_vencimento_documento between @dt_inicial and @dt_final 
   and
   ( isnull(dp.cd_plano_financeiro,0)  = case when @cd_plano_financeiro = 0 then isnull(dp.cd_plano_financeiro,0)  else @cd_plano_financeiro end 
   or isnull(dpf.cd_plano_financeiro,0) = case when @cd_plano_financeiro = 0 then isnull(dpf.cd_plano_financeiro,0) else @cd_plano_financeiro end )
   
order by
  PLANOFINANCEIRO,
  dp.dt_vencimento_documento desc


