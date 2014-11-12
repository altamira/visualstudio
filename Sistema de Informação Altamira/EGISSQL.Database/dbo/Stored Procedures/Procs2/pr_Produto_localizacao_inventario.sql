CREATE PROCEDURE pr_Produto_localizacao_inventario
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Adriano Levy
--Banco de Dados: EGISSQL
--Objetivo: Listar produtos e suas localizações
--Data: 08/11/2002
--Atualizado: 30/04/2003 - Igor Gama
-- Observaçao: - Incluído fase para a localização do produto
---------------------------------------------------
@cd_fase_produto int,
@cd_serie_produto int,
@cd_grupo_produto int,
@nm_fantasia_produto varchar(40)
as

	select distinct 
	   prd.cd_produto,
	   prd.cd_serie_produto,
	   prd.cd_grupo_produto,
	   prd.nm_fantasia_produto,
	   prd.nm_produto,
	   rtrim(ltrim(isnull(pl.qt_posicao_localizacao,'')))+
	   rtrim(ltrim(isnull(pl2.qt_posicao_localizacao,'')))+
	   rtrim(ltrim(isnull(pl3.qt_posicao_localizacao,'')))+
	   rtrim(ltrim(isnull(pl4.qt_posicao_localizacao,'')))+
	   rtrim(ltrim(isnull(pl5.qt_posicao_localizacao,''))) as 'LOCALIZACAO',
	   ps.qt_saldo_atual_produto
	from
	   produto prd
	     left outer join 
	   produto_localizacao pl
	     on (pl.cd_produto = prd.cd_produto and pl.cd_grupo_localizacao = 1 and pl.cd_fase_produto = @cd_fase_produto)
	     left outer join 
	   produto_localizacao pl2
	     on (pl2.cd_produto = prd.cd_produto and pl2.cd_grupo_localizacao = 2 and pl2.cd_fase_produto = @cd_fase_produto)
	     left outer join 
	   produto_localizacao pl3
	     on (pl3.cd_produto = prd.cd_produto and pl3.cd_grupo_localizacao = 3 and pl3.cd_fase_produto = @cd_fase_produto)
	     left outer join 
	   produto_localizacao pl4
	     on (pl4.cd_produto = prd.cd_produto and pl4.cd_grupo_localizacao = 4 and pl4.cd_fase_produto = @cd_fase_produto)
	     left outer join 
	   produto_localizacao pl5
	     on (pl5.cd_produto = prd.cd_produto and pl5.cd_grupo_localizacao = 5 and pl5.cd_fase_produto = @cd_fase_produto)
	     left outer join 
	   produto_saldo ps
	     on (ps.cd_produto = prd.cd_produto and ps.cd_fase_produto = @cd_fase_produto)
	where (
	       ( pl.qt_posicao_localizacao is not null) or --  pl.qt_posicao_localizacao <> '') or
	       (pl2.qt_posicao_localizacao is not null) or -- pl2.qt_posicao_localizacao <> '') or
	       (pl3.qt_posicao_localizacao is not null) or -- pl3.qt_posicao_localizacao <> '') or
	       (pl4.qt_posicao_localizacao is not null) or -- pl4.qt_posicao_localizacao <> '') or
	       (pl5.qt_posicao_localizacao is not null) -- pl5.qt_posicao_localizacao <> '')
	      ) and
	      ( @cd_serie_produto = 0 or prd.cd_serie_produto = @cd_serie_produto ) and
	      ( @cd_grupo_produto = 0 or prd.cd_grupo_produto = @cd_grupo_produto ) and
	      ( @nm_fantasia_produto = '' or prd.nm_fantasia_produto like (@nm_fantasia_produto + '%'))
  order by localizacao

