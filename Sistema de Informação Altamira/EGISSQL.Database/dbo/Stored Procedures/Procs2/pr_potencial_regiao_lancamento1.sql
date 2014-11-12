

/****** Object:  Stored Procedure dbo.pr_potencial_regiao_lancamento1    Script Date: 13/12/2002 15:08:39 ******/
--pr_potencial_regiao_lancamento1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Busca o Potencial da Regiao para lançamento da divisão de área
--Data         : 14.12.2000
--Atualizado   : 14.12.2000
--             : 01.10.2002 - Migração p/ o bco. EGIS - Duela
-----------------------------------------------------------------------------------
CREATE procedure pr_potencial_regiao_lancamento1

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
       sum  (c.qt_item_pedido_venda*c.vl_unitario_item_pedido) as 'Total',
       sum  (c.qt_item_pedido_venda*c.vl_unitario_item_pedido)/@qt_mes_media as 'MediaMensal'
into #TotalClientesGeoValor

from
  Cliente a, Pedido_Venda b, Pedido_Venda_Item c
Where
  @cd_regiao   = a.nm_divisao_area       and
  a.cd_cliente = b.cd_cliente            and
  (b.dt_pedido_venda between @dt_inicial and @dt_final ) and
  b.cd_pedido_venda= c.cd_pedido_venda   and
  (c.qt_item_pedido_venda*c.vl_unitario_item_pedido) > 0                      and
  (c.dt_cancelamento_item is null  )     and
  c.ic_smo_item_pedido_venda = 'N'   

Group by a.nm_divisao_area
Order by 1

-- Tabela Final

select a.*,
       b.*
from 
 #TotalClientesGeo a, #TotalClientesGeoValor b
where
 a.mapa    *= b.mapa 
order by 
 a.mapa
  


