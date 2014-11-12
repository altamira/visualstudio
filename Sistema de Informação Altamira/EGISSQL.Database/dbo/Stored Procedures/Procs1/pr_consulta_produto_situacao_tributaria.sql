
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_produto_situacao_tributaria
-------------------------------------------------------------------------------
--pr_consulta_produto_situacao_tributaria
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Produto para Situaçõ Tributária
--
--Data             : 04.09.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_produto_situacao_tributaria
as

select
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  op.nm_origem_produto,
  cf.cd_mascara_classificacao,
  tp.nm_tipo_produto,
  pp.nm_procedencia_produto,
  t.nm_tributacao,
  f.nm_fantasia_fornecedor,
  CST = pp.cd_digito_procedencia + cd_digito_tributacao_icms

from
  produto p 
  left outer join unidade_medida um       with (nolock) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join origem_produto op       with (nolock) on op.cd_origem_produto       = p.cd_origem_produto
  left outer join produto_fiscal pf       with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join tipo_produto tp         with (nolock) on tp.cd_tipo_produto         = pf.cd_tipo_produto
  left outer join procedencia_produto pp  with (nolock) on pp.cd_procedencia_produto  = pf.cd_procedencia_produto
  left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  left outer join fornecedor_produto pfor with (nolock) on pfor.cd_produto            = p.cd_produto
  left outer join fornecedor f            with (nolock) on f.cd_fornecedor            = pfor.cd_fornecedor
  left outer join tributacao t            with (nolock) on t.cd_tributacao            = pf.cd_tributacao
  left outer join tributacao_icms ticms   with (nolock) on ticms.cd_tributacao_icms   = t.cd_tributacao_icms

--select * from
--select * from tributacao_icms
--select * from fornecedor

order by
  p.nm_fantasia_produto

--select * from procedencia_produto
--select * from fornecedor_produto
--select * from produto_fiscal


