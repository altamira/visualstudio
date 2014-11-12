
CREATE   PROCEDURE pr_meta_venda_diaria
-------------------------------------------------------------------------  
--pr_meta_venda_diaria  
-------------------------------------------------------------------------  
--GBS - Global Business Solution  Ltda                              2004  
-------------------------------------------------------------------------  
--Stored Procedure       : Microsoft SQL Server 2000  
--Autor(es)              : Daniel C. Neto.  
--Banco de Dados         : EgisSql  
--Objetivo               : Calcular as Metas de Vendas Diárias.  
--Data                   : 27/06/2003  
--Atualizado             : 01/08/2003 - Fabio - Inclusão da filtragem por vendedor  
--                       : 17/11/2003 - Acerto nas fórmulas  
--                       : 05/01/2004 - Acerto no relacionamento - Daniel C. Neto  
--                       : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso  
--                       : 25.05.2006 - Revisão da Fórmula - Carlos Fernandes  
--                       : 30.05.2006 - Meta para Tipo de Mercado - Carlos Fernandes  
--                       : 05.06.2006 - Ajuste da Fórmula da Projeção - Carlos Fernandes  
-- 27.01.2009 - Ajuste para busca da Meta do Cadastro do Vendedor - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------  
  
@dt_base         datetime,  
@cd_vendedor     int = 0,  
@cd_tipo_mercado int = 0  
  
AS  
  
set @cd_vendedor = isnull(@cd_vendedor,0)  
  
declare @qt_dia_imediato as integer  
  
set @qt_dia_imediato = ( select isnull(qt_dia_imediato_empresa,0)   
    from Parametro_Comercial  with (nolock) 
    where cd_empresa = dbo.fn_empresa() )  

-- Pedidos não Imediatos  
  
select   
  mv.cd_empresa,  
  max(mv.vl_venda_imediato_meta)            as 'Meta_Imediato',  
  max(mv.vl_venda_mes_meta)                 as 'Meta_Mes',   
  sum(IsNull(vw.qt_item_pedido_venda,0) *   
      IsNull(vw.vl_unitario_item_pedido,0)) as 'Vendas',   
  cast( 0 as Float )                        as 'VendasImediatas',

  max(mv.qt_venda_imediato_meta)            as 'Qt_Meta_Imediato',  
  max(mv.qt_venda_mes_meta)                 as 'Qt_Meta_Mes',   
  sum(IsNull(vw.qt_item_pedido_venda,0))    as 'Qt_Vendas',   
  cast( 0 as Float )                        as 'Qt_VendasImediatas'

into   
  #MetaVendasInicial  
from  
  Meta_Venda mv,  
  vw_venda_bi vw   
where  
  mv.cd_empresa = dbo.fn_empresa()            and  
 (@dt_base between mv.dt_inicial_meta_venda and mv.dt_final_meta_venda)   and  
  month(vw.dt_pedido_venda) = month(@dt_base) and  
  year(vw.dt_pedido_venda) = year(@dt_base)   and  
  isnull(vw.cd_vendedor,0) = ( case IsNull(@cd_vendedor,0) when 0  
                       then isnull(vw.cd_vendedor,0)  
                       else @cd_vendedor  
                     end )  
  and isnull(mv.cd_tipo_mercado,0) = case when @cd_tipo_mercado = 0 then isnull(mv.cd_tipo_mercado,0) else @cd_tipo_mercado end  
group by   
  mv.cd_empresa  
  
-- Pedidos Imediatos  
  
select   
  mv.cd_empresa,  
  max(mv.vl_venda_imediato_meta)            as 'Meta_Imediato',  
  max(mv.vl_venda_mes_meta)                 as 'Meta_Mes',   
  cast(0 as Float)                          as 'Vendas',   
  sum(IsNull(vw.qt_item_pedido_venda,0) *  
      IsNull(vw.vl_unitario_item_pedido,0)) as 'VendasImediatas',

  max(mv.qt_venda_imediato_meta)            as 'Qt_Meta_Imediato',  
  max(mv.qt_venda_mes_meta)                 as 'Qt_Meta_Mes',   
  cast( 0 as Float )                        as 'Qt_Vendas',
  sum(IsNull(vw.qt_item_pedido_venda,0))    as 'Qt_VendasImediatas'   
into   
  #MetaVendasImediatas  
from  
  Meta_Venda mv,  
  vw_venda_bi vw   
where  
  mv.cd_empresa = dbo.fn_empresa() and  
  month(vw.dt_pedido_venda) = month(@dt_base) and  
  year(vw.dt_pedido_venda) = year(@dt_base)   and  
  (@dt_base between mv.dt_inicial_meta_venda and mv.dt_final_meta_venda)   and  
  ((vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) <= @qt_dia_imediato) and  
  vw.cd_vendedor = ( case IsNull(@cd_vendedor,0) when 0  
                      then vw.cd_vendedor  
                      else @cd_vendedor  
                    end )   
  --Tipo de Mercado  
  and mv.cd_tipo_mercado = case when @cd_tipo_mercado = 0 then mv.cd_tipo_mercado else @cd_tipo_mercado end  
  
group by   
  mv.cd_empresa  
  
select   
  cd_empresa,  
  Meta_Imediato,  
  Meta_Mes,   
  --SUM( IsNull(Vendas,0) + IsNull(VendasImediatas,0) ) as 'Vendas',  
  SUM( IsNull(Vendas,0) )                             as 'Vendas',
  SUM( VendasImediatas )                              as 'VendasImediatas',  
  Qt_Meta_Imediato,  
  Qt_Meta_Mes,   
  --SUM( IsNull(Vendas,0) + IsNull(VendasImediatas,0) ) as 'Vendas',  
  SUM( IsNull(Qt_Vendas,0) )                          as 'Qt_Vendas',
  SUM( Qt_VendasImediatas )                           as 'Qt_VendasImediatas'  
into   
 #MetaVendas  
from  
  ( select * from #MetaVendasInicial union all select * from #MetaVendasImediatas ) v  
group by  
  cd_empresa,  
  Meta_Imediato,  
  Meta_Mes,
  Qt_Meta_Imediato,  
  Qt_Meta_Mes  
  
--------------------------------------------------------------------------------------  
-- Mostra a Tabela com dados do Mês, Porcentagem, Dias Transcorridos e dias Úteis.  
--------------------------------------------------------------------------------------  
  declare @qt_dia_util   as integer  
  declare @qt_dia_transc as integer  
  declare @dt_agenda     as datetime

  set @dt_agenda = @dt_base

  if @dt_base>getdate()
     set @dt_agenda = getdate()

  set @qt_dia_util = ( select count(dt_agenda) from Agenda   
                       where month(dt_agenda) = month(@dt_agenda) and  
                       year(dt_agenda) = year(@dt_agenda) and  
                       ic_util = 'S')  
  
  set @qt_dia_transc = ( select count(dt_agenda) from Agenda   
                       where month(dt_agenda) = month(@dt_agenda) and  
                       year(dt_agenda) = year(@dt_agenda) and  
         dt_agenda <= @dt_agenda and  
                       ic_util = 'S')  

------------------------------------------------  
-- Calculando Projeção, Necessidade e Posição  
------------------------------------------------  
  
select   
  cd_empresa,  
  Meta_Imediato,  
  Meta_Mes,   
  Qt_Meta_Imediato,  
  Qt_Meta_Mes,   
  @qt_dia_util   as 'DiaUtil',  
  @qt_dia_transc as 'DiaTransc',  
  
  -- Valores
  cast(Vendas as decimal(25,2))                                        as 'Vendas',   
  (Vendas*100)/Meta_Mes                                                as 'perc_venda',  
  (Vendas/@qt_dia_transc)                                              as 'MediaDiaria',  
  ((Vendas/@qt_dia_transc) * @qt_dia_util)                             as 'Projecao',  
  case when Meta_Mes < Vendas then 0.00   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Mes - Vendas)  
  else   
   ((Meta_Mes - Vendas) / (@qt_dia_util - @qt_dia_transc))  
  end                                                                  as 'Necessidade',  
  ((Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Vendas                as 'Abaixo',  
  cast(VendasImediatas as decimal(25,2))                               as 'VendasImediatas',  
  (VendasImediatas*100)/Meta_Imediato                                  as 'perc_venda_imediato',  
  (VendasImediatas/@qt_dia_transc)                                     as 'MediaDiariaImediata',  
  ((VendasImediatas/@qt_dia_transc) * @qt_dia_util )                   as 'ProjecaoImediata',  
  case when Meta_Imediato < VendasImediatas then 0   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Meta_Imediato - VendasImediatas)  
  else ((Meta_Imediato - VendasImediatas) / (@qt_dia_util - @qt_dia_transc))   
  end                                                                  as 'NecessidadeImediata',  
  ((Meta_Imediato / @qt_dia_util) * @qt_dia_transc) - VendasImediatas  as 'AbaixoImediato',  

  -- Quantidades
  cast(Qt_Vendas as decimal(25,2))                                     as 'Qt_Vendas',   
  (Qt_Vendas*100)/Qt_Meta_Mes                                          as 'Qt_perc_venda',  
  (Qt_Vendas/@qt_dia_transc)                                           as 'Qt_MediaDiaria',  
  ((Qt_Vendas/@qt_dia_transc) * @qt_dia_util)                          as 'Qt_Projecao',  
  case when Qt_Meta_Mes < Qt_Vendas then 0.00   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Qt_Meta_Mes - Qt_Vendas)  
  else   
   ((Qt_Meta_Mes - Qt_Vendas) / (@qt_dia_util - @qt_dia_transc))  
  end                                                                  as 'Qt_Necessidade',  
  ((Qt_Meta_Mes / @qt_dia_util) * @qt_dia_transc) - Qt_Vendas          as 'Qt_Abaixo',  
  cast(Qt_VendasImediatas as decimal(25,2))                            as 'Qt_VendasImediatas',  
  (Qt_VendasImediatas*100)/Qt_Meta_Imediato                            as 'Qt_perc_venda_imediato',  
  (Qt_VendasImediatas/@qt_dia_transc)                                  as 'Qt_MediaDiariaImediata',  
  ((Qt_VendasImediatas/@qt_dia_transc) * @qt_dia_util )                as 'Qt_ProjecaoImediata',  
  case when Qt_Meta_Imediato < Qt_VendasImediatas then 0   
       when (@qt_dia_util - @qt_dia_transc) = 0 then (Qt_Meta_Imediato - Qt_VendasImediatas)  
  else ((Qt_Meta_Imediato - Qt_VendasImediatas) / (@qt_dia_util - @qt_dia_transc))   
  end                                                                  as 'Qt_NecessidadeImediata',  
  ((Qt_Meta_Imediato / @qt_dia_util) * @qt_dia_transc) - Qt_VendasImediatas  as 'Qt_AbaixoImediato'  
  
from  
  #MetaVendas  
order by 1 desc  

