
CREATE VIEW vw_nfe_retencao_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_totais_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Valores Totais de RETENÇÃO DE TRIBUTOS da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 23.02.2010 - Verificação de Totais - Carlos Fernandes 
-- 21.05.2010 - Desenvolvimento Completo
-- 10.12.2010 - Identificação da Nota de Saída - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from nota_saida_item
--select * from nota_saida

select
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  ns.cd_identificacao_nota_saida,
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_retido_pis         > 0 then nsr.vl_retido_pis          else ns.vl_pis_retencao    end,6,2)),103),'0.00')          as 'vRetPIS',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_retido_cofins      > 0 then nsr.vl_retido_cofins       else ns.vl_cofins_retencao end,6,2)),103),'0.00')          as 'vRetCOFINS',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_retido_csll        > 0 then nsr.vl_retido_csll         else null end,6,2)),103),'0.00')                           as 'vRetCSLL',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_base_irrf          > 0 then nsr.vl_base_irrf           else null end,6,2)),103),'0.00')                           as 'vBCIRRF',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_retido_irrf        > 0 then nsr.vl_retido_irrf         else null end,6,2)),103),'0.00')                           as 'vIRRF',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_base_previdencia   > 0 then nsr.vl_base_previdencia    else null end,6,2)),103),'0.00')                           as 'vBCRetPrev',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsr.vl_retido_previdencia > 0 then nsr.vl_retido_previdencia  else null end,6,2)),103),'0.00')                           as 'vRetPrev',
      
  nsr.vl_retido_pis,
  nsr.vl_retido_cofins,    
  nsr.vl_retido_csll,      
  nsr.vl_base_irrf,        
  nsr.vl_retido_irrf,      
  nsr.vl_base_previdencia, 
  nsr.vl_retido_previdencia,
  ns.vl_pis_retencao,
  ns.vl_cofins_retencao

--select * from dI  

from
  nota_saida ns                                with (nolock) 
  left outer join nota_saida_retencao nsr      with (nolock) on nsr.cd_nota_saida      = ns.cd_nota_saida
  left outer join operacao_fiscal     opf      with (nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  left outer join cliente c                    with (nolock) on c.cd_cliente           = ns.cd_cliente 

where
  isnull(ns.vl_pis_retencao,0)>0 and isnull(ns.vl_cofins_retencao,0)>0
  and
  isnull(opf.ic_ret_piscofins_fiscal,'N')    = 'S' --> Verifica se a Operação Fiscal retem PIS/COFINS
  and
  isnull(c.ic_reter_piscofins_cliente,'N')   = 'S' --> Verifica se o Cliente retem PIS/COFINS

--select * from operacao_fiscal 
--select * from cliente

