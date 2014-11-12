
CREATE PROCEDURE pr_consulta_consignacao_pedido_venda
-------------------------------------------------------------------------------
--pr_consulta_consignacao_pedido_venda
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                	                   2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server   2000
--Autor(es)             : Igor Gama
--Banco de Dados        : EgisSQL
--Objetivo              : Consulta de Pedidos para Consignação
--Data                  : 26/02/2003
--Atualizado            : 01.08.2003
--		        : Fabio
--Descritivo            : Foi adicionada a coluna de valor do IPI e total com IPI
--                      : 04/08/2003 - Inclusão do Parâmetro 4 para Dados do Relatório na GRId.
--                                   - Daniel C. Neto.
--                      : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 29/01/2007 - Adicionando pesquisa por cliente e status - Anderson.
--                      : 30.03.2007 - Verificação do order by - Carlos Fernandes
--                      : 30.05.2007 - Data de Ativação - Carlos Fernandes
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
---------------------------------------------------------------------------------------------------
@ic_parametro     int = 0,
@cd_pedido_venda  int = 0,
@cd_cliente       int = 0,
@cd_status_pedido int = 0,
@dt_inicial       datetime,
@dt_final         datetime

AS
-- =============================================
If @ic_parametro = 1
--  Consulta do pedido
-- =============================================
Begin

  Select
    c.nm_fantasia_cliente,
    tp.nm_tipo_pedido,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.vl_total_pedido_venda,
    pv.vl_total_ipi,
    pv.vl_total_pedido_ipi,
    vi.nm_fantasia_vendedor nm_vendedor_interno,
    ve.nm_fantasia_vendedor nm_vendedor_externo,
    cp.nm_condicao_pagamento,
    pv.dt_cancelamento_pedido,
    pv.dt_ativacao_pedido,
    pv.ds_cancelamento_pedido,
    pv.dt_alteracao_pedido_venda,
    pv.nm_alteracao_pedido_venda,
    sp.nm_status_pedido,
--    ns.cd_nota_saida,
    case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
    else
         ns.cd_nota_saida                  
    end                                   as 'cd_nota_saida',

    ns.dt_nota_saida,
    isnull((Select Sum(qt_item_nota_saida  )  from Nota_saida_Item   where (Nota_Saida_Item.cd_pedido_venda = pv.cd_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7))) -
           (Select Sum(qt_saldo_pedido_venda) from Pedido_venda_Item where (Pedido_Venda_Item.cd_pedido_venda = pv.cd_pedido_venda)),0) as Saldo
   
  From
    Pedido_Venda pv                       with (nolock) 
    Left Outer Join Cliente c             on pv.cd_cliente            = c.cd_cliente
    Left Outer Join Tipo_Pedido tp        on pv.cd_tipo_pedido        = tp.cd_tipo_pedido
    Left Outer Join Status_Pedido sp      on pv.cd_status_pedido      = sp.cd_status_pedido
    Left Outer Join Vendedor vi           on pv.cd_vendedor           = vi.cd_vendedor
    Left Outer Join Vendedor ve           on pv.cd_vendedor           = ve.cd_vendedor
    Left Outer Join Condicao_Pagamento cp on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento
    Left Outer Join Nota_Saida ns         on ns.cd_pedido_venda       = pv.cd_pedido_venda
  Where
    ( @cd_pedido_venda <> 0 or pv.dt_pedido_venda Between @dt_inicial and @dt_final) and 
    ( @cd_pedido_venda  = 0 or pv.cd_pedido_venda = @cd_pedido_venda   ) and
    ( @cd_cliente       = 0 or pv.cd_cliente = @cd_cliente             ) and
    ( @cd_status_pedido = 0 or pv.cd_status_pedido = @cd_status_pedido ) and
      IsNull(pv.ic_consignacao_pedido, 'N') = 'S'                        and
      pv.dt_cancelamento_pedido is null

  order by
    c.nm_fantasia_cliente,
    pv.dt_pedido_venda


end

-- =============================================
If @ic_parametro = 2
--  Consulta para os itens do pedido
-- =============================================

Begin

  select
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.qt_item_pedido_venda,
    pvi.qt_saldo_pedido_venda,
    pvi.dt_entrega_vendas_pedido,
    pvi.dt_entrega_fabrica_pedido,
    pvi.ds_produto_pedido_venda,
    pvi.vl_unitario_item_pedido,
    pvi.pc_desconto_item_pedido,
    pvi.qt_liquido_item_pedido,
    pvi.qt_bruto_item_pedido,
    pvi.dt_cancelamento_item,
    IsNull(pvi.nm_mat_canc_item_pedido, pvi.nm_mot_canc_item_pedido) nm_mot_canc_item_pedido,
    IsNull(pvi.pc_ipi, pvi.pc_ipi_item) pc_ipi,
    IsNull(pvi.pc_icms, pvi.pc_icms_item) pc_icms,
    pvi.dt_necessidade_cliente,
    pvi.qt_dia_entrega_cliente,
    pvi.dt_entrega_cliente,
    pvi.ic_smo_item_pedido_venda,
    pvi.ds_produto_pedido,
    pvi.nm_produto_pedido,
    pvi.nm_fantasia_produto,
    pvi.dt_ativacao_item,
    pvi.nm_mot_ativ_item_pedido,
    um.sg_unidade_medida,
    (Select top 1 cd_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as cd_nota_saida,
    (Select top 1 cd_item_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as cd_item_nota_saida,
    (Select top 1 dt_nota_saida from Nota_saida where cd_nota_saida = (Select top 1 cd_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida)) as dt_nota_saida,
    (Select top 1 qt_item_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as qt_item_nota_saida
  From
    Pedido_Venda_Item pvi
    Left Outer Join Unidade_Medida um on pvi.cd_unidade_medida = um.cd_unidade_medida
  Where
    pvi.cd_pedido_venda = @cd_pedido_venda and
    pvi.dt_cancelamento_item is null

  order by
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda


End
-- =============================================
if @ic_parametro = 3
--  Consulta para o relatório
-- =============================================
Begin

  Select
    c.nm_fantasia_cliente,
    tp.nm_tipo_pedido,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.vl_total_pedido_venda,
    pv.vl_total_ipi,
    pv.vl_total_pedido_ipi,
    vi.nm_fantasia_vendedor nm_vendedor_interno,
    ve.nm_fantasia_vendedor nm_vendedor_externo,
    cp.nm_condicao_pagamento,
    pv.dt_cancelamento_pedido,
    pv.ds_cancelamento_pedido,
    pv.dt_alteracao_pedido_venda,
    pv.nm_alteracao_pedido_venda,
    sp.nm_status_pedido,
    pvi.cd_item_pedido_venda,
    pvi.qt_item_pedido_venda,
    pvi.ds_produto_pedido_venda,
    pvi.vl_unitario_item_pedido,
    pvi.pc_desconto_item_pedido,	
    IsNull(pvi.pc_ipi, pvi.pc_ipi_item) pc_ipi,
    IsNull(pvi.pc_icms, pvi.pc_icms_item) pc_icms,
    pvi.dt_necessidade_cliente,	
    IsNull(RTrim(LTrim(pvi.nm_fantasia_produto)), '') + 
    IsNull(' - '+LTrim(RTrim(pvi.nm_produto_pedido)),'') nm_produto,	
    um.sg_unidade_medida,
    (Select top 1 cd_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as cd_nota_saida,
    (Select top 1 cd_item_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as cd_item_nota_saida,
    (Select top 1 dt_nota_saida from Nota_saida where cd_nota_saida = (Select top 1 cd_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida)) as dt_nota_saida,
    (Select top 1 qt_item_nota_saida from Nota_saida_Item where (Nota_Saida_Item.cd_pedido_venda = pvi.cd_pedido_venda) and (Nota_Saida_Item.cd_item_pedido_venda = pvi.cd_item_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7)) order by cd_nota_saida) as qt_item_nota_saida
  From
    Pedido_Venda pv
    Left Outer Join Pedido_Venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda
    Left Outer Join Cliente c             on pv.cd_cliente = c.cd_cliente
    Left Outer Join Tipo_Pedido tp        on pv.cd_tipo_pedido = tp.cd_tipo_pedido
    Left Outer Join Status_Pedido sp      on pv.cd_status_pedido = sp.cd_status_pedido
    Left Outer Join Vendedor vi           on pv.cd_vendedor = vi.cd_vendedor
    Left Outer Join Vendedor ve           on pv.cd_vendedor = ve.cd_vendedor
    Left Outer Join Condicao_Pagamento cp on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento
    Left Outer Join Unidade_Medida um     on pvi.cd_unidade_medida = um.cd_unidade_medida
  Where
    pv.cd_pedido_venda = @cd_pedido_venda and IsNull(pv.ic_consignacao_pedido, 'N') = 'S' and
    pv.dt_cancelamento_pedido is null

  order by
    c.nm_fantasia_cliente,
    pv.dt_pedido_venda


End

-- =============================================
If @ic_parametro = 4
--  Dados para o Relatório da GRID
-- =============================================
Begin

  Select
    c.nm_fantasia_cliente,
    tp.sg_tipo_pedido,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.vl_total_pedido_venda,
    pv.vl_total_ipi,
    pv.vl_total_pedido_ipi,
    vi.nm_fantasia_vendedor nm_vendedor_interno,
    ve.nm_fantasia_vendedor nm_vendedor_externo,
    cp.sg_condicao_pagamento,
    pv.dt_cancelamento_pedido,
    pv.ds_cancelamento_pedido,
    pv.dt_alteracao_pedido_venda,
    pv.nm_alteracao_pedido_venda,
    sp.sg_status_pedido,
    ns.cd_nota_saida,
    ns.dt_nota_saida,
    isnull((Select Sum(qt_item_nota_saida  ) from Nota_saida_Item   where (Nota_Saida_Item.cd_pedido_venda = pv.cd_pedido_venda) and (Nota_Saida_Item.cd_status_nota not in(4,7))) -
           (Select Sum(qt_item_pedido_venda) from Pedido_venda_Item where (Pedido_Venda_Item.cd_pedido_venda = pv.cd_pedido_venda)),0) as Saldo
  From
    Pedido_Venda pv 
    Left Outer Join Cliente c             on pv.cd_cliente = c.cd_cliente 
    Left Outer Join Tipo_Pedido tp        on pv.cd_tipo_pedido = tp.cd_tipo_pedido 
    Left Outer Join Status_Pedido sp      on pv.cd_status_pedido = sp.cd_status_pedido 
    Left Outer Join Vendedor vi           on pv.cd_vendedor = vi.cd_vendedor 
    Left Outer Join Vendedor ve           on pv.cd_vendedor = ve.cd_vendedor 
    Left Outer Join Condicao_Pagamento cp on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
    Left Outer Join Nota_Saida ns         on ns.cd_pedido_venda = pv.cd_pedido_venda
  Where
    ( @cd_pedido_venda <> 0 or pv.dt_pedido_venda Between @dt_inicial and @dt_final) and
    ( @cd_pedido_venda  = 0 or pv.cd_pedido_venda = @cd_pedido_venda   ) and
    ( @cd_cliente       = 0 or pv.cd_cliente = @cd_cliente             ) and
    ( @cd_status_pedido = 0 or pv.cd_status_pedido = @cd_status_pedido ) and
      IsNull(pv.ic_consignacao_pedido, 'N') = 'S'                        and
      pv.dt_cancelamento_pedido is null

  order by
    c.nm_fantasia_cliente,
    pv.dt_pedido_venda

End

