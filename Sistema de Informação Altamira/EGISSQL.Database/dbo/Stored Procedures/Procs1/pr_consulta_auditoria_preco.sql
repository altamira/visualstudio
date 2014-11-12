


CREATE  procedure pr_consulta_auditoria_preco
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Lucio Vanderlei
--Obejtivo         : Auditoria de Preços por Setor (ou Geral)
--Data             : 31.08.2000
--Atualizado       : 06/04/2002 - Sandro Campos
--Atualizado       : 15/05/2002 - Igor Gama - Troca de ic_smo... para ic_fatsmo...
--Atualizado       : 05/07/2002 - Daniel C. Neto - Colocado filtro por Grupo.
--                 : 02/04/2003 - Daniel C. Neto - Acertado filtro ic_fatsmo...
--                 : 08.05.2006 - Acertos Diversos
--                 : 30.05.2006 - Verificação da Categoria - Carlos Fernandes
--------------------------------------------------------------------------------------
@cd_vendedor      int = 0,
@dt_inicial       char(10),
@dt_final         char(10),
@cd_grupo_produto int = 0
As

  Declare @SQL1 as varchar(4000)
  Declare @SQL2 as varchar(4000)

-- VENDAS SEM SMO - OK
--select cd_categoria_produto,* from pedido_venda_item  

  Select
    b.cd_categoria_produto as Categoria,
    a.cd_vendedor          as Vendedor,
    sum(isnull(b.qt_item_pedido_venda,0)) as Quantidade,
    sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_unitario_item_pedido,0)) as ValorVenda,
    sum(isnull(b.vl_unitario_item_pedido,0)) as PrecoUnitario,
    sum(isnull(b.qt_item_pedido_venda,0)*isnull(b.vl_lista_item_pedido,0)) as ValorOrcado,
    0 as PerDiferenca
  into
    #AuditoriaNaoSmo
  from
    pedido_venda a 
    inner join pedido_venda_item b on a.cd_pedido_venda = b.cd_pedido_venda
    
  Where
   (a.dt_pedido_venda between @dt_inicial and @dt_final) and
   ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0)) and
   ((b.cd_grupo_produto = @cd_grupo_produto) or (@cd_grupo_produto = 0)) and
   a.dt_cancelamento_pedido is null and
   b.dt_cancelamento_item is null and
   b.vl_lista_item_pedido > 0 and
   IsNull(a.ic_fatsmo_pedido,'N') = 'N'
  Group by
    --b.cd_grupo_produto, 
    b.cd_categoria_produto,
    a.cd_vendedor

 select * from #AuditoriaNaoSMO

  -- VENDAS COM SMO

  Select
    a.cd_vendedor           as Vendedor,
    b.cd_categoria_produto  as Categoria,
    b.qt_item_pedido_venda  as Quantidade,
    b.qt_item_pedido_venda*b.vl_unitario_item_pedido as ValorVenda,
    b.vl_unitario_item_pedido as PrecoUnitario,
    ValorOrcado =
      (b.qt_item_pedido_venda*b.vl_lista_item_pedido)-((b.qt_item_pedido_venda*b.vl_lista_item_pedido)*8.8/100),
    0 as PerDiferenca
  into
    #AuditoriaComSmoAux
  from
    pedido_venda a Inner Join
    pedido_venda_item b on a.cd_pedido_venda = b.cd_pedido_venda
  Where
   (a.dt_pedido_venda between @dt_inicial and @dt_final) and
   ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0)) and
   ((b.cd_grupo_produto = @cd_grupo_produto) or (@cd_grupo_produto = 0)) and
   a.dt_cancelamento_pedido is null and
   b.dt_cancelamento_item is null and
   b.vl_lista_item_pedido > 0 and
   IsNull(a.ic_fatsmo_pedido,'N') = 'S'


  Select a.Categoria,
         a.Vendedor,
       sum(a.Quantidade)    as 'Quantidade',
       sum(a.ValorVenda)    as 'ValorVenda', 
       sum(a.PrecoUnitario) as 'PrecoUnitario', 
       sum(a.ValorOrcado)   as 'ValorOrcado',
       sum(a.PerDiferenca)  as 'PerDiferenca'
  into #AuditoriaComSmo
  from
   #AuditoriaComSmoAux a
  Group by a.Categoria, a.Vendedor

  -- RESULTADO

  select 
    a.categoria                      as 'ncmapa', 
    --max(c.nm_fantasia_grupo_produto) as 'Categoria',
    max(cp.nm_categoria_produto)     as Categoria,
    b.Vendedor                       as 'CodVendedor',
    max(v.nm_fantasia_vendedor)      as 'Vendedor',
    CAST(sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)) as numeric(25,2)) as 'ValorVenda', 
    sum(isnull(a.quantidade,0) + isnull(b.quantidade,0)) as 'Quantidade',
    sum((isnull(a.valororcado,0) + isnull(b.valororcado,0)) -
         (isnull(a.valorvenda,0) + isnull(b.valorvenda,0))) as 'Diferenca',
    CAST(sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)) as numeric(25,2)) as 'ValorOrcado',
      (100-(Sum(isnull(a.valorvenda,0) + isnull(b.valorvenda,0)))/
       (sum(isnull(a.valororcado,0) + isnull(b.valororcado,0)))*100) as 'PerDiferenca'
--   Into
--     #Resultado
  from 
    #AuditoriaNaoSmo a 
    Left outer join #AuditoriaComSmo b on a.Categoria = b.Categoria and a.Vendedor = b.Vendedor 
    Left outer join Grupo_Produto c    on b.Categoria = c.cd_grupo_produto 
    left outer join Vendedor v         on v.cd_vendedor = b.Vendedor
    left outer join Categoria_Produto cp on cp.cd_categoria_produto = a.Categoria
  group by 
    a.Categoria, b.Vendedor
  Order by 
    a.Categoria, b.Vendedor

--select * from categoria_produto

