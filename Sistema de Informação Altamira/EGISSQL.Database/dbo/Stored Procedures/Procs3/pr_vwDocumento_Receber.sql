

/****** Object:  Stored Procedure dbo.pr_vwDocumento_Receber    Script Date: 13/12/2002 15:08:45 ******/

CREATE PROCEDURE pr_vwDocumento_Receber
  @cd_identificacao as varchar(25)
AS

  select
    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_vencimento_original,
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
    d.vl_documento_receber,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    c.cd_ddd,
    c.cd_telefone
  from
    Documento_Receber d left outer join Cliente c on
      d.cd_cliente = c.cd_cliente
  where
    cd_identificacao = @cd_identificacao



