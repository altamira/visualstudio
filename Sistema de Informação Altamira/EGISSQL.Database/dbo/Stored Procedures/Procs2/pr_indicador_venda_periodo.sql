--sp_helptext pr_indicador_venda_periodo

-------------------------------------------------------------------------------
--pr_indicador_venda_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_indicador_venda_periodo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from meta_venda

declare @vl_meta_periodo float
declare @vl_venda_periodo float

select
  @vl_meta_periodo = isnull(mv.vl_venda_mes_meta,0)
from
  Meta_Venda mv
where
  dt_inicial_meta_venda = @dt_inicial and
  dt_final_meta_venda   = @dt_final

select
  @vl_venda_periodo = sum( isnull(vl_total_pedido_venda,0) )
from
  Pedido_Venda
where
  dt_pedido_venda between @dt_inicial and @dt_final
  --Tirar os cancelados

select
  isnull(@vl_meta_periodo,0)                  as Meta,
  isnull(@vl_venda_periodo,0)                 as TotalVendas,
  case when isnull(@vl_venda_periodo,0)>0 then
       ( isnull(@vl_meta_periodo,0)/@vl_venda_periodo ) * 100
  else
      0 end                          as Atingido


  
