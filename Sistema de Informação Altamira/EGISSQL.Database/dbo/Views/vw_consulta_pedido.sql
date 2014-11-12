CREATE VIEW dbo.vw_consulta_pedido
AS
SELECT     dbo.Pedido_Venda.cd_pedido_venda AS Código, dbo.Pedido_Venda.dt_pedido_venda AS Data, dbo.Cliente.nm_fantasia_cliente AS Cliente, 
                      dbo.Pedido_Venda.vl_total_pedido_venda AS Total, dbo.Status_Pedido.nm_status_pedido AS Status
FROM         dbo.Pedido_Venda INNER JOIN
                      dbo.Cliente ON dbo.Pedido_Venda.cd_cliente = dbo.Cliente.cd_cliente INNER JOIN
                      dbo.Status_Pedido ON dbo.Pedido_Venda.cd_status_pedido = dbo.Status_Pedido.cd_status_pedido
