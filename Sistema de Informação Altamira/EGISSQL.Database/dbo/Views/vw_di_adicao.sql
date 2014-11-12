
CREATE VIEW vw_di_adicao
------------------------------------------------------------------------------------
--sp_helptext vw_di_adicao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Adição em DI - Declaração de Importação
--Data                  : 18.02.2009
--Atualização           : 18.02.2009
-- 18.03.2009 - Finalização da Viws - Carlos Fernandes
------------------------------------------------------------------------------------
as
 
--select * from di_item

select
  di.cd_di,
  cf.cd_classificacao_fiscal,
  max(cf.cd_mascara_classificacao)   as cd_mascara_classificacao,
  sum(di.qt_efetiva_chegada)         as qt_classificacao,
  max(di.pc_di_item_ii)              as pc_ii,
  max(di.pc_di_item_ipi)             as pc_ipi,
  max(di.pc_di_item_icms)            as pc_icms,
  max(di.pc_di_item_red_base)        as pc_di_item_red_base,
  max(di.pc_di_item_pis)             as pc_pis,
  max(di.pc_di_item_cof)             as pc_cofins,
  sum(di.vl_total_ipi_item_di)       as vl_ipi,
  sum(di.vl_total_ii_item_di)        as vl_ii,
  sum(di.vl_total_pis_item_di)       as vl_pis,
  sum(di.vl_total_cof_item_di)       as vl_cofins,
  sum(di.vl_total_icms_item_di)      as vl_icms,
  sum(di.vl_frete_item_di)           as vl_frete,
  sum(di.vl_total_seguro_item_di)    as vl_seguro,
  sum(di.vl_cfr_item_di)             as vl_aduaneiro,
  sum(di.qt_peso_liq_item_di)        as qt_peso_liq_item_di,
  sum(di.qt_peso_bruto_item_di)      as qt_peso_bruto_item_di,
  sum(di.vl_total_capatazia_item_di) as vl_total_capatazia_item_di
  
--select * from di_item


from
  Di_item di                   with (nolock)
  inner join Produto p         on p.cd_produto                     = di.cd_produto
  inner join Produto_Fiscal pf on pf.cd_produto                    = p.cd_produto
  inner join Classificacao_Fiscal cf on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal

group by
  di.cd_di,
  cf.cd_classificacao_fiscal 

--select * from di

