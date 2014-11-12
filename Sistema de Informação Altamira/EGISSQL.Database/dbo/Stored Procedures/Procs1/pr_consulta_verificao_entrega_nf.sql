
create procedure pr_consulta_verificao_entrega_nf
---------------------------------------------------
--GBS Global Business Solution Ltda            2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Listar as Entregas p/ Período
--Data: 17/02/2003
--Atualizado: 
---------------------------------------------------
-- @cd_nota_saida int,
@ic_parametro  Char(1) = 1,
@dt_inicial    datetime,
@dt_final      datetime,
@ic_comercial_operacao char(1) = 'N'
as

If @ic_parametro = 1
Begin

  select 
    td.nm_tipo_destinatario     as 'TipoDestinatario',
    Case td.cd_tipo_destinatario
      When 1 Then 'Customer'
      When 2 Then 'Supplier'
      When 3 Then 'Salesman'
      When 4 Then 'Transporter'
      When 5 Then 'Representative'
      When 6 Then 'Employee'
    Else
      'Others'
    End as 'KindofAddressee',
    n.nm_fantasia_destinatario    as 'Destinatario',
    n.nm_fantasia_destinatario    as 'Addressee',
    IsNull(p.cd_pedido_venda, 0)  as 'Pedido',
    IsNull(p.cd_pedido_venda, 0)  as 'OrderNo', 
    p.dt_pedido_venda             as 'DataPedido',
    p.dt_pedido_venda             as 'OrderDate',
    Sum(pvi.qt_item_pedido_venda) as 'QtdPedido',
    Sum(pvi.qt_item_pedido_venda) as 'AmountOrder',
    IsNull(p.vl_total_pedido_venda, 0) as 'ValorPedido',
    IsNull(p.vl_total_pedido_venda, 0) as 'OrderAmount',
    n.cd_nota_saida               as 'NF',
    n.cd_nota_saida               as 'InvoiceNo',
    n.dt_nota_saida               as 'DataNF',
    n.dt_nota_saida               as 'InvoiceDate',
    Sum(ni.vl_unitario_item_nota * ni.qt_item_nota_saida) as 'ValorNF',
    Sum(ni.vl_unitario_item_nota * ni.qt_item_nota_saida) as 'InvoiceAmount',
    Sum(ni.qt_item_nota_saida)    as 'QtdNF',
    Sum(ni.qt_item_nota_saida)    as 'AmountInvoice',
    Sum(((IsNull((ni.qt_item_nota_saida * ni.vl_unitario_item_nota), 1) / IsNull(p.vl_total_pedido_venda, 1)) * 100)) as 'Percentual',
    n.dt_coleta_nota_saida        as 'DataSolicitacao',
    n.dt_coleta_nota_saida        as 'CollectReqDate',
    n.dt_entrega_nota_saida       as 'DataColeta',
    n.dt_entrega_nota_saida       as 'CollectDate',
    Case
      When t.nm_fantasia = 'Cliente Retira' Then 'Customer picked it up'
    Else
      t.nm_fantasia
    End                           as 'Transporter',
    t.nm_fantasia                 as 'Transportadora'

  from
    Nota_Saida n
      left outer join
    Nota_Saida_item ni on n.cd_nota_saida = ni.cd_nota_saida
      left Outer Join
    Operacao_Fiscal op on n.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join
    Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
      left outer join
    Tipo_Destinatario td on n.cd_tipo_destinatario = td.cd_tipo_destinatario
      left outer join
    transportadora t on n.cd_transportadora = t.cd_transportadora
      left outer join
    Pedido_Venda p on ni.cd_pedido_venda = p.cd_pedido_venda
      Inner Join
    Pedido_Venda_item pvi on ni.cd_pedido_venda = pvi.cd_pedido_venda and ni.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  where
    ((@ic_comercial_operacao = '') or (op.ic_comercial_operacao = @ic_comercial_operacao))
    and gop.cd_tipo_operacao_fiscal = 2
    and p.dt_pedido_venda between @dt_inicial and @dt_final
    and IsNull(pvi.qt_saldo_pedido_venda,0) = 0 
    and n.dt_nota_dev_nota_saida is null
    and n.dt_cancel_nota_saida is null
  Group By
    td.cd_tipo_destinatario,
    td.nm_tipo_destinatario,
    n.nm_fantasia_destinatario,
    p.cd_pedido_venda,
    pvi.cd_pedido_venda,
    p.dt_pedido_venda,
    p.vl_total_pedido_venda,
    n.cd_nota_saida,
    n.dt_nota_saida,
--     ni.vl_unitario_item_nota,
--     ni.qt_item_nota_saida,
    n.dt_coleta_nota_saida,
    n.dt_entrega_nota_saida,
    t.nm_fantasia
  Order by
    pvi.cd_pedido_venda
--     p.dt_pedido_venda

End

If @ic_parametro = 2
Begin

  select 
    td.nm_tipo_destinatario     as 'TipoDestinatario',
    Case td.cd_tipo_destinatario
      When 1 Then 'Customer'
      When 2 Then 'Supplier'
      When 3 Then 'Salesman'
      When 4 Then 'Transporter'
      When 5 Then 'Representative'
      When 6 Then 'Employee'
    Else
      'Others'
    End as 'KindofAddressee',
    n.nm_fantasia_destinatario    as 'Destinatario',
    n.nm_fantasia_destinatario    as 'Addressee',

    IsNull(pvi.nm_fantasia_produto, ni.nm_fantasia_produto) as 'Produto',
    IsNull(pvi.nm_fantasia_produto, ni.nm_fantasia_produto) as 'PartNumber',
    IsNull(p.cd_pedido_venda, 0)  as 'Pedido',
    IsNull(p.cd_pedido_venda, 0)  as 'OrderNo', 
    IsNull(pvi.cd_item_pedido_venda, 0)  as 'ItemPedido', 
    IsNull(pvi.cd_item_pedido_venda, 0)  as 'OrderItem', 
    p.dt_pedido_venda             as 'DataPedido',
    p.dt_pedido_venda             as 'OrderDate',
    IsNull((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) , 0) as 'ValorItem',
    IsNull((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) , 0) as 'ItemAmount',
    pvi.dt_entrega_vendas_pedido  as 'DataEntregaItem',
    pvi.dt_entrega_vendas_pedido  as 'EstimatedDeliveryDate',
    n.cd_nota_saida               as 'NF',
    n.cd_nota_saida               as 'InvoiceNo',
    ni.cd_item_nota_saida         as 'ItemNF',
    ni.cd_item_nota_saida         as 'InvoiceItem',
    n.dt_nota_saida               as 'DataNF',
    n.dt_nota_saida               as 'InvoiceDate',
    n.vl_total                    as 'ValorNF',
    n.vl_total                    as 'InvoiceAmount',
    n.dt_coleta_nota_saida        as 'DataSolicitacao',
    n.dt_coleta_nota_saida        as 'CollectReqDate',
    n.dt_entrega_nota_saida       as 'DataColeta',
    n.dt_entrega_nota_saida       as 'CollectDate',
    Case
      When t.nm_fantasia = 'Cliente Retira' Then 'Customer picked it up'
    Else
      t.nm_fantasia
    End                           as 'Transporter',
    t.nm_fantasia                 as 'Transportadora'

  from
    Nota_Saida n
      left outer join
    Nota_Saida_item ni on n.cd_nota_saida = ni.cd_nota_saida
      left Outer Join
    Operacao_Fiscal op on n.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join
    Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
      left outer join
    Tipo_Destinatario td on n.cd_tipo_destinatario = td.cd_tipo_destinatario
      left outer join
    transportadora t on n.cd_transportadora = t.cd_transportadora
      left outer join
    Pedido_Venda p on ni.cd_pedido_venda = p.cd_pedido_venda
      Left Outer Join
    Pedido_Venda_item pvi on ni.cd_pedido_venda = pvi.cd_pedido_venda and ni.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  where
    ((@ic_comercial_operacao = '') or (op.ic_comercial_operacao = @ic_comercial_operacao))
    and gop.cd_tipo_operacao_fiscal = 2
    and pvi.qt_saldo_pedido_venda >= 0
    and n.dt_saida_nota_saida between @dt_inicial and @dt_final
    and n.dt_nota_dev_nota_saida is null
    and n.dt_cancel_nota_saida is null

end
