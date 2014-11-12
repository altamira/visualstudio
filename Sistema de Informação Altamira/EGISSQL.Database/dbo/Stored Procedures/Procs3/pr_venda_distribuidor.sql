
CREATE PROCEDURE pr_venda_distribuidor

--pr_venda_distribuidor
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar Magalhães
--Banco de Dados: EgisSQL
--Objetivo      : Apresenta um Ranking das venda por Distribuidor
--Data          : 22.12.2003
--Atualizado    : 
-- 30/03/2004 - Acerto na procedure para bater com a consulta
-- de pedidos do spe - Daniel C. Neto.
---------------------------------------------------
@dt_inicial datetime,
@dt_final datetime,
@cd_cliente int, --distribuidor
@cd_moeda int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Distribuidor
 select 
  a.cd_cliente, 
	c.nm_fantasia_cliente,
  cast(sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda)) as decimal(25,2)) as 'Venda', 

  cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*
                                       (a.vl_unitario_item_pedido / @vl_moeda))
                                  , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
  cast(sum((a.qt_item_pedido_venda *
           (a.vl_lista_item_pedido / @vl_moeda)
          )
      ) as decimal(25,2)) as 'TotalLista',
  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
       sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*
                                       (a.vl_unitario_item_pedido / @vl_moeda))
                                  , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)))
	as decimal(25,2)) * 100 as 'MargemContribuicao',

  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',

  max(a.dt_pedido_venda)           as 'UltimaVenda', 
  count(distinct a.cd_pedido_venda) as 'pedidos'
into 
	#VendaDistribuidorAux
from
   vw_venda_bi a inner join
	 	Cliente c on a.cd_cliente = c.cd_cliente and 
                 IsNull(c.ic_distribuidor_cliente,'N') = 'S' left outer join
   	Produto_Custo ps on ps.cd_produto = a.cd_produto 
where
  (a.dt_pedido_venda between @dt_inicial and @dt_final) and                   
  IsNull(a.cd_cliente,0) = (case when (@cd_cliente=0) then IsNull(a.cd_cliente,0) 
			          						else @cd_cliente end)
Group by 
	a.cd_cliente,	
	c.nm_fantasia_cliente
Order by 3 desc


declare @qt_total_distribuidor int
declare @vl_total_distribuidor float
-- Total de Distribuidores
set @qt_total_distribuidor = @@rowcount
-- Total de Vendas Geral dos Distribuidores
set @vl_total_distribuidor = 0

select 
	@vl_total_distribuidor = @vl_total_distribuidor + Venda
from
  #VendaDistribuidorAux

--Cria a Tabela Final de Vendas por Distribuidor
select IDENTITY(int, 1,1)      as 'Posicao',
       a.cd_cliente, 
			 a.nm_fantasia_cliente,
       isnull(a.venda,0)       as 'Venda', 
       a.TotalLiquido,
       a.TotalLista,
       a.CustoContabil,
       a.MargemContribuicao,
       a.BNS,
       isnull(((a.venda/@vl_total_distribuidor)*100),0) as 'Perc',
       a.UltimaVenda, 
       isnull(a.pedidos,0)     as 'pedidos'
Into 
	#VendaDistribuidor
from 
	#VendaDistribuidorAux a
Order 
	by a.venda desc

--Mostra tabela ao usuário
Select 
	* 
from 
	#VendaDistribuidor
order by 
	posicao

