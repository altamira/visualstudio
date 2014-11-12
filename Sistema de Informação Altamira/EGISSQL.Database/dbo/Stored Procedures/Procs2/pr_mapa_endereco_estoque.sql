
CREATE PROCEDURE pr_mapa_endereco_estoque

@cd_grupo_produto int,
@cd_fase_produto int,
@nm_fantasia_produto varchar(40),
@ic_tipo_filtro  char(1)

--pr_mapa_endereco_estoque
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Mostrar o mapa de endereços de estoque de produtos.
--Data          : 26/09/2003
---------------------------------------------------



AS

SELECT DISTINCT
           p.nm_fantasia_produto, 
	   p.nm_produto, 
	   gp.nm_fantasia_grupo_produto, 
	   fp.nm_fase_produto, 
	   pe.qt_maximo_estoque, 
	   ps.qt_saldo_reserva_produto, 
           ps.qt_saldo_atual_produto,
	   dbo.fn_mascara_produto(p.cd_produto) as 'cd_mascara_produto',
	   ISNULL(pe.nm_endereco, dbo.fn_produto_localizacao(p.cd_produto, ps.cd_fase_produto)) as 'Endereco'

FROM       Produto p left outer join
           Grupo_Produto gp ON p.cd_grupo_produto = gp.cd_grupo_produto left outer join
           Produto_Endereco pe ON p.cd_produto = pe.cd_produto Left outer join
           Produto_Saldo ps ON p.cd_produto = ps.cd_produto left outer join
           Fase_Produto fp ON ps.cd_fase_produto = fp.cd_fase_produto 
where
	  ( (( p.cd_grupo_produto = @cd_grupo_produto ) or ( @cd_grupo_produto = 0)) and
            (( ps.cd_fase_produto = @cd_fase_produto ) or ( @cd_fase_produto = 0)) ) and
	    (( p.nm_fantasia_produto like @nm_fantasia_produto + '%') and (@ic_tipo_filtro = 'F')) or
            (( p.cd_mascara_produto like @nm_fantasia_produto + '%') and (@ic_tipo_filtro = 'C'))
order by
  p.nm_fantasia_produto

