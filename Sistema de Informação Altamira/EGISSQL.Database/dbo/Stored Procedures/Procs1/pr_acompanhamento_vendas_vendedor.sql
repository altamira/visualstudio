
-------------------------------------------------------------------------------
--pr_acompanhamento_vendas_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta do acompanhamento de vendas
--Data             : 10.03.2006
--Alteração        : 09.05.2006 - Acertos Diversos - Carlos Fernandes
--                 : 05.06.2006 - Término do Desenvolvimento - Carlos Fernandes
--------------------------------------------------------------------------------
create procedure pr_acompanhamento_vendas_vendedor
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_tipo_vendedor int = 0
as

  declare @qt_dia_util   as integer
  declare @qt_dia_transc as integer
  declare @dt_base       as datetime

  set @dt_base = getdate()

  set @qt_dia_util = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
                       ic_util = 'S')

  set @qt_dia_transc = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
		       dt_agenda <= @dt_base and
                       ic_util = 'S')



--select * from pedido_venda

select
  v.cd_vendedor,
  max(v.nm_fantasia_vendedor)                                   as Vendedor,
  dbo.fn_meta_vendedor(v.cd_vendedor,@dt_inicial,@dt_final,0,0) as MetaVendedor,
  sum( isnull(vl_total_pedido_venda,0) )                        as TotalVenda,
  QtdCliente = ( select count(c.cd_cliente) from Cliente c with (nolock) where c.cd_vendedor=v.cd_vendedor ),
  QtdPedido  = count(pv.cd_pedido_venda),
  Descto     = isnull((100-(((sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/
                              sum(pvi.qt_item_pedido_venda*pvi.vl_lista_item_pedido))*100))),0),

    
  Prazo      = sum( dbo.fn_soma_dia_parcela(pv.cd_condicao_pagamento) )
into
  #AuxAcompanhamento
from
  Vendedor v                      with (nolock)
  left outer join Pedido_Venda pv with (nolock) on pv.cd_vendedor = v.cd_vendedor
  left outer join Pedido_Venda_item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda  
where
  isnull(v.cd_tipo_vendedor,0) = 2 --Externo
  and pv.dt_cancelamento_pedido is null 
  and pv.dt_pedido_venda between @dt_inicial and @dt_final 
  and pvi.dt_cancelamento_item is null  

group by
  v.cd_vendedor
  

select
  a.*,
  PercParticipacao   = (cast(a.qtdCliente as float)/ case when a.qtdPedido>0 then a.qtdPedido else 1 end ) * 100,
  PercAproveitamento = (a.totalvenda / case when a.MetaVendedor>0 then a.MetaVendedor else 1 end ) * 100,
  MediaDiaria        = TotalVenda/@qt_dia_transc,
  DesctoMedio        = Descto,
  PrazoMedio         = Prazo/QtdPedido,
  DiasTranscorridos  = @qt_dia_transc
  
from
  #AuxAcompanhamento a
order by
  a.TotalVenda desc  

