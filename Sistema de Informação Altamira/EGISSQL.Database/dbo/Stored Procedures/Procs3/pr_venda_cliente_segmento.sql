
CREATE PROCEDURE pr_venda_cliente_segmento

------------------------------------------------------------------------------------------------------
--pr_venda_cliente_segmento
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Segmento de Mercado
--		  Filtrado por Cliente.
--Data          : 05/09/2002
--Atualizado    : 05/11/2003 - Incluído consulta por moeda. - Daniel C. Neto.
--                20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar - Daniel C. Neto.
--                02.05.2006 - Acertos Diversos - Carlos Fernandes
-- 01.02.2010 - Ajuste dos valores com Ranking de Cliente - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_ramo_atividade int = 0,
@dt_inicial        datetime,
@dt_final          datetime,
@cd_moeda          int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Segmento

select 
        cli.cd_cliente                 as 'cliente', 
        sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda)    as 'Venda'

into #VendaGrupoAux
from
   Pedido_Venda a      inner join
   Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda inner join
   Cliente cli         on cli.cd_cliente    = a.cd_cliente
where
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
--   ((a.dt_cancelamento_pedido is null ) or 
--   (a.dt_cancelamento_pedido > @dt_final))                          and
    a.vl_total_pedido_venda > 0                                     and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                       and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) > 0         and
   ((b.dt_cancelamento_item is null ) or 
   --(b.dt_cancelamento_item > @dt_final))                          and
   (isnull(b.dt_cancelamento_item,@dt_final+1) > @dt_final))   and  

    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                
    and isnull(a.ic_amostra_pedido_venda,'N') <>'S'
    and isnull(a.ic_garantia_pedido_venda,'N')<>'S'

    and ((cli.cd_ramo_atividade  = @cd_ramo_atividade) or (@cd_ramo_atividade = 0))
    --Casos Especiais de Serviço = Produto 
    and isnull(b.cd_produto_servico,0)   = 0                     


Group by cli.cd_cliente
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
       b.nm_fantasia_cliente,
--       a.qtd,
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'



Into #VendaGrupo
from #VendaGrupoAux a , Cliente b

Where
     a.cliente = b.cd_cliente

order by a.Venda desc

select * from #VendaGrupo order by Posicao

