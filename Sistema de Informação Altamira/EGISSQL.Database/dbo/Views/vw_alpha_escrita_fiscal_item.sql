
CREATE VIEW vw_alpha_escrita_fiscal_item
------------------------------------------------------------------------------------
--sp_helptext vw_alpha_escrita_fiscal_item
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Exportação da Nota Fiscal de Saída para Contabilidade
--Data                  : 13.12.2007
--Atualização           : 03.06.2008
------------------------------------------------------------------------------------
as

--select * from nota_saida
 
select
  '2'                                as TPMOV,
  '1'                                as TPREG,
  ns.cd_nota_saida,        
  ns.dt_nota_saida,
  ns.cd_nota_saida                   as NRDOC,
  cast('' as varchar(3))             as SERIE,
  'NFF'                              as ESPEC,
  ni.cd_item_nota_saida                           as NRITEM,
  CAST(ni.nm_fantasia_produto  as varchar(14))    as CDPRO,
  CAST(ni.nm_produto_item_nota as varchar(45))    as DESCR,
  CAST(replace(cf.cd_mascara_classificacao,'.','') as varchar(8)) as CLASS,
  CAST('' as varchar(13))                         as CDBAR,
  ni.cd_situacao_tributaria                       as SITTR,
  ni.qt_item_nota_saida                           as QUANT,
  ni.vl_unitario_item_nota                        as VLUNI,
  ni.vl_total_item                                as VLTOT,
  0.00 as VLDES,
  0.00 AS VLDESRAT,
  ni.vl_base_icms_item                            as BCICM,
  ni.pc_icms                                      as ALICM,
  ni.vl_icms_item                                 as VLICM,
  ni.vl_bc_subst_icms_item                        as BCICMST,
  ni.vl_icms_subst_icms_item                      as VLICMST,
  ni.vl_base_ipi_item                             as BCIPI,
  ni.pc_ipi                                       as ALIPI,
  ni.vl_ipi                                       as VLIPI,
  cast(um.sg_unidade_medida as varchar(10))       as UNIDA,
  cast('' as varchar(30))                         as APRES,
  0.00 AS IPINC,
  isnull(opf.ic_ativo_operacao_fiscal,'N')        as ATIVO

--select * from nota_saida_item
--select * from classificacao_fiscal

from
  Nota_Saida_item ni       with (nolock)
  inner join Nota_Saida ns with (nolock)  on ns.cd_nota_saida           = ni.cd_nota_saida
  inner join operacao_fiscal opf          on opf.cd_operacao_fiscal     = ns.cd_operacao_fiscal
  left outer join classificacao_fiscal cf on cf.cd_classificacao_fiscal = ni.cd_classificacao_fiscal
  left outer join unidade_medida um       on um.cd_unidade_medida       = ni.cd_unidade_medida
--select * from operacao_fiscal

--where
--  ns.cd_status_nota<>7 --Nota Cancelada não entrada na exportação
-- order by
--   ns.cd_nota_saida

--select * from status_nota
--select * from nota_saida

