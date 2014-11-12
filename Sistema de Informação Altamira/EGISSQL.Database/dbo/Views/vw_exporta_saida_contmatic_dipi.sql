CREATE VIEW vw_exporta_saida_contmatic_dipi
------------------------------------------------------------------------------------
--vw_exporta_saida_contmatic_dipi
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Pharma Special
--Data                  : 19.03.2006
--Atualização           : 13.04.2006 - Alteracao Para o padrao da Pic - Danilo
--                      : 13.04.2006 - Acerto da Exportação para número com Zero a Esquerda - Carlos Fernandes
--                      : 17.04.2006 - Ajustes - Carlos Fernandes
-- 05.10.2009 - Ajustes Diversos - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------
as
  
--select * from nota_saida_item
--select * from classificacao_fiscal

select  
  nsi.cd_nota_saida,
  nsi.dt_nota_saida, 
  'R2'                                           as TIPOREGISTRO,

  cast(' ' as char(08) )                         as Vago_1,

  cast(cf.cd_mascara_classificacao as char(10))  as NCM,

  case when isnull(cf.nm_classificacao_fiscal,'')=''
  then 
     cast(cf.nm_classificacao_fiscal as char(25))
  else
     cast(nsi.nm_produto_item_nota as char(25))
  end                                            as DESCRICAO,
  
  case when isnull(nsi.vl_ipi,0)>0 
  then 
    nsi.vl_base_ipi_item
  else
    0.00
  end 
                                                 as Base_IPI,
  isnull(nsi.vl_ipi,0)                           as IPI,
  isnull(nsi.vl_ipi_isento_item,0)               as Isento_IPI,
  cast(' ' as char(50))                          as Vago_2

from
  Nota_Saida ns                             with (nolock) 
  inner join Nota_Saida_Item nsi            with (nolock) on nsi.cd_nota_saida            = ns.cd_nota_saida
  left outer join Classificacao_fiscal cf   with (nolock) on cf.cd_classificacao_fiscal   = nsi.cd_classificacao_fiscal 	
  left outer join Operacao_Fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = ns.cd_operacao_fiscal
  left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal 

where
  gof.cd_tipo_operacao_fiscal = 2 --SAÍDAS
  and
  ns.cd_nota_saida in ( select cd_nota_saida 
                        from vw_faturamento vw with (nolock) 
                        where 
                          vw.ic_imposto_tipo_pedido = 'S'
                          and
                          vw.cd_nota_saida = ns.cd_nota_saida 
                       )


