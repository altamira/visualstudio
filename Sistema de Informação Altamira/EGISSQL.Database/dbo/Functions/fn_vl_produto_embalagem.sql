CREATE FUNCTION fn_vl_produto_embalagem
	(@cd_pedido_venda int,
   @cd_item_pedido_venda int)
RETURNS numeric(8,2)
---------------------------------------------------------------------------------------------------
--fn_vl_produto_embalagem
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Eduardo
--Banco de Dados	: EGISSQL
--Objetivo		: Retornar o Valor da Embalagem de um Produto de um Item de um Pedido
--Data			  : 20/02/2004
---------------------------------------------------------------------------------------------------

AS
begin

  declare @qt_embalagem float
  declare @vl_embalagem float
  declare @ic_incluso_embalagem char(1)
  declare @valor float

  select top 1
    @qt_embalagem = pve.qt_embalagem,
    @vl_embalagem = IsNull(pr.vl_produto,0),
    @ic_incluso_embalagem = pve.ic_incluso_embalagem
  from 
    Pedido_Venda_Item_Embalagem pve

    left outer join
    Tipo_Embalagem te
      on te.cd_tipo_embalagem = pve.cd_tipo_embalagem

    left outer join
    Produto pr
      on pr.cd_produto = te.cd_produto

  where cd_pedido_venda = @cd_pedido_venda and
        cd_item_pedido_venda = @cd_item_pedido_venda 

  if ( @ic_incluso_embalagem = 'S' )
    set @valor = @qt_embalagem * @vl_embalagem
  else
    set @valor = 0

  return @valor

end



