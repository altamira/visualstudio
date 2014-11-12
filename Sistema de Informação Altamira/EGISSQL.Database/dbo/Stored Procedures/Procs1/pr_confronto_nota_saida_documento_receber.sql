CREATE   procedure pr_confronto_nota_saida_documento_receber
@dt_inicial datetime,
@dt_final datetime

as

select  
  ns.cd_nota_saida  as 'NotaSaida',
  ns.dt_nota_saida as 'Emissão',
  ns.cd_operacao_fiscal,
  ns.cd_mascara_operacao as 'CFOP',
  cp.sg_condicao_pagamento as 'CondPagto',
  cp.ic_vctoespecif_pag_parce as 'VencEspecf',
  ns.vl_total       as 'ValorNota',
  isnull((select
     sum(dr.vl_documento_receber) 
   from 
     Documento_Receber dr 
   where 
     dr.cd_nota_saida = ns.cd_nota_saida),0) as 'ValorDuplicata',
  (ns.vl_total - isnull((select
     sum(dr.vl_documento_receber) 
   from 
     Documento_Receber dr 
   where 
     dr.cd_nota_saida = ns.cd_nota_saida),0))  as 'Diferença'
from
  Nota_Saida ns 
inner join
  Operacao_Fiscal op
on
  ns.cd_operacao_fiscal = op.cd_operacao_fiscal
inner join    
  Grupo_Operacao_Fiscal gr
on
  op.cd_grupo_operacao_fiscal = gr.cd_grupo_operacao_fiscal
left outer join
  Condicao_Pagamento cp
on
  cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
where
  ns.dt_cancel_nota_saida is null and
  gr.cd_tipo_operacao_fiscal = 2 and
  isnull(op.ic_comercial_operacao,'N') = 'S'         and
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  cast(str((ns.vl_total - isnull((select
     sum(dr.vl_documento_receber) 
   from 
     Documento_Receber dr 
   where 
     dr.cd_nota_saida = ns.cd_nota_saida),0)),25,2) as numeric(25,2)) not between -0.02 and 0.02
order by
  ns.dt_nota_saida,
  ns.cd_nota_saida


