
create FUNCTION fn_produto_eh_componente
  ( @cd_produto int ) RETURNS char(1)
AS
BEGIN

  declare @cRetorno char(1)

  -- Verificar se é Componente
  if exists ( select top 1 cd_produto
              from produto_composicao
              where cd_produto = @cd_produto )
  begin
    Set @cRetorno = 'S'
  end
  else begin
    Set @cRetorno = 'N'
  end

  return @cRetorno

end

--select dbo.fn_produto_eh_componente( 76 ) as teste

