

CREATE PROCEDURE pr_mapa_devolucao_analitico

@cd_grupo_categoria    int,
@cd_categoria_produto  int,
@dt_inicial            datetime,    --Data Inicial
@dt_final              datetime,    --Data Final
@ic_smo                char(1)

AS

if @ic_smo = 'S' -- Considerar Smo
   set @ic_smo = ''

SELECT cp.nm_categoria_produto, 
       cp.sg_categoria_produto, 
       gc.nm_grupo_categoria, 
       nsi.cd_pedido_venda, 
       nsi.cd_item_pedido_venda, 
       nsi.dt_restricao_item_nota           as 'dt_devolucao',
       -- LUCIO : Frete
       IsNull(nsi.vl_frete_item,0)+
          IsNull(nsi.vl_desp_acess_item,0)+
          IsNull(nsi.vl_seguro_item,0)      as 'vl_frete_item', 
       IsNull(nsi.vl_seguro_item,0)         as 'vl_seguro_item', 
       IsNull(nsi.vl_desp_acess_item,0)     as 'vl_desp_acess_item', 
       qt_devolucao_item_nota =
       case when IsNull(nsi.qt_devolucao_item_nota,0) > 0 then nsi.qt_devolucao_item_nota 
            when IsNull(nsi.qt_devolucao_item_nota,0) = 0 then nsi.qt_item_nota_saida
       else 0 end,
       vl_devolvido =
       case when IsNull(nsi.qt_devolucao_item_nota,0) > 0 then nsi.qt_devolucao_item_nota * vl_unitario_item_nota
            when IsNull(nsi.qt_devolucao_item_nota,0) = 0 then nsi.qt_item_nota_saida * vl_unitario_item_nota
       else 0 end,
       vl_devolvido_com_frete =
       case when IsNull(nsi.qt_devolucao_item_nota,0) > 0 then (nsi.qt_devolucao_item_nota * vl_unitario_item_nota)+vl_frete_item
            when IsNull(nsi.qt_devolucao_item_nota,0) = 0 then (nsi.qt_item_nota_saida * vl_unitario_item_nota)+vl_frete_item
       else 0 end,
       IsNull(nsi.vl_ipi,0) as 'vl_ipi', 
       ns.dt_nota_saida, 
--       ns.cd_nota_saida, 
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                              as 'cd_nota_saida',

       nsi.cd_item_nota_saida,
       c.nm_fantasia_cliente, 
       v.nm_fantasia_vendedor, 
       ns.cd_vendedor,
       dp.nm_destinacao_produto, 
       pvi.dt_item_pedido_venda, 
       nsi.nm_fantasia_produto,
       pvi.qt_item_pedido_venda, 
       nsi.qt_item_nota_saida,
       IsNull(pvi.ic_smo_item_pedido_venda,'N') as 'FatSMO',
       IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0) AS vl_venda, 
       vl_faturado =
       case when ns.dt_nota_saida < @dt_inicial then 0
            when ns.ic_zona_franca='S' then 
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)-
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)*nsi.pc_icms_desc_item/100)) 
       else (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) end,
       cast(IsNull(nsi.nm_produto_item_nota,p.nm_produto) as varchar(50)) as nm_produto,
       IsNull(p.vl_produto,0) as 'vl_produto', 
       IsNull(ns.vl_icms,0) as 'vl_icms',
       IsNull(p.cd_mascara_produto,cast(nsi.cd_grupo_produto as varchar(2))+'9999999')
                                as 'cd_mascara_produto',
       -- LUCIO : VLR CONTABIL
       vl_contabil = case when (isnull(ofi.ic_servico_operacao,'N')='S') then
                         (isnull(nsi.qt_item_nota_saida,1) * isnull(nsi.vl_servico,0)) + isnull(nsi.vl_frete_item,0)
                     else 
                        /* Devolução de Matéria Prima */
                        case when (isnull(ofi.ic_devmp_operacao_fiscal,'N')='S') then
                           /* Se não existir item */
                           case when (nsi.cd_nota_saida is not null) then 
                                isnull(nsi.vl_total_item,0) - ((isnull(nsi.vl_total_item,0) * isnull(nsi.pc_reducao_icms,0)/100) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                isnull(nsi.vl_ipi_obs_item,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + isnull(nsi.vl_desp_acess_item,0)
                           else 
                                isnull(ns.vl_total,0)
                           end
                        else
                           /* Produtos */ 
                           case when (nsi.cd_nota_saida is not null) then 
                                isnull(nsi.vl_total_item,0) - (isnull(nsi.vl_total_item,0) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                isnull(nsi.vl_ipi,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + isnull(nsi.vl_desp_acess_item,0)
                           else 
                                isnull(ns.vl_total,0)
                           end 
                        end
                     end

FROM Nota_Saida_Item nsi with (nolock) 

LEFT OUTER JOIN Produto p ON 
nsi.cd_produto = p.cd_produto

INNER JOIN Nota_Saida ns ON 
nsi.cd_nota_saida = ns.cd_nota_saida

LEFT OUTER JOIN Vendedor v ON 
ns.cd_vendedor = v.cd_vendedor 

LEFT OUTER JOIN Destinacao_Produto dp ON
ns.cd_destinacao_produto = dp.cd_destinacao_produto

LEFT OUTER JOIN Cliente c ON 
ns.cd_cliente = c.cd_cliente 

LEFT OUTER JOIN Pedido_Venda_Item pvi ON 
nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 

INNER JOIN Categoria_Produto cp ON 
pvi.cd_categoria_produto = cp.cd_categoria_produto 

INNER JOIN Grupo_Categoria gc ON
cp.cd_grupo_categoria = gc.cd_grupo_categoria 

INNER JOIN Operacao_Fiscal ofi ON
ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal

WHERE ns.cd_status_nota <> 7                                         and
      nsi.dt_restricao_item_nota between @dt_inicial and @dt_final   and
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
      ns.vl_total > 0                                                and
     (cp.cd_grupo_categoria = @cd_grupo_categoria or
      @cd_grupo_categoria = 0) and
     (cp.cd_categoria_produto = @cd_categoria_produto or
      @cd_categoria_produto = 0) and
      nsi.cd_status_nota in (3,4) and
     (@ic_smo = '' or
      isnull(pvi.ic_smo_item_pedido_venda,'N') = @ic_smo)

order by gc.nm_grupo_categoria, 
         cp.nm_categoria_produto,
         nsi.dt_restricao_item_nota,
         nsi.cd_nota_saida,
         nsi.cd_item_nota_saida 

