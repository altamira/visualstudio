

/****** Object:  Stored Procedure dbo.pr_auditoria_preco_setor    Script Date: 13/12/2002 15:08:12 ******/

CREATE procedure pr_auditoria_preco_setor
--pr_auditoria_preco_setor
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Lucio Vanderlei
--Auditoria de Preços por Setor (ou Geral)
--Data          : 31.08.2000
--Atualizado    : 06/04/2002 - Sandro Campos
--Atualizado    : 15/05/2002 - Igor Gama - Troca de ic_smo... para ic_fatsmo...
--------------------------------------------------------------------------------------
@cd_vendedor1 int,
@cd_vendedor2 int,
@dt_inicial   datetime,
@dt_final     datetime
As
-- VENDAS SEM SMO - OK
select 
       b.cd_grupo_produto as 'Categoria', 
--       b.cd_categoria_produto as 'Categoria', 
       sum(isnull(b.qt_item_pedido_venda,0)) as 'Quantidade',
       sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_unitario_item_pedido,0)) as 'ValorVenda', 
       sum(isnull(b.vl_unitario_item_pedido,0)) as 'PrecoUnitario', 
       sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_lista_item_pedido,0)) as 'ValorOrcado',
       0 as 'PerDiferenca'

into #AuditoriaNaoSmo
from
    pedido_venda a Inner Join 
    pedido_venda_item b on a.cd_pedido_venda = b.cd_pedido_venda    
Where
   (a.dt_pedido_venda between @dt_inicial and @dt_final) and
   (a.cd_vendedor between @cd_vendedor1 and @cd_vendedor2 ) and
    a.dt_cancelamento_pedido is null          and
    b.dt_cancelamento_item is null          and
    b.vl_lista_item_pedido > 0          and
    a.ic_fatsmo_pedido = 'N'

Group by b.cd_grupo_produto


-- VENDAS COM SMO
select 
       b.cd_grupo_produto as 'Categoria', 
--        b.cd_categoria_produto as 'Categoria', 
       b.qt_item_pedido_venda as 'Quantidade',
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido as 'ValorVenda', 
       b.vl_unitario_item_pedido as 'PrecoUnitario', 
--     coalesce(a.dtped = '08/01/2000',@Perc=11,@Perc=8.8),
       ValorOrcado =
--           case
--              when a.dt_pedido_venda < '08/01/2000' then 
--                 (b.qt_item_pedido_venda*b.vl_lista_item_pedido)-((b.qt_item_pedido_venda*b.vl_lista_item_pedido)*11/100)
--              else 
                (b.qt_item_pedido_venda*b.vl_lista_item_pedido)-((b.qt_item_pedido_venda*b.vl_lista_item_pedido)*8.8/100),
--           end,
       0 as 'PerDiferenca'

into #AuditoriaComSmoAux
from
    pedido_venda a Inner Join 
    pedido_venda_item b on a.cd_pedido_venda = b.cd_pedido_venda
Where
   (a.dt_pedido_venda between @dt_inicial and @dt_final) and
   (a.cd_vendedor between @cd_vendedor1 and @cd_vendedor2 ) and
    a.dt_cancelamento_pedido is null          and
    b.dt_cancelamento_item is null          and
    b.vl_lista_item_pedido > 0          and
    a.ic_fatsmo_pedido = 'S' 

Select a.Categoria,
       sum(a.Quantidade) as 'Quantidade',
       sum(a.ValorVenda) as 'ValorVenda', 
       sum(a.PrecoUnitario) as 'PrecoUnitario', 
       sum(a.ValorOrcado) as 'ValorOrcado',
       sum(a.PerDiferenca) as 'PerDiferenca'
into #AuditoriaComSmo
from
   #AuditoriaComSmoAux a
Group by a.Categoria

-- RESULTADO
select a.categoria as 'ncmapa', 
       max(c.sg_grupo_produto) as 'Categoria',
       CAST(sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)) as numeric(25,2)) as 'ValorVenda', 
       sum(isnull(a.quantidade,0) + isnull(b.quantidade,0)) as 'Quantidade',
       sum((isnull(a.valororcado,0) + isnull(b.valororcado,0)) -
           (isnull(a.valorvenda,0) + isnull(b.valorvenda,0))) as 'Diferenca',
       CAST(sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)) as numeric(25,2)) as 'ValorOrcado',
      (100-(Sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)))/
           (sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)))*100) as 'PerDiferenca'
from #AuditoriaNaoSmo a Left Outer Join 
     #AuditoriaComSmo b on a.Categoria = b.Categoria Left outer Join
     Grupo_Produto c on b.Categoria = c.cd_grupo_produto
-- Where a.Categoria *= b.Categoria and
--       a.Categoria = c.cd_grupo_produto
group by a.Categoria
Order by a.Categoria


