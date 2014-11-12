
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_credito_rural_periodo
-------------------------------------------------------------------------------
--pr_consulta_credito_rural_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : EgisAdmin ou Egissql
--
--Objetivo         : 
--Data             : 01.01.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_credito_rural_periodo
@dt_inicial         datetime = '',
@dt_final           datetime = '', 
@cd_tipo_liquidacao int      = 0

as

--select * from documento_receber
--select * from documento_receber_pagamento
--select * from tipo_liquidacao 

select
  tl.nm_tipo_liquidacao             as Tipo_Liquidacao,
  wd.nm_fantasia                    as Fantasia_Cliente,
  wd.nm_razao_social                as Razao_Social,
  d.cd_identificacao                as Documento,
  d.dt_emissao_documento            as Emissao,
  d.dt_vencimento_documento         as Vencimento,
  dp.dt_pagamento_documento         as Pagamento,
  dp.vl_pagamento_documento         as Valor_Pagamento

from
  documento_receber d
  inner join documento_receber_pagamento dp on dp.cd_documento_receber = d.cd_documento_receber
  inner join tipo_liquidacao tl             on tl.cd_tipo_liquidacao   = dp.cd_tipo_liquidacao
  left outer join vw_destinatario wd        on wd.cd_destinatario      = d.cd_cliente            and
                                               wd.cd_tipo_destinatario = d.cd_tipo_destinatario
 
where
  dp.cd_tipo_liquidacao = case when @cd_tipo_liquidacao = 0 then dp.cd_tipo_liquidacao else @cd_tipo_liquidacao end

order by
  d.dt_vencimento_documento

--select * from documento_receber
--select * from vw_destinatario




