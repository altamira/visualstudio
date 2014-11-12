
create procedure pr_consulta_devolucao_documento_pagar

@dt_inicial	Datetime,
@dt_final	DateTime

as

SELECT
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
           when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
           when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.cd_documento_pagar,
  dp.dt_emissao_documento_paga,
  dp.dt_vencimento_documento,
  dp.vl_documento_pagar,
  dp.vl_saldo_documento_pagar,
  dpp.dt_pagamento_documento,
  dpp.vl_pagamento_documento,
  dp.cd_nota_saida,
  dp.dt_devolucao_documento,
  dp.nm_motivo_dev_documento

FROM
  Documento_Pagar dp
  LEFT OUTER JOIN
  Documento_Pagar_Pagamento dpp
  ON
  dp.cd_documento_pagar = dpp.cd_documento_pagar

WHERE
  dp.dt_devolucao_documento BETWEEN @dt_inicial AND @dt_final

