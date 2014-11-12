
CREATE PROCEDURE pr_mapa_programacao_cliente
@ic_parametro  int,
@nm_fantasia as varchar(30),
@dt_inicial    datetime,
@dt_final      datetime

AS
begin
--******************** Pesquisa por cliente e por período ********************************
if @ic_parametro = 1 
--*****************************************************************************************
begin
  Select 
    cli.nm_fantasia_cliente,
    pp.dt_prog_processo,
    m.nm_fantasia_maquina,
    pc.ic_ordem_fab,
    pc.cd_processo,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    o.nm_operacao,
    pc.qt_hora_prog_operacao,
    pp.dt_entrega_processo,
    pvi.ds_produto_pedido

  from   
    Programacao_composicao pc left outer join
    Programacao p on (pc.cd_programacao = p.cd_programacao)left outer join
    Processo_producao pp on (pc.cd_processo = pp.cd_processo)left outer join
    Pedido_venda pv on (pp.cd_pedido_venda = pv.cd_pedido_venda)left outer join
    Pedido_Venda_Item pvi on(pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda)left outer join
    Cliente cli on (pv.cd_cliente = cli.cd_cliente)left outer join
    Maquina m on (p.cd_maquina = m.cd_maquina)left outer join
    Operacao o on (pc.cd_operacao = o.cd_operacao)

  where
    cli.nm_fantasia_cliente like  @nm_fantasia + '%' and
    pp.dt_prog_processo between @dt_inicial and @dt_final    

end
else
--******************************  Consulta geral ******************************************
if @ic_parametro =  2
--*****************************************************************************************
begin
  Select 
    cli.nm_fantasia_cliente,
    pp.dt_prog_processo,
    m.nm_fantasia_maquina,
    pc.ic_ordem_fab,
    pc.cd_processo,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    o.nm_operacao,
    pc.qt_hora_prog_operacao,
    pp.dt_entrega_processo,
    pvi.ds_produto_pedido    

  from   
    Programacao_composicao pc left outer join
    Programacao p on (pc.cd_programacao = p.cd_programacao)left outer join
    Processo_producao pp on (pc.cd_processo = pp.cd_processo)left outer join
    Pedido_venda pv on (pp.cd_pedido_venda = pv.cd_pedido_venda)left outer join
    Pedido_Venda_Item pvi on(pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda)left outer join
    Cliente cli on (pv.cd_cliente = cli.cd_cliente)left outer join
    Maquina m on (p.cd_maquina = m.cd_maquina)left outer join
    Operacao o on (pc.cd_operacao = o.cd_operacao)

  where
    pp.dt_prog_processo between @dt_inicial and @dt_final    

end
end

