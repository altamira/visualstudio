
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_folha_eventos_periodo
-------------------------------------------------------------------------------
--pr_resumo_folha_eventos_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Resumo da Folha de Pagamento por Período
--                   
--Data             : 15.01.2011
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_resumo_folha_eventos_periodo
@cd_controle_folha int = 0,	
@cd_tipo_calculo_folha int = 0	
as

--select * from calculo_folha
--select * from evento_folha

select
  cf.cd_evento,
  max(ef.nm_evento)                           as nm_evento,
  sum( isnull(cf.vl_calculo_folha,0))         as vl_calculo_folha,
  sum( isnull(cf.vl_referencia_calculo,0))    as vl_referencia_calculo,
  max(ef.cd_tipo_evento)                      as cd_tipo_evento,
  max(cf.nm_evento_provento)                  as nm_evento_provento,
  max(cf.nm_evento_desconto)                  as nm_evento_desconto,
  sum( isnull(cf.vl_provento_calculo,0) )     as vl_provento_calculo,
  sum( isnull(cf.vl_desconto_calculo,0) )     as vl_desconto_calculo,
  sum( isnull(cf.vl_ref_provento_calculo,0) ) as vl_ref_provento_calculo,
  sum( isnull(cf.vl_ref_desconto_calculo,0) ) as vl_ref_desconto_calculo,
  max(cf.dt_pagto_calculo_folha)              as dt_pagto_calculo_folha,               -- lazaro
  max(tcf.nm_tipo_calculo_folha)              as nm_tipo_calculo_folha                 --LAZARO
  
into
  #resumo_evento

from
  calculo_folha cf with (nolock)
  inner join evento_folha ef on ef.cd_evento = cf.cd_evento
  left outer join Tipo_Calculo_Folha  tcf    with (nolock) on tcf.cd_tipo_calculo_folha  = @cd_tipo_calculo_folha  --LAZARO
where
  cf.cd_controle_folha = @cd_controle_folha

group by
  cf.cd_evento


select
  case when cd_tipo_evento = 1 then
     cd_evento
  else
     0
  end                                          as cd_evento_provento,

  case when cd_tipo_evento = 2 then
     cd_evento
  else
     0
  end                                          as cd_evento_desconto,
  *

   
    
from
  #resumo_evento

order by
  cd_evento

