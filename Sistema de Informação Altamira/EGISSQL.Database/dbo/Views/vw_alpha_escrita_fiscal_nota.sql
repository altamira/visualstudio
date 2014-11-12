
CREATE VIEW vw_alpha_escrita_fiscal_nota
------------------------------------------------------------------------------------
--sp_helptext vw_alpha_escrita_fiscal_nota
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
  ns.dt_nota_saida                   as DTEMI,
  ns.dt_saida_nota_saida             as DTSAI,
  ns.cd_mascara_operacao             as CDFIS,
  isnull(ns.vl_total,0)              as VLCTA,
  isnull(ns.vl_bc_icms,0)            as BCICM,
  0.00                               as ALICM,
  isnull(ns.vl_icms,0)               as VLICM,
  isnull(ns.vl_icms_isento,0)        as ISICM,
  isnull(ns.vl_icms_outros,0)        as OUICM,
  isnull(ns.vl_bc_ipi,0)             as BCIPI,
  isnull(ns.vl_ipi,0)                as VLIPI,
  isnull(ns.vl_ipi_isento,0)         as ISIPI,
  isnull(ns.vl_ipi_outros,0)         as OUIPI,
  isnull(ns.vl_servico,0)            as VLSER,
  0.00                               as VLDES,
  --Nota Fiscal Cancelada
  case when ns.cd_status_nota = 7 and dt_cancel_nota_saida is not null 
  then
    'S'           
  else
    'N'
  end                                as CANCE,  

  --cast('' as varchar(40))  as OBSER,
  ns.cd_cnpj_nota_saida                        as CGCDE,
  ns.cd_inscest_nota_saida                     as INEST,
  ns.nm_razao_social_nota                      as RAZAO,
  ns.nm_cidade_nota_saida                      as MUNIC,
  ns.sg_estado_nota_saida                      as UNFED,
  ns.cd_cep_nota_saida                         as NRCEP,
  0.00                                         as IPINC,
  isnull(opf.ic_ativo_operacao_fiscal,'N')     as ATIVO,
  isnull(opf.ic_zfm_operacao_fiscal,'N')       as OPZFM
 
  --ns.nm_bairro_nota_saida  as BAIRRO,
from
  Nota_Saida ns with (nolock)
  inner join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal

--select * from operacao_fiscal

--where
--  ns.cd_status_nota<>7 --Nota Cancelada não entrada na exportação
-- order by
--   ns.cd_nota_saida

--select * from status_nota
--select * from nota_saida

