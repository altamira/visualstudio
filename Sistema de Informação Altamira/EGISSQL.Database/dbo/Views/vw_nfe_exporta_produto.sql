
CREATE VIEW vw_nfe_exporta_produto
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exporta_produto
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro de Produtos
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa
--select * from tipo_pessoa

select
  'M' as SessaoM,
   1  as UM,
  'A' as Sessao,
  (select sg_versao_nfe from versao_nfe)      as versao,
  s.nm_status_produto,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  p.cd_codigo_barra_produto,
  replace(cf.cd_mascara_classificacao,'.','') as cd_mascara_classificacao,
  cf.cd_extipi,
  cf.cd_genero_ncm_produto,
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(1.00,6,2)),103),'.','.'),'0.0000') as qtdTrib,
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(p.vl_produto,6,2)),103),'.','.'),'0.0000') as vl_produto,
  um.sg_unidade_medida                        as sg_unidade_tributaria,
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(p.vl_produto,6,2)),103),'.','.'),'0.0000')                as vl_tributaria,
  p.cd_codigo_barra_produto                   as cd_produto_tributaria,
  isnull(ti.cd_digito_tributacao_icms,'00') as cd_digito_tributacao_icms,
  pp.cd_digito_procedencia,
  mi.cd_digito_modalidade,
  isnull(replace(CONVERT(varchar, convert(numeric(5,2),round(pf.pc_aliquota_icms_produto,6,2)),103),'.','.'),'0.00') as pc_aliquota_icms_produto,
  cast('' as varchar)        as pc_reducao_icms,
  isnull(mis.cd_digito_modalidade_st,'')      as cd_digito_modalidade_st,
  cast('' as varchar)                         as pc_adicionado_icms_st,
  cast('' as varchar)                         as pc_reducao_icms_st,
  cast('' as varchar)                         as pc_aliquota_icms_st,
  cast(''   as varchar(5))                    as cd_classe_ipi,
  cast(''   as varchar(3))                    as cd_classe_legal_ipi,
  cast((select cd_cgc_empresa from egisadmin.dbo.empresa where cd_empresa = dbo.fn_empresa())   as varchar(14))                   as cd_cnpj_produtor,
  cast(''   as varchar(14))                   as EAN,          -- Não sei
  cast(''   as varchar(14))                   as EANTributario -- Não sei
  
from

  Produto p                                         with (nolock)
  inner join status_produto s                       with (nolock) on s.cd_status_produto        = p.cd_status_produto
  left outer join unidade_medida um                 with (nolock) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join classificacao_fiscal cf           with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  left outer join tributacao           t            with (nolock) on t.cd_tributacao            = pf.cd_tributacao
  left outer join tributacao_icms      ti           with (nolock) on ti.cd_tributacao_icms      = t.cd_tributacao_icms
  left outer join procedencia_produto  pp           with (nolock) on pp.cd_procedencia_produto  = pf.cd_procedencia_produto
  left outer join modalidade_calculo_icms       mi  with (nolock) on mi.cd_modalidade_icms      = pf.cd_modalidade_icms
  left outer join modalidade_calculo_icms_strib mis with (nolock) on mis.cd_modalidade_icms_st  = pf.cd_modalidade_icms_st

where
  isnull(s.ic_bloqueia_uso_produto,'N') = 'N' 
 
--select * from tributacao_icms
--select * from status_produto
--select * from produto
--select * from procedencia_produto
--select * from produto_fiscal

