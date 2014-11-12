

/****** Object:  Stored Procedure dbo.pr_clientes_geo_mapas1    Script Date: 13/12/2002 15:08:14 ******/
--pr_clientes_geo_mapas1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Clientes por Mapa Geográfico
--Data         : 13.03.2000
--Atualizado : 15.03.2000 - Marcio Longhini
--	       21.03.2000 - Marcio Longhini - Acerto da consulta pag_cli
--             02.06.2000 - Mudança para período 
--             06.12.2000 - Todas as Regiões   
--             14.12.2000 - Mostrar todos os clientes independente do Valor de Vendas
--             23.09.2002 - Migração bco. EGIS - DUELA
-----------------------------------------------------------------------------------
CREATE procedure pr_clientes_geo_mapas1

@cd_geomapa       int,
@dt_inicial       datetime,
@dt_final         datetime

AS

--Monta uma tabela com todos os Clientes do Vendedor

select cli.nm_divisao_area      as 'Mapa',
       cli.cd_cliente,
       cli.nm_fantasia_cliente  as 'Cliente',
       r.nm_regiao              as 'Regiao',
       cli.cd_vendedor          as 'cd_vendedor',
       v.nm_fantasia_vendedor   as 'Setor',
       cli.dt_cadastro_cliente  as 'Cadastro',
       e.sg_estado              as 'Estado',
       c.nm_cidade              as 'Cidade'
into
   #Cliente_Vendedor
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
   dr.cd_divisao_regiao=@cd_geomapa
--group by cli.nm_divisao_area, cli.nm_fantasia_cliente
order by 1

-- (%) de Expectativa de Crescimento  ( Futuramente um Tabela de Parâmetros no Cadastro Empresa )
declare @pc_crescimento float 
set @pc_crescimento = 1.20

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set     @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1

select cli.nm_divisao_area                    as 'Mapa',
       cli.cd_cliente,
       cli.nm_fantasia_cliente                as 'Cliente',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)                   as 'TotalVendas',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/@qt_mes_media     as 'MediaMensal',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * @pc_crescimento as 'Crescimento',
      (sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)*@pc_crescimento )/@qt_mes_media   
                                              as 'MediaMensalCrescimento'

into #RegClienteAux
from
   Cliente cli
left outer join Divisao_Regiao dr
  on dr.nm_divisao_regiao=cli.nm_divisao_area
left outer join Pedido_Venda pv
  on pv.cd_cliente=cli.cd_cliente
left outer join Pedido_Venda_Item pvi
  on pvi.cd_pedido_venda=pv.cd_pedido_venda
where
   dr.cd_divisao_regiao=@cd_geomapa and
  (pv.dt_pedido_venda between @dt_inicial and @dt_final ) and
  (pv.dt_cancelamento_pedido is null )                    and
  (pvi.dt_cancelamento_item is null )                     and
   pvi.ic_smo_item_pedido_venda = 'N'   

group by cli.nm_divisao_area, cli.nm_fantasia_cliente, cli.cd_cliente
Order by 5 desc

--Montagem da Tabela final com a posicao do Cliente com o Valor de Venda Maior

select IDENTITY(int,1,1) as 'Posicao',
       b.regiao,
       b.cd_cliente,
       b.cliente,
       b.cd_vendedor,
       b.setor, 
       b.cidade,
       b.estado,
       b.cadastro,
       a.totalvendas,
       a.mediamensal,
       a.crescimento,
       a.mediamensalcrescimento
into #RegCliente
from
    #RegclienteAux a, #Cliente_Vendedor b
where b.cliente *= a.cliente
Order by 
    a.TotalVendas desc

-- Mostra a tabela final
select * from #RegCliente
order by
   totalvendas desc



