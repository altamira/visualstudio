
CREATE PROCEDURE pr_saldo_diario_fornecedor
@cd_fornecedor int,                  -- código do fornecedor
@dt_saldo      datetime,             -- data base
@vl_saldo      float output          -- valor do saldo anterior

AS
BEGIN

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SaldoFornecedor'
	   AND 	  type = 'U')
    DROP TABLE SaldoFornecedor


  Select 
    max(ner.cd_rem)               as 'cd_rem',
    max(ner.dt_rem)               as 'dt_rem',
    ner.cd_fornecedor             as 'cd_fornecedor',
    ner.cd_nota_entrada           as 'cd_nota_entrada',
    ner.cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
    max(ner.cd_operacao_fiscal)   as 'cd_operacao_fiscal',
    nep.cd_documento_pagar        as 'cd_documento_pagar',
    snf.sg_serie_nota_fiscal      as 'sg_serie_nota_fiscal'
  into
    #Nota_Entrada_Registro_Individual
  from 
      Nota_Entrada_Registro ner
    inner join Nota_Entrada_Parcela nep
      on ner.cd_fornecedor = nep.cd_fornecedor and 
         ner.cd_nota_entrada = nep.cd_nota_entrada and
         ner.cd_operacao_fiscal = nep.cd_operacao_fiscal and
         ner.cd_serie_nota_fiscal = nep.cd_serie_nota_fiscal
    inner join Operacao_Fiscal op 
        on ner.cd_operacao_fiscal = op.cd_operacao_fiscal
        and (isnull(op.ic_comercial_operacao,'S') = 'S')
    inner join Serie_nota_fiscal snf 
        on snf.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal
    where
      ner.cd_fornecedor = @cd_fornecedor
    group by
      ner.cd_fornecedor,
      ner.cd_nota_entrada,
      ner.cd_serie_nota_fiscal,
      nep.cd_documento_pagar,
      snf.sg_serie_nota_fiscal
    having
      ( (Max(ner.dt_rem) is null) or 
        (Max(ner.dt_rem) < @dt_saldo) ) and
      ( sum(nep.vl_parcela_nota_entrada) > 0 )

  Select 
    distinct
    d.cd_documento_pagar as 'CodDocumento',
    d.cd_identificacao_document as ident,
    d.dt_emissao_documento_paga,
    (case 
      when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) < @dt_saldo ) then d.vl_documento_pagar
      else 0 
     end) -
    (case 
      when (p.dt_pagamento_documento < @dt_saldo ) then p.vl_pagamento_documento
      else 0 
    end) as 'VlrDocumento'    
  into
    dbo.SaldoFornecedor
  from
    Documento_Pagar d 
    left outer join Documento_Pagar_Pagamento p 
      on d.cd_documento_pagar = p.cd_documento_pagar
    left outer join Fornecedor f 
      on d.cd_fornecedor = f.cd_fornecedor
    left outer join #Nota_Entrada_Registro_Individual nr 
       on ( ( nr.cd_documento_pagar is not null ) and ( d.cd_documento_pagar = nr.cd_documento_pagar ) ) or
          ( ( nr.cd_documento_pagar is null ) and ( d.cd_nota_fiscal_entrada = nr.cd_nota_entrada
                                              and d.cd_fornecedor = nr.cd_fornecedor
                                              and d.cd_serie_nota_fiscal_entr = nr.sg_serie_nota_fiscal ) )

    left outer join Tipo_Conta_Pagar t 
      on d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
  where
     d.cd_fornecedor = @cd_fornecedor and
    (nr.cd_rem is not null) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_saldo ) and
    (
      (
        (p.dt_pagamento_documento is null and nr.dt_rem >= @dt_saldo) or 
        (p.dt_pagamento_documento >= @dt_saldo)
      ) or
        (nr.dt_rem is null or nr.dt_rem < @dt_saldo)
    ) and
    t.ic_razao_contabil = 'S'

  select
    @vl_saldo = isnull(sum(VlrDocumento),0)
  from
    dbo.SaldoFornecedor

  drop table #Nota_Entrada_Registro_Individual

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SaldoFornecedor'
	   AND 	  type = 'U')
    DROP TABLE SaldoFornecedor

end

