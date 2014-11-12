
-------------------------------------------------------------------------------
--sp_helptext pr_rotina_inventario_pic
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 02.07.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_rotina_inventario_pic
as

SELECT Produto.nm_produto, 
       PRODUTO_SALDO.qt_saldo_atual_produto, 
       Unidade_Medida.nm_unidade_medida, 
       isnull(Produto.vl_produto, 0) as vl_produto,
       --TOTAL em U$
       (Produto.vl_produto * Produto_Saldo.qt_saldo_atual_produto) 
       * 
       (select top 1 vl_moeda from Valor_Moeda where cd_moeda = 2 order by dt_moeda desc) as Produto_vl_produto_Produ,
       case when 
         produto.cd_moeda<> 1
       then
         ((select top 1 vl_moeda from Valor_Moeda where cd_moeda = 2 order by dt_moeda desc)* (isnull(Produto.vl_produto,0) * Produto_Saldo.qt_saldo_atual_produto))
       else
         (isnull(Produto.vl_produto,0) * Produto_Saldo.qt_saldo_atual_produto)
       end as total_real,
       (select top 1 vl_moeda from Valor_Moeda where cd_moeda = 2 order by dt_moeda desc) as cotacao      

FROM dbo.Produto Produto
      INNER JOIN dbo.PRODUTO_SALDO PRODUTO_SALDO ON 
     (PRODUTO_SALDO.cd_produto = Produto.cd_produto)
      LEFT OUTER JOIN dbo.Unidade_Medida Unidade_Medida ON 
     (Unidade_Medida.cd_unidade_medida = Produto.cd_unidade_medida)
WHERE ( PRODUTO_SALDO.qt_saldo_atual_produto > 0 )
and PRODUTO.CD_CATEGORIA_PRODUTO NOT IN (6)
ORDER BY
  Produto.nm_produto

