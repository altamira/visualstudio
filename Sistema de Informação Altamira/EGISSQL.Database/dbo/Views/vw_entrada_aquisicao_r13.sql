
CREATE VIEW vw_entrada_aquisicao_r13
------------------------------------------------------------------------------------
--vw_entrada_aquisicao_r13
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Notas Fiscais de Entrada/Aquisiç~]ao - Tipo R13
--Data                  : 23.04.2007
--Atualização           : 23.05.2007 - Acerto de Flag de Operação Fiscal de Crédito - Carlos Fernandes
--                      
------------------------------------------------------------------------------------
as
 
--select * from nota_entrada
--select * from nota_entrada_Item_registro

select
  cast(f.cd_cnpj_fornecedor   as varchar(14))       as CNPJ,
  cast(ne.cd_nota_entrada     as varchar(15))       as Documento,
  cast(s.sg_serie_nota_fiscal as varchar(03))       as Serie,
  ne.dt_nota_entrada                                as Emissao,
  ne.dt_receb_nota_entrada                          as Recebimento,
  replace(ofi.cd_mascara_operacao,'.','')           as CFOP,
  ne.vl_total_nota_entrada                          as TOTAL,
  ne.vl_ipi_nota_entrada                            as IPI,
  ner.vl_ipi_reg_nota_entrada                       as IPILIVRO
from
  Nota_Entrada ne                           with (nolock)
  inner join fornecedor f                   with (nolock) on f.cd_fornecedor          = ne.cd_fornecedor
  inner join Serie_Nota_Fiscal s            with (nolock) on s.cd_serie_nota_fiscal   = ne.cd_serie_nota_fiscal
  inner join Operacao_Fiscal ofi            with (nolock) on ofi.cd_operacao_fiscal   = ne.cd_operacao_fiscal
  inner join Nota_Entrada_Item_Registro ner with (nolock) on ner.cd_nota_entrada      = ne.cd_nota_entrada and
                                                         ner.cd_fornecedor        = ne.cd_fornecedor   and
                                                         ner.cd_operacao_fiscal   = ne.cd_operacao_fiscal and
                                                         ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
where
  isnull(ofi.ic_credito_ipi_operacao,'N')='S' and
  isnull(vl_ipi_reg_nota_entrada,0)>0

--select * from serie_nota_fiscal

-- 01
--  CNPJ do Emitente
--  01
--  14
--  14
--  Numérico
--  
-- 02
--  Número do Documento
--  15
--  20
--  6
--  Numérico
--  
-- 03
--  Série/Subsérie do Documento
--  21
--  23
--  3
--  Alfanumérico
--  
-- 04
--  Data de Emissão
--  24
--  31
--  8
--  Numérico
--  
-- 05
--  Data de Entrada
--  32
--  39
--  8
--  Numérico
--  
-- 06
--  Código Fiscal de Operação (CFOP)
--  40
--  43
--  4
--  Alfanumérico
--  
-- 07
--  Valor Total
--  44
--  57
--  14
--  Numérico
--  
-- 08
--  Valor do IPI Destacado
--  58
--  71
--  14
--  Numérico
--  
-- 09
--  Valor do IPI Creditado no Livro RAIPI
--  72
--  85
--  14
--  Numérico
--  

