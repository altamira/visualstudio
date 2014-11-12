create procedure pr_diario_proposta
------------------------------------------------------------------------
--pr_diario_proposta
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                               2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Diário de Propostas Comerciais
--                      : 
--Data			: 19/02/2003
--Desc. Alteração	: 30/06/2003
--                        Acertos no filtro e na definição de Imediato - Daniel C. Neto.
--Desc. Alteração	: 31/07/2003
--                        Realizar a filtragem das propostas do vendedor informado
-- Alteração            : 30.09.2003 - Filtrar apenas a data
--                      : 18/11/2003 - Permitir mostrar um período - Dudu
--                      : 13/12/2004 - Acerto no Cabeçalho - Sérgio Cardoso 
--			: 22/01/2005 - Incluído parâmetro @cd_loja - Clelson Camargo
--                      : 15.10.2005 - Verificação - mostrar também as perdas - Carlos Fernandes
--                      : 09.05.2006 - Usuário / vendedor que atendeu a Proposta
--                      : 11,05.2006 - Código do Cliente - Carlos Fernandes
-- 09.04.2008 - Segmento de Mercado - Carlos Fernandes
-- 04.08.2008 - Verificação da Stored Procedure - Carlos Fernandes
-------------------------------------------------------------------------------------------------

@dt_base         datetime,
@cd_vendedor     int      = 0,
@dt_final        datetime = null,
@cd_loja         int      = 0,
@cd_tipo_mercado int      = 0

as

set @cd_vendedor = isnull(@cd_vendedor, 0)
set @dt_final    = isnull(@dt_final, @dt_base)

declare @qt_dia_imediato as integer

set @qt_dia_imediato = (select isnull(qt_dia_imediato_empresa,0)
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

  select
    co.cd_cliente,
    c.nm_fantasia_cliente                   as 'Cliente',
    co.cd_consulta,
    ico.cd_item_consulta,
    co.dt_consulta                          as 'Data', 
    cp.nm_categoria_produto                 as 'Produto',
    ico.qt_item_consulta                    as 'Quantidade', 
    isnull(ico.qt_item_consulta * 
           ico.vl_unitario_item_consulta,0) as 'Total',
    pg.nm_condicao_pagamento                as 'CondicaoPagamento',

    case 
      when
       (ico.dt_entrega_consulta - co.dt_consulta) <=
      @qt_dia_imediato      then 'Imediato'
      else convert( varchar(10),ico.dt_entrega_consulta,103 ) end as 'Entrega',

    Interno = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = co.cd_vendedor_interno ),
    Externo = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = co.cd_vendedor ),
    v.cd_loja,
    co.cd_usuario_atendente,
    u.nm_fantasia_usuario              as Atendido,
    ra.nm_ramo_atividade,
    isnull(ico.cd_pedido_venda,0)      as cd_pedido_venda,
    isnull(ico.cd_item_pedido_venda,0) as cd_item_pedido_venda,
    case when isnull(ico.cd_pedido_venda,0)>0 and isnull(ico.cd_item_pedido_venda,0)>0
    then   
    isnull(ico.qt_item_consulta * 
           ico.vl_unitario_item_consulta,0)
    else
      0.00
    end                  as 'Total_Fechado'

  from
    Consulta           co             with(nolock) inner join 
    Consulta_Itens    ico             with(nolock) on ico.cd_consulta          = co.cd_consulta           left outer join
    Cliente             c             with(nolock) on c.cd_cliente             = co.cd_cliente            left outer join
    Condicao_Pagamento pg             with(nolock) on pg.cd_condicao_pagamento = co.cd_condicao_pagamento left outer join
    Categoria_Produto  cp             with(nolock) on cp.cd_categoria_produto  = ico.cd_categoria_produto left outer join
    Vendedor            v             with(nolock) on v.cd_vendedor            = co.cd_vendedor           left outer join 
    egisadmin.dbo.Usuario u           with(nolock) on co.cd_usuario_atendente  = u.cd_usuario 
    left outer join Ramo_Atividade ra with(nolock) on ra.cd_ramo_atividade = c.cd_ramo_atividade

  where
    ((@cd_loja = 0) or (v.cd_loja = @cd_loja)) and
    isnull(co.ic_consignacao_consulta,'N') = 'N' and
    (co.dt_consulta between @dt_base and @dt_final) and
--    (ico.dt_perda_consulta_itens is null) and
--Clelson(31.01.2005)    ico.dt_entrega_consulta is not null and -- Comentado para trazer as consultas que tem somente serviço
    (ico.qt_item_consulta * ico.vl_unitario_item_consulta) > 0 and
	((IsNull(@cd_vendedor,0) = 0) or (IsNull(@cd_vendedor,0) <> 0 and co.cd_vendedor = @cd_vendedor)) and
    isnull(c.cd_tipo_mercado,0) = ( case isnull(@cd_tipo_mercado,0) when 0 then isnull(c.cd_tipo_mercado,0) else isnull(@cd_tipo_mercado,0) end) 
  order by 3 desc

