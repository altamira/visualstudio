-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Vendas por Categoria de Produtos por Setor
--Data        : 29.08.2000
--Atualizado  : 29.08.2000
--            : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--            : 19.09.2001 - Inclusão posição GERAL do vendedor (Solicitação Sr. FIX)
--            : 02/08/2002 - Conversão para o Padrão EGIS. - Daniel C. Neto.
--            : 02/08/2002 - Filtro para trazer todas Categorias...
--            : 11/11/2002 - Acerto na qtd. de Pedidos (DUELA)
-- 06/11/2003 - Incluído filtro de Moeda - Daniel C. Neto

-----------------------------------------------------------------------------------
create procedure pr_venda_categoria_setor
@cd_categoria_produto int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


--------------------------
-- Geração da tabela auxiliar de Vendas por Categoria
--------------------------
select 
  b.cd_categoria_produto                 as 'categoria', 
  max(a.cd_vendedor)                     as 'Setor',
  sum(b.qt_item_pedido_venda)            as 'Qtd',
--  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda)    as 'Venda', 
  sum( isnull(b.qt_item_pedido_venda,0) * (case 
	  when(b.dt_cancelamento_item is null) then  
		   (b.vl_unitario_item_pedido) 
		else 0 
    end)/ @vl_moeda) as 'Venda',

  max(a.dt_pedido_venda)                 as 'UltimaVenda',
  count(distinct a.cd_pedido_venda)      as 'pedidos'
--into #VendaCategAux
from
   Pedido_Venda a
left outer join Pedido_Venda_Item b on
  b.cd_pedido_venda = a.cd_pedido_venda
where
  (a.dt_pedido_venda between @dt_inicial and @dt_final )   and
  (a.dt_cancelamento_pedido is null  )                     and
  a.vl_total_pedido_venda > 0                              and

  IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
  IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados

  isnull(a.ic_consignacao_pedido,'N') = 'N'                and
  (b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) > 0 and
  (b.dt_cancelamento_item is null  )                       and
  isnull(b.ic_smo_item_pedido_venda,'N') = 'N'             and
  ((b.cd_categoria_produto  = @cd_categoria_produto) or
   (@cd_categoria_produto = 0))

group by b.cd_categoria_produto, a.cd_vendedor
order  by 4 desc


-------------------------------------------------
-- Total geral do vendedor em todas as categorias
-------------------------------------------------
select 
  a.cd_vendedor         as 'setor', 
--  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) as 'Venda' 
  sum( isnull(b.qt_item_pedido_venda,0) * (case 
	  when(b.dt_cancelamento_item is null) then  
		   (b.vl_unitario_item_pedido) 
		else 0 
    end)/ @vl_moeda) as 'Venda'

into #VendaTotal
from
   Pedido_Venda a
left outer join Pedido_Venda_Item b on
  b.cd_pedido_venda = a.cd_pedido_venda
where
  (a.dt_pedido_venda between @dt_inicial and 
                             @dt_final)                              and                   

  IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
  IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados

  isnull(a.ic_consignacao_pedido,'N') = 'N'                         and           
  a.cd_pedido_venda = b.cd_pedido_venda                             and     
  (b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) > 0           and
  b.dt_cancelamento_item is null                                    and
  isnull(b.ic_smo_item_pedido_venda,'N') = 'N'   
group by a.cd_vendedor

declare @vl_total_setor float
set @vl_total_setor = 0

select @vl_total_setor = @vl_total_setor + venda
from #VendaTotal

select 
  IDENTITY(int,1,1) as 'PosicaoGeral', 
  a.setor, 
  (a.venda/@vl_total_setor)*100 as 'PercGeral'
into #VendaTotalAux
from #VendaTotal a
order by a.Venda desc

select a.* 
into #VendaTotal1
from #VendaTotalAux a
order by a.PosicaoGeral
----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_categ int
declare @vl_total_categ float

--------------------------
-- Total de Setores
--------------------------
set @qt_total_categ = @@rowcount

--------------------------
-- Total de Vendas Geral por Setor
--------------------------
set    @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #VendaCategAux

--------------------------
--Cria a Tabela Final de Vendas por Setor
--------------------------
select 
  IDENTITY(int,1,1) as 'Posicao',
  b.nm_categoria_produto,
  c.nm_fantasia_vendedor,
  a.setor,
  a.qtd,
  a.venda, 
  (a.venda/@vl_total_categ)*100 as 'Perc',
  a.UltimaVenda,
  a.pedidos
into #VendaCateg
from #VendaCategAux a, Categoria_Produto b, Vendedor c
where
     a.categoria = b.cd_categoria_produto and
     a.setor     = c.cd_vendedor
order by a.venda desc

--------------------------
--Mostra tabela ao usuário
--------------------------
select a.*,
       b.PosicaoGeral, 
       b.PercGeral
from #VendaCateg a, #VendaTotal1 b
where a.setor = b.setor
order by a.posicao
