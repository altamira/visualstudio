
CREATE PROCEDURE pr_importa_fornecedor_produto_nota
  @cd_usuario int
AS

  insert into 
    fornecedor_produto
    (cd_fornecedor, 
     cd_produto, 
     ic_cotacao_fornecedor,
     dt_usuario, 
     cd_usuario,
     dt_cotacao_fornecedor,
     dt_pedido_fornecedor,
     qt_nota_prod_fornecedor)
  select
    nei.cd_fornecedor,
    nei.cd_produto,
    'S',
    getdate(),
    @cd_usuario,
    max(co.dt_cotacao) as dt_cotacao,
    max(pc.dt_pedido_compra) as dt_pedido_compra,
    count(nei.cd_nota_entrada)as qt_nota_prod_fornecedo
  from 
    nota_entrada_item nei,
    Cotacao co,
    Pedido_Compra pc
  where
    nei.cd_produto is not null and
    nei.cd_produto not in (select cd_produto from fornecedor_produto where cd_fornecedor = nei.cd_fornecedor) and
    nei.cd_fornecedor not in (select cd_fornecedor from fornecedor_produto where cd_produto = nei.cd_produto)
  group by
    nei.cd_fornecedor,
    nei.cd_produto
  
