

--------------------------------------------------------------------------------------
--pr_resumo_desconto_setor
--------------------------------------------------------------------------------------
----GBS - Global Business Solution	       2002
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes
--Lucio Vanderlei
--Resumo de Descontos por Setor (ou Geral)
--Data          : 15.08.2000
--Atualizado    : Sandro Campos - 06/04/2002
--Atualizado    : Daniel C. Neto - 01/07/2002 - Atualizado filtro para Categoria e Vendedor.
--                Daniel C. Neto - 10/12/2003 - Acertos Gerais.
-- 30/03/2004 - Acerto para bater com a consulta de pedidos por vendedor do SPE - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 25.05.2006 - Sigla da Categoria - Carlos Fernandes
--------------------------------------------------------------------------------------
CREATE procedure pr_resumo_desconto_setor
@cd_vendedor          int,
@cd_categoria_produto int,
@dt_inicial           datetime,
@dt_final             datetime,
@cd_moeda             int = 1

As

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- VENDAS SEM SMO
select a.cd_categoria_produto as 'Categoria', 
       sum(isnull(a.qt_item_pedido_venda,0)) as 'Quantidade',
--       sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_unitario_item_pedido,0)) as 'ValorVenda', 
    	 sum( isnull(a.qt_item_pedido_venda,0) * (a.vl_unitario_item_pedido) / @vl_moeda ) as 'ValorVenda',
       sum(isnull(a.vl_unitario_item_pedido,0))                               as 'PrecoUnitario', 
       sum(isnull(a.qt_item_pedido_venda,0)*isnull(a.vl_lista_item_pedido,0)) as 'ValorOrcado',
       0.00                                                                   as 'Desconto'
       
into #ResumoNaoSmo
from
    vw_venda_bi a
Where
   ((a.cd_vendedor = @cd_vendedor ) or (@cd_vendedor = 0)) and
   ((a.cd_categoria_produto = @cd_categoria_produto) or ( @cd_categoria_produto = 0)) and
  (a.dt_pedido_venda between @dt_inicial and @dt_final )    and
  a.cd_produto is not null

Group by a.cd_categoria_produto

-- RESULTADO

select a.categoria                  as 'ncmapa', 
       max(c.cd_mascara_categoria)  as 'Codigo',
       max(c.sg_categoria_produto)  as 'Sigla',
       max(c.nm_categoria_produto)  as 'Categoria', 
       sum(isnull(a.valorvenda,0))  as 'ValorVenda', 
       sum(isnull(a.quantidade,0))  as 'Quantidade',
       sum(isnull(a.valorvenda,0) /
           isnull(a.quantidade,0))  as 'PrecoMedio',
       sum(isnull(a.valororcado,0)) as 'ValorOrcado',
      (100-(Sum(isnull(a.valorvenda,0)))/
           (sum(isnull(a.valororcado,0)))*100) as 'Desconto'
from #ResumoNaoSmo a, categoria_produto c
Where 
    a.Categoria = c.cd_categoria_produto
group by a.Categoria
Order by a.Categoria

