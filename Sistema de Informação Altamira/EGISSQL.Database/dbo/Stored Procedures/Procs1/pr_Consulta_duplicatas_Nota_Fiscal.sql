
CREATE PROCEDURE pr_Consulta_duplicatas_Nota_Fiscal

-- Parametros
@cd_nota_saida int
AS
    Select  

--      ns.cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
      end                                   as cd_nota_saida,

      ns.dt_nota_saida,

      v.nm_fantasia_vendedor,
      '( ' + IsNull(ns.cd_ddd_nota_saida, '') + ' ) ' + IsNull(ns.cd_telefone_nota_saida, '') as 'DDDTel',
      dr.cd_documento_receber as Numero,
      dr.cd_identificacao     as Duplicata,
--      dr.cd_tipo_documento as tipo, 
      dr.dt_emissao_documento as Emissao,
      dr.dt_vencimento_documento as Vencimento,
      dr.vl_documento_receber as Valor,
      dr.dt_cancelamento_documento as Cancelamento,
      dr.dt_devolucao_documento as Devolucao,
      drp.dt_pagamento_documento as Pagamento,
--      dr.cd_portador as Portador,
--      dr.cd_tipo_cobranca as Cobranca,
--      dr.cd_bordero as Bordero
      ns.nm_fantasia_nota_saida,
      ns.nm_razao_social_nota as Cliente,
      p.nm_portador,
      tc.nm_tipo_cobranca,
      ns.nm_operacao_fiscal,
      dr.ds_documento_receber,
      ns.cd_mascara_operacao + ' - ' + ns.nm_operacao_fiscal as 'CFOP',
      ns.vl_total,
      dr.vl_saldo_documento,
      dr.vl_pagto_document_receber,
      td.nm_tipo_destinatario,
      sn.nm_status_nota


   from  
         Nota_Saida ns        with (nolock)    left outer join
         Documento_Receber dr on dr.cd_nota_saida = ns.cd_nota_saida   Left Join 
	 portador p           On p.cd_portador = dr.cd_portador Left Join 
         Tipo_Cobranca tc     On tc.cd_tipo_cobranca = dr.cd_tipo_cobranca Left Join 
         Documento_receber_pagamento drp On drp.cd_documento_receber = dr.cd_documento_receber left outer join
   	 Vendedor v           on v.cd_vendedor = ns.cd_vendedor left outer join
 	 Tipo_Destinatario td on td.cd_tipo_destinatario = ns.cd_tipo_destinatario left outer join
         Status_Nota sn       on sn.cd_status_nota = ns.cd_status_nota

    where 
        ns.cd_nota_saida = @cd_nota_saida

    order by dr.cd_documento_receber

