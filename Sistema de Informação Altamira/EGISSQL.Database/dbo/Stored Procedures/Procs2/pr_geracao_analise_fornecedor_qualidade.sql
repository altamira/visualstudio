
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_analise_fornecedor_qualidade
-------------------------------------------------------------------------------
--pr_geracao_analise_fornecedor_qualidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Análise dos Fornecedor - Perfomance - Qualidade
--Data             : 18.07.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_analise_fornecedor_qualidade
@ic_parametro  int   = 0,
@cd_fornecedor int   = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from fornecedor
--select * from classificacao_fornecedor

select
  f.cd_fornecedor,
  f.nm_fantasia_fornecedor          as Fornecedor,
  f.nm_razao_social                 as RazaoSocial,
  cf.nm_classif_fornecedor          as Classificacao,
  f.cd_certificado_avaliacao        as RelatorioAvaliacao,
  f.cd_certificado_iso_fornecedor   as CertifidoISO,
  cq.nm_certificadora_qualidade     as Certificadora,
  f.dt_vcto_avaliacao_fornec        as Validade,
  0.00                              as IP,
  0.00                              as IQ,
  0.00                              as IQP,
  0.00                              as IQF,
  0.00                              as IQFAnterior,
  0.00                              as QtdFornecida
from
  fornecedor f
  left outer join classificacao_fornecedor cf on cf.cd_classif_fornecedor      = f.cd_classif_fornecedor
  left outer join certificadora_qualidade  cq on cq.cd_certificadora_qualidade = f.cd_certificadora_qualidade
where
  f.cd_fornecedor = case when @cd_fornecedor = 0 then f.cd_fornecedor else @cd_fornecedor end
order by
  f.nm_fantasia_fornecedor


