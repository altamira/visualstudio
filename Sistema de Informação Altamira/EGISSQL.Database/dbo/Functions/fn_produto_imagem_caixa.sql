
create FUNCTION fn_produto_imagem_caixa
  ( @cd_produto int ) RETURNS varchar(100)
AS
BEGIN

  declare @nm_imagem_produto varchar(100)

  set @nm_imagem_produto =
    ( select top 1
        pim.nm_imagem_produto
      from
        produto_imagem pim
        inner join tipo_imagem_produto tip
              on tip.cd_tipo_imagem_produto = pim.cd_tipo_imagem_produto
      where
        pim.cd_produto = @cd_produto
        and
        tip.sg_tipo_imagem_produto = 'CX' )

  return @nm_imagem_produto

end

--select dbo.fn_produto_imagem_caixa( 1 ) as teste

