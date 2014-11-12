
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_calculo_folha_evento
-------------------------------------------------------------------------------
--pr_resumo_calculo_folha_evento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumdo do Cálculo da Folha por Eventos da Folha de Pagamento
--Data             : 14.06.2008
--Alteração        : 
--
-- 15.01.2011 - Ajustes Diversos - Carlos Fernnades
------------------------------------------------------------------------------
create procedure pr_resumo_calculo_folha_evento
@ic_parametro          int      = 0,
@cd_controle_folha     int      = 0,
@cd_tipo_calculo_folha int      = 0,
@dt_inicial            datetime = '',
@dt_final              datetime = ''

as

--select * from evento_folha
--select * from plano_financeiro
--select * from evento_incidencia
--select * from calculo_folha

if @ic_parametro = 1
begin
  select
    e.cd_evento,
    max(e.nm_evento) as nm_evento,
    max(e.sg_evento) as sg_evento,
    sum( isnull(cf.vl_provento_calculo,0)) as vl_provento_calculo,
    sum( isnull(cf.vl_desconto_calculo,0)) as vl_desconto_calculo,
    sum( isnull(cf.vl_calculo_folha,0))    as vl_calculo_folha,
    sum( isnull(cf.vl_provento_calculo,0) - 
         isnull(cf.vl_desconto_calculo,0)) as vl_total_liquido
--    0.00                                   as pc_evento
  into
    #Resumo_Evento

  from
    Evento_Folha e                          with (nolock)  
    left outer join Calculo_Folha       cf  with (nolock) on cf.cd_evento               = e.cd_evento
                                                             and
                                                             cf.dt_base_calculo_folha between @dt_inicial and @dt_final
                                                             and
    cf.cd_controle_folha = case when @cd_controle_folha = 0 then cf.cd_controle_folha else @cd_controle_folha end 
                                                             and
    cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 
  where
    isnull(vl_calculo_folha,0)>0

  group by
    e.cd_evento
  order by
    e.cd_evento

declare @vl_total_evento decimal(25,2)

select
  @vl_total_evento = sum( isnull(vl_calculo_folha,0) )
from
  #Resumo_Evento

select
  *,
  case when @vl_total_evento > 0 then
    ( vl_calculo_folha / @vl_total_evento ) * 100
  else
    0.00
  end as pc_evento 
from
  #Resumo_Evento
order by
  cd_evento

--select * from calculo_folha
   
end


