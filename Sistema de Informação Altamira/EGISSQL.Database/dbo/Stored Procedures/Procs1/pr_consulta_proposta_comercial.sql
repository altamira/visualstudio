
CREATE PROCEDURE pr_consulta_proposta_comercial
-------------------------------------------------------------------------------
--pr_consulta_proposta_comercial
-------------------------------------------------------------------------------
-- GBS - Global Business Sollution  Ltda                                   2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Daniel C. Neto / Victor
--Banco de Dados        : EgisSql
--Objetivo              : Faz uma consulta individual de proposta comercial.
--Data                  : 05/02/2003
--Atualizado            : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso 
-------------------------------------------------------------------------------
@cd_consulta as int

AS

  SELECT     
    c.cd_consulta,
    c.dt_consulta,
    c.cd_vendedor as cd_vendedor_consulta,
    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
    c.cd_vendedor_interno,
    (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
    c.dt_fechamento_consulta,
    c.nm_referencia_consulta,
    IsNull(c.ic_fatsmo_consulta,'N') as 'ic_fatsmo_consulta',

    CAST((ci.qt_item_consulta * ci.vl_unitario_item_consulta) as numeric(25,2)) as 'vl_total_consulta', 
    ci.qt_peso_liquido, 
    ci.qt_peso_bruto, 
    ci.cd_item_consulta, 
    ci.dt_item_consulta, 
    ci.qt_item_consulta, ci.pc_desconto_item_consulta, 
    ci.qt_dia_entrega_consulta, 
    ci.dt_entrega_consulta,
    CAST(ci.vl_unitario_item_consulta as numeric(25,2)) as 'vl_unitario_item_consulta', 
--    c.nm_alteracao_consulta,
    CONVERT(char(10),c.dt_alteracao_consulta, 103) as 'dt_ult_alteracao',
    cli.cd_cliente, 
    cli.nm_fantasia_cliente, 
    cli.nm_razao_social_cliente,

    c.nm_assina_consulta, 
    c.cd_status_proposta, 
    c.cd_tipo_proposta,
    tp.nm_tipo_proposta,
    st.sg_status_proposta,
    st.nm_status_proposta,
    c.cd_vendedor_interno, 
    c.cd_contato, 
    (Select top 1 nm_fantasia_contato From Cliente_Contato Where cd_contato = c.cd_contato and cd_cliente = c.cd_cliente) as 'nm_fantasia_contato',
    prod.cd_mascara_produto,
    prod.cd_produto,
    ci.nm_fantasia_produto, ci.nm_produto_consulta, 
    cop.nm_condicao_pagamento,
    cop.sg_condicao_pagamento,
    cop.qt_parcela_condicao_pgto,
    ci.cd_pedido_venda,
    pv.dt_pedido_venda,
	 ci.dt_desconto_item_consulta,
    ci.dt_perda_consulta_itens,
    (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as 'qt_Qtdade'
--    nfs.qt_volume_nota_saida

  FROM 
    Consulta c WITH (NOLOCK)  Left Outer Join 
    Consulta_Itens  ci  WITH (NOLOCK)  on c.cd_consulta = ci.cd_consulta Left Outer Join 
    Cliente cli on c.cd_cliente = cli.cd_cliente Left Outer Join 
    Produto prod on ci.cd_produto = prod.cd_produto Left Outer Join
    Condicao_Pagamento cop on c.cd_condicao_pagamento = cop.cd_condicao_pagamento Left Outer Join
    Pedido_Venda_Item pvi  WITH (NOLOCK)  on pvi.cd_pedido_venda = ci.cd_pedido_venda and
                           pvi.cd_item_pedido_venda = ci.cd_item_pedido_venda Left Outer Join
    Pedido_Venda pv WITH (NOLOCK) on   pv.cd_pedido_venda = ci.cd_pedido_venda Left Outer Join
    Status_Proposta st on st.cd_status_proposta = c.cd_status_proposta Left Outer Join
    Tipo_Proposta tp on tp.cd_tipo_proposta = c.cd_tipo_proposta
  WHERE         
    (c.cd_consulta = @cd_consulta)

  ORDER BY
    c.dt_consulta desc, ci.cd_item_pedido_venda

