
CREATE PROCEDURE pr_cotacao_compra_aberto
@cd_cotacao int = 0,
@cd_rc int = 0,
@nm_fantasia_fornecedor varchar(40),
@dt_Inicial datetime,
@dt_final datetime
as

  if ((@cd_cotacao <> 0) and (@cd_rc <> 0))
    -- INFORMADO A COTAÇÃO E A RC
    select distinct
      c.cd_cotacao,
      c.dt_cotacao, 
      f.nm_fantasia_fornecedor,
      (select top 1 fc.nm_contato_fornecedor from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'nm_contato_fornecedor', 
      (select top 1 IsNull('(' + cd_ddd_contato_fornecedor + ') ', '') + fc.cd_telefone_contato_forne from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'cd_telefone_contato', 
      isnull((select top 1 fc.cd_email_contato_forneced from Fornecedor_Contato fc
              where fc.cd_fornecedor=f.cd_fornecedor), max(f.nm_email_fornecedor)) as 'cd_mail_contato_forneced', 
      min(rc.dt_necessidade_req_compra) as dt_necessidade_req_compra,
      case when exists (select top 1 isnull(x.ic_retorno_item_cotacao,'N') 
                        from Cotacao_Item x where x.ic_retorno_item_cotacao = 'S' and
		                    c.cd_cotacao = x.cd_cotacao ) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno_item_cotacao',
      case when max(rc.dt_necessidade_req_compra) + 1 < getdate() 
      then 'S' 
      else 'N' 
      end as 'ic_atraso',
      case when (c.dt_retorno_fornecedor<>'') and (not c.dt_retorno_fornecedor is null) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno',
      (select max(r.cd_requisicao_compra) from Requisicao_Compra r
       where ci.cd_requisicao_compra = r.cd_requisicao_compra) as 'cd_requisicao_compra',
      f.cd_fornecedor
    from
      Cotacao c left outer join 
      Cotacao_item ci on c.cd_cotacao = ci.cd_cotacao left outer join 
      Fornecedor f on c.cd_fornecedor  = f.cd_fornecedor left outer join 
      Requisicao_Compra rc on ci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
      Requisicao_Compra_Item rci on rci.cd_requisicao_compra = ci.cd_requisicao_compra and
                                    rci.cd_item_requisicao_compra = ci.cd_item_requisicao_compra  
    where
      (c.cd_cotacao = @cd_cotacao) and (rc.cd_requisicao_compra = @cd_rc)
    group by
      c.cd_cotacao, c.dt_cotacao, f.nm_fantasia_fornecedor, f.cd_fornecedor,
      ci.ic_retorno_item_cotacao, dt_retorno_fornecedor, ci.cd_requisicao_compra
    order by
      c.cd_cotacao desc, c.dt_cotacao desc

  else if ((@cd_cotacao <> 0) and (@cd_rc = 0))

    -- INFORMADO SOMENTE A COTAÇÃO
    select distinct
      c.cd_cotacao,
      c.dt_cotacao, 
      f.nm_fantasia_fornecedor,
      (select top 1 fc.nm_contato_fornecedor from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'nm_contato_fornecedor', 
      (select top 1 IsNull('(' + cd_ddd_contato_fornecedor + ') ', '') + fc.cd_telefone_contato_forne from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'cd_telefone_contato', 
      isnull((select top 1 fc.cd_email_contato_forneced from Fornecedor_Contato fc
              where fc.cd_fornecedor=f.cd_fornecedor), max(f.nm_email_fornecedor)) as 'cd_mail_contato_forneced', 
      min(rc.dt_necessidade_req_compra) as dt_necessidade_req_compra,
      case when exists (select top 1 isnull(x.ic_retorno_item_cotacao,'N') 
                        from Cotacao_Item x where x.ic_retorno_item_cotacao = 'S' and
		                    c.cd_cotacao = x.cd_cotacao ) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno_item_cotacao',
      case when max(rc.dt_necessidade_req_compra) + 1 < getdate() 
      then 'S' 
      else 'N' 
      end as 'ic_atraso',
      case when (c.dt_retorno_fornecedor<>'') and (not c.dt_retorno_fornecedor is null) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno',
      (select max(r.cd_requisicao_compra) from Requisicao_Compra r
       where ci.cd_requisicao_compra = r.cd_requisicao_compra) as 'cd_requisicao_compra',
      f.cd_fornecedor
    from
      Cotacao c left outer join 
      Cotacao_item ci on c.cd_cotacao = ci.cd_cotacao left outer join 
      Fornecedor f on c.cd_fornecedor  = f.cd_fornecedor left outer join 
      Requisicao_Compra rc on ci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
      Requisicao_Compra_Item rci on rci.cd_requisicao_compra = ci.cd_requisicao_compra and
                                    rci.cd_item_requisicao_compra = ci.cd_item_requisicao_compra  
    where
      c.cd_cotacao = @cd_cotacao
    group by
      c.cd_cotacao, c.dt_cotacao, f.nm_fantasia_fornecedor, f.cd_fornecedor,
      ci.ic_retorno_item_cotacao, dt_retorno_fornecedor, ci.cd_requisicao_compra
    order by
      c.cd_cotacao desc, c.dt_cotacao desc

  else if ((@cd_cotacao = 0) and (@cd_rc <> 0))

    -- INFORMADO SOMENTE A REQUISICAO
    select distinct
      c.cd_cotacao,
      c.dt_cotacao, 
      f.nm_fantasia_fornecedor,
      (select top 1 fc.nm_contato_fornecedor from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'nm_contato_fornecedor', 
      (select top 1 IsNull('(' + cd_ddd_contato_fornecedor + ') ', '') + fc.cd_telefone_contato_forne from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'cd_telefone_contato', 
      isnull((select top 1 fc.cd_email_contato_forneced from Fornecedor_Contato fc
              where fc.cd_fornecedor=f.cd_fornecedor), max(f.nm_email_fornecedor)) as 'cd_mail_contato_forneced', 
      min(rc.dt_necessidade_req_compra) as dt_necessidade_req_compra,
      case when exists (select top 1 isnull(x.ic_retorno_item_cotacao,'N') 
                        from Cotacao_Item x where x.ic_retorno_item_cotacao = 'S' and
		                    c.cd_cotacao = x.cd_cotacao ) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno_item_cotacao',
      case when max(rc.dt_necessidade_req_compra) + 1 < getdate() 
      then 'S' 
      else 'N' 
      end as 'ic_atraso',
      case when (c.dt_retorno_fornecedor<>'') and (not c.dt_retorno_fornecedor is null) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno',
      (select max(r.cd_requisicao_compra) from Requisicao_Compra r
       where ci.cd_requisicao_compra = r.cd_requisicao_compra) as 'cd_requisicao_compra',
      f.cd_fornecedor
    from
      Cotacao c left outer join 
      Cotacao_item ci on c.cd_cotacao = ci.cd_cotacao left outer join 
      Fornecedor f on c.cd_fornecedor  = f.cd_fornecedor left outer join 
      Requisicao_Compra rc on ci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
      Requisicao_Compra_Item rci on rci.cd_requisicao_compra = ci.cd_requisicao_compra and
                                    rci.cd_item_requisicao_compra = ci.cd_item_requisicao_compra  
    where
      rc.cd_requisicao_compra = @cd_rc
    group by
      c.cd_cotacao, c.dt_cotacao, f.nm_fantasia_fornecedor, f.cd_fornecedor,
      ci.ic_retorno_item_cotacao, dt_retorno_fornecedor, ci.cd_requisicao_compra
    order by
      c.cd_cotacao desc, c.dt_cotacao desc

  else if ((@cd_cotacao = 0) and (@cd_rc = 0))

    -- INFORMADO SOMENTE A DATA 
    -- SEM RC E SEM CT
    select distinct
      c.cd_cotacao,
      c.dt_cotacao, 
      f.nm_fantasia_fornecedor,
      (select top 1 fc.nm_contato_fornecedor from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'nm_contato_fornecedor', 
      (select top 1 IsNull('(' + cd_ddd_contato_fornecedor + ') ', '') + fc.cd_telefone_contato_forne from Fornecedor_Contato fc
       where fc.cd_fornecedor=f.cd_fornecedor) as 'cd_telefone_contato', 
      isnull((select top 1 fc.cd_email_contato_forneced from Fornecedor_Contato fc
              where fc.cd_fornecedor=f.cd_fornecedor), max(f.nm_email_fornecedor)) as 'cd_mail_contato_forneced', 
      min(rc.dt_necessidade_req_compra) as dt_necessidade_req_compra,
      case when exists (select top 1 isnull(x.ic_retorno_item_cotacao,'N') 
                        from Cotacao_Item x where x.ic_retorno_item_cotacao = 'S' and
		                    c.cd_cotacao = x.cd_cotacao ) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno_item_cotacao',
      case when max(rc.dt_necessidade_req_compra) + 1 < getdate() 
      then 'S' 
      else 'N' 
      end as 'ic_atraso',
      case when (c.dt_retorno_fornecedor<>'') and (not c.dt_retorno_fornecedor is null) 
      then 'S' 
      else 'N' 
      end as 'ic_retorno',
      (select max(r.cd_requisicao_compra) from Requisicao_Compra r
       where ci.cd_requisicao_compra = r.cd_requisicao_compra) as 'cd_requisicao_compra',
      f.cd_fornecedor
    from
      Cotacao c left outer join 
      Cotacao_item ci on c.cd_cotacao = ci.cd_cotacao left outer join 
      Fornecedor f on c.cd_fornecedor  = f.cd_fornecedor left outer join 
      Requisicao_Compra rc on ci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
      Requisicao_Compra_Item rci on rci.cd_requisicao_compra = ci.cd_requisicao_compra and
                                    rci.cd_item_requisicao_compra = ci.cd_item_requisicao_compra  
    where
      c.dt_cotacao between @dt_inicial and @dt_final and 
      c.dt_fechamento_cotacao is null and
      isnull(ci.ic_pedido_compra_cotacao ,'N') = 'N' and
      isnull(rci.ic_pedido_item_req_compra,'N') = 'N' and
      f.nm_fantasia_fornecedor like @nm_fantasia_fornecedor + '%'
    group by
      c.cd_cotacao, c.dt_cotacao, f.nm_fantasia_fornecedor, f.cd_fornecedor,
      ci.ic_retorno_item_cotacao, dt_retorno_fornecedor, ci.cd_requisicao_compra
    order by
      c.cd_cotacao desc, c.dt_cotacao desc

