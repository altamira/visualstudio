CREATE PROCEDURE pr_historico_reajuste_preco_produto
-----------------------------------------------------------------------
--pr_historico_reajuste_preco_produto
-----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                              2004
-----------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Clelson Camargo
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Histórico de reajuste dos preços dos produtos
--Data			: 19/02/2005
--Atualização           :
---------------------------------------------------------------------------------------------
@ic_parametro char(1), -- Tipo de registro 'C'usto ou 'V'enda
@cd_produto int -- Código do produto
as
  select
   ph.*,
   m.sg_moeda,
   tp.sg_tabela_preco,
   tr.sg_tipo_reajuste,
   mr.sg_motivo_reajuste
  from
   produto_historico ph
  left outer join moeda m
   on (ph.cd_moeda = m.cd_moeda)
  left outer join tabela_preco tp
   on (tp.cd_tabela_preco = ph.cd_tipo_tabela_preco)
  left outer join tipo_reajuste tr
   on (tr.cd_tipo_reajuste = ph.cd_tipo_reajuste)
  left outer join motivo_reajuste mr
   on (mr.cd_motivo_reajuste = ph.cd_motivo_reajuste)
  where
   ph.ic_tipo_historico_produto = @ic_parametro
   and ph.cd_produto = @cd_produto
  order by
   dt_historico_produto desc
