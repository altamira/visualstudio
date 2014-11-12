
CREATE VIEW vw_nfe_pis_st_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_pis_st_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do PIS da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

select
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  'R'                                                            as 'PISST',
  cast(ti.cd_digito_tributacao_pis as varchar(2))                                    as 'CST',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 then nsi.vl_total_item else null end,6,2)),103),'')      as 'vBC',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_pis > 0 then 
                                                        nsi.pc_pis 
                                                      else
                                                        case when nsi.vl_pis > 0 then
                                                          isnull(CONVERT(varchar, convert(numeric(14,2),round(((nsi.vl_pis * 100)/(nsi.vl_total_item)),6,2)),103),'')   
                                                        else
                                                          null
                                                        end 
                                                      end,6,2)),103),'')  as 'pPIS',

--  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_pis > 0 then nsi.pc_pis else null end,6,2)),103),'')             as 'pPIS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_pis > 0 then nsi.vl_pis else null end,6,2)),103),'')             as 'vPIS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.qt_item_nota_saida > 0 then nsi.qt_item_nota_saida else null end,6,2)),103),'') as 'qBCProd',
  --Não tem este campo no Egis ainda----------------------------
  isnull(CONVERT(varchar, convert(numeric(14,2),round(null,6,2)),103),'')                   as 'vAliqProd'
  
from
  nota_saida_item nsi                               with (nolock)
  inner join nota_saida ns                          with (nolock) on ns.cd_nota_saida            = nsi.cd_nota_saida
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto               = nsi.cd_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao             = pf.cd_tributacao
  left outer join tributacao_pis ti                 with (nolock) on ti.cd_tributacao_pis        = t.cd_tributacao_pis 
   

--select * from nota_saida_item

