
CREATE VIEW vw_documento_receber
AS 
  select
    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_vencimento_original,
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
    d.vl_documento_receber,
    c.nm_fantasia_cliente
  from
    Documento_Receber d left outer join Cliente c
  on
    d.cd_cliente = c.cd_cliente
