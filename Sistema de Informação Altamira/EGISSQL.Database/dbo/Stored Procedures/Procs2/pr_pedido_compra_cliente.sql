
CREATE PROCEDURE pr_pedido_compra_cliente

@ic_filtro char(1),
@cd_cliente int,
@cd_pedido_compra varchar(20),
@dt_inicial datetime,
@dt_final datetime

AS

  declare @vl_total float
  declare @vl_total_canc float

  set @vl_total = ( select 
                      sum((case when(it.dt_cancelamento_item is null) 
                                then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) 
                           else 0 end)) 
                    from Pedido_Venda pe Left Outer Join
                         Pedido_Venda_Item it on pe.cd_pedido_venda = it.cd_pedido_venda 
                    Where
                      pe.dt_pedido_venda between @dt_inicial and @dt_final and
                     (pe.cd_cliente = @cd_cliente) and
                     ( (it.cd_pdcompra_item_pedido like @cd_pedido_compra + '%' and @ic_filtro = 'P') or
                       (it.cd_os_tipo_pedido_venda like @cd_pedido_compra + '%' and @ic_filtro = 'O') or
                       (it.cd_posicao_item_pedido  like @cd_pedido_compra + '%' and @ic_filtro = 'S') ) )


  set @vl_total_canc = ( select 
                      sum((case when (it.dt_cancelamento_item is not null) 
                                then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) 
                           else 0 end)) 
                    from Pedido_Venda pe Left Outer Join
                         Pedido_Venda_Item it on pe.cd_pedido_venda = it.cd_pedido_venda 
                    Where
                      pe.dt_pedido_venda between @dt_inicial and @dt_final and
                     (pe.cd_cliente = @cd_cliente) and
                     ( (it.cd_pdcompra_item_pedido like @cd_pedido_compra + '%' and @ic_filtro = 'P') or
                       (it.cd_os_tipo_pedido_venda like @cd_pedido_compra + '%' and @ic_filtro = 'O') or
                       (it.cd_posicao_item_pedido  like @cd_pedido_compra + '%' and @ic_filtro = 'S') ) )

    Select
      case when @ic_filtro = 'P' 
           then it.cd_pdcompra_item_pedido
           when @ic_filtro = 'O'
           then it.cd_os_tipo_pedido_venda
	   when @ic_filtro = 'S'
	   then it.cd_posicao_item_pedido end as 'PedidoCompra',

      pe.cd_pedido_venda,
      pe.dt_pedido_venda,
      pe.cd_cliente,
      pe.dt_cancelamento_pedido,
      pe.ds_cancelamento_pedido,
      case when(it.dt_cancelamento_item is null) then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_pedido',
      case when (it.dt_cancelamento_item is not null) then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_totalcanc',
      pe.cd_vendedor,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = pe.cd_vendedor) as 'nm_fantasia_vendedor',
      pe.cd_vendedor_interno,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = pe.cd_vendedor_interno) as 'nm_fantasia_vendedor_interno',
      IsNull(pe.ic_fatsmo_pedido, 'N') as 'ic_fatsmo_pedido', 
      IsNull(po.cd_produto,se.cd_servico) as 'cd_produto',
      IsNull(it.nm_fantasia_produto,se.nm_servico) as 'nm_fantasia_produto',
      it.cd_item_pedido_venda,
      it.qt_item_pedido_venda, it.dt_entrega_fabrica_pedido, 
      it.vl_unitario_item_pedido, it.pc_desconto_item_pedido,   
      it.dt_entrega_vendas_pedido,
      it.qt_saldo_pedido_venda,
      IsNull(it.nm_produto_pedido,cast(se.ds_servico as varchar(50))) as 'nm_produto_pedido',
      case when(it.dt_cancelamento_item is not null)       then 'C'
           when(isnull(it.ic_libpcp_item_pedido,'N')= 'S') then 'S' 
      else 'N' end as ic_libpcp_item_pedido,
      co.nm_condicao_pagamento,
      co.sg_condicao_pagamento,
      co.qt_parcela_condicao_pgto,
      ct.nm_fantasia_contato,
      ct.nm_contato_cliente,
      c.cd_cliente,
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente,
      (IsNull(c.cd_ddd,'') + ' ' + IsNull(c.cd_telefone,'')) as 'cd_telefone',
      nf.cd_nota_saida,
      nf.dt_nota_saida,
      st.sg_status_pedido,
      tp.sg_tipo_pedido,
      it.cd_consulta,
      it.cd_item_consulta,
      tr.nm_fantasia as nm_fantasia_trasportadora,
      dest.nm_destinacao_produto,
      ISNULL(pe.ic_consignacao_pedido,'N') as ic_consignacao_pedido,
      ISNULL(pe.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,
      @vl_total as 'TotalPedido',
      @vl_total_canc as 'TotalPedidoCanc'
    From
      Pedido_Venda pe Left Outer Join
      Pedido_Venda_Item it on pe.cd_pedido_venda = it.cd_pedido_venda Left Outer Join
      Produto po on it.cd_produto = po.cd_produto Left Outer Join
      Nota_Saida_Item nfi on it.cd_pedido_venda = nfi.cd_pedido_venda and
                             it.cd_item_pedido_venda = nfi.cd_item_pedido_venda Left Outer Join
      Nota_Saida nf on nfi.cd_nota_saida = nf.cd_nota_saida Left Outer Join
      Cliente c on pe.cd_cliente = c.cd_cliente Left Outer Join
     (Select * 
      from Cliente_Endereco 
      where cd_tipo_endereco = 1) ce  on c.cd_cliente = ce.cd_cliente Left Outer Join
      Condicao_pagamento co on pe.cd_condicao_pagamento = co.cd_condicao_pagamento Left Outer Join
      Cliente_Contato ct on pe.cd_contato = ct.cd_contato and 
                            pe.cd_cliente = ct.cd_cliente Left Outer Join
      Status_Pedido st on pe.cd_status_pedido = st.cd_status_pedido Left Outer Join
      Tipo_Pedido tp on pe.cd_tipo_pedido = tp.cd_tipo_pedido LEFT OUTER JOIN
      Servico se ON it.cd_servico = se.cd_servico LEFT OUTER JOIN
      Transportadora tr on pe.cd_transportadora = tr.cd_transportadora LEFT OUTER JOIN
      Destinacao_Produto dest ON pe.cd_destinacao_produto = dest.cd_destinacao_produto 
   where
      pe.cd_cliente = @cd_cliente and
      it.dt_item_pedido_venda between @dt_inicial and @dt_final and
      ( (it.cd_pdcompra_item_pedido like @cd_pedido_compra + '%' and @ic_filtro = 'P') or
        (it.cd_os_tipo_pedido_venda like @cd_pedido_compra + '%' and @ic_filtro = 'O') or
        (it.cd_posicao_item_pedido  like @cd_pedido_compra + '%' and @ic_filtro = 'S') )
   

