

/****** Object:  Stored Procedure dbo.pr_regiao_total_vendas1    Script Date: 13/12/2002 15:08:40 ******/

--pr_regiao_total_vendas1
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Total de Vendas por Regiao
--Data          : 06.12.2000
--Atualizado    : 08.12.2000
--              : 18.09.2002 - Migração para a bco. EGISSQL (DUELA)
--------------------------------------------------------------------------------------
create procedure pr_regiao_total_vendas1
@cd_regiao   int,
@dt_inicial  datetime,
@dt_final    datetime

as

-- (%) de Expectativa de Crescimento  ( Futuramente um Tabela de Parâmetros no Cadastro Empresa )
declare @pc_crescimento float 
set @pc_crescimento = 1.20

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1


select dr.cd_divisao_regiao                                      as 'Mapa',
       c.cd_regiao,
       r.nm_regiao                                               as 'Regiao',
       count(c.cd_cliente)                                       as 'Clientes',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) as 'Total',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/@qt_mes_media     as 'MediaMensal',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * @pc_crescimento as 'Crescimento',
      (sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)*@pc_crescimento )/@qt_mes_media as 'MediaMensalCrescimento'    
into #RegCidadeAux
from
  Regiao r
left outer join Cliente c on
  c.cd_regiao=r.cd_regiao
left outer join Divisao_Regiao dr on
  dr.nm_divisao_regiao=c.nm_divisao_area
left outer join Pedido_Venda pv on
  pv.cd_cliente=c.cd_cliente
left outer join Pedido_Venda_Item pvi on
  pvi.cd_pedido_venda=pv.cd_pedido_venda

where
  r.cd_regiao=@cd_regiao and
  (pv.dt_pedido_venda between @dt_inicial and @dt_final) and
  pvi.dt_cancelamento_item is null
group by dr.cd_divisao_regiao, c.cd_regiao, r.nm_regiao
--Montagem da Tabela Final

select IDENTITY(int,1,1) as 'Posicao', a.*
into #RegCidade
from
  #RegCidadeAux a
order by 
  a.total desc

-- Mostrar a tabela final

select * from #Regcidade
order by
   total desc
   


