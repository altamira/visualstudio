create procedure pr_consulta_posicao_vendedor_meta_realizado
-------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EgisSql
--Objetivo: Calcular as Metas de Vendas Diárias.
--Data: 27/06/2003
--Atualizado: 01.08.2003 - Fabio - Inclusão da filtragem por vendedor
--            17/11/2003 - Acerto nas fórmulas
-------------------------------------------------------------------------
@dt_base as Datetime,
@cd_vendedor int
as

declare @qt_dia_imediato as integer

-- qtde. de dias para ser considerado "Imediato"
set @qt_dia_imediato = ( select qt_dia_imediato_empresa 
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

-- Pedidos não Imediatos
select 
  vw.nm_categoria_produto,
  vw.cd_categoria_produto,
  vm.vl_meta_vendedor as 'vl_meta',
  vm.qt_meta_vendedor as 'qt_meta',
  sum(vw.vl_unitario_item_pedido * (vw.qt_item_pedido_venda - vw.qt_saldo_pedido_venda)) 'vl_realizado',
  sum(vw.qt_item_pedido_venda - vw.qt_saldo_pedido_venda) 'qt_realizado'
 into 
   #MetaVendasImediatas
from
  Vendedor_Meta vm,
  vw_venda_bi vw 
where
  vm.cd_vendedor = vw.cd_vendedor and
  vm.cd_categoria_produto = vw.cd_categoria_produto and
  month(vw.dt_pedido_venda) = month(@dt_base) and
  year(vw.dt_pedido_venda) = year(@dt_base)   and
  (@dt_base between vm.dt_inicio_meta_vendedor and vm.dt_final_meta_vendedor) and
  ((vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) > @qt_dia_imediato) and
  vm.cd_vendedor = @cd_vendedor
group by 
    vw.nm_categoria_produto, vw.cd_categoria_produto, vm.vl_meta_vendedor, vm.qt_meta_vendedor

-- Pedidos Imediatos
select 
  vw.nm_categoria_produto,
  vw.cd_categoria_produto,
  vm.vl_meta_vendedor as 'vl_meta',
  vm.qt_meta_vendedor as 'qt_meta',
  sum(vw.vl_unitario_item_pedido * (vw.qt_item_pedido_venda - vw.qt_saldo_pedido_venda)) 'vl_realizado',
  sum(vw.qt_item_pedido_venda - vw.qt_saldo_pedido_venda) 'qt_realizado'
into 
  #MetaVendasInicial
from
  Vendedor_Meta vm,
  vw_venda_bi vw 
where
  vm.cd_vendedor = vw.cd_vendedor and
  vm.cd_categoria_produto = vw.cd_categoria_produto and
  month(vw.dt_pedido_venda) = month(@dt_base) and
  year(vw.dt_pedido_venda) = year(@dt_base)   and
  (@dt_base between vm.dt_inicio_meta_vendedor and vm.dt_final_meta_vendedor) and
  ((vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) <= @qt_dia_imediato) and
  vm.cd_vendedor = @cd_vendedor
group by 
  vw.nm_categoria_produto, vw.cd_categoria_produto, vm.vl_meta_vendedor, vm.qt_meta_vendedor



select 
  nm_categoria_produto,
  cd_categoria_produto,
  vl_meta,
  qt_meta,
  vl_realizado,
  qt_realizado,
  ((vl_realizado * 100)/ vl_meta) as 'pc_atingido'
into 
 	#MetaVendas
from
  ( select * from #MetaVendasInicial union all select * from #MetaVendasImediatas ) v


--------------------------------------------------------------------------------------
-- Mostra a Tabela com dados do Mês, Porcentagem, Dias Transcorridos e dias Úteis.
--------------------------------------------------------------------------------------
  declare @qt_dia_util as integer
  declare @qt_dia_transc as integer

  set @qt_dia_util = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
                       ic_util = 'S')

  set @qt_dia_transc = ( select count(dt_agenda) from Agenda 
                       where month(dt_agenda) = month(@dt_base) and
                       year(dt_agenda) = year(@dt_base) and
		       dt_agenda <= @dt_base and
                       ic_util = 'S')

------------------------------------------------
-- Calculando Projeção, Necessidade e Posição
------------------------------------------------

select 
  nm_categoria_produto,
  cd_categoria_produto,
  vl_meta,
  qt_meta,
  vl_realizado,
  qt_realizado,
  pc_atingido,
  @qt_dia_util as 'qt_dia_util',
  @qt_dia_transc as 'qt_dia_transc',
  ((vl_realizado/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) 'vl_projecao',
  ((qt_realizado/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) 'qt_projecao',

  ((vl_meta - vl_realizado) / (@qt_dia_util - @qt_dia_transc)) 'vl_necessidade',
  ((qt_meta - qt_realizado) / (@qt_dia_util - @qt_dia_transc)) 'qt_necessidade',

  ((vl_meta / @qt_dia_util) * @qt_dia_transc) - vl_realizado 'vl_posicao',
  ((qt_meta / @qt_dia_util) * @qt_dia_transc) - qt_realizado 'qt_posicao'
from
  #MetaVendas
order by 1 desc

