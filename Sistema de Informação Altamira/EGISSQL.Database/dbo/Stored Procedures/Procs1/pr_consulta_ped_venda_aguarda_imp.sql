

CREATE   PROCEDURE pr_consulta_ped_venda_aguarda_imp

------------------------------------------------------------------------
--pr_consulta_ped_venda_aguarda_imp
------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Pedidos aguardando importação.
--Data			: 29/04/2004
------------------------------------------------------------------------

@ic_parametro        char(1), -- Tipo de Retorno [R-Resumido/A-Analítico]
@cd_pedido_venda     int,  
@cd_cliente          int,  
@ic_filtrar_periodo  char(1),
@dt_inicial          datetime,
@dt_final            datetime,
@cd_fase_produto     int = 6 -- Fase mais utilizazda na SMC, pois colocando este parametro, 
                             -- ele naum irar dar erro nos forms antigos
AS  

---------------------------------------------------------------
if @ic_parametro = 'R' -- Dados Resumidos
---------------------------------------------------------------
begin
  select 
    count(pvi.cd_pedido_venda)     as Pedido_Venda,
    min(pvi.dt_entrega_vendas_pedido)   as Entrega,
    min(pvi.dt_item_pedido_venda)       as Emissao,
    cast(NULL as varchar(30))           as Cliente,
    0                                   as Item,
    p.nm_fantasia_produto               as Produto,
    sum(pvi.qt_item_pedido_venda)       as Qtde,
    avg(ps.qt_saldo_atual_produto)      as Atual,
    avg(ps.qt_saldo_reserva_produto)    as Disponivel,
    min(ps.dt_prev_ent1_produto)        as Dt_Prev_Ent_1,
    min(ps.dt_prev_ent2_produto)        as Dt_Prev_Ent_2,
    min(ps.dt_prev_ent3_produto)        as Dt_Prev_Ent_3,
    min(ps.qt_prev_ent1_produto)        as Qt_Prev_Ent_1,
    min(ps.qt_prev_ent2_produto)        as Qt_Prev_Ent_2,
    min(ps.qt_prev_ent3_produto)        as Qt_Prev_Ent_3,
    min(ps.cd_ped_comp_imp1)            as cd_ped_comp_imp1,
    min(ps.cd_ped_comp_imp2)            as cd_ped_comp_imp2,
    min(ps.cd_ped_comp_imp3)            as cd_ped_comp_imp3,
    min(ps.qt_ped_comp_imp1)            as qt_ped_comp_imp1,
    min(ps.qt_ped_comp_imp2)            as qt_ped_comp_imp2,
    min(ps.qt_ped_comp_imp3)            as qt_ped_comp_imp3,
    min(ps.dt_ped_comp_imp1)            as dt_ped_comp_imp1,
    min(ps.dt_ped_comp_imp2)            as dt_ped_comp_imp2,
    min(ps.dt_ped_comp_imp3)            as dt_ped_comp_imp3,
    min(ps.nm_di1)                      as nm_di1,
    min(ps.nm_di2)                      as nm_di2,
    min(ps.nm_di3)                      as nm_di3,
    max(pc.vl_custo_produto)            as Valor_Produto
from 
  pedido_venda_item pvi left outer join 
  Pedido_Venda pv on pv.cd_pedido_venda=pvi.cd_pedido_venda left outer join 
  Produto_Saldo ps on ps.cd_produto=pvi.cd_produto and 
                      ( ps.cd_fase_produto = @cd_fase_produto) left outer join 
  Produto_Custo pc on pc.cd_produto=pvi.cd_produto left outer join 
  Produto p on p.cd_produto=pvi.cd_produto left outer join 
  grupo_produto gp on gp.cd_grupo_produto=p.cd_grupo_produto left outer join 
  serie_produto sp on sp.cd_serie_produto=p.cd_serie_produto inner join 
  Cliente cli on cli.cd_cliente = pv.cd_cliente 
where 
  ( (sp.ic_import_serie_produto = 'S') or 
    (gp.ic_importacao_grupo_produ = 'S') or
    (p.ic_importacao_produto = 'S') ) and
  ( pv.dt_cancelamento_pedido is null ) and
  IsNull(pvi.qt_saldo_pedido_venda,0) > 0 and 
  pv.cd_status_pedido = 1 and
  ps.qt_saldo_reserva_produto < 0 and
  ( pvi.cd_pedido_venda = @cd_pedido_venda or @cd_pedido_venda = 0) and
  ( pv.cd_cliente = @cd_cliente or @cd_cliente = 0 ) and
  ( ( pv.dt_pedido_venda between @dt_inicial and @dt_final and @ic_filtrar_periodo = 'S' ) or
    ( @ic_filtrar_periodo = 'N' ) )

group by 
  p.nm_fantasia_produto


end
else
begin
  select 
    pvi.cd_pedido_venda                  as Pedido_Venda,
    pvi.dt_entrega_vendas_pedido        as Entrega,
    pvi.dt_item_pedido_venda            as Emissao,
    cli.nm_fantasia_cliente             as Cliente,
    pvi.cd_item_pedido_venda            as Item,
    p.nm_fantasia_produto               as Produto,
    pvi.qt_item_pedido_venda            as Qtde,
    ps.qt_saldo_atual_produto           as Atual,
    ps.qt_saldo_reserva_produto         as Disponivel,
    ps.dt_prev_ent1_produto             as Dt_Prev_Ent_1,
    ps.dt_prev_ent2_produto             as Dt_Prev_Ent_2,
    ps.dt_prev_ent3_produto             as Dt_Prev_Ent_3,
    ps.qt_prev_ent1_produto             as Qt_Prev_Ent_1,
    ps.qt_prev_ent2_produto             as Qt_Prev_Ent_2,
    ps.qt_prev_ent3_produto             as Qt_Prev_Ent_3,
    ps.cd_ped_comp_imp1,
    ps.cd_ped_comp_imp2,
    ps.cd_ped_comp_imp3,
    ps.qt_ped_comp_imp1,
    ps.qt_ped_comp_imp2,
    ps.qt_ped_comp_imp3,
    ps.dt_ped_comp_imp1,
    ps.dt_ped_comp_imp2,
    ps.dt_ped_comp_imp3,
    ps.nm_di1,
    ps.nm_di2,
    ps.nm_di3,
    pc.vl_custo_produto                 as Valor_Produto

from 
  pedido_venda_item pvi left outer join 
  Pedido_Venda pv on pv.cd_pedido_venda=pvi.cd_pedido_venda left outer join 
  Produto_Saldo ps on ps.cd_produto=pvi.cd_produto and 
                      ( ps.cd_fase_produto = @cd_fase_produto) left outer join 
  Produto_Custo pc on pc.cd_produto=pvi.cd_produto left outer join 
  Produto p on p.cd_produto=pvi.cd_produto left outer join 
  grupo_produto gp on gp.cd_grupo_produto=p.cd_grupo_produto left outer join 
  serie_produto sp on sp.cd_serie_produto=p.cd_serie_produto inner join 
  Cliente cli on cli.cd_cliente = pv.cd_cliente 
where 
  ( (sp.ic_import_serie_produto = 'S') or 
    (gp.ic_importacao_grupo_produ = 'S') or
    (p.ic_importacao_produto = 'S') ) and
  ( pv.dt_cancelamento_pedido is null ) and
  ps.qt_saldo_reserva_produto < 0 and 
  IsNull(pvi.qt_saldo_pedido_venda,0) > 0 and 
  pv.cd_status_pedido = 1 and
  ( pvi.cd_pedido_venda = @cd_pedido_venda or @cd_pedido_venda = 0) and
  ( pv.cd_cliente = @cd_cliente or @cd_cliente = 0 ) and
  ( ( pv.dt_pedido_venda between @dt_inicial and @dt_final and @ic_filtrar_periodo = 'S' ) or
    ( @ic_filtrar_periodo = 'N' ) )
order by 
  dt_entrega_vendas_pedido, 
  pvi.cd_pedido_venda, 
  cd_item_pedido_venda

end
  


