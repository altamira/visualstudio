
CREATE PROCEDURE pr_resumo_documento_receber_plano_financeiro

@dt_inicial          datetime,
@dt_final            datetime

AS

  declare @vl_total float
  set     @vl_total = 0

  select
    dt_emissao_documento       as 'Data',
    count(cd_identificacao)    as 'Duplicatas',
    sum(vl_saldo_documento)    as 'ValorTotal',
    count(distinct cd_cliente) as 'Clientes',
    max(cd_plano_financeiro)   as 'Plano'
  into
    #documento_receber
  from
    documento_receber
  where
    cast(str(vl_saldo_documento,25,2) as decimal(25,2)) > 0 and
    dt_emissao_documento between @dt_inicial and @dt_final and
    dt_cancelamento_documento is null and 
   cd_portador = 999
  group by
    dt_emissao_documento
  order by
    dt_emissao_documento

  select
    @vl_total = sum(ValorTotal)
  from
    #documento_receber

  select
    max(d.cd_plano_financeiro)    as 'PlanoB',         
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
  into #AuxTab1
  from
    Documento_Receber_Pagamento p left outer join Documento_Receber d
  on
    d.cd_documento_receber = p.cd_documento_receber
  where
    dt_pagamento_documento between @dt_inicial and @dt_final
  group by
    dt_pagamento_documento
  order by
    dt_pagamento_documento

select 
    pf.nm_conta_plano_financeiro,
    a.Data,
    a.Duplicatas,
    a.ValorTotal,
    (a.ValorTotal / @vl_total) * 100 as 'Perc',
    a.Clientes,
    a.Plano,
    b.*
from
   #documento_receber a, #AuxTab1 b, Plano_Financeiro pf
where
   a.plano = b.PlanoB and
   a.plano = pf.cd_plano_financeiro
   

