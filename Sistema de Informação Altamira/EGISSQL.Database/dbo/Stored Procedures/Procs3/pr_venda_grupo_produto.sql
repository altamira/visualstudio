CREATE PROCEDURE pr_venda_grupo_produto
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Grupo de produto.
--Data          : 04/09/2002
--Atualizado    : 01/04/2003 - Acerto no Filtro de SMO
---------------------------------------------------
@cd_grupo_produto int,
@dt_inicial dateTime,
@dt_final   dateTime

as

  create table #VendaGrupoAux
  (grupo int, qtd float, venda float, TotalLiquido float, UltimaVenda datetime, Clientes int, pedidos int)

  -- Geração da tabela auxiliar de Vendas por Grupo
  if ( @cd_grupo_produto = 0 ) 
  begin
    insert into #VendaGrupoAux
    Select 
      b.cd_grupo_produto                 as 'grupo', 
      sum(b.qt_item_pedido_venda)            as 'Qtd',
      sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)    as 'Venda', 
      sum(dbo.fn_vl_liquido_venda('V', (b.vl_unitario_item_pedido * b.qt_item_pedido_venda), 
                                            b.pc_icms_item, b.pc_ipi_item, a.cd_destinacao_produto, @dt_inicial)) as 'TotalLiquido',
      max(a.dt_pedido_venda)       as 'UltimaVenda',
      count(distinct a.cd_cliente) as 'Clientes',
      count('x')             as 'pedidos'
    From
      Pedido_Venda a with (nolock) 
      inner join Pedido_Venda_Item b with (nolock) 
        on a.cd_pedido_venda = b.cd_pedido_venda 
    where
      (a.dt_pedido_venda between @dt_inicial and @dt_final )      and
      (a.dt_cancelamento_pedido is null  )                        and
       a.vl_total_pedido_venda > 0                                and
       isnull(a.ic_consignacao_pedido,'N') = 'N'                  and
      (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0    and
      (b.dt_cancelamento_item is null  )                          and
       IsNull(b.ic_smo_item_pedido_venda,'N') = 'N'               
    Group by 
      b.cd_grupo_produto
  end
  else
  begin
    insert into #VendaGrupoAux
    Select 
      b.cd_grupo_produto                 as 'grupo', 
      sum(b.qt_item_pedido_venda)            as 'Qtd',
      sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)    as 'Venda', 
      sum(dbo.fn_vl_liquido_venda('V', (b.vl_unitario_item_pedido * b.qt_item_pedido_venda), 
                                            b.pc_icms_item, b.pc_ipi_item, a.cd_destinacao_produto, @dt_inicial)) as 'TotalLiquido',
      max(a.dt_pedido_venda)       as 'UltimaVenda',
      count(distinct a.cd_cliente) as 'Clientes',
      count('x')             as 'pedidos'
    from
      Pedido_Venda a with (nolock) 
      inner join Pedido_Venda_Item b with (nolock) 
        on a.cd_pedido_venda = b.cd_pedido_venda 
    where
      (a.dt_pedido_venda between @dt_inicial and @dt_final )      and
      (a.dt_cancelamento_pedido is null  )                        and
       a.vl_total_pedido_venda > 0                                and
       isnull(a.ic_consignacao_pedido,'N') = 'N'                  and
      (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0    and
      (b.dt_cancelamento_item is null  )                          and
       IsNull(b.ic_smo_item_pedido_venda,'N') = 'N'               and
      (b.cd_grupo_produto  = @cd_grupo_produto) 
    Group by 
      b.cd_grupo_produto
  end
----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_grupo int
declare @vl_total_grupo float

-- Total de Grupos
set @qt_total_grupo = @@rowcount

-- Total de Vendas Geral por Grupo
set    @vl_total_grupo     = 0

Select 
  @vl_total_grupo = sum(venda)
from
  #VendaGrupoAux

--Cria a Tabela Final de Vendas por Grupo
select IDENTITY(int,1,1) as 'Posicao',
       b.nm_grupo_produto,
       a.qtd,
       a.venda, 
       a.TotalLiquido,
      (a.venda/@vl_total_grupo)*100 as 'Perc',
       a.UltimaVenda,
       a.pedidos,
       a.Clientes
Into 
  #VendaGrupo
from 
  #VendaGrupoAux a 
  inner join Grupo_Produto b with (nolock)
    on a.grupo = b.cd_grupo_produto
order by 
  a.Venda desc

select * from #VendaGrupo order by Posicao
