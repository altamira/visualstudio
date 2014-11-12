
CREATE PROCEDURE pr_emissao_boleto
@ic_parametro         int,
@dt_inicial           datetime,
@dt_final             datetime,
@cd_documento_receber int = 0

as

--select * from documento_receber

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista boletos NÃO impressas
-------------------------------------------------------------------------------
  begin
   
    --select * from vw_destinatario

    select
      n.ic_boleto_parc_nota_saida,
--      isnull(d.cd_nota_saida,0)              as cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
        ns.cd_identificacao_nota_saida
      else
        d.cd_nota_saida
      end                                    as cd_nota_saida,

      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      isnull(d.vl_documento_receber,0)       as vl_documento_receber,
      --c.nm_fantasia_cliente,
      vw.nm_fantasia                         as nm_fantasia_cliente,
      d.ds_documento_receber,
      d.cd_identificacao                     as 'cd_ident_parc_nota_saida',
      d.ic_emissao_documento,
      d.cd_documento_receber,
      d.cd_banco_documento_recebe,
      d.cd_digito_bancario,
      po.nm_portador,
      cp.nm_condicao_pagamento,
      fcp.nm_forma_condicao

    from
      Documento_Receber d                          with (nolock) 
      left outer join Nota_Saida_Parcela n         with (nolock) on d.cd_nota_saida    = n.cd_nota_saida and
                                                                    d.cd_identificacao = n.cd_ident_parc_nota_saida
      left outer join Cliente c                    with (nolock) on d.cd_cliente       = c.cd_cliente
      left outer join Portador po                  with (nolock) on d.cd_portador      = po.cd_portador
      left outer join Nota_Saida ns                with (nolock) on ns.cd_nota_saida         = d.cd_nota_saida
      left outer join Condicao_Pagamento cp        with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
      left outer join Forma_Condicao_Pagamento fcp with (nolock) on fcp.cd_forma_condicao    = cp.cd_forma_condicao
      left outer join vw_destinatario vw            with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                                    vw.cd_tipo_destinatario = d.cd_tipo_destinatario
    where
      d.cd_documento_receber = case when @cd_documento_receber = 0 then d.cd_documento_receber else @cd_documento_receber end and
      d.dt_emissao_documento between @dt_inicial and @dt_final and
      IsNull(n.ic_boleto_parc_nota_saida,'N') = 'N' and
      IsNull(d.ic_emissao_documento,'N')      = 'N' and
      dt_cancelamento_documento is null and
      dt_devolucao_documento    is null
    order by
      d.dt_emissao_documento

  end -- If @ic_parametro = 1

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- lista boletos impressas ( REEMISSÃO )
-------------------------------------------------------------------------------
  begin
   
    select
      'N'                                    as 'Selecionado', 
      n.ic_boleto_parc_nota_saida,
      isnull(d.cd_nota_saida,0)              as cd_nota_saida,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      isnull(d.vl_documento_receber,0)       as vl_documento_receber,
      --c.nm_fantasia_cliente,
      --c.nm_fantasia_cliente,
      vw.nm_fantasia                         as nm_fantasia_cliente,
      d.ds_documento_receber,
      d.cd_identificacao                     as 'cd_ident_parc_nota_saida',
      d.ic_emissao_documento,
      d.cd_documento_receber,
      d.cd_banco_documento_recebe,
      d.cd_digito_bancario,
      po.nm_portador,
      cp.nm_condicao_pagamento,
      fcp.nm_forma_condicao


    from
      Documento_Receber d                          with (nolock) 
      left outer join Nota_Saida_Parcela n         with (nolock) on d.cd_nota_saida    = n.cd_nota_saida and
                                                                    d.cd_identificacao = n.cd_ident_parc_nota_saida
      left outer join Cliente c                    with (nolock) on d.cd_cliente       = c.cd_cliente
      left outer join Portador po                  with (nolock) on d.cd_portador      = po.cd_portador
      left outer join Nota_Saida ns                with (nolock) on ns.cd_nota_saida         = d.cd_nota_saida
      left outer join Condicao_Pagamento cp        with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
      left outer join Forma_Condicao_Pagamento fcp with (nolock) on fcp.cd_forma_condicao    = cp.cd_forma_condicao
      left outer join vw_destinatario vw            with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                                    vw.cd_tipo_destinatario = d.cd_tipo_destinatario

    where
      d.cd_documento_receber = case when @cd_documento_receber = 0 then d.cd_documento_receber else @cd_documento_receber end and
      d.dt_emissao_documento between @dt_inicial and @dt_final and
      ((IsNull(n.ic_boleto_parc_nota_saida,'N') = 'S') or (IsNull(d.ic_emissao_documento,'N') = 'S')) and
      dt_cancelamento_documento is null and
      dt_devolucao_documento    is null
    order by
      d.dt_emissao_documento

  end

else  
  return
    
