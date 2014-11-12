
CREATE FUNCTION fn_saldo_diario_fornecedor
(@cd_fornecedor int,                  -- código do fornecedor
 @dt_saldo      datetime)             -- data base
RETURNS float                         -- valor do saldo anterior

AS
BEGIN

  declare @vl_saldo float
  set     @vl_saldo = 0.00

  select 
    @vl_saldo = isnull(sum(d.vl_documento_pagar),0)
  from 
    documento_pagar d
  left outer join
    documento_pagar_pagamento p
  on
    d.cd_documento_pagar = p.cd_documento_pagar
  left outer join
    nota_entrada n
  on
    n.cd_nota_entrada = d.cd_nota_fiscal_entrada and
    n.cd_fornecedor = d.cd_fornecedor
  left outer join
    nota_entrada_registro nr
  on
    nr.cd_nota_entrada = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor
  left outer join
    tipo_conta_pagar t
  on
    t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar
  where 
    d.cd_fornecedor = @cd_fornecedor and
    isnull(nr.dt_rem, d.dt_emissao_documento_paga) < @dt_saldo and
    (p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_saldo ) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_saldo ) and
     t.ic_razao_contabil = 'S' 

  return @vl_saldo

end
