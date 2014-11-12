
create procedure pr_consulta_pedido_venda_reserva_composicao
  @cd_produto int,
  @dt_inicial datetime,
  @dt_final datetime
As


--Por solicitação da GBS a regra será sempre o primeiro dia do mês do período selecionado até a data corrente
Select
  @dt_inicial = cast(cast(datepart(year,@dt_inicial) as varchar(4)) + '/' + cast(datepart(month,@dt_inicial) as varchar(2))
                + '/' + cast(datepart(day,@dt_inicial) as varchar(2)) as datetime),
  @dt_final = getdate()


Select 
  c.nm_fantasia_cliente,
  pvi.cd_produto,
  pvi.nm_fantasia_produto,
  pvi.cd_pedido_venda ,
  pvi.cd_item_pedido_venda,
  pvi.qt_item_pedido_venda,
  pvi.vl_unitario_item_pedido,
  pvi.dt_item_pedido_venda,
  pvi.cd_lote_item_pedido,
  pv.ic_amostra_pedido_venda,
  pv.ic_consignacao_pedido,
  pvi.ic_estrutura_item_pedido,
  pvi.ic_reserva_item_pedido,
  pvi.dt_fechamento_pedido,
  pvi.ic_sel_fechamento
from 
  pedido_venda_item pvi with(nolock) 
  inner join pedido_venda pv with(nolock) 
    on pvi.cd_pedido_venda = pv.cd_pedido_venda
  inner join cliente c with(nolock) 
    on pv.cd_cliente = c.cd_cliente
where 
  pvi.dt_fechamento_pedido is not null and --Define que o item já teve o botão reservar pressionado
  pvi.dt_cancelamento_item is null and --desconsidera os itens canceladossal
  --pvi.qt_saldo_pedido_venda > 0 and --Saldo do item deverá ser superior a "zero" (Solicitação da GBS)
  pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and --Filtra apenas os pedidos do mês corrente
  IsNull(pvi.cd_produto,0) = @cd_produto and --realiza a busca pelo produto especificamente
  IsNull(ic_estrutura_item_pedido, 'N') = 'N' --traz somente os produto que não tiveram sua estrutura movimentada
