
CREATE VIEW vw_escrita_fiscal_entrada_proforma_servnews
------------------------------------------------------------------------------------
--vw_escrita_fiscal_entrada_pharma_special
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2006
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Pharma Special
--
--                        Nota Fiscal de Entrda
--
--Data                  : 19.03.2006
--Atualização           : 14.04.2006 - Acertos Diversos
-- 29.07.2008 - Acertos ServNews - Proforma - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select top 10 * from fornecedor
--select * from Nota_Entrada

select
  'I'                                         as TIPO,
  substring(opf.cd_mascara_operacao,1,1)+
  substring(opf.cd_mascara_operacao,3,3)+
  '0'                                         as NATUREZA,
  cast(f.cd_cnpj_fornecedor  as varchar(14))  as CNPJ_CPF,
  cast(ne.cd_nota_entrada    as varchar(09))  as NUM_NOTA_INICIAL,
  cast(ne.cd_nota_entrada    as varchar(09))  as NUM_NOTA_FINAL,
  ne.nm_serie_nota_entrada                    as SERIE,
  ne.nm_especie_nota_entrada                  as ESPECIE,
  ne.dt_nota_entrada                          as DATA_DOCUMENTO,
  ne.dt_receb_nota_entrada                    as DATA_SAIDA_ENTRADA,
  e.sg_estado                                 as ESTADO,
  ne.vl_total_nota_entrada                    as VALOR_CONTABIL,
  ne.vl_bicms_nota_entrada                    as BASE_ICMS_1,

  cast(0                 as float )           as BASE_ICMS_2,
  cast(0                 as float )           as BASE_ICMS_3,

  cast(0                 as float )           as ALIQ_ICMS_1,
  cast(0                 as float )           as ALIQ_ICMS_2,
  cast(0                 as float )           as ALIQ_ICMS_3,

  ne.vl_icms_nota_entrada                     as ICMS_1,

  cast(0                 as float )           as ICMS_2,
  cast(0                 as float )           as ICMS_3,
  cast(0                 as float )           as ISENTAS_ICMS,
  cast(0                 as float )           as OUTRAS_ICMS,

  ne.vl_bipi_nota_entrada                     as BASE_IPI,

  cast(0                 as float )           as ALIQ_IPI,

  ne.vl_ipi_nota_entrada                      as IPI,

  cast(0    as float)                         as ISENTAS_IPI,
  cast(0    as float)                         as OUTRAS_IPI,
  cast(null as varchar(80))                   as OBSERVACAO_DESCRICAO,
  cast(null as varchar(19))                   as OBSERVACAO_VALOR,

  '00'                                        as CONSTANTE,

  cast(0  as int )                            as CODIGO_SERVICO,

  ne.vl_bsticm_nota_entrada                   as BASE_ICMS_SUBSTITUICAO,
  ne.vl_sticm_nota_entrada                    as ICMS_SUBSTITUICAO,
  'N'                                         as SITUACAO_NOTA,
  '#13'                                       as FINAL_LINHA

from
	Nota_Entrada ne with (nolock) 
        left outer join operacao_fiscal opf  with (nolock) on opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
        left outer join fornecedor      f    with (nolock) on f.cd_fornecedor        = ne.cd_fornecedor
        left outer join serie_nota_fiscal sn with (nolock) on sn.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
        left outer join estado            e  with (nolock) on e.cd_estado             = f.cd_estado

--select * from nota_entrada
--select * from operacao_fiscal
--select * from serie_nota_fiscal
--select * from estado

--	Nota_Entrada ne
--	left outer join
--      Nota_Entrada_Item nei on nei.cd_nota_entrada = ne.cd_nota_entrada
--	left outer join
--	Nota_Entrada_Item_Registro neir on neir.cd_nota_entrada = ne.cd_nota_entrada


 	
