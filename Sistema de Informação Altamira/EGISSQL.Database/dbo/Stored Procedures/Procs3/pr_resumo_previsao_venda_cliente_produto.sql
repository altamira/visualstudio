
CREATE PROCEDURE pr_resumo_previsao_venda_cliente_produto
@dt_inicial   datetime,
@dt_final     datetime,
@cd_cliente   int = 0,
@cd_produto   int = 0,
@cd_pais      int = 0,
@ic_parametro Char(1) = 'V'

as

--select * from previsao_venda
--select * from pedido_venda
--select * from previsao_venda_composicao


-------------------------------------------------------------------------------
--Cliente
-------------------------------------------------------------------------------
if @ic_parametro <> 'P'
Begin
  select
     c.cd_cliente,                          
     c.nm_fantasia_cliente                     as Cliente, 
     pd.cd_produto,                             
     pd.cd_mascara_produto                     as Codigo,
     pd.nm_fantasia_produto                    as Produto,
     max(pd.nm_produto)                        as Descricao,
     max(um.sg_unidade_medida)                 as Sigla,
     sum(isnull(pv.qt_programado_previsao,0))  as Programado,
     sum(isnull(pv.qt_potencial_previsao ,0))  as Potencial,
     Realizado = ( 
                 select 
                   sum(ip.qt_item_pedido_venda) 
                 from Pedido_Venda p 
                   left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                where 
                  p.cd_cliente = c.cd_cliente and
                  p.dt_pedido_venda between @dt_inicial and @dt_final and
                  ip.dt_cancelamento_item is null  ),

     --cast( 0 as float )                       as Realizado,
     sum(isnull(pv.qt_programado_previsao,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorProgramado,
     sum(isnull(pv.qt_potencial_previsao ,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorPotencial,
     --cast( 0 as float )                                                      as ValorRealizado,   
     --sum(isnull(iped.qt_item_pedido_venda ,0) * isnull(iped.vl_unitario_item_pedido,0)) as ValorRealizado,
     ValorRealizado = ( 
                 select 
                   sum(ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)
                 from Pedido_Venda p 
                   left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                where 
                  p.cd_cliente = c.cd_cliente and
                  p.dt_pedido_venda between @dt_inicial and @dt_final and
                  ip.dt_cancelamento_item is null  ),

     max(pvc.vl_unitario_previsao)            as Unitario,
     cast( 0 as float )                       as Unitario_Item_Pedido
     --max(iped.vl_unitario_item_pedido) as Unitario_Item_Pedido
  into
    #AuxPrevClienteProduto
  from
    Previsao_Venda pv
    left outer join Previsao_Venda_Composicao pvc on pvc.cd_previsao_venda = pv.cd_previsao_venda
    left outer join Cliente c                     on c.cd_cliente          = pv.cd_cliente
    left outer join Produto pd                    on pd.cd_produto         = pv.cd_produto
    left outer join Unidade_Medida um 		  on um.cd_unidade_medida  = pd.cd_unidade_medida

  where
    ((@cd_cliente = 0 ) or (c.cd_cliente = @cd_cliente)) and
    pv.dt_inicio_previsao_venda between @dt_inicial and @dt_final 

  group by
    c.cd_cliente,
    c.nm_fantasia_cliente,
    pd.cd_produto,
    pd.cd_mascara_produto,
    pd.nm_fantasia_produto


--  order by Programado desc

  select
    *,
    --ValorRealizado  = (Realizado * Unitario_Item_Pedido),
    PercAtingido    = (case when Programado      = 0 then 1 else Realizado      / Programado      end)*100,
    PerVlrRealizado = (case when ValorProgramado = 0 then 1 else ValorRealizado / ValorProgramado end)*100
  from
    #AuxPrevClienteProduto
  order by
    Programado desc
end
else
begin
  select
     Pais.cd_pais as cd_cliente,                          
     Pais.nm_pais                              as Cliente, 
     pd.cd_produto,                             
     pd.cd_mascara_produto                     as Codigo,
     pd.nm_fantasia_produto                    as Produto,
     max(pd.nm_produto)                        as Descricao,
     max(um.sg_unidade_medida)                 as Sigla,
     sum(isnull(pv.qt_programado_previsao,0))  as Programado,
     sum(isnull(pv.qt_potencial_previsao ,0))  as Potencial,
     Realizado = ( 
                 select 
                   sum(ip.qt_item_pedido_venda) 
                 from Pedido_Venda p 
                   left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                   left join Cliente c on (c.cd_cliente = p.cd_cliente)
                where 
                  c.cd_pais      = pais.cd_pais  and                  p.cd_cliente = c.cd_cliente and
                  p.dt_pedido_venda between @dt_inicial and @dt_final and
                  ip.dt_cancelamento_item is null  ),

     --cast( 0 as float )                       as Realizado,
     sum(isnull(pv.qt_programado_previsao,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorProgramado,
     sum(isnull(pv.qt_potencial_previsao ,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorPotencial,
     --cast( 0 as float )                                                      as ValorRealizado,   
     --sum(isnull(iped.qt_item_pedido_venda ,0) * isnull(iped.vl_unitario_item_pedido,0)) as ValorRealizado,
     ValorRealizado = ( 
                 select 
                   sum(ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)
                 from Pedido_Venda p 
                   left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                   left join Cliente c on (c.cd_cliente = p.cd_cliente)
                where 
                  c.cd_pais      = pais.cd_pais  and
                  p.dt_pedido_venda between @dt_inicial and @dt_final and
                  ip.dt_cancelamento_item is null  ),

     max(pvc.vl_unitario_previsao)            as Unitario,
     cast( 0 as float )                       as Unitario_Item_Pedido
     --max(iped.vl_unitario_item_pedido) as Unitario_Item_Pedido
  into
    #AuxPrevPaisProduto
  from
    Previsao_Venda pv
    left outer join Previsao_Venda_Composicao pvc on pvc.cd_previsao_venda = pv.cd_previsao_venda
    left outer join Cliente c                     on c.cd_cliente          = pv.cd_cliente
    left outer join Produto pd                    on pd.cd_produto         = pv.cd_produto
    left outer join Unidade_Medida um 		  on um.cd_unidade_medida  = pd.cd_unidade_medida
    left join Pais on (pais.cd_pais = pv.cd_pais)

  where
    isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais end and
    pv.dt_inicio_previsao_venda between @dt_inicial and @dt_final 

  group by
    Pais.cd_pais,
    Pais.nm_pais,
    pd.cd_produto,
    pd.cd_mascara_produto,
    pd.nm_fantasia_produto


--  order by Programado desc

  select
    *,
    --ValorRealizado  = (Realizado * Unitario_Item_Pedido),
    PercAtingido    = (case when Programado      = 0 then 1 else Realizado      / Programado      end)*100,
    PerVlrRealizado = (case when ValorProgramado = 0 then 1 else ValorRealizado / ValorProgramado end)*100
  from
    #AuxPrevPaisProduto
  order by
    Programado desc
end

