
--------------------------------------------------------
--pr_atualizar_analise_consumo
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Atualizar os campos utilizados na Análise de Consumo.
--Data			: 13/11/2003
--            16/02/2004:  Usar o Código do País ao invés do Nome
---------------------------------------------------

CREATE PROCEDURE pr_atualizar_analise_consumo
@qt_minimo_produto float,
@qt_maximo_produto float,
@qt_comprar float,
@cd_pais_origem int,
@cd_produto int

AS

  declare @cd_fase_produto int
  
  set @cd_fase_produto = ( select top 1 cd_fase_produto from Parametro_Comercial
			   where cd_empresa = dbo.fn_empresa())

  update Produto_Saldo
  set qt_minimo_produto = @qt_minimo_produto,
      qt_maximo_produto = @qt_maximo_produto
  where
    cd_produto = @cd_produto and
    cd_fase_produto = @cd_fase_produto

  update Produto
  set cd_origem_produto = @cd_pais_origem
  where cd_produto = @cd_produto
      




