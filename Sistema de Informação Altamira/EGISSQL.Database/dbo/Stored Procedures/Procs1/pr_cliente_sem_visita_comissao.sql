
-------------------------------------------------------------------------------
--pr_cliente_sem_visita_comissao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Cliente sem Visita para Pagamento de Comissão
--Data             : 21.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_cliente_sem_visita_comissao
@cd_vendedor int = 0,
@dt_inicial  datetime,
@dt_final    datetime

as

--select * from parametro_visita

declare @qt_dia_visita_comissao int

set @qt_dia_visita_comissao = 0

select 
  @qt_dia_visita_comissao = isnull(qt_dia_visita_comissao,0)
from
  Parametro_Visita with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--select @qt_dia_visita_comissao

--select * from criterio_visita
--select * from visita
--select * from pedido_venda

select
  pv.cd_vendedor,
  v.nm_fantasia_vendedor,
  pv.dt_pedido_venda,
  pv.cd_pedido_venda,
  pv.vl_total_pedido_venda,
  c.nm_fantasia_cliente,
  --Data da última Visita
  ( select max(vi.dt_visita) 
    from 
      Visita vi with (nolock) 
    where 
     vi.cd_vendedor = pv.cd_vendedor and
     vi.cd_cliente  = pv.cd_cliente )       as UltimaVisita,
  cv.nm_criterio_visita
     
into
  #VisitaComissao                          
from
  Pedido_Venda pv                    with (nolock) 
  left outer join Vendedor v         with (nolock) on v.cd_vendedor         = pv.cd_vendedor
  left outer join Cliente  c         with (nolock) on c.cd_cliente          = pv.cd_cliente
  left outer join Criterio_Visita cv with (nolock) on cv.cd_criterio_visita = c.cd_criterio_visita
where
  pv.cd_vendedor = case when @cd_vendedor = 0 then pv.cd_vendedor else @cd_vendedor end and
  pv.dt_pedido_venda between @dt_inicial and @dt_final 
  

select
  *,
  isnull(getdate()-UltimaVisita,0) as 'Dias',

  case when
    @qt_dia_visita_comissao > 0 and ( dt_pedido_venda - UltimaVisita )>=@qt_dia_visita_comissao 
  then 'Sim'
  else 'Não' end as 'Comissao',  

  case when
    @qt_dia_visita_comissao=0 
    then cast('Dias para Checagem não Parametrizado - CONFIG' as varchar(60))
    else case when
          @qt_dia_visita_comissao > 0 and ( dt_pedido_venda - UltimaVisita )>=@qt_dia_visita_comissao 
         then cast('Visita Realizada - Pagto.Comissão Liberado'         as varchar(60))
         else cast('Visita Não Realizado - Pagto.Comissão Não Liberado' as varchar(60)) end 
    end as 'Observacao'  
                                          
from
  #VisitaComissao
order by
  nm_fantasia_vendedor,
  dt_pedido_venda desc

