
CREATE PROCEDURE pr_rel_doc_rec_individual

@cd_identificacao    as varchar(20),
@dt_inicial          as datetime,
@dt_final            as datetime

AS
  
begin

  set nocount on

 Select 
    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_vencimento_original,
    d.vl_documento_receber,
    d.vl_saldo_documento,
    d.dt_cancelamento_documento,
    d.nm_cancelamento_documento,
    d.cd_modulo,      
    d.cd_banco_documento_recebe,
    d.ds_documento_receber,
    d.ic_emissao_documento,
    d.ic_envio_documento,
    d.dt_envio_banco_documento,
    d.dt_contabil_documento,
    d.cd_portador,
    d.cd_tipo_cobranca,
    d.cd_cliente,
    d.cd_tipo_documento,
    d.cd_pedido_venda,
    d.cd_nota_saida,
    d.cd_vendedor,
    d.dt_pagto_document_receber,
    d.vl_pagto_document_receber,
    d.ic_tipo_lancamento,	-- 11/06/2002
    d.cd_tipo_liquidacao,
    d.cd_plano_financeiro,
    p.sg_portador,
    d.cd_usuario,
    d.dt_usuario,
    d.cd_tipo_destinatario,
    d.vl_abatimento_documento,
    d.vl_reembolso_documento,
    d.dt_devolucao_documento,
    d.nm_devolucao_documento,
    d.dt_retorno_banco_doc,
    p.nm_portador,
    tl.nm_tipo_liquidacao,
    v.nm_fantasia_vendedor,
    pf.nm_conta_plano_financeiro,
    tc.nm_tipo_cobranca,
    --Nome Fantasia do Destinatário *************************************************************************************
    case 
      when d.cd_tipo_destinatario = 1 then 
         ( Select top 1 x.nm_fantasia_cliente from Cliente x with (nolock, index(pk_cliente)) where x.cd_cliente = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 2 then 
         ( Select top 1 x.nm_fantasia_fornecedor from Fornecedor x with (nolock, index(pk_fornecedor)) where x.cd_fornecedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 3 then 
         ( Select top 1 x.nm_fantasia_vendedor from Vendedor x with (nolock, index(pk_vendedor)) where x.cd_vendedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 4 then 
         ( select x.nm_fantasia from Transportadora x with (nolock, index(pk_transportadora)) where x.cd_transportadora = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 5 then 
       Null
   	 when d.cd_tipo_destinatario = 6 then 
       ( select x.nm_funcionario from Funcionario x with (nolock, index(pk_funcionario)) where x.cd_funcionario = d.cd_cliente )
   	 when d.cd_tipo_destinatario = 7 then 
       Null 
    end as 'nm_fantasia_cliente',
    --Razão Social do Destinatário *************************************************************************************
    case 
      when d.cd_tipo_destinatario = 1 then 
         ( Select top 1 x.nm_razao_social_cliente from Cliente x with (nolock, index(pk_cliente)) where x.cd_cliente = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 2 then 
         ( Select top 1 x.nm_razao_social from Fornecedor x with (nolock, index(pk_fornecedor)) where x.cd_fornecedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 3 then 
         ( Select top 1 x.nm_vendedor from Vendedor x with (nolock, index(pk_vendedor)) where x.cd_vendedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 4 then 
         ( select x.nm_transportadora from Transportadora x with (nolock, index(pk_transportadora)) where x.cd_transportadora = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 5 then 
       Null
   	 when d.cd_tipo_destinatario = 6 then 
       ( select x.nm_funcionario from Funcionario x with (nolock, index(pk_funcionario)) where x.cd_funcionario = d.cd_cliente )
   	 when d.cd_tipo_destinatario = 7 then 
       Null 
    end as 'nm_razao_social_destinatario',
    --DDD do Destinatário  **********************************************************************************************
    case 
      when d.cd_tipo_destinatario = 1 then 
         ( Select top 1 x.cd_ddd from Cliente x with (nolock, index(pk_cliente)) where x.cd_cliente = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 2 then 
         ( Select top 1 x.cd_ddd from Fornecedor x with (nolock, index(pk_fornecedor)) where x.cd_fornecedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 3 then 
         ( Select top 1 x.cd_ddd_vendedor from Vendedor x with (nolock, index(pk_vendedor)) where x.cd_vendedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 4 then 
         ( select x.cd_ddd from Transportadora x with (nolock, index(pk_transportadora)) where x.cd_transportadora = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 5 then 
       Null
   	 when d.cd_tipo_destinatario = 6 then 
       null
   	 when d.cd_tipo_destinatario = 7 then 
       Null 
    end as 'cd_ddd',
    --Telefone do Destinatário  ****************************************************************************************
    case 
      when d.cd_tipo_destinatario = 1 then 
         ( Select top 1 x.cd_telefone from Cliente x with (nolock, index(pk_cliente)) where x.cd_cliente = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 2 then 
         ( Select top 1 x.cd_telefone from Fornecedor x with (nolock, index(pk_fornecedor)) where x.cd_fornecedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 3 then 
         ( Select top 1 x.cd_telefone_vendedor from Vendedor x with (nolock, index(pk_vendedor)) where x.cd_vendedor = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 4 then 
         ( select x.cd_telefone from Transportadora x with (nolock, index(pk_transportadora)) where x.cd_transportadora = d.cd_cliente)
   	 when d.cd_tipo_destinatario = 5 then 
       Null
   	 when d.cd_tipo_destinatario = 6 then 
       null
   	 when d.cd_tipo_destinatario = 7 then 
       Null 
    end as 'cd_telefone'
  from
    Documento_receber d  with (nolock, index(IX_documento_receber_Identificacao)) 
    left outer join Portador p  with (nolock, index(pk_portador))
      on  d.cd_portador = p.cd_portador 
    left outer join Tipo_Liquidacao tl 
      on tl.cd_tipo_liquidacao = d.cd_tipo_liquidacao 
    left outer join Vendedor v with (nolock, index(pk_vendedor))
      on v.cd_vendedor = d.cd_vendedor 
    left outer join Plano_Financeiro pf 
      on pf.cd_plano_financeiro = d.cd_plano_financeiro 
    left outer join Tipo_Cobranca tc 
      on tc.cd_tipo_cobranca = d.cd_tipo_cobranca
 where
    --Caso tenha sido informado uma identificação 
    ( (@cd_identificacao <> '0') and (replace(d.cd_identificacao,'-','') = replace(@cd_identificacao,'-','')) )
    or
    --Caso não tiver sido informada um documento específico busca por data
    ( (@cd_identificacao = '0') and (d.dt_vencimento_documento between @dt_inicial and @dt_final) and
      (d.dt_cancelamento_documento is null) and
      (cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) <> 0 ) )
  order by
      d.dt_vencimento_documento desc

  set nocount off

end

