
CREATE VIEW vw_exporta_entrada_contmatic_dipi
------------------------------------------------------------------------------------
--vw_exporta_entrada_contmatic_dipi
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Pharma Special
--                        DIIPI - Produtos - Entrada
--Data                  : 19.03.2006
--Atualização           : 13.04.2006 - Alteracao Para o padrao da Pic - Danilo
--                      : 13.04.2006 - Acerto da Exportação para número com Zero a Esquerda - Carlos Fernandes
--                      : 17.04.2006 - Ajustes - Carlos Fernandes
-- 08.10.2009 - Ajustes Diversos - Carlos Fernandes
-- 23.10.2009 - Fornecedor - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------
as
  
--select * from nota_entrada_item
--select * from classificacao_fiscal

--Acho que tem que ser Group by

select  
  ne.cd_nota_entrada,
  ne.dt_nota_entrada, 
  ne.dt_receb_nota_entrada,
  'R2'                                             as TIPOREGISTRO,
  cast(' ' as char(08) )                           as Vago_1,
  cf.cd_mascara_classificacao                      as NCM,
  case when isnull(cf.nm_classificacao_fiscal,'')=''
  then 
     cast(cf.nm_classificacao_fiscal as char(25))
  else
     cast(nei.nm_produto_nota_entrada  as char(25))
  end                                              as DESCRICAO,
  nei.vl_bipi_nota_entrada                         as Base_IPI,
  nei.vl_ipi_nota_entrada                          as IPI,
  nei.vl_ipiisen_nota_entrada                      as Isento_IPI,
  cast(' ' as  char(50))                           as Vago_2,
  ne.cd_fornecedor

from
  Nota_Entrada ne                     with (nolock) 

  inner join Nota_Entrada_item nei on nei.cd_nota_entrada      = ne.cd_nota_entrada      and
                                      nei.cd_fornecedor        = ne.cd_fornecedor        and
                                      nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                                      nei.cd_operacao_fiscal   = ne.cd_operacao_fiscal

  left outer join Classificacao_fiscal cf on cf.cd_classificacao_fiscal = nei.cd_classificacao_fiscal 	

where
  isnull(nei.cd_classificacao_fiscal,0)>0

union

select  
  ns.cd_nota_saida                               as cd_nota_entrada,
  ns.dt_nota_saida                               as dt_nota_entrada, 
  ns.dt_nota_saida                               as dt_receb_nota_entrada,
  'R2'                                           as TIPOREGISTRO,
  cast(' ' as char(08) )                         as Vago_1,
  cast(cf.cd_mascara_classificacao as char(10))  as NCM,
  case when isnull(cf.nm_classificacao_fiscal,'')=''
  then 
     cast(cf.nm_classificacao_fiscal as char(25))
  else
     cast(nsi.nm_produto_item_nota   as char(25))
  end                                              as DESCRICAO,
  --nsi.vl_total_item                                as Base_IPI,
  nsi.vl_base_ipi_item                             as Base_IPI,
  nsi.vl_ipi                                       as IPI,
  nsi.vl_ipi_isento_item                           as Isento_IPI,

  cast(' ' as char(50))                            as Vago_2,
  isnull(ns.cd_cliente,0)                          as cd_fornecedor

--select * from nota_saida_item

from
  Nota_Saida ns                           with (nolock) 

  inner join Nota_Saida_item nsi          on nsi.cd_nota_saida      = ns.cd_nota_saida 

  left outer join Classificacao_fiscal cf on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal 	

  left outer join Operacao_Fiscal opf       with (nolock)  on opf.cd_operacao_fiscal         = ns.cd_operacao_fiscal
  left outer join Grupo_Operacao_Fiscal gof with (nolock)  on gof.cd_grupo_operacao_fiscal   = opf.cd_grupo_operacao_fiscal 

where
  isnull(nsi.cd_classificacao_fiscal,0)>0
  and  gof.cd_tipo_operacao_fiscal = 1     --ENTRADAS NO FATURAMENTO


