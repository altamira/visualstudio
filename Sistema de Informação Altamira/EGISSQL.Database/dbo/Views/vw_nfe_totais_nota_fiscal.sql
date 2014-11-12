
CREATE VIEW vw_nfe_totais_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_totais_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Valores Totais da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 23.02.2010 - Verificação de Totais - Carlos Fernandes 
-- 06.10.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
-- 17.11.2010 - Ajuste do Frete - Carlos / Luis Santana
------------------------------------------------------------------------------------
as

--select * from nota_saida_item
--select * from nota_saida

select
  ns.cd_identificacao_nota_saida,
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  'W'                                                                                                    as 'total',
  'W02'                                                                                                  as 'ICMSTot',--

--  ns.vl_bc_icms                 as 'vBC',--
--   ns.vl_icms                    as 'vICMS',--
--   ns.vl_bc_subst_icms           as 'vBCST',--
--   ns.vl_icms_subst              as 'vST',--
--   ns.vl_produto                 as 'vProd',--
--   ns.vl_frete                   as 'vFrete',--
--   ns.vl_seguro                  as 'vSeg',--
--   ns.vl_desconto_nota_saida     as 'vDesc',--
--   ns.vl_ii                      as 'vII',  --
--   ns.vl_ipi                     as 'vIPI', --
--   ns.vl_pis                     as 'vPIS',--
--   ns.vl_cofins                  as 'vCOFINS',--
--   ns.vl_desp_acess              as 'vOutro',--
--   ns.vl_total                   as 'vNF',--

  --select * from nota_saida_item where cd_nota_saida = 611

--Para checagem dos valores.

--   ( select sum( isnull(nsi.vl_base_icms_item,0) ) 
--     from
--      nota_saida_item nsi 
--     where
--      nsi.cd_nota_saida = ns.cd_nota_saida ) as vl_base_icms_item,
-- 
--   ( select sum( isnull(nsi.vl_total_item,0) ) 
--     from
--      nota_saida_item nsi 
--     where
--      nsi.cd_nota_saida = ns.cd_nota_saida ) as vl_total_item,

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_bc_icms             > 0 then ns.vl_bc_icms       else null end,6,2)),103),'0.00')             as 'vBC',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_icms                > 0 then ns.vl_icms          else null end,6,2)),103),'0.00')             as 'vICMS',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_bc_subst_icms       > 0 then ns.vl_bc_subst_icms else null end,6,2)),103),'0.00')             as 'vBCST',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_icms_subst          > 0 then ns.vl_icms_subst    else null end,6,2)),103),'0.00')             as 'vST',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_produto             > 0 then ns.vl_produto       else null end,6,2)),103),'0.00')             as 'vProd',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_frete               > 0 then ns.vl_frete         else null end,6,2)),103),'0.00')             as 'vFrete',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_seguro              > 0 then ns.vl_seguro        else null end,6,2)),103),'0.00')             as 'vSeg',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_desconto_nota_saida > 0 then ns.vl_desconto_nota_saida else null end,6,2)),103),'0.00')       as 'vDesc',--

  --Valor do Imposto de Importação
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_ii                  > 0 then ns.vl_ii            else null end,6,2)),103),'0.00')             as 'vII',  --

  --Valor do IPI

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_ipi                 > 0 then ns.vl_ipi           else null end,6,2)),103),'0.00')             as 'vIPI', --
  --Valor do PIS

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_pis                 > 0 then ns.vl_pis           else null end,6,2)),103),'0.00')             as 'vPIS',--
  --Valor do COFINS

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_cofins              > 0 then ns.vl_cofins        else null end,6,2)),103),'0.00')             as 'vCOFINS',--
  --Valor das Despesas Acessórias

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_desp_acess          > 0 then ns.vl_desp_acess    else 

    case when isnull(ic_materia_prima_aplicada,'N')='S' then
        case when ( ns.vl_produto - ns.vl_bc_icms ) > 0 then ns.vl_produto - ns.vl_bc_icms else null end 
    else
      null
    end

  end,6,2)),103),'0.00')             as 'vOutro',--

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total               > 0 then ns.vl_total         else null end,6,2)),103),'0.00')             as 'vNF',--

--'1.00' as 'vNF',

  'W17'                                                                                                  as 'ISSQNtot',--

--   ns.vl_servico as 'vServ',--
--   ns.vl_servico as 'vBCISS',
--   ns.vl_iss     as 'vISS',
 
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_servico       > 0 then ns.vl_servico else null end,6,2)),103),'0.00')                   as 'vServ',--
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_servico       > 0 then ns.vl_servico else null end,6,2)),103),'0.00')                   as 'vBCISS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_iss           > 0 then ns.vl_iss else null end,6,2)),103),'0.00')                       as 'vISS',
--  
  'W23'                                                                                              as 'retTrib',
 
 --Não Existe Campo no Egis-------------------------
  ''                                                                                                 as 'vRetPIS',
  ''                                                                                                 as 'vRetCOFINS',
  ''                                                                                                 as 'vRetCSLL',
--  ns.vl_servico                                                                            as 'vBCIRRF',
--  ns.vl_irrf_nota_saida                                                                    as 'vIRRF',
--  ns.vl_servico                                                                            as 'vBCRetPrev',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_servico         > 0 then ns.vl_servico else null end,6,2)),103),'0.00')                                               as 'vBCIRRF',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_irrf_nota_saida > 0 then ns.vl_irrf_nota_saida else null end,6,2)),103),'0.00')                                       as 'vIRRF',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_servico         > 0 then ns.vl_servico else null end,6,2)),103),'0.00')                                               as 'vBCRetPrev',
  ''                                                                                                 as 'vRefPrev'
      
--select * from dI  

from
  nota_saida ns                           with (nolock) 
  left outer join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal

--select * from operacao_fiscal

