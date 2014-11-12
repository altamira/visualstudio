
CREATE PROCEDURE pr_ordem_estocagem

@ic_parametro           int, 
@cd_fornecedor          int,
@cd_nota_entrada        int,
@cd_serie_nota          int,
@dt_inicial             datetime,
@dt_final		datetime

--pr_ordem_estocagem
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Fazer uma ordem de estocagem de uma Nota de Entrada.
--Data          : 26/09/2003
---------------------------------------------------



AS

  declare @cd_fase_produto int
  declare @nm_fase_produto varchar(40)  

  set @cd_fase_produto = ( select cd_fase_produto from Parametro_Comercial where cd_empresa = dbo.fn_empresa())
  set @nm_fase_produto = ( select nm_fase_produto from Fase_Produto where cd_fase_produto = @cd_fase_produto)  


SELECT     
           nei.cd_nota_entrada,
	   nei.cd_fornecedor, 
	   nei.cd_serie_nota_fiscal, 
	   nei.cd_operacao_fiscal, 
	   nei.cd_item_nota_entrada,
	   nei.cd_produto,
	   IsNull(nei.ic_estocado_nota_entrada,'N') as ic_estocado_nota_entrada,
	   GetDate() as 'Data',
	   f.nm_razao_social, 
           p.nm_fantasia_produto, 
           p.nm_produto, 
           dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto, 
           @cd_fase_produto as cd_fase_produto,
	   @nm_fase_produto as 'FaseProduto', 
           nei.qt_item_nota_entrada,
	   pe.qt_maximo_estoque,
	   cast(IsNull(pe.qt_saldo_atual_estoque,0) as float) as 'Estocagem',
	   cast(IsNull(pe.qt_saldo_reserva_estoque,0) as float) as 'Estocagem_Reserva',
	   IsNull(pe.cd_produto_endereco,0) as cd_produto_endereco,
	   ISNULL(pe.nm_endereco, dbo.fn_produto_localizacao(p.cd_produto, @cd_fase_produto)) as 'Endereco'

FROM       
	   Nota_Entrada ne inner join
	   Nota_Entrada_Item nei on nei.cd_fornecedor = ne.cd_fornecedor and
				    nei.cd_nota_entrada = ne.cd_nota_entrada and
			            nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal INNER JOIN
           Fornecedor f ON nei.cd_fornecedor = f.cd_fornecedor INNER JOIN
           Produto p ON nei.cd_produto = p.cd_produto left outer join
	   Produto_Endereco pe on pe.cd_produto = p.cd_produto and
				  pe.cd_fase_produto = @cd_fase_produto
	   where
             nei.cd_nota_entrada = (case @ic_parametro
				    when 1 then @cd_nota_entrada
				    else nei.cd_nota_entrada
				    end ) and

             nei.cd_fornecedor = (case @ic_parametro
				    when 1 then @cd_fornecedor
				    else nei.cd_fornecedor
				    end ) and

	     nei.cd_serie_nota_fiscal = (case @ic_parametro
				    when 1 then @cd_serie_nota
				    else nei.cd_serie_nota_fiscal
				    end ) and

	     nei.cd_serie_nota_fiscal = (case @ic_parametro
				    when 1 then @cd_serie_nota
				    else nei.cd_serie_nota_fiscal
				    end ) or
	     ( ( ne.dt_nota_entrada between @dt_inicial and @dt_final ) and
	       ( @ic_parametro = 2 ) ) 
	     

