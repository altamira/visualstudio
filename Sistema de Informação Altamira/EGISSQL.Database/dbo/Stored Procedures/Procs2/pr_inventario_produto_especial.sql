
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Rafael M. Santiago
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 22/08/2005
--Alteração        : 
------------------------------------------------------------------------------
CREATE PROCEDURE pr_inventario_produto_especial
@dt_base DATETIME

AS
	SELECT
		gp.nm_grupo_produto, 
		pvi.cd_pedido_venda,
		pvi.cd_item_pedido_venda,
		pvi.qt_item_pedido_venda,
		pvi.ds_produto_pedido_venda
	FROM
		Pedido_Venda pv 
    LEFT OUTER JOIN
  	Pedido_Venda_Item pvi ON pv.cd_pedido_venda = pv.cd_pedido_venda
    LEFT OUTER JOIN
		Grupo_Produto gp ON isnull(pvi.cd_grupo_produto,0) = isnull(gp.cd_grupo_produto,0)
		
    
 
