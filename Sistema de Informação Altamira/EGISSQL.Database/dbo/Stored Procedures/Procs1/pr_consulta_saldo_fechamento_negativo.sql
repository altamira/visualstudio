
-----------------------------------------------------------------------------------------------------
--pr_consulta_saldo_fechamento_negativo
-----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Rafael M. Santiago
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de saldo de fechamento negativo
--Data			: 22/10/2003
--Alteração		: 14/01/2004 - Alteração do campo 'cd_mascara_produto'. 
--                                     Anteriormente pegava o campo errado. - DUELA
--                      : 23.10.2005 - Acertos Gerais - Carlos Fernandes
-- 07.06.2010 - Grupo de Produto - Carlos Fernandes
-----------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_consulta_saldo_fechamento_negativo

@dt_base datetime

AS

select
  dbo.fn_mascara_produto(pf.cd_produto) as cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.nm_fase_produto,
  pf.qt_atual_prod_fechamento,
  pf.qt_consig_prod_fechamento,
  pf.qt_terc_prod_fechamento,
  gp.nm_grupo_produto
from
  Produto_fechamento pf             with (nolock) 
  left outer join Produto p         with (nolock) on pf.cd_produto = p.cd_produto
  left outer join Unidade_Medida um with (nolock) on p.cd_unidade_medida = um.cd_unidade_medida
  left outer join Fase_Produto fp   with (nolock) on pf.cd_fase_produto = fp.cd_fase_produto  
  left outer join Grupo_Produto gp  with (nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
where
  pf.dt_produto_fechamento = @dt_base and
  isnull(pf.qt_atual_prod_fechamento,0) < 0 

