

CREATE FUNCTION fn_fantasia_produto (
@nm_fantasia_produto varchar(30)
)
RETURNS int

AS
BEGIN

  declare @cd_produto int

  select 
    top 1 @cd_produto = cd_produto
  from 
    Produto
  where
    nm_fantasia_produto = @nm_fantasia_produto

  return(@cd_produto)

end

