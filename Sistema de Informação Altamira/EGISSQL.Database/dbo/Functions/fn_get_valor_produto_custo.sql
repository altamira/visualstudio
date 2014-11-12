CREATE FUNCTION fn_get_valor_produto_custo(
@cd_produto int,
@cd_fase_produto int,
@cd_tipo_custo int = 1)
RETURNS decimal(25,4)
AS
begin
  
  --Tipo de pesquisa
  -- 1 - Através do Fechamento do Produto
  -- 2 - Através do Produto Custo

  declare @vl_custo decimal(25,4)

  select @cd_fase_produto = isnull(@cd_fase_produto,cd_fase_produto)
  from parametro_comercial where cd_empresa = dbo.fn_empresa()

  if @cd_tipo_custo = 1
  begin

	  select top 1 @vl_custo = vl_custo_prod_fechamento
	  from Produto_Fechamento
	  where cd_fase_produto = @cd_fase_produto and isnull(vl_custo_prod_fechamento,0) > 0
    order by dt_produto_fechamento desc

  end

  return cast(isnull(@vl_custo,0) as decimal(25,4))

end
