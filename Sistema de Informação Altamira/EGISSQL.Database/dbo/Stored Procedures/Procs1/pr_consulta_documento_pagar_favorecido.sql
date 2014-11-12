

CREATE  PROCEDURE pr_consulta_documento_pagar_favorecido

@dt_inicial datetime,
@dt_final datetime,
@cd_tipo_favorecido int,
@cd_favorecido varchar(30)

AS

  select
    d.cd_documento_pagar,
    d.cd_identificacao_document,
    d.dt_vencimento_documento,
    case when cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) <> 0.00 then
      (d.vl_documento_pagar +
       isnull(d.vl_juros_documento,0) -
       isnull(d.vl_abatimento_documento,0) -
       isnull(d.vl_desconto_documento,0))
    else
      (p.vl_pagamento_documento +
       isnull(p.vl_juros_documento_pagar,0) -
       isnull(p.vl_abatimento_documento,0) -
       isnull(p.vl_desconto_documento,0))
    end as 'vl_documento_pagar', 
    p.dt_pagamento_documento,
    (select tp.sg_tipo_pagamento from Tipo_Pagamento_documento tp where tp.cd_tipo_pagamento = p.cd_tipo_pagamento)as 'nm_tipo_pagamento',
    p.cd_identifica_documento,
    (select tc.sg_tipo_conta_pagar from Tipo_Conta_pagar tc where tc.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar)as 'nm_tipo_conta_pagar',
    d.nm_observacao_documento,
    d.dt_emissao_documento_paga,
    isnull(nr.dt_rem, d.dt_emissao_documento_paga) as 'dt_recebimento',
    case @cd_tipo_favorecido
      when 1 then cast(d.cd_empresa_diversa as varchar(30))
      when 2 then cast(d.cd_contrato_pagar as varchar(30))
      when 3 then cast(d.cd_funcionario as varchar(30))
      when 4 then cast(d.nm_fantasia_fornecedor as varchar(30))
    end as 'cd_favorecido',
    case @cd_tipo_favorecido
      when 1 then cast((select top 1 z.nm_favorecido_empresa from favorecido_empresa z where z.cd_empresa = dbo.fn_empresa() and z.cd_empresa_diversa = d.cd_empresa_diversa and z.cd_favorecido_empresa_div = d.cd_favorecido_empresa) as varchar(50))
      when 2 then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
      when 3 then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
      when 4 then cast((select top 1 o.nm_fantasia_fornecedor from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
    end as 'nm_favorecido',
    d.cd_fornecedor,
    nr.cd_nota_entrada,
    pf.nm_conta_plano_financeiro                    as 'PlanoFinanceiro',
    isNull(p.vl_pagamento_documento,0) as vl_pagamento_documento,
    isNull(p.vl_juros_documento_pagar,0) as vl_juros_documento_pagar,
    isNull(p.vl_desconto_documento,0) as vl_desconto_documento,
    isNull(p.vl_abatimento_documento,0) as vl_abatimento_documento,
    isNull((p.vl_pagamento_documento +
    isnull(p.vl_juros_documento_pagar,0) -
    isnull(p.vl_desconto_documento,0) -
    isnull(p.vl_abatimento_documento,0)),0) as 'vl_total'
  into #Tabela_Distinta
  from
    documento_pagar d 
  left outer join
    Nota_Entrada_Registro nr
  on
    nr.cd_nota_entrada = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor
  left outer join
    documento_pagar_pagamento p
  on
    p.cd_documento_pagar = d.cd_documento_pagar
  left outer join
  Plano_Financeiro pf
  on
  d.cd_plano_financeiro = pf.cd_plano_financeiro
  where
    case @cd_tipo_favorecido
      when 1 then cast(d.cd_empresa_diversa as varchar(30))
      when 2 then cast(d.cd_contrato_pagar as varchar(30))
      when 3 then cast(d.cd_funcionario as varchar(30))
      when 4 then cast(d.nm_fantasia_fornecedor as varchar(30))
    end = @cd_favorecido and
    d.dt_vencimento_documento between @dt_inicial and @dt_final  
  order by
    d.dt_vencimento_documento, 
    d.cd_tipo_conta_pagar, 
    cd_favorecido, 
    d.cd_identificacao_document

  select distinct * from #Tabela_Distinta
  drop table #Tabela_Distinta
