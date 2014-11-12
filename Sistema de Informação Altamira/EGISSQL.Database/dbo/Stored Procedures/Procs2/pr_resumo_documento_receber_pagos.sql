
CREATE PROCEDURE pr_resumo_documento_receber_pagos

@dt_inicial datetime,
@dt_final   datetime

AS

  select
    p.dt_pagamento_documento      as 'DataPagamento',
    count(p.cd_documento_receber) as 'Documentos',
    sum(p.vl_pagamento_documento) as 'ValorTotal',
    ((select
        sum(x.vl_pagamento_documento)
      from
        Documento_Receber_Pagamento x
      where
        x.dt_pagamento_documento = p.dt_pagamento_documento
      group by
        x.dt_pagamento_documento) * 100)/
      (select
         sum(k.vl_pagamento_documento)
       from
         Documento_Receber_Pagamento k
       where
         k.dt_pagamento_documento between @dt_inicial and @dt_final) as 'Percentual',
    count(distinct d.cd_cliente)  as 'Clientes'
  from
    Documento_Receber_Pagamento p left outer join Documento_Receber d
  on
    d.cd_documento_receber = p.cd_documento_receber
  where
    dt_pagamento_documento between @dt_inicial and @dt_final and
    dt_cancelamento_documento is null and
    dt_devolucao_documento    is null
  group by
    dt_pagamento_documento
  order by
    dt_pagamento_documento


