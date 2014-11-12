
-------------------------------------------------------------------------------
--pr_ranking_atendimento_interno
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 10.03.2006
--Alteração        : 01.05.2006 - Acertos Diversos - filtro por Vendedor, analista/vendedor que atendeu
--                              - Novo parâmetro, na tabela parametro_bi, ic_tipo_atendimento
--                              - Carlos Fernandes
--                 : 09.05.2006 - Acerto dos Cálculo para utilização qtd. itens consulta/pedido - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------
create procedure pr_ranking_atendimento_interno
@dt_inicial       datetime,
@dt_final         datetime,
@cd_vendedor      int = 0,
@cd_tipo_vendedor int = 0,
@cd_cliente       int = 0
as

declare @ic_tipo_atendimento char(1)

select
  @ic_tipo_atendimento = isnull(ic_tipo_atendimento,'I')
from
  parametro_bi
where
  cd_empresa = dbo.fn_empresa()

--print @ic_tipo_atendimento

if @cd_cliente>0
begin
  set @ic_tipo_atendimento = 'E'
end

--select * from egisadmin.dbo.usuario

--select * from consulta
--select * from pedido_venda


create table #AuxRankingAtendimento (
 cd_vendedor    int,
 nm_vendedor    varchar(15) null,
 consulta       int null,
 pedido         int null,
 consultapedido int null,
 descto         float null )

------------------------------------------------------------------------------
--Externo
------------------------------------------------------------------------------

if @ic_tipo_atendimento = 'E' 
begin

  select
    v.cd_vendedor,
    max(v.nm_fantasia_vendedor)        as nm_vendedor,

    Consulta       =  ( select count(ci.cd_item_consulta) from  Consulta c with (nolock)
                                                           inner join consulta_itens ci with (nolock) on ci.cd_consulta = c.cd_consulta   
                                                           where 
                                                                c.cd_cliente   = case when @cd_cliente = 0 then c.cd_cliente else @cd_cliente end and
                                                                c.cd_vendedor  = v.cd_vendedor and 
                                                                c.dt_consulta  between @dt_inicial and @dt_final ),
                   


    Pedido         = ( select count(pvi.cd_item_pedido_venda) from Pedido_Venda pv with (nolock)
                                                                inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                                                where 
                                                                pv.cd_cliente      = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                                                                pv.cd_vendedor     = v.cd_vendedor and
                                                                pv.dt_pedido_venda between @dt_inicial and @dt_final and
                                                                pv.dt_cancelamento_pedido is null  ),

    ConsultaPedido =  ( select count(ci.cd_item_consulta) from consulta_itens ci with (nolock) 
                                                        inner join consulta cx with (nolock) on cx.cd_consulta = ci.cd_consulta
                                                        where
                                                               cx.cd_cliente          = case when @cd_cliente = 0 then cx.cd_cliente else @cd_cliente end and
                                                               v.cd_vendedor = cx.cd_vendedor and
                                                               isnull(ci.cd_pedido_venda,0)>0         and
                                                               cx.dt_consulta  between @dt_inicial and @dt_final ),
    --select * from pedido_venda_item

    descto         = isnull(( select 100-(((sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/
                                     sum(pvi.qt_item_pedido_venda*pvi.vl_lista_item_pedido))*100))
                       from Pedido_Venda pv with (nolock)
                            inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                       where 
                            pv.cd_cliente      = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                            pv.cd_vendedor     = v.cd_vendedor and
                            pv.dt_pedido_venda between @dt_inicial and @dt_final and
                            pv.dt_cancelamento_pedido is null  ),0)

  into
    #AuxRankingAtendimentoExterno
  from
    Vendedor v with (nolock)
  where
    v.cd_vendedor                = case when @cd_vendedor = 0      then v.cd_vendedor      else @cd_vendedor      end and
    --Tipo do Vendedor 1=Interno / 2=Externo
    isnull(v.cd_tipo_vendedor,0) = case when @cd_tipo_vendedor = 0 then v.cd_tipo_vendedor else @cd_tipo_vendedor end 
  group by
    v.cd_vendedor

  insert into #AuxRankingAtendimento
    select * from #AuxRankingAtendimentoExterno
  
end


else

------------------------------------------------------------------------------
--Interno / Atendimento da Proposta / Pedido de Venda
------------------------------------------------------------------------------

begin

--  print 'Interno'

  select
    v.cd_vendedor,
    max(v.nm_fantasia_vendedor)        as nm_vendedor,

    Consulta       = case when @ic_tipo_atendimento = 'I' then
                       ( select count(ci.cd_item_consulta) from  Consulta c with (nolock)
                                                           inner join consulta_itens ci with (nolock) on ci.cd_consulta = c.cd_consulta   
                                                           where 
                                                                c.cd_cliente = case when @cd_cliente = 0 then c.cd_cliente else @cd_cliente end and
                                                                c.cd_vendedor_interno  = v.cd_vendedor and 
                                                                c.dt_consulta  between @dt_inicial and @dt_final )
                   else
                       ( select count(ci.cd_item_consulta) from  Consulta c with (nolock)
                                                           inner join consulta_itens ci with (nolock)            on ci.cd_consulta = c.cd_consulta   
                                                           left outer join egisadmin.dbo.Usuario u with (nolock) on c.cd_usuario_atendente = u.cd_usuario 
                                                           where 
                                                                c.cd_cliente = case when @cd_cliente = 0 then c.cd_cliente else @cd_cliente end and
                                                                u.cd_vendedor          = v.cd_vendedor and 
                                                                c.dt_consulta  between @dt_inicial and @dt_final )

                   end,

  Pedido         = case when @ic_tipo_atendimento = 'I' then
                       ( select count(pvi.cd_item_pedido_venda) from Pedido_Venda pv with (nolock)
                                                                inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                                                where 
                                                                pv.cd_cliente          = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                                                                pv.cd_vendedor_interno = v.cd_vendedor and
                                                                pv.dt_pedido_venda between @dt_inicial and @dt_final and
                                                                pv.dt_cancelamento_pedido is null  )
                   else
                       ( select count(pvi.cd_item_pedido_venda) from Pedido_Venda pv with (nolock)
                                                                inner join Pedido_Venda_Item pvi  with (nolock)       on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                                                left outer join egisadmin.dbo.Usuario u with (nolock) on pv.cd_usuario_atendente = u.cd_usuario  

                                                                where 
                                                                pv.cd_cliente          = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                                                                u.cd_vendedor           = v.cd_vendedor and
                                                                pv.dt_pedido_venda between @dt_inicial and @dt_final and
                                                                pv.dt_cancelamento_pedido is null  )

                   end,

  ConsultaPedido = case when @ic_tipo_atendimento = 'I' then
                       ( select count(ci.cd_item_consulta) from consulta_itens ci with (nolock)
                                                           inner join consulta cx with (nolock) on cx.cd_consulta = ci.cd_consulta
                                                           where
                                                               cx.cd_cliente          = case when @cd_cliente = 0 then cx.cd_cliente else @cd_cliente end and
                                                               v.cd_vendedor = cx.cd_vendedor_interno and
                                                               isnull(ci.cd_pedido_venda,0)>0         and
                                                               cx.dt_consulta  between @dt_inicial and @dt_final )

                   else
                       ( select count(ci.cd_item_consulta) from consulta_itens ci with (nolock)
                                                           inner join consulta cx with (nolock) on cx.cd_consulta = ci.cd_consulta
                                                           left outer join egisadmin.dbo.usuario u on u.cd_usuario = cx.cd_usuario_atendente
                                                           where 
                                                               cx.cd_cliente          = case when @cd_cliente = 0 then cx.cd_cliente else @cd_cliente end and
                                                               u.cd_vendedor           = v.cd_vendedor and 
                                                               isnull(ci.cd_pedido_venda,0)>0          and
                                                               cx.dt_consulta  between @dt_inicial and @dt_final )
                   end,

    descto         = case when @ic_tipo_atendimento = 'I' then
                       isnull(( select 100-(((sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/
                                     sum(pvi.qt_item_pedido_venda*pvi.vl_lista_item_pedido))*100))
                       from Pedido_Venda pv with (nolock)
                       inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                       where 
                           pv.cd_cliente          = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                           pv.cd_vendedor_interno = v.cd_vendedor and
                           pv.dt_pedido_venda between @dt_inicial and @dt_final and
                           pv.dt_cancelamento_pedido is null  ),0)
                     else
                       isnull(( select 100-(((sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/
                                     sum(pvi.qt_item_pedido_venda*pvi.vl_lista_item_pedido))*100))
                       from Pedido_Venda pv with (nolock)
                            inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                            left outer join egisadmin.dbo.Usuario u with (nolock) on pv.cd_usuario_atendente = u.cd_usuario  

                       where 
                            pv.cd_cliente      = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
                            u.cd_vendedor           = v.cd_vendedor and 
                            pv.dt_pedido_venda between @dt_inicial and @dt_final and
                            pv.dt_cancelamento_pedido is null  ),0)
                      end   
                      

  into
    #AuxRankingAtendimentoInterno
  from
    Vendedor v with (nolock)
  where
    v.cd_vendedor                = case when @cd_vendedor = 0      then v.cd_vendedor      else @cd_vendedor      end and
    --Tipo do Vendedor 1=Interno / 2=Externo
    isnull(v.cd_tipo_vendedor,0) = case when @cd_tipo_vendedor = 0 then v.cd_tipo_vendedor else @cd_tipo_vendedor end 
  group by
    v.cd_vendedor

  insert into #AuxRankingAtendimento
    select * from #AuxRankingAtendimentoInterno

  --select * from #AuxRankingAtendimento
  
end


--Tabela de Ranking de Atendimento


declare @qt_total_consulta        float
declare @qt_total_consulta_pedido float

set @qt_total_consulta        = 0
set @qt_total_consulta_pedido = 0

select
  @qt_total_consulta        = sum( isnull(consulta,0) ),
  @qt_total_consulta_pedido = sum( isnull(consultapedido,0) )

from
  #AuxRankingAtendimento

if @qt_total_consulta = 0
   set @qt_total_consulta = 1

if @qt_total_consulta_pedido = 0
   set @qt_total_consulta_pedido = 1


--select @qt_total_consulta        
--select @qt_total_consulta_pedido

select
  a.*,
  PercParticipacao   = cast((a.consulta      /@qt_total_consulta       ) * 100 as float ),
  PercAproveitamento = cast((a.consultapedido/@qt_total_consulta_pedido) * 100 as float )  
from
  #AuxRankingAtendimento a
where
  (a.consulta<>0 or pedido<>0 )
order by
  a.consulta desc  

