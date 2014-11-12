
CREATE FUNCTION fn_maior_custo_produto
  ( @cd_produto int,
    @dt_inicial datetime,
    @dt_final datetime ) RETURNS float
AS
BEGIN

  declare @nMaiorCusto as float

  select
    @nMaiorCusto = max(nei.vl_item_nota_entrada)
  from
    Nota_Entrada ne
    inner join Nota_Entrada_Item nei
          on nei.cd_nota_entrada = ne.cd_nota_entrada   
    inner join Operacao_Fiscal ofi
          on ofi.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    ne.dt_nota_entrada between @dt_inicial and @dt_final
    and
    nei.cd_produto = @cd_produto
    and
    ofi.ic_comercial_operacao = 'S'

  return Isnull(@nMaiorCusto,0)
end

--select dbo.fn_maior_custo_produto( 1, '08/01/2003', '08/31/2003' ) as teste
