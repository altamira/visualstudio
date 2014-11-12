
CREATE PROCEDURE pr_pedido_venda_consulta
--pr_pedido_venda_consulta
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Pedido_Venda
--Data: 14/03/2002
--Atualizado: 15/03/2002 - Igor Gama
---------------------------------------------------
@ic_parametro as int,
@cd_pedido_venda as int,
@dt_inicial as DateTime,
@dt_final as DateTime
AS

--------------------------------------------------------------------------------------------
--  ic_parametro = 1 - Realiza a Consulta do Pedido
--------------------------------------------------------------------------------------------  

  If @ic_parametro = 1
  Begin

    SELECT     
      ped.cd_pedido_venda,
      ped.dt_pedido_venda,
      ped.cd_vendedor_pedido,
      (Select nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_pedido) as 'nm_vendedor_externo',
      ped.cd_vendedor_interno,
      (Select nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
      ped.dt_cancelamento_pedido,
      ped.ds_cancelamento_pedido,
      IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
      CAST(ped.vl_total_pedido_venda as numeric(25,2)) as 'vl_total_pedido_venda', 
      ped.qt_liquido_pedido_venda, 
      ped.qt_bruto_pedido_venda, 
      pvi.cd_item_pedido_venda, 
      pvi.dt_item_pedido_venda, 
      pvi.qt_item_pedido_venda, 
      pvi.qt_saldo_pedido_venda, 
      pvi.dt_entrega_vendas_pedido,
      pvi.dt_entrega_fabrica_pedido,
      CAST(pvi.vl_unitario_item_pedido as numeric(25,2)) as 'vl_unitario_item_pedido', 
      ped.nm_alteracao_pedido_venda,
      Case When ped.nm_alteracao_pedido_venda is not null then ped.dt_usuario Else null end as 'dt_ult_alteracao',
      cli.cd_cliente, 
      cli.nm_fantasia_cliente, 
      cli.nm_razao_social_cliente,
      ped.cd_tipo_restricao_pedido, 
      trp.nm_tipo_restricao_pedido as nm_tipo_restricao, 
      trp.sg_tipo_restricao,  
      ped.cd_tipo_pedido, 
      (Select nm_tipo_pedido From Tipo_pedido Where cd_tipo_pedido = ped.cd_tipo_pedido) as 'nm_tipo_pedido',
      ped.cd_vendedor, 
      ped.cd_contato, 
      (Select nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',
      prod.cd_mascara_produto,
      prod.cd_produto,
      prod.nm_fantasia_produto,
      cop.nm_condicao_pagamento,
      cop.sg_condicao_pagamento,
      cop.qt_parcela_condicao_pgto,
      nfs.cd_nota_saida,
      nfs.dt_nota_saida,
      (nsi.vl_unitario_item_nota * nsi.qt_item_nota_saida) as 'qt_Qtdade',
      nfs.qt_volume_nota_saida
    FROM
      Pedido_venda ped 
    Left Outer Join
      Pedido_Venda_Item pvi on ped.cd_pedido_venda = pvi.cd_pedido_Venda
    Left Outer Join 
      Cliente cli on ped.cd_cliente = cli.cd_cliente
    left outer Join
      Tipo_Restricao_Pedido trp on ped.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido
    Left Outer Join 
      Produto prod on pvi.cd_produto = prod.cd_produto
    Left Outer Join
      Condicao_Pagamento cop on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
    Left Outer Join
      Nota_Saida_Item nsi on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                             nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    Left Outer Join
      Nota_Saida nfs on nsi.cd_nota_saida = nfs.cd_nota_saida              
    WHERE     
      ped.dt_pedido_venda BETWEEN @dt_inicial AND @dt_final and     
      ped.cd_pedido_venda = @cd_pedido_venda

    ORDER BY
      ped.cd_pedido_venda

  End Else
  If @ic_parametro = 2
  Begin
    print('Atenção, não existe consulta para esse parâmetro!')
  End

