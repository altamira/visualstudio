

/****** Object:  Stored Procedure dbo.pr_clientes_geo_mapas_geral1    Script Date: 13/12/2002 15:08:14 ******/
--pr_clientes_geo_mapas_geral1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Seleção de clientes com GeoMapas
--Data         : 25.01.2001
--Atualizado   : 25/09/2002 - Migração para o bco. EGIS - DUELA
-----------------------------------------------------------------------------------
CREATE procedure pr_clientes_geo_mapas_geral1 

@dt_inicial     datetime,
@dt_final       datetime

with recompile

AS

-- (%) de Expectativa de Crescimento  ( Futuramente um Tabela de Parâmetros no Cadastro Empresa )
declare @pc_crescimento float 
set @pc_crescimento = 1.20

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set     @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1

declare @totalvendas float
set @totalvendas = 0.00

--Verificação do Total de Clientes com GeoMapas cadastrados independente de vendas

select cli.nm_divisao_area      as 'Mapa',
       cli.nm_fantasia_cliente  as 'Cliente',
       r.nm_regiao              as 'Regiao',
       v.nm_fantasia_vendedor   as 'Setor',
       cli.dt_cadastro_cliente  as 'Cadastro',
       e.sg_estado              as 'Estado',
       c.nm_cidade              as 'Cidade',
       @totalvendas             as 'TotalVendas' 
into #ClientesGeoMapasGeral  
from
  Cliente cli
left outer join Regiao r
  on r.cd_regiao=cli.cd_regiao
left outer join Vendedor v
  on v.cd_vendedor=cli.cd_vendedor
left outer join Estado e
  on e.cd_estado=cli.cd_estado
left outer join Cidade c
  on c.cd_cidade=cli.cd_cidade
left outer join Divisao_Regiao dr
  on dr.nm_divisao_regiao=cli.nm_divisao_area
where
  cli.nm_divisao_area <> ''
group by cli.nm_fantasia_cliente, cli.nm_divisao_area, r.nm_regiao, v.nm_fantasia_vendedor,
         cli.dt_cadastro_cliente, c.nm_cidade, e.sg_estado
order by cli.nm_fantasia_cliente

--Verificação do Total de Vendas dos Clientes com Mapa
select cli.nm_divisao_area                    as 'Mapa',
       cli.nm_fantasia_cliente                as 'Cliente',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)                   as 'TotalVendas',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/@qt_mes_media     as 'MediaMensal',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * @pc_crescimento as 'Crescimento',
      (sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)*@pc_crescimento )/@qt_mes_media   
                                              as 'MediaMensalCrescimento'
into #ClientesGeoValorGeral
from
   Cliente cli
left outer join Pedido_Venda pv
  on pv.cd_cliente=cli.cd_cliente
left outer join Pedido_Venda_Item pvi
  on pvi.cd_pedido_venda=pv.cd_pedido_venda
left outer join Divisao_Regiao dr
  on dr.nm_divisao_regiao=cli.nm_divisao_area
left outer join Divisao_Area_Vendedor dav
  on dav.cd_geomapa=dr.cd_grupo_div_regiao
where
  cli.nm_divisao_area <> '' and
  (pv.dt_pedido_venda between @dt_inicial and @dt_final ) and
  (pv.dt_cancelamento_pedido is null )                    and
  (pvi.dt_cancelamento_item is null )                     and
   pvi.ic_smo_item_pedido_venda = 'N'   
group by nm_divisao_area, cli.nm_fantasia_cliente
order by 1

-- Tabela Final

select a.Cliente,
       a.Mapa,
       a.Regiao,
       a.Setor,
       a.Cadastro,
       a.Estado,
       a.Cidade, 
       isnull(b.TotalVendas,0) as 'TotalVendas',
       b.MediaMensal,
       b.Crescimento,
       b.MediaMensalCrescimento
into #ClientesGeoMapasValorGeral
from 
   #ClientesGeoMapasGeral a, #ClientesGeoValorGeral b
where
   a.cliente *= b.cliente

select * 
into #ClientesGeoMapasValorAux
from #ClientesGeoMapasValorGeral
order by TotalVendas Desc

select IDENTITY(int,1,1) as 'Posicao',
       a.* 
into #TabelaFinalGeral
from #ClientesGeoMapasValorAux a
order by a.TotalVendas

-- Mostra a tabela final

select * from #TabelaFinalGeral
order by
   posicao


