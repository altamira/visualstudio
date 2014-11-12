  
CREATE PROCEDURE pr_documento_receber_pago_cliente
@ic_parametro          int,
@dt_inicial            datetime,
@dt_final              datetime,
@cd_cliente            int = 0,
@cd_cliente_grupo      int = 0,
@cd_plano_financeiro   int = 0,
@cd_centro_custo       int = 0

AS

  declare @ic_rateio int

  set @ic_rateio = isnull(dbo.fn_ver_uso_custom('RATEIO'),0)


   select
      dr.cd_identificacao		   as 'Documento',
      td.sg_tipo_documento                 as 'Tipo',
      dr.dt_emissao_documento              as 'Emissao',
      dr.dt_vencimento_documento	   as 'Vencimento',

      dr.vl_documento_receber              as 'Valor_Documento',

      case when dr.dt_devolucao_documento is not null then
         dr.dt_devolucao_documento
      else
        drp.dt_pagamento_documento end     as 'Pagamento',

      case when dr.dt_devolucao_documento is not null then
          dr.vl_documento_receber
      else
  	 drp.vl_pagamento_documento  end    as 'Valor',

--      cast( 
--
--       case when dr.dt_devolucao_documento is not null then
--          dr.dt_devolucao_documento
--       else
--         drp.dt_pagamento_documento end
-- 
--       - 
-- 
--       dr.dt_vencimento_documento as int )  as 'Prazo',
      
      cast(dr.dt_vencimento_documento - 
           dr.dt_emissao_documento as int ) 
                                           as 'Prazo',
      
      por.sg_portador		   	   as 'Portador',
      por.nm_portador		   	   as 'NomePortador',
      ven.nm_fantasia_vendedor             as 'Vendedor',
      cob.sg_tipo_cobranca	   	   as 'Cobranca',
      dr.ic_emissao_documento	           as 'Emitido',
      cg.nm_cliente_grupo                  as 'ClienteGrupo',
      cl.nm_fantasia_cliente               as 'Cliente',
      drp.nm_obs_documento                 as 'ObservacaoPagamento',
      cl.cd_cnpj_cliente,
      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      pf.nm_conta_plano_financeiro,
      isnull(drc.vl_imposto_documento,0)    as vl_imposto_documento,
      isnull(drc.vl_multa_documento,0)      as vl_multa_documento,
      isnull(drc.vl_pagamento_documento,0)  as vl_pg_antecipado_documento,
      isnull(drc.vl_outros_documento,0)     as vl_outros_documento,
      cast(drc.ds_complemento_documento     as varchar(100))                 as 'ObservacaoComplemento',
      isnull(drp.vl_juros_pagamento,0)      as vl_juros_pagamento,
      isnull(drp.vl_desconto_documento,0)   as vl_desconto_documento,
      isnull(drp.vl_abatimento_documento,0) as vl_abatimento_documento,
      isnull(drp.vl_despesa_bancaria,0)     as vl_despesa_bancaria,
      isnull(drp.vl_reembolso_documento,0)  as vl_reembolso_documento,
      isnull(drp.vl_credito_pendente,0)     as vl_credito_pendente,

      ( isnull(drp.vl_pagamento_documento, 0)
        - isnull(drp.vl_juros_pagamento, 0)
        + isnull(drp.vl_desconto_documento, 0)
        + isnull(drp.vl_abatimento_documento, 0)
        + isnull(drp.vl_despesa_bancaria, 0)
        - isnull(drp.vl_reembolso_documento, 0)
        - isnull(drp.vl_credito_pendente, 0) )  as vl_pagamento_liquido,

    tl.nm_tipo_liquidacao,
    tc.nm_tipo_caixa,
    vwc.conta    

      
      

--select * from documento_receber_complemento
--select * from documento_receber
--select * from documento_receber_pagamento

   from
      Documento_Receber dr                               with (nolock) 
      left outer join Documento_Receber_Pagamento drp    with (nolock) on  drp.cd_documento_receber = dr.cd_documento_receber
      left outer join Portador por                       with (nolock) on  por.cd_portador          = dr.cd_portador         
      left outer join Tipo_Documento td                  with (nolock) on  td.cd_tipo_documento     = dr.cd_tipo_documento 
      left outer join Tipo_Cobranca cob                  with (nolock) on  dr.cd_tipo_cobranca      = cob.cd_tipo_cobranca 
      left outer join Vendedor ven                       with (nolock) on  dr.cd_vendedor           = ven.cd_vendedor         
      left outer join Cliente  cl                        with (nolock) on  dr.cd_cliente            = cl.cd_cliente          
      left outer join Cliente_Grupo cg                   with (nolock) on  cl.cd_cliente_grupo      = cg.cd_cliente_grupo   
      left outer join Documento_receber_centro_custo dcc with (nolock) on case when @ic_rateio = 0 then 0 else dcc.cd_documento_receber end = dr.cd_documento_receber 
      left outer join Documento_receber_plano_financ dpf with (nolock) on case when @ic_rateio = 0 then 0 else dpf.cd_documento_receber end = dr.cd_documento_receber 
      left outer join centro_custo cc                    with (nolock) on cc.cd_centro_custo     = IsNull(dcc.cd_centro_custo,dr.cd_centro_custo) 
      left outer join Plano_Financeiro pf                with (nolock) on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro )
      left outer join Documento_Receber_Complemento drc  with (nolock) on drc.cd_documento_receber = dr.cd_documento_receber
      left outer join Tipo_Liquidacao tl             with (nolock) on tl.cd_tipo_liquidacao = drp.cd_tipo_liquidacao
      left outer join Tipo_Caixa      tc             with (nolock) on tc.cd_tipo_caixa      = drp.cd_tipo_caixa
      left outer join vw_conta_corrente vwc          with (nolock) on vwc.cd_conta_banco    = drp.cd_conta_banco

   where     
--      ((@cd_cliente       = 0) or (dr.cd_cliente       = @cd_cliente       )) and
--      ((@cd_cliente_grupo = 0) or (cl.cd_cliente_grupo = @cd_cliente_grupo )) and

    dr.cd_cliente                 = case when @cd_cliente = 0 then dr.cd_cliente else @cd_cliente end and
    isnull(cl.cd_cliente_grupo,0) = case when @cd_cliente_grupo = 0 then cl.cd_cliente_grupo else @cd_cliente_grupo end and

    drp.dt_pagamento_documento  between @dt_inicial and @dt_final     and	  
    ( IsNull(dr.dt_cancelamento_documento,@dt_final + 1) > @dt_final ) and
    ( IsNull(dr.dt_devolucao_documento,@dt_final + 1) > @dt_final )    and

     IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
								IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
     IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
	  					  IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) else
							  @cd_centro_custo end ) 

    --Lote ( Verifica se os documentos foram gerados por Lote, mostrar somente o Lote )
    and isnull(dr.cd_lote_receber,0)=0
 
   order by
      cl.cd_cliente_grupo,
      cl.nm_fantasia_cliente,
      drp.dt_pagamento_documento,
      dr.cd_identificacao

--end

