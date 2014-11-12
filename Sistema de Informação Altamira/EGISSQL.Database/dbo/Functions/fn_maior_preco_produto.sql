
CREATE FUNCTION fn_maior_preco_produto
  ( @cd_produto int,
    @dt_inicial datetime,
    @dt_final datetime ) RETURNS float
AS
BEGIN

  declare @nMaiorValor as float

  select
    @nMaiorValor = max(nsi.vl_unitario_item_nota)
  from
    Nota_Saida ns
    inner join Nota_Saida_Item nsi
          on nsi.cd_nota_saida = ns.cd_nota_saida
    inner join Operacao_Fiscal ofi
          on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_status_nota = 5 --Nota Emitida
    and
    nsi.cd_produto = @cd_produto 
    and
    ofi.ic_comercial_operacao = 'S'

  return IsNull(@nMaiorValor,0)
end

--select dbo.fn_maior_preco_produto( 1, '08/01/2003', '08/31/2003' ) as teste
