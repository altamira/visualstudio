
-------------------------------------------------------------------------------
--sp_helptext pr_rel_registro_inventario_custo
-------------------------------------------------------------------------------
--pr_rel_registro_inventario_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 17.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_rel_registro_inventario_custo
@cd_moeda int = 1 
as
declare @vl_moeda float  

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                    else dbo.fn_vl_moeda(@cd_moeda) end )  
SELECT 
  Produto.nm_produto, 
  PRODUTO_SALDO.qt_saldo_atual_produto, 
  Unidade_Medida.nm_unidade_medida, 
  Produto.vl_produto, 
  (Produto.vl_produto * Produto_Saldo.qt_saldo_atual_produto) Produto_vl_produto_Produ,
  (@vl_moeda* (Produto.vl_produto * Produto_Saldo.qt_saldo_atual_produto)) total_real,
   @vl_moeda as cotacao
FROM 
  Produto                  Produto
  INNER JOIN PRODUTO_SALDO PRODUTO_SALDO ON PRODUTO_SALDO.cd_produto = Produto.cd_produto
  LEFT OUTER JOIN Unidade_Medida Unidade_Medida ON Unidade_Medida.cd_unidade_medida = Produto.cd_unidade_medida
WHERE 
  PRODUTO_SALDO.qt_saldo_atual_produto > 0 AND
  PRODUTO.ic_comercial_produto = 'S'
ORDER BY
  Produto.nm_produto
