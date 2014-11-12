--pr_resumo_desconto_setor_categoria
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000
--Lucio Vanderlei
--Resumo de Descontos por Categoria
--Data          : 30.08.2000
--Atualizado    : 29.11.2000 Inclusão do Fan_Cli do Vendedor
--                06/04/2002
--------------------------------------------------------------------------------------
CREATE procedure pr_resumo_desconto_setor_categoria

@ncmapa char(10),
@dt_inicial   datetime,
@dt_final     datetime

as

-- VENDAS SEM SMO
select a.cd_vendedor as 'Vendedor', 
       sum(isnull(b.qt_item_pedido_venda,0)) as 'Quantidade',
       sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_unitario_item_pedido,0)) as 'ValorVenda', 
       sum(isnull(b.vl_unitario_item_pedido,0)) as 'PrecoUnitario', 
       sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_lista_item_pedido,0)) as 'ValorOrcado',
       0 as 'Desconto'

into #ResumoNaoSmo
from
    pedido_venda a, pedido_venda_item b
Where
   (a.dt_pedido_venda between @dt_inicial and @dt_final) and
    a.dt_cancelamento_pedido is null          and
    a.cd_pedido_venda = b.cd_pedido_venda    and
    b.cd_categoria_produto = @ncmapa       and 
    b.dt_cancelamento_item is null          and
    b.vl_lista_item_pedido > 0          and
    a.ic_smo_pedido_venda = 'N'

Group by a.cd_vendedor

-- VENDAS COM SMO
select a.cd_vendedor as 'Vendedor', 
       b.qt_item_pedido_venda as 'Quantidade',
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido as 'ValorVenda', 
       b.vl_unitario_item_pedido as 'PrecoUnitario', 
       ValorOrcado =
          case
             when a.dt_pedido_venda < '08/01/2000' then 
                (b.qt_item_pedido_venda*b.vl_lista_item_pedido)-((b.qt_item_pedido_venda*b.vl_lista_item_pedido)*11/100)
             else 
                (b.qt_item_pedido_venda*b.vl_lista_item_pedido)-((b.qt_item_pedido_venda*b.vl_lista_item_pedido)*8.8/100)
          end,
       0 as 'Desconto'

into #ResumoComSmoAux
from
    pedido_venda a, pedido_venda_item b
Where
   (a.dt_cancelamento_pedido between @dt_inicial and @dt_final) and
    a.dt_cancelamento_pedido is null          and
    a.cd_pedido_venda = b.cd_pedido_venda    and
    b.cd_categoria_produto = @ncmapa       and
    b.dt_cancelamento_item is null          and
    b.vl_lista_item_pedido > 0          and
    a.ic_smo_pedido_venda = 'S'

select a.Vendedor as 'Vendedor', 
       sum(a.Quantidade) as 'Quantidade',
       sum(a.ValorVenda) as 'ValorVenda', 
       sum(a.PrecoUnitario) as 'PrecoUnitario', 
       sum(a.ValorOrcado) as 'ValorOrcado',
       0 as 'Desconto'

into #ResumoComSmo
from
   #ResumoComSmoAux a
Group by a.Vendedor

-- RESULTADO
select a.Vendedor as 'Setor', 
       Max(c.nm_fantasia_vendedor) as 'Vendedor',
       sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)) as 'ValorVenda', 
       sum(isnull(a.quantidade,0) + isnull(b.quantidade,0)) as 'Quantidade',
       sum((isnull(a.valorvenda,0) + isnull(b.valorvenda,0)) /
           (isnull(a.quantidade,0) + isnull(b.quantidade,0))) as 'PrecoMedio',
       sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)) as 'ValorOrcado',
      (100-(Sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)))/
           (sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)))*100) as 'Desconto'
from #ResumoNaoSmo a, #ResumoComSmo b, vendedor c
Where a.Vendedor *= b.Vendedor and
      a.Vendedor = c.cd_vendedor
group by a.Vendedor
Order by a.Vendedor
