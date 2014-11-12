
CREATE   PROCEDURE pr_meta_venda_exportacao
-------------------------------------------------------------------------
--pr_meta_venda_exportacao
-------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                	             2005
-------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : André Seolin Fernandes
--Banco de Dados         : EgisSql
--Objetivo               : Calcular as Metas de Exportação.
--Data                   : 15/07/2005
--Atualizado             : 

-------------------------------------------------------------------------------------

@dt_base as Datetime,
@cd_vendedor int = 0
AS

set @cd_vendedor = isnull(@cd_vendedor,0)

declare @qt_dia_imediato as integer

-- qtde. de dias para ser considerado "Imediato"
set @qt_dia_imediato = ( select qt_dia_imediato_empresa 
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

-- Pedidos não Imediatos
select 
  me.cd_empresa,
  max(me.vl_venda_imediato_meta) as 'Meta_Imediato',
  max(me.vl_venda_mes_meta) as 'Meta_Mes', 
  sum(IsNull(vw.qt_item_pedido_venda,0) * 
      IsNull(vw.vl_unitario_item_pedido,0)) as 'Vendas', 
  cast( 0 as Float ) as 'VendasImediatas'
into 
  #MetaVendasInicialF
from
  Meta_Exportacao me,
  vw_venda_exportacao_bi vw 
where
  me.cd_empresa = dbo.fn_empresa()            and
  month(vw.dt_pedido_venda) = month(@dt_base) and
  year(vw.dt_pedido_venda) = year(@dt_base)   and
  (@dt_base between me.dt_inicial_meta_venda and me.dt_final_meta_venda)   and
  ((vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) > @qt_dia_imediato) and
  vw.cd_vendedor = ( case IsNull(@cd_vendedor,0) when 0
                      then vw.cd_vendedor
                      else @cd_vendedor
                    end )
group by 
  me.cd_empresa

-- Pedidos Imediatos
select 
  me.cd_empresa,
  max(me.vl_venda_imediato_meta) as 'Meta_Imediato',
  max(me.vl_venda_mes_meta) as 'Meta_Mes', 
  cast(0 as Float) as 'Vendas', 
  sum(IsNull(vw.qt_item_pedido_venda,0) *
      IsNull(vw.vl_unitario_item_pedido,0)) as 'VendasImediatas'
into 
  #MetaVendasImediatas
from
  meta_exportacao me,
  vw_venda__exportacao vw 
where
  me.cd_empresa = dbo.fn_empresa() and
  month(vw.dt_pedido_venda) = month(@dt_base) and
  year(vw.dt_pedido_venda) = year(@dt_base)   and
  (@dt_base between me.dt_inicial_meta_venda and me.dt_final_meta_venda)   and
  ((vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) <= @qt_dia_imediato) and
  vw.cd_vendedor = ( case IsNull(@cd_vendedor,0) when 0
                      then vw.cd_vendedor
                      else @cd_vendedor
                    end )
group by 
  me.cd_empresa

select 
  cd_empresa,
  Meta_Imediato,
  Meta_Mes, 
  SUM( IsNull(Vendas,0) + IsNull(VendasImediatas,0) ) as 'Vendas',
  SUM( VendasImediatas ) as 'VendasImediatas'
into 
	#MetaVendas
from
  ( select * from #MetaVendasInicial union all select * from #MetaVendasImediatas ) v
group by
  cd_empresa,
  Meta_Imediato,
  Meta_Mes


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
  cd_empresa,
  Meta_Imediato,
  Meta_Mes, 
  @qt_dia_util as 'DiaUtil',
  @qt_dia_transc as 'DiaTransc',

  cast(Vendas as decimal(25,2)) as Vendas, 
  (Vendas*100)/Meta_Mes as 'perc_venda',
  (Vendas/@qt_dia_transc) as 'MediaDiaria',
  ((Vendas/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) as 'Projecao',

  case when Meta_Mes < Vendas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Mes - Vendas)
  else ((Meta_Mes - Vendas) / (@qt_dia_util - @qt_dia_transc)) end as 'Necessidade',

  ((Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Vendas as 'Abaixo',

  cast(VendasImediatas as decimal(25,2)) as VendasImediatas,
  (VendasImediatas*100)/Meta_Imediato as 'perc_venda_imediato',
  (VendasImediatas/@qt_dia_transc) as 'MediaDiariaImediata',
  ((VendasImediatas/@qt_dia_transc) * (@qt_dia_util - @qt_dia_transc)) as 'ProjecaoImediata',

  case when Meta_Imediato < VendasImediatas then 0 
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Imediato - VendasImediatas)
  else ((Meta_Imediato - VendasImediatas) / (@qt_dia_util - @qt_dia_transc)) end as 'NecessidadeImediata',

  ((Meta_Imediato / @qt_dia_util) * @qt_dia_transc) - VendasImediatas as 'AbaixoImediato'

from
  #MetaVendas
order by 1 desc

