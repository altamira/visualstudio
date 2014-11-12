

CREATE PROCEDURE pr_consulta_programacao_receber 
--------------------------------------------------------------------
-- pr_consulta_programacao_receber 
-------------------------------------------------------------------- 
--GBS - Global Business Solution Ltda                           2004
--------------------------------------------------------------------
--Stored Procedure   : Microsoft SQL Server 2000 
--Autor(es)          : Daniel Duela
--Banco de Dados     : EGISSQL 
--Objetivo           : Consultar Programação de Recebimentos. 
--Data               : 27/06/2003
--Atualizado         : 13/08/2003 - Duela - Acerto no campo ic_credito_icms_documento
--                   : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     03/10/2006 - Otimização de código, acerto do campo de pgto
--                                - Daniel C. Neto.
--                     01/11/2006 - Incluído plano financeiro e centro de custo
--                                - conforme customização da Cydak.
--                                - Daniel C. Neto.
--                     10/11/2006 - Incluído dt_pagamento_documento - Daniel C. Neto.
--                     10/02/2006 - Verificação do Lote / Documentos Agrupados não entram
--                                  na Consulta - Carlos Fernandes
--                     02.10.2007 - Acerto nos Documentos Vencidos/Atraso - Carlos Fernandes
-- 09.09.2009 - Ajustes Diveros - Carlos Fernandes
---------------------------------------------------------------------------------------------

@ic_parametro          int,  
@dt_inicial            datetime, 
@dt_final              datetime, 
@cd_identificacao      varchar(20), 
@cd_empresa            int ,
@cd_plano_financeiro   int = 0,
@cd_centro_custo       int = 0

AS 

declare @ic_rateio int

  set @ic_rateio = dbo.fn_ver_uso_custom('RATEIO')

  SELECT distinct
    vw.nm_fantasia                          as nm_cliente,  
    dr.cd_identificacao,  
    isnull(dr.dt_emissao_documento,null)    as dt_emissao_documento,  
    isnull(dr.dt_vencimento_documento,null) as dt_vencimento_documento,  
    dr.vl_documento_receber,  
    dr.vl_saldo_documento,  
    drp.vl_pagamento_documento as vl_pagto_document_receber,  
    p.nm_portador,  
    v.nm_fantasia_vendedor,
    isnull(dr.dt_cancelamento_documento,null) as dt_cancelamento_documento,  
    isnull(dr.dt_devolucao_documento,null) as dt_devolucao_documento,  
    case when dr.dt_vencimento_documento < (GetDate() - 1) and IsNull(dr.vl_saldo_documento, 0) <> 0  
      then 'S' else 'N' end as ic_atraso,  
    case when IsNull(drp.dt_pagamento_documento,0) <> 0 and  
              IsNull(dr.vl_saldo_documento,0) = 0 then 'S' else 'N' end as ic_pagamento,  
    case when IsNull(drp.dt_pagamento_documento,0) > dr.dt_vencimento_documento and  
              IsNull(dr.vl_saldo_documento,0) = 0 then 'S' else 'N' end as ic_pag_atraso,  
    case when IsNull(dr.dt_cancelamento_documento,0)<>0 then 'S' else 
              'N' end as ic_cancelado,  
    case when IsNull(dr.dt_devolucao_documento,0)<>0 then 'S' else 
              'N' end as ic_devolvido,  
    case when IsNull(dr.dt_retorno_banco_doc,0)<>0 then 'S' else 
              'N' end as ic_retorno,  
    case when IsNull(td.nm_tipo_documento,0) like '%Dupl%' then 'S' else 
              'N' end as ic_duplicata,  
    case when IsNull(td.nm_tipo_documento,0) like '%Boleto%' then 'S' else 
              'N' end as ic_boleto,  
    case when IsNull(dr.cd_arquivo_magnetico,0) <>0 then 'S' else 
              'N' end as ic_remessa,  
    IsNull(dr.ic_credito_icms_documento,'N') as ic_credito_icms_documento, 
    case when dr.dt_vencimento_documento > dr.dt_vencimento_original then 'S' else 
              'N' end as ic_prorrogacao,
    dcc.pc_centro_custo,
    dcc.vl_centro_custo, 
    dpf.pc_plano_financeiro, 
    dpf.vl_plano_financeiro,
    cc.nm_centro_custo,
    pf.nm_conta_plano_financeiro,
    drp.dt_pagamento_documento

  FROM 
    Documento_Receber dr               with (nolock) 
    left outer join vw_Destinatario vw with (nolock) ON vw.cd_destinatario = dr.cd_cliente and 
                                                        vw.cd_tipo_destinatario = dr.cd_tipo_destinatario  left outer join 
    Documento_Receber_Pagamento drp    with (nolock) ON dr.cd_documento_receber = drp.cd_documento_receber left outer join 
    Tipo_Documento td                  with (nolock) on td.cd_tipo_documento=dr.cd_tipo_documento left outer join 
    Portador p                         with (nolock) on p.cd_portador=dr.cd_portador              left outer join 
    Vendedor v                         with (nolock) on v.cd_vendedor=dr.cd_vendedor              left outer join
    Documento_receber_centro_custo dcc with (nolock) on case when @ic_rateio = 0 then 0 else dcc.cd_documento_receber end = dr.cd_documento_receber left outer join
    Documento_receber_plano_financ dpf with (nolock) on case when @ic_rateio = 0 then 0 else dpf.cd_documento_receber end = dr.cd_documento_receber left outer join
    centro_custo cc                    with (nolock) on cc.cd_centro_custo     = IsNull(dcc.cd_centro_custo,isnull(dr.cd_centro_custo,0)) left outer join
    Plano_Financeiro pf                with (nolock) on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , isnull(dr.cd_plano_financeiro,0) )
  WHERE 
    ( case when @ic_parametro = 1 then dr.dt_emissao_documento 
	   when @ic_parametro = 2 then dr.dt_vencimento_documento 
           when @ic_parametro = 3 then drp.dt_pagamento_documento end ) BETWEEN  
    @dt_inicial   AND   @dt_final  AND 

    --Ver o que ocorre está travando

--     ( isNull(dr.cd_identificacao,'') = ( case when IsNull(@cd_identificacao,'') = '' then isNull(dr.cd_identificacao,'')
-- 					 else IsNull(@cd_identificacao,'') end )) and  

    IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
								IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and

   IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
	  					  IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) else
							  @cd_centro_custo end ) and

    dr.dt_cancelamento_documento is null  and

    --Carlos 10.2.2007 - Verificação de Documento Agrupado em Lote
   
    isnull(dr.cd_lote_receber,0)=0 

  ORDER BY dr.dt_vencimento_documento desc, dr.cd_identificacao  


