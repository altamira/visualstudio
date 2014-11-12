
CREATE VIEW vw_nfe_ipi_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_ipi_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local da Retirada da Nota Fiscal 
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
  'O'                                                            as 'IPI',
  cast('' as varchar(5))                                         as 'cIEnq',
  cast('' as varchar(14))                                        as 'CNPJProd',
  cast('' as varchar(1))                                         as 'cSelo',
  cast('' as varchar(12))                                        as 'qSelo',
  cast('999' as varchar(03))                                     as 'cEnq',
  'O07'                                                          as 'IPITrib',
  rtrim(ltrim(cast(ti.cd_digito_tributacao_ipi as varchar(80)))) as 'CST',
  case when isnull(nsi.vl_base_ipi_item,0)>0 then
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_base_ipi_item > 0 then nsi.vl_base_ipi_item else null end,6,2)),103),'')
  else
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 then nsi.vl_total_item else null end,6,2)),103),'')
  end                                                            as 'vBC',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.qt_item_nota_saida > 0 then nsi.qt_item_nota_saida else null end,6,2)),103),'')       as 'qUnid',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_unitario_ipi_produto > 0 then nsi.vl_unitario_ipi_produto else null end,6,2)),103),'') as 'vUnid',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_ipi > 0 then nsi.pc_ipi else null end,6,2)),103),'')  as 'pIPI',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_ipi > 0 then nsi.vl_ipi else null end ,6,2)),103),'') as 'vIPI',
  'O08'                                                                                                                      as 'IPINT'
  
from
  nota_saida_item nsi                               with (nolock)
  inner join nota_saida ns                          with (nolock) on ns.cd_nota_saida            = nsi.cd_nota_saida
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto               = nsi.cd_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao             = pf.cd_tributacao
  left outer join tributacao_ipi ti                 with (nolock) on ti.cd_tributacao_ipi        = t.cd_tributacao_ipi 
  left outer join classificacao_fiscal cf           with (nolock) on cf.cd_classificacao_fiscal  = nsi.cd_classificacao_fiscal
    
--select * from tributacao_ipi       
--select * from classificacao_fiscal_estado

--select * from procedencia_produto
--select * from tributacao_icms
--select * from nota_saida_item
--select cd_estado,* from nota_saida
