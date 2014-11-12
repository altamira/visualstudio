
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_documento_remessa_fora_limite
-------------------------------------------------------------------------------
--pr_consulta_documento_remessa_fora_limite
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 13.04.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_documento_remessa_fora_limite
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from documento_receber

declare @dt_hoje datetime 

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


select
  vw.nm_fantasia,
  vw.nm_razao_social,
  vw.cd_cnpj,
  d.cd_documento_receber,
  d.cd_identificacao,
  d.dt_emissao_documento,
  d.dt_vencimento_documento,
  d.dt_envio_banco_documento,

  p.nm_portador,

  case when isnull(p.cd_banco,0)>0 then
    b1.qt_dia_limite_cnab_banco
  else
    b2.qt_dia_limite_cnab_banco
  end                                            as qt_dia_limite_cnab_banco,

  @dt_hoje
  +
  case when isnull(p.cd_banco,0)>0 then
    b1.qt_dia_limite_cnab_banco
  else
    b2.qt_dia_limite_cnab_banco
  end                                            as dt_vencimento_limite,

  case when d.dt_vencimento_documento
  >
  ( @dt_hoje
    +
    case when isnull(p.cd_banco,0)>0 then
      b1.qt_dia_limite_cnab_banco
    else
      b2.qt_dia_limite_cnab_banco
    end
  ) then 'Vencimento Fora do Limite'
    else 'ok'
    end                                           as nm_obs_documento_limite,
    d.vl_saldo_documento


into
  #RemessaConsulta

from
  documento_receber d                     with (nolock)
  left outer join portador p              with (nolock) on p.cd_portador           = d.cd_portador
  left outer join conta_agencia_banco cab with (nolock) on cab.cd_conta_banco      = d.cd_conta_banco_remessa
  left outer join banco    b1             with (nolock) on b1.cd_banco             = p.cd_banco
  left outer join banco    b2             with (nolock) on b2.cd_banco             = cab.cd_banco
  left outer join vw_destinatario vw      with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                           vw.cd_tipo_destinatario = d.cd_tipo_destinatario

--select * from banco
--select * from conta_agencia_banco
--select * from portador
--select * from vw_destinatario vw

where
  d.dt_envio_banco_documento  is not null and
  d.dt_cancelamento_documento is null and
  d.dt_devolucao_documento    is null and
  isnull(d.vl_saldo_documento,0)>0 

order by
  d.dt_envio_banco_documento

select
  *
from
  #RemessaConsulta
where
   nm_obs_documento_limite<>'ok'

order by
  dt_envio_banco_documento


