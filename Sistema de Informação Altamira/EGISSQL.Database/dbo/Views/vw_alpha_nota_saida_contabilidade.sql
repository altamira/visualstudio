
CREATE VIEW vw_alpha_nota_saida_contabilidade
------------------------------------------------------------------------------------
--sp_helptext vw_alpha_nota_saida_contabilidade
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Exportação da Nota Fiscal de Saída para Contabilidade
--Data                  : 13.12.2007
--Atualização           : 
------------------------------------------------------------------------------------
as
 
select
  ns.cd_nota_saida,
  ns.dt_nota_saida,
  ns.sg_estado_nota_saida  as UNDEF,
  ns.cd_nota_saida         as NRDOC,
  cast('' as varchar(5))   as SERIE,
  'NFF'                    as ESPEC,
  ns.dt_nota_saida         as DTEMI,
  ns.dt_saida_nota_saida   as DTSAI,
  ns.cd_mascara_operacao   as CDFIS,
  ns.vl_total              as VLCTA,
  ns.vl_bc_icms            as BCICM,
  0.00                     as AL,
  ns.vl_icms               as VLICM,
  ns.vl_icms_isento        as ISICM,
  ns.vl_icms_outros        as OUICM,
  ns.vl_bc_ipi             as BCIPI,
  ns.vl_ipi                as VLIPI,
  ns.vl_ipi_isento         as ISIPI,
  ns.vl_ipi_outros         as OUIPI,
  cast('' as varchar(40))  as OBSER,
  ns.cd_cnpj_nota_saida    as CGC,
  ns.cd_inscest_nota_saida as IE,
  ns.nm_bairro_nota_saida  as BAIRRO,
  ns.nm_cidade_nota_saida  as CIDADE,
  ns.nm_razao_social_nota  as RAZAO
from
  Nota_Saida ns
where
  ns.cd_status_nota<>7 --Nota Cancelada não entrada na exportação
-- order by
--   ns.cd_nota_saida

--select * from status_nota
--select * from nota_saida

