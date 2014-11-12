create procedure pr_consulta_nota_entrada_sem_movimentacao_estoque
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta das Notas de importacao sem invoice ou DI
--Data: 01.04.2004
---------------------------------------------------
@dt_inicial as DateTime,
@dt_final as DateTime
as

select
  nep.cd_produto,
  dbo.fn_mascara_produto(nep.cd_produto) as cd_mascara_produto,
  nep.cd_documento_entrada_peps,
  nep.cd_item_documento_entrada,
  nep.qt_entrada_peps,
  p.nm_fantasia_produto, p.nm_produto,
  nep.dt_documento_entrada_peps
from
  Nota_Entrada_PEPS nep,
  Produto p
where
  nep.cd_produto = p.cd_produto and
  nep.dt_documento_entrada_peps between @dt_inicial and @dt_final and
  isnull(nep.cd_movimento_estoque,0) = 0
order by 2,3


