
CREATE PROCEDURE pr_documento_receber_pago_grupo_cliente
@cd_cliente_grupo int      = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = ''

AS

-- if @cd_cliente_grupo = 0
-- begin

--select * from documento_receber

    select
      cl.cd_cliente_grupo,
      dr.cd_identificacao		   as 'Documento',
      cl.cd_cnpj_cliente                   as 'CNPJ',
      td.sg_tipo_documento      	   as 'Tipo',
      dr.dt_emissao_documento   	   as 'Emissao',
      dr.dt_vencimento_documento	   as 'Vencimento',
      dr.vl_documento_receber              as 'Valor_Documento',
      drp.dt_pagamento_documento 	   as 'Pagamento',
      drp.vl_pagamento_documento     	   as 'Valor',
      por.sg_portador		   	   as 'Portador',
      ven.nm_fantasia_vendedor     	   as 'Vendedor',
      cob.sg_tipo_cobranca	   	   as 'Cobranca',
      dr.ic_emissao_documento	   	   as 'Emitido',
      cg.nm_cliente_grupo                  as 'ClienteGrupo',
      cl.nm_fantasia_cliente               as 'Cliente',
      cl.cd_cnpj_cliente,
--      cl.cd_cnpj_cliente                   as 'CNPJ',

      drp.nm_obs_documento                 as 'ObservacaoPagamento',
      cc.nm_centro_custo,
      pf.nm_conta_plano_financeiro,

--select * from documento_receber_complemento
      --Complemento do documento

        isnull(drc.vl_imposto_documento,0)   as 'Imposto',
        isnull(drc.vl_multa_documento,0)     as 'Multa',
        isnull(drc.vl_pagamento_documento,0) as 'Antecipacao',
        isnull(drc.vl_outros_documento,0)    as 'Outros',
        cast(drc.ds_complemento_documento as varchar(100))                as 'ObservacaoComplemento',

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

    por.nm_portador,
    tl.nm_tipo_liquidacao,
    tc.nm_tipo_caixa,
    vwc.conta    

      
      

      
--select * from documento_receber_pagamento       

    into
      #TabAux

    from
      Documento_Receber dr               with (nolock) 
      left outer join Documento_Receber_Pagamento drp 
                                         with (nolock) on  drp.cd_documento_receber = dr.cd_documento_receber
      left outer join Documento_Receber_Complemento drc
                                          with (nolock) on drc.cd_documento_receber  = dr.cd_documento_receber
      left outer join Portador por        with (nolock) on  por.cd_portador          = dr.cd_portador            
      left outer join Tipo_Documento td   with (nolock) on  td.cd_tipo_documento     = dr.cd_tipo_documento
      left outer join Tipo_Cobranca cob   with (nolock) on  dr.cd_tipo_cobranca      = cob.cd_tipo_cobranca
      left outer join Vendedor ven        with (nolock) on  dr.cd_vendedor           = ven.cd_vendedor     
      left outer join Cliente  cl         with (nolock) on  dr.cd_cliente            = cl.cd_cliente       
      left outer join Cliente_Grupo cg    with (nolock) on  cl.cd_cliente_grupo      = cg.cd_cliente_grupo    
      left outer join Plano_Financeiro pf with (nolock) on  pf.cd_plano_financeiro   = dr.cd_plano_financeiro 
      left outer join centro_custo cc                   on cc.cd_centro_custo        = dr.cd_centro_custo
        
      left outer join Tipo_Liquidacao tl             with (nolock) on tl.cd_tipo_liquidacao = drp.cd_tipo_liquidacao
      left outer join Tipo_Caixa      tc             with (nolock) on tc.cd_tipo_caixa      = drp.cd_tipo_caixa
      left outer join vw_conta_corrente vwc          with (nolock) on vwc.cd_conta_banco    = drp.cd_conta_banco

    WHERE     
       cl.cd_cliente_grupo     = case when @cd_cliente_grupo = 0 then cl.cd_cliente_grupo else @cd_cliente_grupo end and
       drp.dt_pagamento_documento  between @dt_inicial and @dt_final     and	  
       dr.dt_cancelamento_documento is null and
--     ((drp.dt_pagamento_documento between @dt_inicial and @dt_final) or 
--      ((dr.dt_devolucao_documento between @dt_inicial and @dt_final) and (drp.dt_pagamento_documento is null))) 
    ( IsNull(dr.dt_cancelamento_documento,@dt_final + 1) > @dt_final ) and
    ( IsNull(dr.dt_devolucao_documento,@dt_final    + 1) > @dt_final )    


    ORDER BY
      cl.cd_cliente, -- Não retirar
      drp.dt_pagamento_documento,
      dr.cd_identificacao

select 
  *,
  (select count(*) from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as CountGrupo,
  (select sum(isnull(Valor,0.00))       from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as Sumvl_pagamento_documento,
  (select sum(isnull(Imposto,0.00))     from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as SumImposto,
  (select sum(isnull(Multa,0.00))       from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as SumMulta,
  (select sum(isnull(Antecipacao,0.00)) from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as SumAntecipacao,
  (select sum(isnull(Outros,0.00))      from #TabAux where cd_cliente_grupo = ta.cd_cliente_grupo) as SumOutros

from
  #TabAux ta  
-- end else begin
--     select
--       dr.cd_identificacao		as 'Documento',
--       td.sg_tipo_documento      	as 'Tipo',
--       dr.dt_emissao_documento   	as 'Emissao',
--       dr.dt_vencimento_documento	as 'Vencimento',
--       drp.dt_pagamento_documento 	as 'Pagamento',
--       drp.vl_pagamento_documento     	as 'Valor',
--       por.sg_portador		   	as 'Portador',
--       ven.nm_fantasia_vendedor     	as 'Vendedor',
--       cob.sg_tipo_cobranca	   	as 'Cobranca',
--       dr.ic_emissao_documento	   	as 'Emitido',
--       cg.nm_cliente_grupo               as 'ClienteGrupo',
--       cl.nm_fantasia_cliente            as 'Cliente'
--     from
--       Documento_Receber dr with (nolock) 
--       left outer join Documento_Receber_Pagamento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
--       left outer join Portador por       with (nolock) on  por.cd_portador = dr.cd_portador            
--       left outer join Tipo_Documento td  with (nolock) on  td.cd_tipo_documento = dr.cd_tipo_documento
--       left outer join Tipo_Cobranca cob  with (nolock) on  dr.cd_tipo_cobranca = cob.cd_tipo_cobranca
--       left outer join Vendedor ven       with (nolock) on  dr.cd_vendedor = ven.cd_vendedor     
--       left outer join Cliente  cl        with (nolock) on  dr.cd_cliente  = cl.cd_cliente       
--       left outer join Cliente_Grupo cg   with (nolock) on  cl.cd_cliente_grupo = cg.cd_cliente_grupo    
--     WHERE     
--      cl.cd_cliente_grupo     = case when @cd_cliente_grupo = 0 then cl.cd_cliente_grupo else @cd_cliente_grupo end and
--      drp.dt_pagamento_documento  between @dt_inicial and @dt_final     and	  
--     ( IsNull(dr.dt_cancelamento_documento,@dt_final + 1) > @dt_final ) and
--     ( IsNull(dr.dt_devolucao_documento,@dt_final + 1) > @dt_final )    
-- 
--     ORDER BY
--       drp.dt_pagamento_documento,
--       dr.cd_identificacao
-- end
-- 
