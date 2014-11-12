
CREATE VIEW vw_escrita_fiscal_saida_pharma_special
------------------------------------------------------------------------------------
--vw_escrita_fiscal_saida_pharma_special
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Pharma Special
--Data                  : 19.03.2006
--Atualização           : 14.04.2006 - Revisão Geral
-- 29.07.2008 - Verificação da colunas Isentas - Carlos Fernandes                    
------------------------------------------------------------------------------------
as

select
  'I'                                         as TIPO,

  substring(ns.cd_mascara_operacao,1,1)+
  substring(ns.cd_mascara_operacao,3,3)+
  '0'                                         as NATUREZA,

  cast(ns.cd_cnpj_nota_saida as varchar(14))  as CNPJ_CPF,

  cast(ns.cd_nota_saida      as varchar(09))  as NUM_NOTA_INICIAL,
  cast(ns.cd_nota_saida      as varchar(09))  as NUM_NOTA_FINAL,

--  cast(null                  as varchar(03))  as SERIE,
--  cast(null                  as varchar(05))  as ESPECIE,

--  'NFF'                                       as SERIE,
  CAST(sn.nm_serie_livro_saida as varchar(3)) as SERIE,

--  'NFF'                                       as ESPECIE,
  CAST(sn.nm_especie_livro_saida as varchar(5)) as ESPECIE,

  ns.dt_nota_saida                            as DATA_DOCUMENTO,

  case when ns.dt_saida_nota_saida is null 
       then ns.dt_nota_saida                  
       else ns.dt_saida_nota_saida end        as DATA_SAIDA_ENTRADA,

  ns.sg_estado_nota_saida                     as ESTADO,

  isnull(ns.vl_total,0)                       as VALOR_CONTABIL,

  isnull(ns.vl_bc_icms,0)                     as BASE_ICMS_1,

  cast(null                 as float )        as BASE_ICMS_2,

  cast(null                 as float )        as BASE_ICMS_3,

--  cast(null                 as float )        as ALIQ_ICMS_1,
-- select * from nota_saida

  (select top 1 isnull(pc_icms,0) 
   from 
     Nota_Saida_Item 
   where cd_nota_saida = ns.cd_nota_saida
   and isnull(pc_icms,0)>0                )   as ALIQ_ICMS_1,

  cast(null                 as float )        as ALIQ_ICMS_2,

  cast(null                 as float )        as ALIQ_ICMS_3,

  isnull(ns.vl_icms,0)                        as ICMS_1,  

  cast(null                 as float )        as ICMS_2,

  cast(null                 as float )        as ICMS_3,

  --isnull(ns.vl_icms_isento,0)                 as ISENTAS_ICMS,
  0.00                                        as ISENTAS_ICMS,

  case when isnull(ns.vl_icms_outros,0)>0 then
     isnull(ns.vl_icms_outros,0)              
  else
     isnull(ns.vl_icms_isento,0)
  end                                         as OUTRAS_ICMS,

  isnull(ns.vl_bc_ipi,0)                      as BASE_IPI,

  (select top 1 isnull(pc_ipi,0) 
   from 
     Nota_Saida_Item 
   where
     cd_nota_saida = ns.cd_nota_saida and
     isnull(pc_ipi,0) >0                  )   as ALIQ_IPI,

  ns.vl_ipi                                   as IPI,

  isnull(ns.vl_ipi_isento,0)                  as ISENTAS_IPI,

  isnull(ns.vl_ipi_outros,0)                  as OUTRAS_IPI,

  cast(null as varchar(80))                   as OBSERVACAO_DESCRICAO,

  cast(null as varchar(19))                   as OBSERVACAO_VALOR,

  '00'                                        as CONSTANTE,

  cast(0    as int )                          as CODIGO_SERVICO,

  isnull(ns.vl_bc_subst_icms,0)               as BASE_ICMS_SUBSTITUICAO,

  isnull(ns.vl_icms_subst,0)                  as ICMS_SUBSTITUICAO,

  case when ns.cd_status_nota = 7 
       then 'C'
       else 'N' end                           as SITUACAO_NOTA,

  '#13'                                       as FINAL_LINHA

from
  Nota_Saida ns with (nolock) 
  left outer join Serie_Nota_Fiscal sn on sn.cd_serie_nota_fiscal = ns.cd_serie_nota
  left outer join Operacao_Fiscal  opf on opf.cd_operacao_fiscal  = ns.cd_operacao_fiscal
where
  isnull(opf.ic_servico_operacao,'N')='N'

	--left outer join	Nota_Saida_Item nsi           on nsi.cd_nota_saida  = ns.cd_nota_saida
	--left outer join Nota_Saida_Item_Registro nsir on nsir.cd_nota_saida = ns.cd_nota_saida
        --left outer join Operacao_Fiscal opf           on n
 	
