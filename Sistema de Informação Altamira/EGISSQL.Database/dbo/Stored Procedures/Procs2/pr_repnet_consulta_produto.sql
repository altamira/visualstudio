

CREATE   PROCEDURE pr_repnet_consulta_produto
@sg_estado char(2),
@cd_destinacao_produto int,
@nm_fantasia_produto varchar(30),
@nm_produto varchar(30),
@nm_serie_produto int,
@nm_grupo_produto int
AS
Begin
	SET NOCOUNT ON
	
	declare @cd_estado int,
		@cd_fase_produto int

	--Define o estado
	select top 1 @cd_estado = cd_estado from estado where sg_estado = @sg_estado
	
	--Define se irá utilizar o ICMS embutido
	select 
		@cd_fase_produto	  = cd_fase_produto
	from 
		Parametro_Comercial 
	where 
		cd_empresa = dbo.fn_empresa()

	--Gera o resultado
	Select 
	p.nm_fantasia_produto as 'Produto', 
	p.nm_produto 'Descricao',
	(Select top 1 sg_unidade_medida from Unidade_Medida where cd_unidade_medida = p.cd_unidade_medida) as 'Unv',
	dbo.fn_get_IPI_Produto(p.cd_produto) as 'IPI',
	p.qt_peso_liquido as 'PesoLiquido',
	p.qt_peso_bruto as 'PesoBruto',
	(Select top 1 IsNull(pc_icms_classif_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)) as 'ICMS',
	dbo.fn_vl_venda_produto(@sg_estado, @cd_destinacao_produto, p.cd_produto) as 'Preco',
        IsNull((select top 1 qt_saldo_reserva_produto from produto_saldo where cd_produto = p.cd_produto
	and cd_fase_produto = @cd_fase_produto), 0) as 'Disponivel',
	IsNull((select top 1 qt_saldo_atual_produto from produto_saldo where cd_produto = p.cd_produto
	and cd_fase_produto = @cd_fase_produto), 0) as 'SaldoReal',
	IsNull((select top 1 qt_saldo_atual_produto from produto_saldo where cd_produto = p.cd_produto
	and cd_fase_produto = @cd_fase_produto), 0) - IsNull((select top 1 qt_saldo_reserva_produto from produto_saldo where cd_produto = p.cd_produto
	and cd_fase_produto = @cd_fase_produto), 0) 'Reservado',
  case when ISNULL((Select top 1 IsNull(pc_redu_icms_class_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)),0) = 0 
    then
      0
    else 
      100 - (Select top 1 IsNull(pc_redu_icms_class_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)) 
  end as pc_icms_red
	from Produto p
	left outer join
	Produto pa
	on p.cd_substituto_produto = pa.cd_produto
        left outer join Serie_Produto sr
        on (sr.cd_serie_produto=p.cd_serie_produto)
        left outer join Grupo_Produto gp
        on (gp.cd_grupo_produto=p.cd_grupo_produto)
	where p.nm_fantasia_produto like @nm_fantasia_produto + '%'
	and p.nm_produto like @nm_produto + '%' and
        ((sr.cd_serie_produto = @nm_serie_produto) or @nm_serie_produto = 0) and
        ((gp.cd_grupo_produto = @nm_grupo_produto) or @nm_grupo_produto = 0) 
	order by
	  p.nm_fantasia_produto

SET NOCOUNT OFF      
end


