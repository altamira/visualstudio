

/****** Object:  Stored Procedure dbo.pr_resumo_regiao_total_vendas1    Script Date: 13/12/2002 15:08:41 ******/

--pr_regiao_total_vendas
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Resumo com Total de Vendas das Regiões
--Data          : 06.12.2000
--Atualizado    : 06.12.2000
--              : 18.09.2002 - Migração para a bco. EGISSQL (DUELA)
--------------------------------------------------------------------------------------
create procedure pr_resumo_regiao_total_vendas1
@dt_inicial  datetime,
@dt_final    datetime

as

-- (%) de Expectativa de Crescimento  ( Futuramente um Tabela de Parâmetros no Cadastro Empresa )
declare @pc_crescimento float 
set @pc_crescimento = 1.20

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1
 
select c.cd_regiao,
       r.nm_regiao                                               as 'Regiao',
       count(c.cd_cliente)                                       as 'Clientes',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) as 'Total',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/@qt_mes_media     as 'MediaMensal',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * @pc_crescimento as 'Crescimento',
      (sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)*@pc_crescimento )/@qt_mes_media as 'MediaMensalCrescimento'    
into #RegiaoAux
from
  Regiao r
left outer join Cliente c on
  c.cd_regiao=r.cd_regiao
left outer join Pedido_Venda pv on
  pv.cd_cliente=c.cd_cliente
left outer join Pedido_Venda_Item pvi on
  pvi.cd_pedido_venda=pv.cd_pedido_venda

where
  (pv.dt_pedido_venda between @dt_inicial and @dt_final) and
  pvi.dt_cancelamento_item is null
group by c.cd_regiao, r.nm_regiao

-- Montagem da Tabela Auxiliar

   select IDENTITY(int,1,1) as 'Posicao',
          a.*
   into #Regiao
   from
      #RegiaoAux a
   order by 
      a.total desc

-- Mostra a Tabela final
 
   select * from #Regiao
   order by 
      total desc



