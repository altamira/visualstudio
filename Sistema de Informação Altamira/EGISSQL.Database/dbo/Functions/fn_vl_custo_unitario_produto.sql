
CREATE  FUNCTION fn_vl_custo_unitario_produto( @cd_produto int ) RETURNS numeric(8,2)
---------------------------------------------------------------------------------------------------
--fn_vl_custo_unitario_produto
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Eduardo
--Banco de Dados	: EGISSQL
--Objetivo		: Define do Custo Unitário para o Produto. Usado na Evolução de Consumo
--Data			  : 22/01/2004
---------------------------------------------------------------------------------------------------
AS
begin

  declare @vl_custo            numeric(8,2)
  declare @vl_custo_total_peps numeric(8,2)
  declare @qt_entrada_peps     numeric(8,2)

  set @vl_custo = null

  -- Custo do último registro PEPS
  select top 1
    @vl_custo_total_peps = vl_custo_total_peps,
    @qt_entrada_peps     = qt_entrada_peps
  from
    nota_entrada_peps with (nolock) 
  where
    cd_produto = @cd_produto
  order by
    dt_documento_entrada_peps desc

  -- Fazer o cálculo em separado para evitar divisões por ZERO

  if ( isnull(@qt_entrada_peps,0) > 0 )
  begin
    set @vl_custo = cast( isnull(@vl_custo_total_peps,0) / @qt_entrada_peps as float) 
  end 

  -- Custo da Última Nota de Entrada

  if ( @vl_custo is null )
  begin
    select top 1
      @vl_custo = cast( isnull(vl_item_nota_entrada,0) as float) 
    from
      nota_entrada_item with (nolock) 
    where
      cd_produto = @cd_produto 
    order by
      dt_item_receb_nota_entrad desc
  end

  set @vl_custo = isnull(@vl_custo,0)

  if @vl_custo = 0 
  begin

    select
      @vl_custo = isnull(vl_custo_produto,0)
    from
      produto_custo with (nolock)
    where
      cd_produto = @cd_produto

  end

  return isnull(@vl_custo,0)
  
end
