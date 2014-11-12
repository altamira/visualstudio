
CREATE PROCEDURE pr_venda_categoria_segmento

--pr_venda_categoria_segmento
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Segmento de Mercado
--		  Filtrado por Categoria de Produto.
--Data          : 05/09/2002
--Atualizado    : 05/11/2003 - Incluído consulta por Moeda.
-- Daniel C. Neto.
---------------------------------------------------

@cd_ramo_atividade int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as

-- Geração da tabela auxiliar de Vendas por Segmento

select 
        b.cd_categoria_produto                 as 'categoria', 
        sum(b.qt_item_pedido_venda)            as 'Qtd',
        sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido*dbo.fn_vl_moeda(@cd_moeda))    as 'Venda'

into #VendaGrupoAux
from
   Pedido_Venda a inner join
   Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda inner join
   Cliente cli on cli.cd_cliente = a.cd_cliente
where
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
   ((a.dt_cancelamento_pedido is null ) or 
   (a.dt_cancelamento_pedido > @dt_final))                          and
    a.vl_total_pedido_venda > 0                                     and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                       and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido*dbo.fn_vl_moeda(@cd_moeda)) > 0         and
   ((b.dt_cancelamento_item is null ) or 
   (b.dt_cancelamento_item > @dt_final))                          and
    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                  and
    ((cli.cd_ramo_atividade  = @cd_ramo_atividade) or
     (@cd_ramo_atividade = 0))

Group by b.cd_categoria_produto
order  by 1 desc

-------------------------------------------------
-- calculando Potencial - A Definir.
-------------------------------------------------
 /* select pvi.cd_grupo_produto, 
       (select count(cd_cliente)
             from Pedido_Venda x  
             inner join Pedido_Venda_item xi
               on x.cd_pedido_venda = xi.cd_pedido_venda
         where xi.cd_grupo_produto = pvi.cd_grupo_produto) as Clientes
into #Cliente

from Pedido_Venda pv 
inner join Pedido_Venda_item pvi
  on pvi.cd_pedido_venda = pv.cd_pedido_venda
group by pvi.cd_grupo_produto
order by pvi.cd_grupo_produto */

----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_grupo int
declare @vl_total_grupo float

-- Total de Grupos
set @qt_total_grupo = @@rowcount

-- Total de Vendas Geral por Grupo
set    @vl_total_grupo     = 0
select @vl_total_grupo = @vl_total_grupo + venda
from
  #VendaGrupoAux

--Cria a Tabela Final de Vendas por Grupo


select IDENTITY(int,1,1) as 'Posicao',
       b.nm_categoria_produto,
       a.qtd,
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'

Into #VendaGrupo
from #VendaGrupoAux a , Categoria_Produto b

Where
     a.categoria = b.cd_categoria_produto

order by a.Venda desc

select * from #VendaGrupo order by Posicao

