

/****** Object:  Stored Procedure dbo.pr_consulta_pedido_venda_produto    Script Date: 13/12/2002 15:08:22 ******/

CREATE PROCEDURE pr_consulta_pedido_venda_produto
-------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Adriano Levy
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Pedido Venda por produto
--Data: 12/08/2002
-------------------------------------------------------
@nm_Fantasia_Produto as varchar(40),
@dt_inicial as DateTime,
@dt_final as DateTime
AS

    SELECT     
      ped.cd_pedido_venda,
      ped.dt_pedido_venda,
      ped.cd_vendedor as cd_vendedor_pedido, 
      (Select nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
      ped.cd_vendedor_interno,
      (Select nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
      ped.dt_cancelamento_pedido,
      ped.ds_cancelamento_pedido,
      IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
      CAST((qt_item_pedido_venda * vl_unitario_item_pedido) as numeric(25,2)) as 'vl_total_pedido_venda', 
      ped.qt_liquido_pedido_venda, 
      ped.qt_bruto_pedido_venda, 
      pvi.cd_item_pedido_venda, 
      pvi.dt_item_pedido_venda, 
      pvi.qt_item_pedido_venda, pvi.pc_desconto_item_pedido, 
      pvi.qt_saldo_pedido_venda, 
      pvi.dt_entrega_vendas_pedido,
      pvi.dt_entrega_fabrica_pedido, 
      CAST(pvi.vl_unitario_item_pedido as numeric(25,2)) as 'vl_unitario_item_pedido', 
      ped.nm_alteracao_pedido_venda,
      CONVERT(char(10),ped.dt_alteracao_pedido_venda, 103) as 'dt_ult_alteracao',
      cli.cd_cliente, 
      cli.nm_fantasia_cliente, 
      cli.nm_razao_social_cliente,
      ped.cd_tipo_restricao_pedido, 
      trp.nm_tipo_restricao_pedido, 
      trp.sg_tipo_restricao,  
      tp.cd_tipo_pedido, 
      tp.nm_tipo_pedido,
      st.sg_status_pedido,
      st.nm_status_pedido,
      ped.cd_vendedor, 
      ped.cd_contato, 
      (Select nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',
      prod.cd_mascara_produto,
      prod.cd_produto,
      pvi.nm_fantasia_produto, pvi.nm_produto_pedido, 
      cop.nm_condicao_pagamento,
      cop.sg_condicao_pagamento,
      cop.qt_parcela_condicao_pgto,
      nfs.cd_nota_saida,
      nfs.dt_nota_saida,
      (nsi.vl_unitario_item_nota * nsi.qt_item_nota_saida) as 'qt_Qtdade',
      nfs.qt_volume_nota_saida
    FROM
      Pedido_venda ped Left Outer Join
      Pedido_Venda_Item pvi on ped.cd_pedido_venda = pvi.cd_pedido_Venda Left Outer Join 
      Cliente cli on ped.cd_cliente = cli.cd_cliente left outer Join
      Tipo_Restricao_Pedido trp on ped.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido Left Outer Join 
      Produto prod on pvi.cd_produto = prod.cd_produto Left Outer Join
      Condicao_Pagamento cop on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento Left Outer Join
      Nota_Saida_Item nsi on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                             nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda Left Outer Join
      Nota_Saida nfs on nsi.cd_nota_saida = nfs.cd_nota_saida Left Outer Join
      Status_Pedido st on st.cd_status_pedido = ped.cd_status_pedido Left Outer Join
      Tipo_Pedido tp on tp.cd_tipo_pedido = ped.cd_tipo_pedido
    WHERE     
      ped.dt_pedido_venda BETWEEN @dt_inicial AND @dt_final and     
      pvi.nm_fantasia_produto like  @nm_Fantasia_Produto
    ORDER BY
      ped.dt_pedido_venda desc, ped.cd_pedido_venda desc, pvi.cd_item_pedido_venda



