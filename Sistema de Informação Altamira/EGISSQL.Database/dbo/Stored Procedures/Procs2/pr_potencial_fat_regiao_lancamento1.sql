

/****** Object:  Stored Procedure dbo.pr_potencial_fat_regiao_lancamento1    Script Date: 13/12/2002 15:08:39 ******/
--pr_potencial_fat_regiao_lancamento1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Busca o Potencial da Regiao (Faturamento) para lançamento da divisão de área
--Data         : 26.12.2000
--Atualizado   : 
--             : 01.10.2002 - Migração p/ o bco. EGIS - Duela
-----------------------------------------------------------------------------------
CREATE procedure pr_potencial_fat_regiao_lancamento1

@cd_regiao      varchar(30),
@dt_inicial     datetime,
@dt_final       datetime

AS

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set     @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1

--Verificação do Total de Clientes Cadastrados independente de vendas
select b.cd_divisao_regiao                       as 'mapa',
       b.nm_divisao_regiao                       as 'Regiao',
       isnull(count(distinct a.cd_cliente),0)  as 'TotalClientes'
into #TotalClientesGeo
from
  Cliente a, Divisao_Regiao b
Where
  @cd_regiao = a.nm_divisao_area and
  a.nm_divisao_area = b.nm_divisao_regiao  
Group by 
  b.cd_divisao_regiao, b.nm_divisao_regiao
Order by 1

--Verificação do Total de Vendas do Setor

select a.nm_divisao_area                      as 'Mapa',
       count(a.cd_cliente)                    as 'QtdClientesVendas',
       sum(c.vl_unitario_item_nota*c.qt_item_nota_saida) as 'Total',
       sum(c.vl_unitario_item_nota*c.qt_item_nota_saida)/@qt_mes_media as 'MediaMensal'
into #TotalFatClientesGeoValor
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  @cd_regiao= a.nm_divisao_area and
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

select a.nm_divisao_area                                 as 'Mapa',
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota) as 'Total',
       sum((case when isnull(c.qt_devolucao_item_nota,0)>0 then
          c.qt_devolucao_item_nota else c.qt_item_nota_saida end ) * c.vl_unitario_item_nota) as 'TotalDev'
into #TotalFatClientesGeoValorDev
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  @cd_regiao= a.nm_divisao_area and
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
select a.nm_divisao_area                                 as 'Mapa',
       sum(c.qt_item_nota_saida*c.vl_unitario_item_nota) as 'TotalAnt',
       sum((case when isnull(c.qt_devolucao_item_nota,0)>0 then
          c.qt_devolucao_item_nota else c.qt_item_nota_saida end ) * c.vl_unitario_item_nota) as 'TotalDev'
into #TotalFatClientesGeoValorAnt
from
  Cliente a, Nota_Saida b, Nota_Saida_Item c, 
  Pedido_Venda d, Pedido_Venda_Item e, Operacao_Fiscal f
where
  @cd_regiao= a.nm_divisao_area and
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

select a.Mapa,
       a.QtdClientesVendas,
       Total = (a.Total-isnull(c.TotalAnt,0)) + 
               (isnull(b.Total,0) - isnull(b.TotalDev,0))
into #TotalFatClientesGeoValor1
from #TotalFatClientesGeoValor a, #TotalFatClientesGeoValorDev b, #TotalFatClientesGeoValorAnt c
where a.Mapa *= b.Mapa and
      a.Mapa *= c.Mapa
-- Tabela Final

select a.*,
       b.*,
       b.Total / @qt_mes_media as 'MediaMensal'
from 
 #TotalClientesGeo a, #TotalFatClientesGeoValor1 b
where
 a.mapa    *= b.mapa 
order by 
 a.mapa


