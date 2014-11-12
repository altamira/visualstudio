
CREATE FUNCTION fn_custo_pedido_venda_especial
( @cd_pedido_venda      int,
  @cd_item_pedido_venda int ) RETURNS float

AS
BEGIN
  --select * from produto_custo

declare @vl_custo_reposicao float
declare @vl_custo_contabil  float
declare @vl_custo           float

set @vl_custo = 0

  select
    @vl_custo_reposicao = sum( isnull(pc.vl_custo_produto,0) ),          
    @vl_custo_contabil  = sum( isnull(pc.vl_custo_contabil_produto,0) ) 
  from
    Pedido_Venda_Composicao pvc 
    inner join produto p        on p.cd_produto  = pvc.cd_produto 
    inner join produto_custo pc on pc.cd_produto = p.cd_produto
  where
    pvc.cd_pedido_venda      = @cd_pedido_venda and
    pvc.cd_item_pedido_venda = @cd_item_pedido_venda

  set @vl_custo = case when isnull(@vl_custo_contabil,0)=0 then @vl_custo_reposicao else @vl_custo_contabil end 

  return cast(IsNull(@vl_custo,0) as decimal (15,2))

END

