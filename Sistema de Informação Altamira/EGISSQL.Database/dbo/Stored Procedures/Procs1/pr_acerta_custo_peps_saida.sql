
--pr_acerta_custo_peps_saida
-----------------------------------------------------------------------------------------
--Polimold Industrial S/A                      2001
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias P. Silva 
--Banco de Dados: EGISSQL
--Objetivo: Busca o Custo PEPS da última entrada e carrega no Movimento de Estoque de Saída
--Data: 12/05/2004
-----------------------------------------------------------------------------------------
create procedure pr_acerta_custo_peps_saida
@dt_inicial datetime,
@dt_final datetime

as

update movimento_estoque 
set 
  vl_custo_contabil_produto = (select top 1 (vl_custo_contabil_produto / qt_movimento_estoque)
                               from movimento_estoque mov
                               where mov.cd_tipo_documento_estoque = 3 and
                                     mov.cd_tipo_movimento_estoque <> 12 and
                                     mov.vl_custo_contabil_produto <> 0 and
                                     mov.cd_produto = me.cd_produto and
                                     mov.dt_movimento_estoque <= me.dt_movimento_estoque
                               order by
                                 mov.dt_movimento_estoque desc) * qt_movimento_estoque
--                                 nei.vl_total_nota_entr_item - nei.vl_icms_nota_entrada + vl_ipi_nota_entrada 
-- select 
--   me.cd_produto,
--   me.vl_custo_contabil_produto,
--   nei.vl_total_nota_entr_item - nei.vl_icms_nota_entrada + vl_ipi_nota_entrada ,
--   me.cd_movimento_estoque, 
--   me.cd_documento_movimento,
--   me.cd_item_documento
from
  movimento_estoque me --,
--  nota_entrada_item nei
where
--  me.cd_documento_movimento = nei.cd_nota_entrada and
--  me.cd_item_documento = nei.cd_item_nota_entrada and
--  me.cd_fornecedor = nei.cd_fornecedor and
   me.cd_tipo_documento_estoque <> 3 and
   me.dt_movimento_estoque between @dt_inicial and @dt_final
--   me.cd_documento_movimento = 29379
-- order by 
--   me.cd_produto


