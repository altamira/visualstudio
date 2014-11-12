CREATE  FUNCTION fn_fase_produto 
	(@cd_produto int, 
         @cd_fase_produto_default int --Caso for informado "0" irá buscar da tabela de Parametro_Comercial
        )

RETURNS int

AS
begin
  declare @cd_fase_produto int


  select 
	top 1 @cd_fase_produto = IsNull(cd_fase_produto_baixa,0)
  from 
	Produto 
  where 
	cd_produto = @cd_produto

  if @cd_fase_produto = 0 
    select 
      --Buscando fase de venda do produto definido no parametro comercial
      @cd_fase_produto = cd_fase_produto 
    from 
      Parametro_Comercial 
    where 
      cd_empresa = dbo.fn_empresa()
  
  if @cd_fase_produto = 0
  begin
    if @cd_fase_produto_default > 0
       set @cd_fase_produto = @cd_fase_produto_default
    else
      Select top 1 @cd_fase_produto = cd_fase_produto from Parametro_Comercial where cd_empresa = dbo.fn_empresa()
  end

  return @cd_fase_produto

end



