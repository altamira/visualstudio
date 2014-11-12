

/****** Object:  Stored Procedure dbo.pr_soma_regiao_total_vendas1    Script Date: 13/12/2002 15:08:42 ******/

--pr_regiao_total_vendas
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Soma do Total de Vendas das Regiões - Utilizado a Divisão da Região de Vendas
--Data          : 12.12.2000
--Atualizado    : 12.12.2000
--              : 27.09.2002 - Migração bco. Egis - DUELA
--------------------------------------------------------------------------------------
create procedure pr_soma_regiao_total_vendas1
@dt_inicial  datetime,
@dt_final    datetime

as

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set     @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1
 
--Verificação do Total de Clientes Cadastrados independente de vendas
select b.cd_divisao_regiao                    as 'mapa',
       max(b.nm_divisao_regiao)               as 'Regiao',
       isnull(count(distinct a.nm_fantasia_cliente),0) as 'TotalClientes'
into #TotalClientesGeo
from
  Cliente a, Divisao_Regiao b
Where
  b.nm_divisao_regiao *= a.nm_divisao_area
Group by 
  b.cd_divisao_regiao
Order by 1

--Verificação do Total de Vendas do Setor

select a.nm_divisao_area                      as 'MapaVendas',
       count(distinct a.nm_fantasia_cliente)  as 'QtdClientesVendas',
       sum(c.qt_item_pedido_venda*c.vl_unitario_item_pedido) as 'Total',
       sum(c.qt_item_pedido_venda*c.vl_unitario_item_pedido)/@qt_mes_media as 'MediaMensal'
into #TotalClientesGeoValor
from
   Cliente a, Pedido_Venda b,Pedido_Venda_Item c
Where
  a.cd_cliente    = b.cd_cliente                          and
  (b.dt_pedido_venda between @dt_inicial and @dt_final ) and
  b.cd_pedido_venda = c.cd_pedido_venda                   and
  (c.dt_cancelamento_item is null )                     and
  c.ic_smo_item_pedido_venda = 'N'   

Group by a.nm_divisao_area
Order by 1

-- Tabela Final

select a.*,
       b.*
into #Tabela_Final
from 
 #TotalClientesGeo a, #TotalClientesGeoValor b

where
 a.mapa *= b.mapaVendas
order by 
 a.mapa


-- Cálculo da Soma final

declare @qt_total_vendas_regiao   float
declare @qt_total_clientes_regiao int

set @qt_total_vendas_regiao   = 0.00
set @qt_total_clientes_regiao = 0

select @qt_total_vendas_regiao   = @qt_total_vendas_regiao   + isnull(total,0),
       @qt_total_clientes_regiao = @qt_total_clientes_regiao + totalclientes
from #tabela_final

select @qt_total_clientes_regiao as 'clientes',
       @qt_total_vendas_regiao   as 'total'



