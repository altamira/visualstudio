
CREATE VIEW vw_baixa_documento_receber
------------------------------------------------------------------------------------
--sp_helptext vw_baixa_documento_receber
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Soma Total de Baixas do Contas a Receber
--
--Data                  : 18.11.2009
--Atualização           : 08.02.2010
--
------------------------------------------------------------------------------------
as

--select * from documento_receber_pagamento

select
  drp.cd_documento_receber,
  max(d.cd_identificacao)                    as cd_identificacao,
  max(drp.dt_pagamento_documento)            as dt_pagamento_documento,
  sum(isnull(drp.vl_pagamento_documento,0))  as vl_pagamento_documento,
  sum(isnull(drp.vl_juros_pagamento,0))      as vl_juros_pagamento,
  sum(isnull(drp.vl_desconto_documento,0))   as vl_desconto_documento,
  sum(isnull(drp.vl_abatimento_documento,0)) as vl_abatimento_documento,
  sum(isnull(drp.vl_despesa_bancaria,0))     as vl_despesa_bancaria,
  sum(isnull(drp.vl_reembolso_documento,0))  as vl_reembolso_documento,
  sum(isnull(drp.vl_credito_pendente,0))     as vl_credito_pendente

from
  documento_receber_pagamento drp with (nolock) 
  inner join documento_receber d  with (nolock) on d.cd_documento_receber = drp.cd_documento_receber

group by
  drp.cd_documento_receber


 
