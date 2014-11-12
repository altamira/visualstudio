
-------------------------------------------------------------------------------
--sp_helptext pr_romaneio_entrega_vendedor
-------------------------------------------------------------------------------
--pr_romaneio_entrega_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Romaneio de Entrega por Vendedor
--Data             : 03.10.2008
--Alteração        : 03.12.2008 - Ajustes Diversos - Carlos Fernandes
--
-- 26.12.2008 - Dados do Veículo e Motorista - Carlos Fernandes
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_romaneio_entrega_vendedor
@cd_vendedor int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''

as

select
  v.nm_fantasia_vendedor,
  ns.cd_vendedor,
--  ns.cd_nota_saida,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                                                     as cd_nota_saida,

  ns.dt_nota_saida,
  ns.nm_fantasia_nota_saida,
  ns.nm_razao_social_nota,
  ns.vl_total,
  cp.sg_condicao_pagamento,
  fp.nm_forma_pagamento,
  ns.nm_endereco_nota_saida+', '+cd_numero_end_nota_saida as nm_endereco,
  ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  ns.cd_cep_nota_saida,
  ( select top 1 cd_pedido_venda 
    from nota_saida_item with (nolock) 
    where
      cd_nota_saida = ns.cd_nota_saida ) as cd_pedido_venda,
  cv.sg_criterio_visita,
  vei.nm_veiculo,
  mot.nm_motorista
from 
  nota_saida                         ns         with (nolock)
  left outer join cliente            c          with (nolock) on c.cd_cliente             = ns.cd_cliente
  left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente            = c.cd_cliente
  left outer join Vendedor           v          with (nolock) on v.cd_vendedor            = ns.cd_vendedor
  left outer join Condicao_Pagamento cp         with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
  left outer join Operacao_fiscal    opf        with (nolock) on opf.cd_operacao_fiscal   = ns.cd_operacao_fiscal
  left outer join Forma_Pagamento    fp         with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento
  left outer join criterio_visita    cv         with (nolock) on cv.cd_criterio_visita    = c.cd_criterio_visita
  left outer join Veiculo            vei        with (nolock) on vei.cd_veiculo           = ns.cd_veiculo 
  left outer join Motorista          mot        with (nolock) on mot.cd_motorista         = ns.cd_motorista
where
  ns.dt_nota_saida between @dt_inicial and @dt_final                                      and
  ns.cd_vendedor   = case when @cd_vendedor = 0 then ns.cd_vendedor else @cd_vendedor end and
  ns.dt_cancel_nota_saida is null
order by
  ns.cd_vendedor,
  ns.nm_fantasia_nota_saida

