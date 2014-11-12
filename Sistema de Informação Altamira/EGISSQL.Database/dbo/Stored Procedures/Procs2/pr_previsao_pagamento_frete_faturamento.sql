
-------------------------------------------------------------------------------
--pr_previsao_pagamento_frete_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Notas Fiscais com Tipo Pagamento Frete = Emitente
--                   e Entregues por Transportadora
--Data             : 21.10.2006
--Alteração        : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------

create procedure pr_previsao_pagamento_frete_faturamento
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from tipo_pagamento_frete
--select * from transportadora
--select * from nota_saida

select
  t.nm_fantasia                as Transportadora,
  --ns.cd_nota_saida             as Nota,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                          as Nota,

  ns.dt_nota_saida             as Emissao,
  ns.dt_saida_nota_saida       as Saida,
  ns.nm_fantasia_nota_saida    as Cliente,
  ns.sg_estado_nota_saida      as UF,
  ns.nm_cidade_nota_saida      as Cidade,
  ns.vl_total                  as Total,
  ns.vl_frete                  as Frete,
  ns.vl_seguro                 as Seguro,
  opf.nm_operacao_fiscal       as Operacao

from
  Nota_Saida ns                       with (nolock)  
  inner join Transportadora       t   with (nolock)  on t.cd_transportadora        = ns.cd_transportadora
  inner join Tipo_Pagamento_Frete tp  with (nolock)  on tp.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete
  left outer join Operacao_Fiscal opf with (nolock)  on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  isnull(tp.ic_pagar_pagamento_frete,'N') = 'S'      and
  isnull(ns.cd_transportadora,0)>0                   and
  ns.dt_cancel_nota_saida is null

order by
  t.nm_fantasia,
  ns.dt_nota_saida
  
