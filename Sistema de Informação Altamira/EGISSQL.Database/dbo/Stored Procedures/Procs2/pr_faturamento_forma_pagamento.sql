
-------------------------------------------------------------------------------
--sp_helptext pr_faturamento_forma_pagamento
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta / Relatório por Forma de Pagamento
--Data             : 29.10.2008
--Alteração        : 
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes

--
------------------------------------------------------------------------------
create procedure pr_faturamento_forma_pagamento
@cd_forma_pagamento int = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@cd_nota_saida      int      = 0

as

--select * from nota_saida

select
  fp.nm_forma_pagamento,
  ns.dt_nota_saida,
--  ns.cd_nota_saida,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                           as cd_nota_saida,

  ns.cd_cliente,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente,
  ns.nm_fantasia_nota_saida,  
  ns.nm_razao_social_nota,
  ns.cd_vendedor, 
  c.cd_criterio_visita,
  ns.vl_total,
  nsp.cd_parcela_nota_saida,
  nsp.vl_parcela_nota_saida,
  nsp.dt_parcela_nota_saida,
  nsp.cd_ident_parc_nota_saida,
  ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  v.nm_fantasia_vendedor,
  cv.sg_criterio_visita,
  cv.nm_criterio_visita,
  ns.cd_pedido_venda,
  ns.nm_bairro_entrega,
  ns.sg_estado_entrega

--select * from nota_saida_parcela

from
  nota_saida ns                                 with (nolock) 
  inner join nota_saida_parcela nsp             with (nolock) on nsp.cd_nota_saida     = ns.cd_nota_saida
  left outer join Cliente c                     with (nolock) on c.cd_cliente          = ns.cd_cliente
  left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente         = c.cd_cliente
  left outer join Forma_Pagamento fp            with (nolock) on fp.cd_forma_pagamento = ci.cd_forma_pagamento
  left outer join Vendedor v                    with (nolock) on v.cd_vendedor         = ns.cd_vendedor
  left outer join Criterio_Visita cv            with (nolock) on cv.cd_criterio_visita = c.cd_criterio_visita

where
  ci.cd_forma_pagamento = case when @cd_forma_pagamento=0 then ci.cd_forma_pagamento end and
  ns.dt_nota_saida between @dt_inicial and @dt_final 
order by
  fp.nm_forma_pagamento,
  dt_nota_saida

--select * from forma_pagamento

