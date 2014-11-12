
create procedure pr_recibo_pagar

@ic_parametro   int,
@cd_recibo      int,
@dt_inicial     datetime,
@dt_final       datetime

as

   select
      e.nm_empresa,
      e.nm_endereco_empresa,
      e.cd_cgc_empresa,
      e.cd_iest_empresa,
      est.nm_estado as nm_estado_empresa,
      cid.nm_cidade as nm_cidade_empresa,
      e.cd_cep_empresa,
      e.nm_bairro_empresa,
      m.nm_mes
    into #Empresa
    from
      egisadmin.dbo.empresa e  left outer join
      Estado est  on  e.cd_estado = est.cd_estado and 
			      e.cd_pais = est.cd_pais left outer join
      Cidade cid  on  e.cd_cidade = cid.cd_cidade and 
			      cid.cd_estado = e.cd_estado and 
			      cid.cd_pais = e.cd_pais left outer join
      Mes m on m.cd_mes = month(GetDate()) 
   where 
     e.cd_empresa = dbo.fn_empresa()


  SELECT     
	     e.*,
	     r.cd_recibo, 
             r.dt_recibo, 
             r.cd_tipo_recibo,
             tr.nm_tipo_recibo, 
             r.ic_impresso_recibo, 
             r.vl_recibo,
	     IsNull(r.cd_destinatario,0) as 'cd_destinatario',
             IsNull(r.cd_tipo_destinatario,0) as 'cd_tipo_destinatario',
             r.ds_recibo,
             r.ic_tipo_recibo,
             r.cd_departamento,
             r.cd_observacao_recibo,
	     d.nm_fantasia,
	     d.nm_razao_social,
             est.nm_estado,
             est.sg_estado,
             cid.nm_cidade,
             d.nm_bairro,
             d.cd_numero_endereco,
             d.nm_endereco,
             d.cd_cnpj,
             d.cd_inscestadual,
             d.cd_cep,
             obr.ds_observacao_recibo,
	     cast('A' as varchar(250)) as 'ValorExtenso',
             memi.nm_mes as 'nm_mes_emissao'
  FROM 
      Recibo r left outer join
      Tipo_Recibo tr ON r.cd_tipo_recibo = tr.cd_tipo_recibo left outer join
      vw_Destinatario d on d.cd_tipo_destinatario = r.cd_tipo_destinatario and
		           d.cd_destinatario = r.cd_destinatario left outer join
      Observacao_Recibo obr on obr.cd_observacao_recibo = r.cd_observacao_recibo left outer join
      Estado est on est.cd_estado = d.cd_estado and
                    est.cd_pais = d.cd_pais left outer join
      Cidade cid on cid.cd_cidade = d.cd_cidade and
                    cid.cd_estado = d.cd_estado and
                    cid.cd_pais   = d.cd_pais cross join
      #Empresa e

      left outer join
      Mes memi on memi.cd_mes = month( r.dt_recibo )

  where
    ( ( r.cd_recibo = @cd_recibo ) or
      (( r.dt_recibo between @dt_inicial and @dt_final) and (@cd_recibo = 0)) and
      @ic_parametro = 1) or
    ( r.cd_recibo = @cd_recibo and @ic_parametro = 2 )


