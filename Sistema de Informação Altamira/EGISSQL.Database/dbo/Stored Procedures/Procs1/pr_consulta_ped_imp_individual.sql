
create procedure pr_consulta_ped_imp_individual

----------------------------------------------------------------
--pr_consulta_ped_imp_individual
----------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004 
----------------------------------------------------------------
--Stored Procedure         : Microsoft SQL Server 2000
--Autor(es)                : Daniel C. Neto.
--Banco de Dados           : EgisSql
--Objetivo                 : Realizar uma consulta de Pedido de Importação
--Data                     : 17/02/2003
--Atualizado               : 16/02/2004 - Igor Gama - inclusão de novos campos
--                         : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
@cd_pedido_importacao as int

AS

  SELECT     
    ped.cd_pedido_importacao,
    ped.dt_pedido_importacao,
    ped.cd_comprador as cd_comprador_pedido,
    (Select top 1 nm_comprador From Comprador Where cd_comprador = ped.cd_comprador) as 'nm_comprador',
    ped.dt_canc_pedido_importacao,
    ped.nm_canc_pedido_importacao,
    IsNull(ped.ic_cobertura_cambial,'N') as 'ic_cobertura_cambial',
    CAST((qt_item_ped_imp * vl_item_ped_imp) as numeric(25,2)) as 'vl_total_pedido_imp', 
    ped.qt_pesoliq_ped_imp, 
    ped.qt_pesobru_ped_imp, 
    pedi.cd_item_ped_imp, 
    pedi.qt_item_ped_imp, 
    pedi.qt_saldo_item_ped_imp, 
    pedi.dt_entrega_ped_imp,
    CAST(pedi.vl_item_ped_imp as numeric(25,2)) as 'vl_unitario_item_pedido', 
    pedi.nm_ordem_compra_ped_imp, -- Antiga: ped.nm_alteracao_pedido_venda,
    CONVERT(char(10), pedi.dt_prev_embarque_ped_imp, 103) as 'dt_prev_embarque',
    fo.cd_fornecedor, 
    fo.nm_fantasia_fornecedor, 
    fo.nm_razao_social,
    st.sg_status_pedido,
    st.nm_status_pedido,
    ped.cd_contato_fornecedor,
    (Select top 1 nm_fantasia_contato_forne From Fornecedor_Contato Where cd_contato_fornecedor = ped.cd_contato_fornecedor and
									  cd_fornecedor = ped.cd_fornecedor) as 'nm_fantasia_contato',
    prod.cd_mascara_produto,
    prod.cd_produto,
    prod.nm_fantasia_produto, prod.nm_produto, 
    cop.nm_condicao_pagamento,
    cop.sg_condicao_pagamento,
    cop.qt_parcela_condicao_pgto,
    pvi.cd_pedido_venda,
    pvi.dt_item_pedido_venda,
    (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as 'qt_Qtdade',
    tp.cd_tipo_pedido,
    tp.nm_tipo_pedido,
    ped.cd_origem_pais,
    p.nm_pais,
    m.cd_moeda,
    m.nm_moeda,
    tc.cd_termo_comercial,
    tc.nm_termo_comercial,
    ped.dt_alteracao_pedido_imp,
    ped.nm_alteracao_pedido_imp,
    timp.nm_tipo_importacao as 'nm_tipo_imp',
    timp.sg_tipo_importacao as 'sg_tipo_imp',
    tr.nm_transportadora,
    tr.nm_fantasia,
    mpagto.nm_modalidade_pagamento,
    mpagto.sg_modalidade_pagamento,
    tpf.nm_tipo_pagamento_frete,
    tpf.sg_tipo_pagamento_frete,
    m.cd_moeda as 'cd_moeda_frete',
    m.nm_moeda as 'nm_moeda_frete',
    (pedi.vl_item_ped_imp * pedi.qt_item_ped_imp) as 'TotalItem'
  FROM
    Pedido_Importacao ped Left Outer Join
    Pedido_Importacao_Item pedi on ped.cd_pedido_importacao = pedi.cd_pedido_importacao Left Outer Join 
    Fornecedor fo on ped.cd_fornecedor = fo.cd_fornecedor left outer Join
    Produto prod on pedi.cd_produto = prod.cd_produto Left Outer Join
    Condicao_Pagamento cop on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento Left Outer Join
    Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pedi.cd_pedido_venda and
                             pvi.cd_item_pedido_venda = pedi.cd_item_pedido_venda Left Outer Join
    Status_Pedido st on st.cd_status_pedido = ped.cd_status_pedido left outer join
    Tipo_Pedido tp on tp.cd_tipo_pedido = ped.cd_tipo_pedido left outer join
    Termo_Comercial tc on tc.cd_termo_comercial = ped.cd_termo_comercial left outer join
    Pais p on p.cd_pais = ped.cd_origem_pais left outer join
    Moeda m on m.cd_moeda = ped.cd_moeda Left Outer Join
    Tipo_Importacao timp on ped.cd_tipo_importacao = timp.cd_tipo_importacao Left Outer Join
    Transportadora tr on ped.cd_transportadora = tr.cd_transportadora Left Outer Join
    Modalidade_Pagamento mpagto on ped.cd_modalidade_pagamento = mpagto.cd_modalidade_pagamento Left Outer Join
    Pedido_Importacao_Frete pif on ped.cd_pedido_importacao = pif.cd_pedido_importacao Left Outer Join
    Tipo_Pagamento_Frete tpf on pif.cd_tipo_frete = tpf.cd_tipo_pagamento_frete Left Outer Join
    Moeda moe on pif.cd_moeda = moe.cd_moeda
  WHERE         
    ped.cd_pedido_importacao = @cd_pedido_importacao

  ORDER BY
    ped.dt_pedido_importacao desc, ped.cd_pedido_importacao desc, pedi.cd_item_ped_imp

