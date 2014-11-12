
CREATE PROCEDURE pr_consulta_documento_retorno_remessa_banco

  @dt_inicial datetime,
  @dt_final   datetime

as
  select
    c.nm_fantasia_cliente,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_documento_receber,
    d.cd_portador,
    p.nm_portador

  from
    Documento_Receber d, 
    Cliente c, 
    Portador p

  where
   dt_retorno_banco_doc between @dt_inicial and @dt_final and
   d.cd_cliente = c.cd_cliente and
   d.cd_portador = p.cd_portador  
