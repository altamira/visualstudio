
create procedure pr_rel_gera_recibo
@dt_inicial     datetime,
@dt_final       datetime

as

 
  Select
   r.*,
   obr.ds_observacao_recibo,
   d.nm_fantasia,
   d.nm_razao_social,
   d.nm_endereco,
   d.cd_numero_endereco,
   d.nm_bairro,
   d.cd_cnpj,
   d.cd_cep,
   d.cd_inscestadual,
   e.sg_estado,
   e.nm_estado,
   c.nm_cidade,
   memi.nm_mes as 'nm_mes_emissao',
   dr.cd_identificacao
   
--select * from documento_receber

  from
    recibo r left outer join
    Observacao_recibo obr on (r.cd_observacao_recibo = obr.cd_observacao_recibo)left outer join
    vw_Destinatario d on (r.cd_destinatario = d.cd_destinatario)and
                         (r.cd_tipo_destinatario = d.cd_tipo_destinatario) left outer join
    Estado e on (d.cd_estado = e.cd_estado)left outer join
    Cidade c on (d.cd_cidade = c.cd_cidade)left outer join
    Mes memi on memi.cd_mes = month( r.dt_recibo )
    left outer join Documento_Receber dr on dr.cd_documento_receber = r.cd_documento_receber

where 
(r.dt_recibo between @dt_inicial and @dt_final) and 
 isnull(r.ic_impresso_recibo,'N') = 'N'

