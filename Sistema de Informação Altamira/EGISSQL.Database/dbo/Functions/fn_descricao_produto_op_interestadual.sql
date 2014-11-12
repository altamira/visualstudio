

CREATE   FUNCTION fn_descricao_produto_op_interestadual
  ( @codigo_produto varchar(20), @descricao_produto varchar(100) )
RETURNS varchar(100)

AS
BEGIN

  declare @descricao varchar(100)

  if ( @codigo_produto is null ) or ( @codigo_produto = '999999999' )
    set @descricao = 'PRODUTO ESPECIAL'
  else
    set @descricao = @descricao_produto

  return(@descricao)

end



