
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_check_list_documento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Montagem do Check List por Documento
--Data             : 03.08.2007
--Alteração        : 03.08.2007
------------------------------------------------------------------------------
create procedure pr_geracao_check_list_documento
@cd_tipo_check_list         int = 0,
@cd_documento               int = 0,
@cd_idioma                  int = 1

as

--select * from tipo_check_list
--select * from check_list_componente
--select * from check_list_componente_texto

------------------------------------------------------------------------------
if @cd_tipo_check_list = 1 --Proposta Comercial
------------------------------------------------------------------------------
begin

select
  pc.cd_consulta                      as Proposta,
  pc.dt_consulta                      as Emissao,
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
  pc.dt_cambio_consulta               as DataCambio,
  pc.vl_cambio_consulta               as Cotacao,
  tle.nm_tipo_local_entrega           as TipoLocalEntrega,
  clc.nm_componente                   as Componente,
  clt.cd_item_componente              as Item,
  clt.nm_texto_componente             as Texto,
  clt.ds_texto_componente             as Descritivo,
--  clt.nm_complemento_texto            as Complemento,
  isnull(clt.ic_negrito_texto,'N')    as Negrito,
  isnull(clt.ic_sublinhado_texto,'N') as Sublinhado,
  isnull(clt.ic_tipo_texto,1)         as Tipo

from
  Tipo_Check_List tc
  inner join Check_List_Componente clc       on clc.cd_tipo_check_list      = tc.cd_tipo_check_list
  inner join Check_List_Componente_Texto clt on clt.cd_componente           = clc.cd_componente
  left outer join Consulta     pc            on pc.cd_consulta              = @cd_documento
  left outer join Cliente      c             on c.cd_cliente                = pc.cd_cliente
  left outer join Vendedor     v             on v.cd_vendedor               = pc.cd_vendedor
  left outer join Transportadora t           on t.cd_transportadora         = pc.cd_transportadora
  left outer join Tipo_Pagamento_Frete tpf   on tpf.cd_tipo_pagamento_frete = pc.cd_tipo_pagamento_frete
  left outer join Condicao_Pagamento   cp    on cp.cd_condicao_pagamento    = pc.cd_condicao_pagamento
  left outer join Moeda                m     on m.cd_moeda                  = pc.cd_moeda
  left outer join Tipo_Local_Entrega   tle   on tle.cd_tipo_local_entrega   = pc.cd_tipo_local_entrega
where
  isnull(clc.cd_idioma,1) = case when @cd_idioma = 0 then isnull(clc.cd_idioma,1) else @cd_idioma end and
  isnull(clc.ic_ativo_componente,'N') = 'S' and
  isnull(clt.ic_ativo_texto,'N')      = 'S' 
order by
  clc.cd_ordem_componente,
  clt.cd_componente,
  clt.cd_ordem_item_componente

end

