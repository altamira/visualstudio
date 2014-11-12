
CREATE PROCEDURE pr_consulta_doc_desconto
@dt_inicial datetime,
@dt_final   datetime,
@cd_banco   int = 0
AS

  select     
    dr.cd_identificacao, 
    td.nm_tipo_destinatario,
    vd.nm_fantasia,
    dr.dt_emissao_documento,
    dr.dt_vencimento_documento,
    dr.vl_documento_receber, 
    dr.vl_saldo_documento, 
    drd.cd_item_desconto, 
    drd.dt_desconto_documento, 
    b.nm_banco, 
    drd.vl_desconto_documento, 
    drd.pc_desconto_documento
  from         
    documento_receber_desconto drd inner join
    banco b on drd.cd_banco = b.cd_banco left outer join
    documento_receber dr on drd.cd_documento_receber = dr.cd_documento_receber left outer join
    vw_destinatario vd on dr.cd_tipo_destinatario = vd.cd_tipo_destinatario and dr.cd_cliente = vd.cd_destinatario left outer join
    tipo_destinatario td on dr.cd_tipo_destinatario = td.cd_tipo_destinatario
  where     
    drd.cd_banco = case when @cd_banco=0 then drd.cd_banco else @cd_banco end AND
    cast(substring(cast(drd.dt_desconto_documento as varchar(20)),1,11) as datetime) between @dt_inicial and @dt_final
  order by
    drd.cd_banco,
    drd.vl_desconto_documento desc, dr.dt_vencimento_documento

