
CREATE PROCEDURE pr_consulta_pedido_alteracao
-------------------------------------------------------------------------------
--pr_consulta_pedido_alteracao
-------------------------------------------------------------------------------
--GBS - Global Business Sollution                                          2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server  2000
--Autor(es)             : Igor 
--Banco de Dados        : SAPSQL
--Objetivo              : Mostrar os pedidos com alteração
--Data                  : 13/05/2002
--Atualizado            : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
@cd_parametro int,
@dt_inicial datetime,
@dt_final datetime 
AS

--Retorno para a Grid
if @cd_parametro = 1
Begin

  SELECT     
    p.dt_alteracao_pedido_venda,
    t.sg_tipo_pedido,
    t.nm_tipo_pedido,
    p.cd_pedido_venda,
    p.dt_pedido_venda,
    c.nm_fantasia_cliente,
    (Select top 1 nm_fantasia_contato 
     From Cliente_Contato 
     Where cd_cliente = p.cd_cliente and cd_contato = p.cd_contato) as 'nm_fantasia_contato',
    u.nm_fantasia_usuario,
    p.nm_alteracao_pedido_venda,
    s.nm_status_pedido,
    s.sg_status_pedido
  from
    Pedido_Venda p left outer join
    Tipo_Pedido t
      on p.cd_tipo_pedido = t.cd_tipo_Pedido left outer join
    Cliente c
      on p.cd_cliente = c.cd_cliente left outer join
    EgisAdmin.dbo.Usuario u 
      on p.cd_usuario = u.cd_usuario left outer join
    Status_Pedido s
      on p.cd_status_pedido = s.cd_status_pedido
  where
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    p.dt_alteracao_pedido_venda is not null
  order by
    p.dt_pedido_venda desc

end
Else
--Retorno para o Relatório
if @cd_parametro = 2 
Begin
  SELECT     
    p.dt_alteracao_pedido_venda,
    t.sg_tipo_pedido,
    t.nm_tipo_pedido,
    p.cd_pedido_venda,
    p.dt_pedido_venda,
    c.nm_fantasia_cliente,
    (Select top 1 nm_fantasia_contato 
     From Cliente_Contato 
     Where cd_cliente = p.cd_cliente and cd_contato = p.cd_contato) as 'nm_fantasia_contato',
    u.nm_fantasia_usuario,
    p.nm_alteracao_pedido_venda,
    s.nm_status_pedido,
    s.sg_status_pedido,
    i.cd_item_pedido_venda,
    i.qt_item_pedido_venda,
    i.vl_unitario_item_pedido,
    (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) as 'vl_total_item_pedido',
    i.dt_entrega_vendas_pedido,
    i.dt_entrega_fabrica_pedido,
    pd.cd_produto,
    pd.nm_produto,
    pd.nm_fantasia_produto
  from
    Pedido_Venda p left outer join
    Pedido_Venda_Item i 
      on p.cd_pedido_venda = i.cd_pedido_venda Left Outer Join
    Produto pd
      on i.cd_produto = pd.cd_produto Left Outer Join
    Tipo_Pedido t
      on p.cd_tipo_pedido = t.cd_tipo_Pedido left outer join
    Cliente c
      on p.cd_cliente = c.cd_cliente left outer join
    Egisadmin.dbo.Usuario u 
      on p.cd_usuario = u.cd_usuario left outer join
    Status_Pedido s
      on p.cd_status_pedido = s.cd_status_pedido
  where
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    p.dt_alteracao_pedido_venda is not null
  order by
    p.dt_pedido_venda desc
End
 

