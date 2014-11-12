
CREATE PROCEDURE pr_rel_doc_pag_individual

@cd_identificacao    as varchar(20) = '',
@dt_inicial          as datetime    = '',
@dt_final            as datetime    = ''

AS
  
begin

  set nocount on

--select * from documento_pagar

 Select 
    d.cd_documento_pagar,
    d.cd_identificacao_document,
    d.dt_emissao_documento_paga,
    d.dt_vencimento_documento,
    d.dt_vencimento_original,
    d.vl_documento_pagar,
    d.vl_saldo_documento_pagar,
    d.vl_multa_documento,
    d.dt_cancelamento_documento,
    d.nm_cancelamento_documento,
    --d.cd_modulo,      
    d.cd_numero_banco_documento,
    d.nm_observacao_documento,
    'S'                         as ic_emissao_documento,
    d.ic_envio_documento,
    d.dt_envio_banco_documento,
    --d.dt_contabil_documento,
    d.dt_contabil_documento_pag,
    d.cd_portador,
    --d.cd_tipo_cobranca,
    d.cd_fornecedor,
    d.cd_tipo_documento,
    d.cd_pedido_compra,
    d.cd_nota_saida,
    d.cd_nota_fiscal_entrada,
    --d.cd_vendedor,
    d.dt_pagamento_documento,
    d.vl_pagamento_documento,
--    d.ic_tipo_lancamento,	-- 11/06/2002
    d.cd_tipo_pagamento,
    --d.cd_tipo_liquidacao,
    d.cd_plano_financeiro,
    p.sg_portador,
    d.cd_usuario,
    d.dt_usuario,
    --d.cd_tipo_destinatario,
    d.vl_juros_documento,
    d.vl_abatimento_documento,
    d.vl_desconto_documento,
  --  d.vl_reembolso_documento,
--    d.dt_retorno_banco_doc,
    p.nm_portador,
  --  tl.nm_tipo_liquidacao,
--    v.nm_fantasia_vendedor,
    pf.nm_conta_plano_financeiro,
--    tc.nm_tipo_cobranca,

   d.nm_fantasia_fornecedor,
  
  --Nome Fantasia do Destinatário *************************************************************************************
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',                 
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
      end                             as 'nm_favorecido',
      d.nm_complemento_documento,
      d.nm_ref_documento_pagar

    --Razão Social do Destinatário *************************************************************************************
    --DDD do Destinatário  **********************************************************************************************
    --Telefone do Destinatário  ****************************************************************************************

    --select * from documento_pagar

  from

    Documento_Pagar d                   with (nolock, index(IX_documento_pagar_Identificacao)) 
    left outer join Portador p          with (nolock, index(pk_portador)) on  d.cd_portador         = p.cd_portador 
    left outer join Plano_Financeiro pf with (nolock)                     on pf.cd_plano_financeiro = d.cd_plano_financeiro 
--    left outer join Tipo_Cobranca tc    with (nolock)                     on tc.cd_tipo_cobranca = d.cd_tipo_cobranca

 where
    --Caso tenha sido informado uma identificação 
    ( (@cd_identificacao <> '0') and (replace(d.cd_identificacao_document,'-','') = replace(@cd_identificacao,'-','')) )
    or
    --Caso não tiver sido informada um documento específico busca por data
    ( (@cd_identificacao = '0') and (d.dt_vencimento_documento between @dt_inicial and @dt_final) and
      (d.dt_cancelamento_documento is null) and
      (cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) <> 0 ) )
  order by
      d.dt_vencimento_documento desc

  set nocount off

end

