
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_vendas_vendedor
-------------------------------------------------------------------------------
--pr_mapa_vendas_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Mapa de Vendas por Vendedor
--
--Data             : 10.04.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_mapa_vendas_vendedor
@cd_vendedor          int      = 0,
@cd_vendedor_interno  int      = 0,    
@dt_inicial           datetime = '',
@dt_final             datetime = ''

as

--select * from vw_venda_bi

select
  identity(int,1,1)               as cd_controle,
  vw.cd_vendedor,
  vw.cd_vendedor_interno,
  vw.nm_vendedor_externo,
  vw.nm_vendedor_interno,
  vw.dt_pedido_venda,
  datepart(wk,vw.dt_pedido_venda) as Semana,
  datepart(dw,vw.dt_pedido_venda) as DiaSemana,
  ( select nm_semana from semana where cd_semana = datepart(dw,vw.dt_pedido_venda ))  as nm_semana,

  --Total de Vendas

  (vw.qt_item_pedido_venda  * vw.vl_unitario_item_pedido )                            as vl_total_venda,

  --Total de Saldo de Carteira
  case when isnull(vw.qt_saldo_pedido_venda,0)>0 then
     (vw.qt_saldo_pedido_venda * vw.vl_unitario_item_pedido )                        
  else
    0.00
  end                                                                                 as vl_saldo_carteira,

  --Total de Faturamento 

  isnull(vwf.vl_unitario_item_total,0.00)                                             as vl_faturamento,


  --Total retirado do Estoque

  0.00                                                                                as vl_estoque
 
--select datepart(wk,getdate())  
--select datepart(dw,getdate())  
--select * from semana

into
  #MapaVendedor

from
  vw_venda_bi vw with (nolock)
  left outer join vw_faturamento vwf on vwf.cd_pedido_venda      = vw.cd_pedido_venda and
                                        vwf.cd_item_pedido_venda = vw.cd_item_pedido_venda
where
  vw.cd_vendedor = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
  vw.dt_pedido_venda between @dt_inicial and @dt_final

order by
  vw.nm_vendedor_externo,
  vw.dt_pedido_venda

select
  max(cd_controle)       as cd_controle,
  cd_vendedor,
  nm_vendedor_externo,
  Semana,
  DiaSemana,
  max(nm_semana)         as nm_semana,
  min(dt_pedido_venda)   as dt_inicial,
  max(dt_pedido_venda)   as dt_final,
  sum(vl_total_venda)    as vl_total_venda,
  sum(vl_saldo_carteira) as vl_saldo_carteira,
  sum(vl_faturamento)    as vl_faturamento,
  sum(vl_estoque)        as vl_estoque,
  --Total do Contrato
 
  ( select sum(vl_total_item_contrato)
    from 
      vw_programacao_contrato_produto vwp
    where
      vwp.cd_vendedor = mv.cd_vendedor and
      vwp.dt_prevista_contrato between @dt_inicial and @dt_final and
      vwp.DiaSemana = DiaSemana  )                                              as vl_total_contrato

from
  #MapaVendedor mv

group by
  cd_vendedor,
  nm_vendedor_externo,
  Semana,
  DiaSemana
order by
  nm_vendedor_externo,
  Semana,
  DiaSemana  


