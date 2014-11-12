
---------------------------------------------------------------------------------
--pr_pedido_categoria_aberto
---------------------------------------------------------------------------------
--GBS - Global Business Sollution Ltda                                       2004
---------------------------------------------------------------------------------
--Stored Procedure         : Microsoft SQL Server 2000
--Autor(es)                : Daniel C. Neto
--Banco de Dados           : SAPSQL
--Objetivo                 : Mostrar os pedidos em aberto por Categoria
--Data                     : 21/03/2002
--Atualizado               : Igor - 07/06/2002
--                         : Pedidos faturados após a database : Lucio
--                         : Alteração de valores em pedidos faturados após a database : Lucio
--                         : 14/05/2004 - Inclusão de isnull nas cláusulas where por valor nulo não se verifica. Igor Gama
--                         : 07/12/2004 - Alterado forma de trazer a data de entrega, incluído data de entrega do PCP. - Daniel C. Neto.
--                         : 08/12/2004 - Corrigido a Data de Entrega - Carlos
--                         : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                         : 05.12.2005 - Grupo de Cliente - Carlos Fernandes
--                         : 06.06.2006 - Sigla da Categoria do Produto - Carlos Fernandes
--                         : 18.09.2006 - Código do Produto do Cliente - Carlos Fernandes
--                         : 26.03.2007 - Frete - Carlos Fernandes
--                         : 18.12.2007 - Data da Reprogramação - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_consulta_pedido_categoria_aberto

@cd_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_categoria varchar(20)

as

declare @dt_perc_smo datetime
set @dt_perc_smo = '08/01/2000'

if @cd_parametro = 1
Begin

  --
  -- Pedidos com Saldo (em aberto)
  --
  select 
     pvi.cd_pedido_venda,
     pvi.cd_item_pedido_venda,
     pvi.dt_entrega_fabrica_pedido,
     pvi.cd_categoria_produto, 
     pvi.qt_saldo_pedido_venda,
     pvi.dt_cancelamento_item,
     pvi.dt_entrega_vendas_pedido as dt_entrega_pedido,
     nm_grupo_categoria =  
     substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8) + ' - ' + gc.nm_grupo_categoria,
    (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) as vl_total_saldo_aberto,
     gc.cd_grupo_categoria,
     cp.nm_categoria_produto,
     cp.cd_mascara_categoria,
     cp.sg_categoria_produto,
     pc.nm_fantasia_prod_cliente
  -------
  into #Pedidos_Com_Saldo 
  -------
  from Pedido_Venda_Item pvi with(nolock)

  inner join Pedido_Venda pv           on  pvi.cd_pedido_venda = pv.cd_pedido_venda

  inner join Cliente c                 on  pv.cd_cliente = c.cd_cliente

  left outer join Categoria_Produto cp on  pvi.cd_categoria_produto = cp.cd_categoria_produto 

  left outer join Grupo_Categoria gc   on  cp.cd_grupo_categoria = gc.cd_grupo_categoria

  left outer join Produto_Cliente pc   on  pc.cd_cliente =  pv.cd_cliente and pc.cd_produto = pvi.cd_produto

  --select * from produto_cliente

  where
     pv.dt_pedido_venda <= @dt_final                        and
     isnull(pvi.qt_saldo_pedido_venda,0) > 0.00 and
    (pvi.dt_cancelamento_item is null or
     pvi.dt_cancelamento_item > @dt_final) and
     pvi.cd_item_pedido_venda <= ( case IsNull(c.cd_pais,1) 
                                  when 1 then 80
                                  else  pvi.cd_item_pedido_venda
                                end ) and --Limita os pedidos nacionais até 80, devido a uma regra de negócio aplicada     
     cp.cd_mascara_categoria like @cd_categoria+'%' and 
     isnull(cp.ic_vendas_categoria,'N')   = 'S'     and
     isnull(pv.ic_consignacao_pedido,'N') <> 'S'    and
     pv.cd_status_pedido in (1,2)

   --
   -- Já faturados após a database
   --
   select
     pvi.cd_pedido_venda,
     pvi.cd_item_pedido_venda,
     pvi.dt_entrega_fabrica_pedido,
     pvi.cd_categoria_produto,
-- Alterado Lucio : 04/08/2003
--     pvi.qt_saldo_pedido_venda+nsi.qt_item_nota_saida as qt_saldo_faturado,
--   ((pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) +
--       (nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota)) as vl_total_saldo_faturado,
     nsi.qt_item_nota_saida as qt_saldo_faturado,
     (nsi.qt_item_nota_saida * pvi.vl_unitario_item_pedido) as vl_total_saldo_faturado,
     pvi.qt_saldo_pedido_venda,
     pvi.dt_cancelamento_item,
     pvi.dt_entrega_vendas_pedido as dt_entrega_pedido,
     nm_grupo_categoria =  
     substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8) + ' - ' + gc.nm_grupo_categoria,
     gc.cd_grupo_categoria,
     cp.nm_categoria_produto,
     cp.cd_mascara_categoria,
     cp.sg_categoria_produto
   -------
   into #Pedidos_Faturados
   -------
   from Pedido_Venda_Item pvi
        left join Pedido_Venda pv on (pvi.cd_pedido_venda = pv.cd_pedido_venda)
        left join Nota_Saida_Item nsi on(pvi.cd_pedido_venda = nsi.cd_pedido_venda and pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda) 
        left join Nota_Saida ns on (nsi.cd_nota_saida = ns.cd_nota_saida) 
        left join Operacao_Fiscal op on(ns.cd_operacao_fiscal = op.cd_operacao_fiscal) 
        left join Categoria_produto cp on (pvi.cd_categoria_produto = cp.cd_categoria_produto)
        left join Grupo_Categoria gc on (cp.cd_grupo_categoria = gc.cd_grupo_categoria)
   
   where 
     (pvi.dt_cancelamento_item is null or  pvi.dt_cancelamento_item > @dt_final) and
      -- Pedido Faturado Total ou Parcial apos o Periodo (Abaixo)
     (pvi.qt_saldo_pedido_venda = 0 or (pvi.qt_saldo_pedido_venda > 0 and pvi.qt_item_pedido_venda > pvi.qt_saldo_pedido_venda)) and
      pv.dt_pedido_venda <= @dt_final and
      isnull(pv.ic_consignacao_pedido,'N') <> 'S' and
      nsi.cd_status_nota <> 7 and
      ns.dt_nota_saida > @dt_final and       
      pvi.cd_item_pedido_venda <= ( case IsNull(ns.cd_pais,1) 
                                  when 1 then 80 
                                  else pvi.cd_item_pedido_venda
                                end ) and --Limita os pedidos nacionais até 80, devido a uma regra de negócio aplicada     
      isnull(op.ic_comercial_operacao,'N') = 'S' and
      cp.cd_mascara_categoria like @cd_categoria+'%' and
      isnull(cp.ic_vendas_categoria,'N') = 'S' and
      pv.cd_status_pedido in (1,2)

    --------------------------------------------------------------------------------------------------------------
    -- Resultado Final    
    --------------------------------------------------------------------------------------------------------------

    select 
       isnull(a.cd_pedido_venda,b.cd_pedido_venda)           as cd_pedido_venda,
       isnull(a.cd_item_pedido_venda,b.cd_item_pedido_venda) as cd_item_pedido_venda,
       pvi.dt_entrega_fabrica_pedido,
       pvi.dt_reprog_item_pedido,
      (isnull(a.qt_saldo_pedido_venda,0) + 
          isnull(b.qt_saldo_faturado,0))                     as qt_saldo_pedido_venda,
       -- Valor total em aberto
       vl_total_pedido_venda = isnull(a.vl_total_saldo_aberto,0) + isnull(b.vl_total_saldo_faturado,0),
       case when b.dt_entrega_pedido is null then pvi.dt_entrega_vendas_pedido
                                             else b.dt_entrega_pedido end      as dt_entrega_pedido,
       isnull(a.cd_categoria_produto,b.cd_categoria_produto) as cd_categoria_produto,
       isnull(a.nm_grupo_categoria,b.nm_grupo_categoria)     as nm_grupo_categoria,
       isnull(a.cd_grupo_categoria,b.cd_grupo_categoria)     as cd_grupo_categoria,
       isnull(a.nm_categoria_produto,b.nm_categoria_produto) as nm_categoria_produto,
       isnull(a.cd_mascara_categoria,b.cd_mascara_categoria) as cd_mascara_categoria,
       isnull(pv.ic_smo_pedido_venda,'N') ic_smo_pedido_venda,
       pv.cd_tipo_pedido,
       t.sg_tipo_pedido,
       t.nm_tipo_pedido,
       cli.nm_fantasia_cliente,
       pv.cd_vendedor          as 'cd_vendedor_pedido',
       ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
       vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
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
       end                  AS vl_total_item_moeda,
       cg.nm_cliente_grupo  as GrupoCliente,
       a.sg_categoria_produto,
       pc.nm_fantasia_prod_cliente,
       dbo.fn_ultima_ordem_producao_item_pedido(pvi.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo,
       isnull(pvi.vl_frete_item_pedido,0)   as vl_frete_item_pedido,
       pvi.pc_ipi,
       pvi.pc_icms,
       isnull(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (pvi.pc_ipi/100),0)     as vl_item_ipi
       
    from
      #Pedidos_Com_Saldo a   

    full outer join #Pedidos_Faturados b on a.cd_pedido_venda      = b.cd_pedido_venda and
                                            a.cd_item_pedido_venda = b.cd_item_pedido_venda 

    inner join Pedido_Venda_Item pvi   with(nolock) on isnull(a.cd_pedido_venda,b.cd_pedido_venda) = pvi.cd_pedido_venda and
                                                       isnull(a.cd_item_pedido_venda,b.cd_item_pedido_venda) = pvi.cd_item_pedido_venda

    inner join Pedido_Venda pv         with(nolock) on  pvi.cd_pedido_venda    = pv.cd_pedido_venda
    left outer join Produto pro        with(nolock) on  pvi.cd_produto         = pro.cd_produto
    left outer join Tipo_Pedido t      with(nolock) on  pv.cd_tipo_pedido      = t.cd_tipo_pedido
    left outer join Cliente cli        with(nolock) on  pv.cd_cliente          = cli.cd_cliente 
    left outer join Status_Pedido sp   with(nolock) on  pv.cd_status_pedido    = sp.cd_status_pedido 
    left Outer Join Vendedor vi        with(nolock) on  pv.cd_vendedor_interno = vi.cd_vendedor 
    left Outer Join Vendedor ve        with(nolock) on  pv.cd_vendedor         = ve.cd_vendedor    
    left outer join moeda m            with(nolock) on (pvi.cd_moeda_cotacao   = m.cd_moeda)
    left outer join cliente_grupo cg   with(nolock) on cg.cd_cliente_grupo     = cli.cd_cliente_grupo
    left outer join Produto_Cliente pc with(nolock) on pc.cd_cliente           =  pv.cd_cliente and
                                                       pc.cd_produto           = pvi.cd_produto

    order by 
       a.cd_grupo_categoria,
       a.cd_mascara_categoria,
       a.dt_entrega_pedido,
       a.cd_pedido_venda desc,
       a.cd_item_pedido_venda

end

else


if @cd_parametro = 2
Begin
  select 
    i.cd_categoria_produto,
    substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8)+' - '+gc.nm_grupo_categoria as nm_grupo_categoria, gc.cd_grupo_categoria, 
    cp.nm_categoria_produto,
    cp.cd_mascara_categoria,
    isnull(p.ic_smo_pedido_venda,'N') ic_smo_pedido_venda, --Status
    p.cd_tipo_pedido,
    t.sg_tipo_pedido,
    t.nm_tipo_pedido,
    cli.nm_fantasia_cliente, --Cliente
    p.cd_vendedor           as 'cd_vendedor_pedido',
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    p.dt_pedido_venda,     --Data Emissão
    p.cd_pedido_venda,

    case 
       when(i.dt_cancelamento_item is null) 
       then  i.qt_item_pedido_venda 
       else 0 
       end AS 'qt_item_pedido_venda', 

    case 
       when (i.dt_cancelamento_item is not null) 
       then  i.qt_item_pedido_venda 
       else 0 
       end AS 'qt_item_pedido_venda_canc', 
--    i.qt_item_pedido_venda, --Qtdade


    i.cd_item_pedido_venda,
    p.qt_liquido_pedido_venda,
    p.qt_bruto_pedido_venda,
    i.pc_desconto_item_pedido,
    i.nm_produto_pedido, --Desc
    i.nm_fantasia_produto,
    i.vl_unitario_item_pedido, 
    case 
       when(i.dt_cancelamento_item is null) 
       then  (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) 
       else 0 
       end AS 'vl_total_pedido_venda', 

    case 
       when (i.dt_cancelamento_item is not null) 
       then  (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) 
       else 0 
       end AS 'vl_totalcanc', 

--    (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) AS 'vl_total_pedido_venda', --Valor

    i.qt_saldo_pedido_venda, --Saldo
    sp.nm_status_pedido,
    sp.sg_status_pedido, --Status Pedido,
    cg.nm_cliente_grupo as GrupoCliente,
    pc.nm_fantasia_prod_cliente,
    dbo.fn_ultima_ordem_producao_item_pedido(p.cd_pedido_venda, i.cd_item_pedido_venda) as cd_processo,
    isnull(i.vl_frete_item_pedido,0)   as vl_frete_item_pedido

  from 
    Pedido_Venda p with (nolock)
  left outer join Tipo_Pedido t        on t.cd_tipo_pedido       = p.cd_tipo_pedido 
  left outer join Cliente cli          on p.cd_cliente           = cli.cd_cliente 
  left outer join Pedido_Venda_Item i  on p.cd_pedido_venda      = i.cd_pedido_venda 
  left outer join Status_Pedido sp     on p.cd_status_pedido     = sp.cd_status_pedido 
  Left Outer Join Vendedor vi          on p.cd_vendedor_interno  = vi.cd_vendedor 
  Left Outer Join Vendedor ve          on p.cd_vendedor          = ve.cd_vendedor    
  Left Outer Join Categoria_Produto cp on cp.cd_categoria_produto=i.cd_categoria_produto
  Left outer join Grupo_Categoria gc   on cp.cd_grupo_categoria  = gc.cd_grupo_categoria
  Left outer join Cliente_Grupo cg     on cg.cd_cliente_grupo    = cli.cd_cliente_grupo
  left outer join Produto_Cliente pc   on pc.cd_cliente          = p.cd_cliente and
                                          pc.cd_produto          = i.cd_produto

  where
    p.dt_cancelamento_pedido is null and
    IsNull(i.qt_saldo_pedido_venda,0) > 0.00 and
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    cp.cd_mascara_categoria like @cd_categoria+'%' and 
    isnull(cp.ic_vendas_categoria,'S')='S'

order by gc.cd_grupo_categoria,
         cp.cd_mascara_categoria,
         p.dt_pedido_venda desc, 
         p.cd_pedido_venda desc, 
         i.cd_item_pedido_venda
end

