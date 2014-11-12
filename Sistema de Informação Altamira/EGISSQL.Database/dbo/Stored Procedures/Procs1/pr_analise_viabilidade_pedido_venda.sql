
-------------------------------------------------------------------------------
--pr_analise_viabilidade_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Montagem da Análise de Viabilidade do pedido de Venda
--Data             : 23.04.2007
--Alteração        : 15.05.2007
------------------------------------------------------------------------------
create procedure pr_analise_viabilidade_pedido_venda
@cd_pedido_venda            int = 0,
@cd_idioma                  int = 1,
@ic_tipo_componente_analise int = '2'

as


--select * from pedido_venda
--select * from componente_analise
--select * from componente_analise_texto
--select * from vendedor
--select * from cliente  
--select * from transportadora
--select * from tipo_pagamento_frete

select
  pv.cd_pedido_venda                  as Pedido,
  pv.dt_pedido_venda                  as Emissao,
  c.cd_cliente                        as CodigoCliente,
  c.nm_razao_social_cliente           as RazaoSocial,
  c.nm_fantasia_cliente               as Fantasia,
  v.nm_fantasia_vendedor              as Vendedor,
  t.nm_transportadora                 as Transportadora,
  t.nm_fantasia                       as FantasiaTransportadora,
  ltrim(rtrim(t.cd_ddd))+' '+
  ltrim(rtrim(t.cd_telefone))         as FoneTransportadora,
  tpf.nm_tipo_pagamento_frete         as PagamentoFrete,
  cp.nm_condicao_pagamento            as CondicaoPagamento,
  m.nm_moeda                          as Moeda,
  pv.dt_cambio_pedido_venda           as DataCambio,
  pv.vl_indice_pedido_venda           as Cotacao,
  tle.nm_tipo_local_entrega           as TipoLocalEntrega,
  ca.nm_componente_analise            as Componente,
  cat.cd_item_texto_analise           as Item,
  cat.nm_texto_analise                as Texto,
  cat.ds_texto_analise                as Descritivo,
  cat.nm_complemento_texto            as Complemento,
  isnull(cat.ic_negrito_texto,'N')    as Negrito,
  isnull(cat.ic_sublinhado_texto,'N') as Sublinhado,
  isnull(cat.ic_tipo_texto,1)         as Tipo

from
  Componente_Analise ca
  inner join Componente_Analise_Texto cat  on cat.cd_componente_analise   = ca.cd_componente_analise
  left outer join Pedido_Venda pv          on pv.cd_pedido_venda          = @cd_pedido_venda
  left outer join Cliente      c           on c.cd_cliente                = pv.cd_cliente
  left outer join Vendedor     v           on v.cd_vendedor               = pv.cd_vendedor
  left outer join Transportadora t         on t.cd_transportadora         = pv.cd_transportadora
  left outer join Tipo_Pagamento_Frete tpf on tpf.cd_tipo_pagamento_frete = pv.cd_tipo_pagamento_frete
  left outer join Condicao_Pagamento   cp  on cp.cd_condicao_pagamento    = pv.cd_condicao_pagamento
  left outer join Moeda                m   on m.cd_moeda                  = pv.cd_moeda
  left outer join Tipo_Local_Entrega   tle on tle.cd_tipo_local_entrega   = pv.cd_tipo_local_entrega
where
  isnull(ca.cd_idioma,1) = case when @cd_idioma = 0 then isnull(ca.cd_idioma,1) else @cd_idioma end and
  isnull(ca.ic_ativo_componente,'N') = 'S' and
  isnull(cat.ic_ativo_texto,'N')     = 'S' and
  ( isnull(ca.ic_tipo_componente_analise,'3')='2' or isnull(ca.ic_tipo_componente_analise,'3')='3' )
order by
  ca.cd_ordem_componente,
  cat.cd_ordem_texto

