
CREATE VIEW vw_escrita_fiscal_saida_servnews
------------------------------------------------------------------------------------
--vw_escrita_fiscal_saida_servnews
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--                        Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Servnews
--                        ** SERVIÇOS **
--Data                  : 05.08.2008
--Atualização           : 19.08.2008 - Modificação específica para Serviços
--                     
------------------------------------------------------------------------------------
as

select

  'C'                                         as TIPO,
  substring(ns.cd_mascara_operacao,1,1)+
  substring(ns.cd_mascara_operacao,3,3)+
  '0'                                         as NATUREZA,

  cast(ns.cd_cnpj_nota_saida as varchar(14))  as CNPJ_CPF,

  cast(ns.cd_nota_saida      as varchar(09))  as NUM_NOTA_INICIAL,
  cast(ns.cd_nota_saida      as varchar(09))  as NUM_NOTA_FINAL,

--  cast(null                  as varchar(03))  as SERIE,
--  cast(null                  as varchar(05))  as ESPECIE,

  'NFF'                                       as SERIE,

  'NFF'                                       as ESPECIE,

  ns.dt_nota_saida                            as DATA_DOCUMENTO,

  case when ns.dt_saida_nota_saida is null 
       then ns.dt_nota_saida                  
       else ns.dt_saida_nota_saida end        as DATA_SAIDA_ENTRADA,

  ns.sg_estado_nota_saida                     as ESTADO,

  isnull(ns.vl_total,0)                       as VALOR_CONTABIL,

--select * from nota_saida

  isnull(ns.vl_servico,0)                     as BASE_ISS_1,

  cast(null                 as float )        as BASE_ISS_2,

  cast(null                 as float )        as BASE_ISS_3,

--  cast(null                 as float )        as ALIQ_ICMS_1,
-- select * from nota_saida

  (select top 1 isnull(pc_iss_servico,0) 
   from 
     Nota_Saida_Item 
   where cd_nota_saida = ns.cd_nota_saida
   and isnull(pc_iss_servico,0)>0        )    as ALIQ_ISS_1,

--select * from nota_saida_Item

  cast(null                 as float )        as ALIQ_ISS_2,

  cast(null                 as float )        as ALIQ_ISS_3,

  isnull(ns.vl_iss,0)                         as ISS_1,  

  cast(null                 as float )        as ISS_2,

  cast(null                 as float )        as ISS_3,

  --isnull(ns.vl_icms_isento,0)                 as ISENTAS_ICMS,
  0.00                                        as ISENTAS_ICMS,

  --isnull(ns.vl_icms_outros,0)                 as OUTRAS_ICMS,
  0.00                                        as OUTRAS_ICMS,

  0.00                                        as BASE_IPI,

--  isnull(ns.vl_bc_ipi,0)                      as BASE_IPI,

--   (select top 1 isnull(pc_ipi,0) 
--    from 
--      Nota_Saida_Item 
--    where
--      cd_nota_saida = ns.cd_nota_saida and
--      isnull(pc_ipi,0) >0                  )   as ALIQ_IPI,

  0.00                                        as ALIQ_IPI,
  --ns.vl_ipi                                   as IPI,
  0.00                                        as IPI,

--  isnull(ns.vl_ipi_isento,0)                  as ISENTAS_IPI,
  0.00                                        as ISENTAS_IPI,

--  isnull(ns.vl_ipi_outros,0)                  as OUTRAS_IPI,
  0.00                                        as OUTRAS_IPI,

  cast(null as varchar(80))                   as OBSERVACAO_DESCRICAO,

  cast(null as varchar(19))                   as OBSERVACAO_VALOR,

  '00'                                        as CONSTANTE,

--  cast(0    as int )                          as CODIGO_SERVICO,

  (select top 1 isnull(cd_servico,0) 
   from 
     Nota_Saida_Item 
   where cd_nota_saida = ns.cd_nota_saida
   and isnull(cd_servico,0)>0        )        as CODIGO_SERVICO,

--  isnull(ns.vl_bc_subst_icms,0)               as BASE_ICMS_SUBSTITUICAO,
  0.00                                        as BASE_ICMS_SUBSTITUICAO,

  --isnull(ns.vl_icms_subst,0)                  as ICMS_SUBSTITUICAO,
  0.00                                        as ICMS_SUBSTITUICAO,

  case when ns.cd_status_nota = 7 
       then 'C'
       else 'N' end                           as SITUACAO_NOTA,

  '#13'                                       as FINAL_LINHA,
  0.00                                        as ISENTAS_ISS,
  0.00                                        as OUTRAS_ISS,
  0.00                                        as VALOR_RESERVADO,
  0.00                                        as ISS_DEVIDO_RETIDO,
  0.00                                        as VLRINSS,
  0.00                                        as VLRIRRF,
  0.00                                        as VLRPIS,
  0.00                                        as VLRCOFINS,
  0.00                                        as VLRCSLL
  

from
  Nota_Saida ns with (nolock)
  left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
where
  isnull(opf.ic_servico_operacao,'N') = 'S'

--select * from operacao_fiscal where ic_servico_operacao = 'S'

 	
