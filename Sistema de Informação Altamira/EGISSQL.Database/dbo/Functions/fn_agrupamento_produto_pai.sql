
CREATE FUNCTION fn_agrupamento_produto_pai
  ( @cd_agrupamento_produto int ) RETURNS int
AS
BEGIN

  declare @cd_agrupamento_pai int

  set @cd_agrupamento_pai = ( select ap.cd_agrupamento_prod_pai
                              from agrupamento_produto ap
                              where cd_agrupamento_produto = @cd_agrupamento_produto )

  if ( @cd_agrupamento_pai is null )
  begin
    set @cd_agrupamento_pai = @cd_agrupamento_produto
  end

  return @cd_agrupamento_pai

end

