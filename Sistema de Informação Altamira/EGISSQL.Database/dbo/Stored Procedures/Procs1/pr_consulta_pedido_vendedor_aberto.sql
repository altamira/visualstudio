
CREATE procedure pr_consulta_pedido_vendedor_aberto
-----------------------------------------------------------------------------------
--pr_consulta_pedido_vendedor_aberto
-----------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                          2004
-----------------------------------------------------------------------------------                     
--Stored Procedure        : SQL Server Microsoft 2000
--Autor(es)               : Anderson Messias da Silva
--Banco de Dados          : EgisSql ou EgisAdmin
--Objettivo               : Pedidos em aberto por vendedor
--Data                    : 21/02/2007
--Atualizado              : 21.08.2008 - Ajuste da Consulta - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
@cd_parametro int      = 1,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_vendedor  int      = 0
as

declare @dt_perc_smo datetime
set @dt_perc_smo = '08/01/2000'

if @cd_parametro = 1
Begin
  select 
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.dt_entrega_fabrica_pedido,
    pvi.cd_categoria_produto, 
    pvi.qt_saldo_pedido_venda,
    pvi.dt_cancelamento_item,
    pvi.dt_entrega_vendas_pedido as dt_entrega_pedido,
   (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) as vl_total_saldo_aberto,
    pc.nm_fantasia_prod_cliente
  -------
  into 
    #Pedidos_Com_Saldo 
  -------
  from 
    Pedido_Venda_Item pvi with (nolock) 

  inner join Pedido_Venda pv           with (nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
  inner join Cliente c                 with (nolock) on pv.cd_cliente = c.cd_cliente
  left outer join Produto_Cliente pc   with (nolock) on pc.cd_cliente =  pv.cd_cliente and
                                                        pc.cd_produto = pvi.cd_produto
  where
    pv.dt_pedido_venda <= @dt_final and
    isnull(pvi.qt_saldo_pedido_venda,0) > 0.00 and
   (pvi.dt_cancelamento_item is null or
    pvi.dt_cancelamento_item > @dt_final) and
--     pvi.cd_item_pedido_venda <= ( case IsNull(c.cd_pais,1) 
--                                     when 1 then 80
--                                     else  pvi.cd_item_pedido_venda
--                                   end ) and --Limita os pedidos nacionais até 80, devido a uma regra de negócio aplicada
    isnull(pv.ic_consignacao_pedido,'N') <> 'S' and
    pv.cd_status_pedido in (1,2) and
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    isnull(pv.cd_vendedor_pedido,0) = case when isnull( @cd_vendedor,0 )=0 then isnull(pv.cd_vendedor_pedido,0) else @cd_vendedor end

  select
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.dt_entrega_fabrica_pedido,
    pvi.cd_categoria_produto,
    nsi.qt_item_nota_saida as qt_saldo_faturado,
    (nsi.qt_item_nota_saida * pvi.vl_unitario_item_pedido) as vl_total_saldo_faturado,
    pvi.qt_saldo_pedido_venda,
    pvi.dt_cancelamento_item,
    pvi.dt_entrega_vendas_pedido as dt_entrega_pedido
  -------
  into 
    #Pedidos_Faturados
  -------
  from 
    Pedido_Venda_Item pvi, 
    Pedido_Venda pv,
    Nota_Saida_Item nsi, 
    Nota_Saida ns, 
    Operacao_Fiscal op
  where 
   (pvi.dt_cancelamento_item is null or
    pvi.dt_cancelamento_item > @dt_final) and
   (pvi.qt_saldo_pedido_venda = 0 or
   (pvi.qt_saldo_pedido_venda > 0 and
    pvi.qt_item_pedido_venda > pvi.qt_saldo_pedido_venda)) and
    pvi.cd_pedido_venda = pv.cd_pedido_venda and
    pv.dt_pedido_venda <= @dt_final and
    isnull(pv.ic_consignacao_pedido,'N') <> 'S' and
    pvi.cd_pedido_venda = nsi.cd_pedido_venda and
    pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda and
    nsi.cd_status_nota <> 7 and
    nsi.cd_nota_saida = ns.cd_nota_saida and
    ns.dt_nota_saida > @dt_final and 
    ns.cd_operacao_fiscal = op.cd_operacao_fiscal and
--     pvi.cd_item_pedido_venda <= ( case IsNull(ns.cd_pais,1) 
--                                     when 1 then 80 
--                                     else pvi.cd_item_pedido_venda
--                                   end ) and --Limita os pedidos nacionais até 80, devido a uma regra de negócio aplicada     
    isnull(op.ic_comercial_operacao,'N') = 'S' and
    pv.cd_status_pedido in (1,2) and
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    isnull(pv.cd_vendedor_pedido,0) = case when isnull( @cd_vendedor,0 )=0 then isnull(pv.cd_vendedor_pedido,0) else @cd_vendedor end

  --
  -- Resultado Final    
  --
  select 
    isnull(a.cd_pedido_venda,b.cd_pedido_venda)           as cd_pedido_venda,
    isnull(a.cd_item_pedido_venda,b.cd_item_pedido_venda) as cd_item_pedido_venda,
    pvi.dt_entrega_fabrica_pedido,
   (isnull(a.qt_saldo_pedido_venda,0) + 
    isnull(b.qt_saldo_faturado,0))                        as qt_saldo_pedido_venda,
    -- Valor total em aberto 
    vl_total_pedido_venda = isnull(a.vl_total_saldo_aberto,0) + isnull(b.vl_total_saldo_faturado,0),
    case when b.dt_entrega_pedido is null then pvi.dt_entrega_vendas_pedido
                                          else b.dt_entrega_pedido end      as dt_entrega_pedido,
    isnull(pv.ic_smo_pedido_venda,'N') ic_smo_pedido_venda,
    pv.cd_tipo_pedido,
    t.sg_tipo_pedido,
    t.nm_tipo_pedido,
    cli.nm_fantasia_cliente,
    pv.cd_vendedor                                        as 'cd_vendedor_pedido',
    ve.nm_fantasia_vendedor                               as 'nm_vendedor_externo',
    vi.nm_fantasia_vendedor                               as 'nm_vendedor_interno',
    pv.dt_pedido_venda,
    pvi.qt_item_pedido_venda,
    qt_item_pedido_venda_canc =
    case when (a.dt_cancelamento_item is not null) then pvi.qt_item_pedido_venda else 0 end,
    pv.qt_liquido_pedido_venda,
    pv.qt_bruto_pedido_venda,
    pvi.pc_desconto_item_pedido,
    pvi.nm_produto_pedido,
    pvi.nm_fantasia_produto,
    pvi.ic_libpcp_item_pedido,
    pvi.ic_progfat_item_pedido,
    Desconto = 
    case when (pvi.vl_lista_item_pedido>0 and pvi.vl_unitario_item_pedido>0) then
       case 
         when (isnull(pv.ic_smo_pedido_venda,'N') = 'S' and pv.dt_pedido_venda < @dt_perc_smo) then 
            (100-(pvi.vl_unitario_item_pedido/(pvi.vl_lista_item_pedido-(pvi.vl_lista_item_pedido*11/100)))*100)
         when (isnull(pv.ic_smo_pedido_venda,'N') = 'S' and pv.dt_pedido_venda >= @dt_perc_smo) then 
            (100-(pvi.vl_unitario_item_pedido/(pvi.vl_lista_item_pedido-(pvi.vl_lista_item_pedido*8.8/100)))*100)
         else 
            (100-(pvi.vl_unitario_item_pedido/pvi.vl_lista_item_pedido)*100)
       end
    end, 
    pvi.vl_unitario_item_pedido, 
    vl_totalcanc =
    case when (a.dt_cancelamento_item is not null) then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) else 0 end,
    sp.nm_status_pedido,
    sp.sg_status_pedido,
    isnull(pro.cd_mascara_produto,cast(pvi.cd_grupo_produto as char(2))+'9999999') as 'Codigo_Produto',
    m.sg_moeda,
    Isnull(pvi.vl_moeda_cotacao,0) as vl_moeda_cotacao,
    pvi.dt_moeda_cotacao,
    case 
      when(Isnull(pvi.vl_moeda_cotacao,0) = 0) 
      then  0
       else round((pvi.vl_unitario_item_pedido / pvi.vl_moeda_cotacao),2)
    end AS vl_unitario_moeda,
    case 
      when(Isnull(pvi.vl_moeda_cotacao,0) = 0) 
      then  0
       else round(((pvi.qt_item_pedido_venda * pvi.vl_Unitario_item_pedido) / pvi.vl_moeda_cotacao),2)
    end AS vl_total_item_moeda,
    cg.nm_cliente_grupo as GrupoCliente,
    pc.nm_fantasia_prod_cliente,
    dbo.fn_ultima_ordem_producao_item_pedido(pvi.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo
  from
    #Pedidos_Com_Saldo a   
    full outer join #Pedidos_Faturados b on a.cd_pedido_venda = b.cd_pedido_venda and
                                            a.cd_item_pedido_venda = b.cd_item_pedido_venda 
    inner join Pedido_Venda_Item pvi     on isnull(a.cd_pedido_venda,b.cd_pedido_venda) = pvi.cd_pedido_venda and
                                            isnull(a.cd_item_pedido_venda,b.cd_item_pedido_venda) = pvi.cd_item_pedido_venda
    inner join Pedido_Venda pv           on pvi.cd_pedido_venda = pv.cd_pedido_venda
    left outer join Produto pro          on pvi.cd_produto = pro.cd_produto
    left outer join Tipo_Pedido t        on pv.cd_tipo_pedido = t.cd_tipo_pedido
    left outer join Cliente cli          on pv.cd_cliente = cli.cd_cliente 
    left outer join Status_Pedido sp     on pv.cd_status_pedido = sp.cd_status_pedido 
    left Outer Join Vendedor vi          on pv.cd_vendedor_interno = vi.cd_vendedor 
    left Outer Join Vendedor ve          on  pv.cd_vendedor = ve.cd_vendedor    
    left outer join moeda m              on (pvi.cd_moeda_cotacao = m.cd_moeda)
    left outer join cliente_grupo cg     on cg.cd_cliente_grupo = cli.cd_cliente_grupo
    left outer join Produto_Cliente pc   on pc.cd_cliente =  pv.cd_cliente and
                                            pc.cd_produto = pvi.cd_produto
  order by
    a.nm_vendedor_externo,
    a.dt_entrega_pedido,
    a.cd_pedido_venda desc,
    a.cd_item_pedido_venda
end

