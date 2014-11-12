
CREATE PROCEDURE pr_documento_consistencia_pagar


AS

select 
  f.nm_fantasia_fornecedor as 'Fornecedor',
  d.cd_identificacao_document as 'Documento',
  d.dt_emissao_documento_paga as 'Emissao',
  d.dt_vencimento_documento as 'Vencimento',
  d.vl_documento_pagar as 'Valor',
  cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'Saldo'

from
  Documento_Pagar d

left outer join
  Fornecedor f
on
  d.cd_fornecedor = f.cd_fornecedor
group by
  f.nm_fantasia_fornecedor,
  d.cd_identificacao_document,
  d.dt_emissao_documento_paga,
  d.dt_vencimento_documento,
  d.vl_documento_pagar,
  d.vl_saldo_documento_pagar

having 
  count(d.cd_identificacao_document+d.nm_fantasia_fornecedor) > 1

order by Fornecedor


