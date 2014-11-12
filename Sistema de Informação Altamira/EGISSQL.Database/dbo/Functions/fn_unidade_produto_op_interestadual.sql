
CREATE  FUNCTION fn_unidade_produto_op_interestadual
  ( @codigo_produto varchar(20), @unidade_produto char(10) )
RETURNS char(10)

AS
BEGIN

  declare @unidade varchar(100)

  if ( @codigo_produto is null ) or ( @codigo_produto = '999999999' ) or
     ( @unidade_produto is null ) or ( @unidade_produto = '' )

    set @unidade = 'PC'
  else
    set @unidade = @unidade_produto

  return(@unidade)

end


