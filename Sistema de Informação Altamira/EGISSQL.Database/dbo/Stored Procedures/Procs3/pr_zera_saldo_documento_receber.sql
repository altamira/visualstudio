

create procedure pr_zera_saldo_documento_receber

as

select dp.*,d.*
from documento_receber_pagamento dp,
     documento_receber d
where dp.cd_documento_receber = d.cd_documento_receber and
      d.vl_saldo_documento > 0


