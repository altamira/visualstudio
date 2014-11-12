

/****** Object:  Stored Procedure dbo.pr_soma_regiao_total_faturas1    Script Date: 13/12/2002 15:08:42 ******/

--pr_regiao_total_faturas
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Soma do Total de Faturas das Regiões - Utilizado a Divisão da Região de Vendas
--Data          : 26.12.2000
--Atualizado    : 
--              : 30.09.2002 - Migração bco. Egis - DUELA
--------------------------------------------------------------------------------------
create procedure pr_soma_regiao_total_faturas1

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
into #TotalFatClientesGeo
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
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota) as 'Total',
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota)/@qt_mes_media as 'MediaMensal'
into #TotalFatClientesGeoValor
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  a.cd_cliente=b.cd_cliente and
  (b.dt_nota_saida between @dt_inicial and @dt_final) and
  b.cd_operacao_fiscal=f.cd_operacao_fiscal and
  b.cd_nota_saida=c.cd_nota_saida  and
  c.ic_status_item_nota_saida<>'C' and
  (c.dt_cancel_item_nota_saida is null or c.dt_cancel_item_nota_saida>@dt_final) and
  c.cd_pedido_venda=d.cd_pedido_venda and
  c.cd_item_pedido_venda=e.cd_pedido_venda and
  e.ic_smo_item_pedido_venda = 'N'   
group by a.nm_divisao_area
order by 1
-- Devoluções no Mês
select a.nm_divisao_area                                 as 'MapaVendas',
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota) as 'Total',
       sum((case when isnull(c.qt_devolucao_item_nota,0)>0 then
          c.qt_devolucao_item_nota else c.qt_item_nota_saida end ) * c.vl_unitario_item_nota) as 'TotalDev'
into #TotalFatClientesGeoValorDev
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  a.cd_cliente=b.cd_cliente and
  (b.dt_nota_saida between @dt_inicial and @dt_final) and
  b.cd_operacao_fiscal=f.cd_operacao_fiscal and
  f.ic_comercial_operacao='S' and
  b.cd_nota_saida=c.cd_nota_saida  and
  c.ic_status_item_nota_saida='D' and
  (c.dt_cancel_item_nota_saida is null or c.dt_cancel_item_nota_saida>@dt_final) and
  c.cd_pedido_venda=d.cd_pedido_venda and
  c.cd_item_pedido_venda=e.cd_pedido_venda and
  e.ic_smo_item_pedido_venda = 'N'   
group by a.nm_divisao_area
order by 1

-- Devoluções dos Meses Anteriores

select a.nm_divisao_area                                 as 'MapaVendas',
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota) as 'TotalAnt',
       sum((case when isnull(c.qt_devolucao_item_nota,0)>0 then
          c.qt_devolucao_item_nota else c.qt_item_nota_saida end ) * c.vl_unitario_item_nota) as 'TotalDev'
into #TotalFatClientesGeoValorAnt
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  a.cd_cliente=b.cd_cliente and
  (b.dt_nota_saida < @dt_inicial) and
  b.cd_operacao_fiscal=f.cd_operacao_fiscal and
  b.cd_nota_saida=c.cd_nota_saida  and
  c.ic_status_item_nota_saida='D' and
  (c.dt_cancel_item_nota_saida is null or c.dt_cancel_item_nota_saida>@dt_final) and
  c.cd_pedido_venda=d.cd_pedido_venda and
  c.cd_item_pedido_venda=e.cd_pedido_venda and
  e.ic_smo_item_pedido_venda = 'N'   
group by a.nm_divisao_area
order by 1

-- Juntar as três querys

select a.MapaVendas,
       a.QtdClientesVendas,
       a.MediaMensal,
       Total = (a.Total-isnull(c.TotalAnt,0)) + 
               (isnull(b.Total,0) - isnull(b.TotalDev,0))
into #TotalFatClientesGeoValor1
from #TotalFatClientesGeoValor a, #TotalFatClientesGeoValorDev b, #TotalFatClientesGeoValorAnt c
where a.MapaVendas *= b.MapaVendas and
      a.MapaVendas *= c.MapaVendas

-- Tabela Final

select a.*,
       b.*
into #Tabela_Final
from 
   #TotalFatClientesGeo a, #TotalFatClientesGeoValor1 b
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


