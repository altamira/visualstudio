

CREATE PROCEDURE pr_mapa_faturamento_analitico_smo

@cd_grupo_categoria    int,
@cd_categoria_produto  int,
@dt_inicial            datetime,    --Data Inicial
@dt_final              datetime     --Data Final

AS

declare @vl_zero int
set @vl_zero = 0

SELECT cp.nm_categoria_produto, 
       cp.sg_categoria_produto, 
       gc.nm_grupo_categoria, 
       nsi.cd_pedido_venda, 
       nsi.cd_item_pedido_venda, 
       --Comentado por Adriano, 05/08/2003
       --IsNull(nsi.vl_frete_item,0)          as 'vl_frete_item', 
       IsNull(nsi.vl_frete_item,0) + 
          IsNull(nsi.vl_seguro_item,0) + 
          IsNull(nsi.vl_desp_acess_item,0)  as 'vl_frete_item', 
       IsNull(nsi.vl_seguro_item,0)         as 'vl_seguro_item', 
       IsNull(nsi.vl_desp_acess_item,0)     as 'vl_desp_acess_item', 
       --Comentado por Adriano, 05/08/2003
       --IsNull(nsi.vl_ipi,0)                 as 'vl_ipi', 
       vl_ipi = case when (isnull(ofi.ic_devmp_operacao_fiscal,'N')='S') then
 		   case when (nsi.cd_nota_saida is not null) then 
                        isnull(nsi.vl_ipi_obs_item,0)
                   else isnull(ns.vl_ipi,0)
                   end
                else 
                   case when (nsi.cd_nota_saida is not null) then 
                        isnull(nsi.vl_ipi,0)
                   else isnull(ns.vl_ipi,0)
                   end 
                end,
       --Comentado por Adriano, 05/08/2003
       --IsNull(nsir.vl_contabil_item_nota,0) as 'vl_contabil', 
       vl_contabil = case when (isnull(ofi.ic_servico_operacao,'N')='S') then
                         (isnull(nsi.qt_item_nota_saida,1) * isnull(nsi.vl_servico,0)) + isnull(nsi.vl_frete_item,0)
                     else 
                        /* Devolução de Matéria Prima */
                        case when (isnull(ofi.ic_devmp_operacao_fiscal,'N')='S') then
                           /* Se não existir item */
                           case when (nsi.cd_nota_saida is not null) then 
                                isnull(nsi.vl_total_item,0) - ((isnull(nsi.vl_total_item,0) * isnull(nsi.pc_reducao_icms,0)/100) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                isnull(nsi.vl_ipi_obs_item,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + IsNull(nsi.vl_desp_acess_item,0)
                           else 
                                isnull(ns.vl_total,0)
                           end
                        else
                           /* Produtos */ 
                           case when (nsi.cd_nota_saida is not null) then 
                                isnull(nsi.vl_total_item,0) - (isnull(nsi.vl_total_item,0) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                isnull(nsi.vl_ipi,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + IsNull(nsi.vl_desp_acess_item,0)
                           else 
                                isnull(ns.vl_total,0)
                           end 
                        end
                     end,
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
       case 
        when (IsNull(nsi.cd_pedido_venda,0) > 0)  then
          pvi.nm_fantasia_produto
        else
          nsi.nm_fantasia_produto
       end as nm_fantasia_produto,
       pvi.qt_item_pedido_venda, 
       nsi.qt_item_nota_saida,
       IsNull(pvi.ic_smo_item_pedido_venda,'N') as 'FatSMO',
       IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0) as vl_venda, 
       -- Se houver valor no ICMSDESC (Percentual Venda Manaus), retira
       vl_faturado =
       case when ns.ic_zona_franca='S' then 
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)-
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)*nsi.pc_icms_desc_item/100)) 
       else (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) end,
       case 
        when (IsNull(nsi.cd_pedido_venda,0) > 0)  then
          pvi.nm_produto_pedido
        else
          nsi.nm_produto_item_nota
       end as nm_produto,
       IsNull(p.vl_produto,0)   as 'vl_produto', 
       IsNull(ns.vl_icms,0)     as 'vl_icms',
       IsNull(p.cd_mascara_produto,cast(nsi.cd_grupo_produto as varchar(2))+'9999999')
                                as 'cd_mascara_produto',
       qt_devolucao = @vl_zero,
       devolucao = @vl_zero,
       'F'                      as 'status'

FROM Nota_Saida_Item nsi 

INNER JOIN Nota_Saida ns ON 
nsi.cd_nota_saida = ns.cd_nota_saida

LEFT OUTER JOIN Nota_Saida_Item_Registro nsir ON
nsi.cd_nota_saida = nsir.cd_nota_saida and
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida

LEFT OUTER JOIN Destinacao_Produto dp ON
ns.cd_destinacao_produto = dp.cd_destinacao_produto

INNER JOIN Vendedor v ON 
ns.cd_vendedor = v.cd_vendedor 

INNER JOIN Cliente c ON 
ns.cd_cliente = c.cd_cliente 

LEFT OUTER JOIN Pedido_Venda_Item pvi ON 
nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 

LEFT OUTER JOIN Produto p ON 
pvi.cd_produto = p.cd_produto

INNER JOIN Categoria_Produto cp ON 
pvi.cd_categoria_produto = cp.cd_categoria_produto 

INNER JOIN Grupo_Categoria gc ON
cp.cd_grupo_categoria = gc.cd_grupo_categoria 

INNER JOIN Operacao_Fiscal ofi ON
ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal

WHERE ns.dt_nota_saida between @dt_inicial and @dt_final             and
      ns.cd_status_nota <> 7                                         and
     (nsi.dt_restricao_item_nota is null or 
      nsi.dt_restricao_item_nota > @dt_final)                        and
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
      ns.vl_total > 0                                                and
     (cp.cd_grupo_categoria = @cd_grupo_categoria or
      @cd_grupo_categoria = 0) and
     (cp.cd_categoria_produto = @cd_categoria_produto or
      @cd_categoria_produto = 0) and
      isnull(ns.ic_smo_nota_saida,'N') = 'S'

UNION

--
-- Devoluções no Mês e Meses Anteriores
--

SELECT cp.nm_categoria_produto, 
       cp.sg_categoria_produto, 
       gc.nm_grupo_categoria, 
       nsi.cd_pedido_venda, 
       nsi.cd_item_pedido_venda, 
       --Comentado por Adriano, 05/08/2003
       --IsNull(nsi.vl_frete_item,0)          as 'vl_frete_item', 
       vl_frete_item = 
       case when ns.dt_nota_saida < @dt_inicial then 0
       else IsNull(nsi.vl_frete_item,0)+
            IsNull(nsi.vl_desp_acess_item,0)+
            IsNull(nsi.vl_seguro_item,0) end,
       IsNull(nsi.vl_seguro_item,0)         as 'vl_seguro_item', 
       IsNull(nsi.vl_desp_acess_item,0)     as 'vl_desp_acess_item', 
       --Comentado por Adriano, 05/08/2003
       --IsNull(nsi.vl_ipi,0)                 as 'vl_ipi', 
       vl_ipi =
       case when ns.dt_nota_saida < @dt_inicial then 0
       else
          case when (isnull(ofi.ic_devmp_operacao_fiscal,'N')='S') then
 	     case when (nsi.cd_nota_saida is not null) then 
                  isnull(nsi.vl_ipi_obs_item,0)
             else isnull(ns.vl_ipi,0)
             end
          else 
             case when (nsi.cd_nota_saida is not null) then 
                  isnull(nsi.vl_ipi,0)
             else isnull(ns.vl_ipi,0)
             end 
          end 
       end,
       -- Comentado por Adriano, 05/08/2003
       -- IsNull(nsir.vl_contabil_item_nota,0) as 'vl_contabil',
       vl_contabil =
       case when ns.dt_nota_saida < @dt_inicial then 0
       else
           case when (isnull(ofi.ic_servico_operacao,'N')='S') then
                               (isnull(nsi.qt_item_nota_saida,1) * isnull(nsi.vl_servico,0)) + isnull(nsi.vl_frete_item,0)
                             else 
                               /* Devolução de Matéria Prima */
                               case when (isnull(ofi.ic_devmp_operacao_fiscal,'N')='S') then
                                 /* Se não existir item */
                                 case when (nsi.cd_nota_saida is not null) then 
                                   isnull(nsi.vl_total_item,0) - ((isnull(nsi.vl_total_item,0) * isnull(nsi.pc_reducao_icms,0)/100) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                   isnull(nsi.vl_ipi_obs_item,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + IsNull(nsi.vl_desp_acess_item,0)
                                 else 
                                   isnull(ns.vl_total,0)
                                 end
                               else
                                 /* Produtos */ 
                                 case when (nsi.cd_nota_saida is not null) then 
                                   isnull(nsi.vl_total_item,0) - (isnull(nsi.vl_total_item,0) * isnull(nsi.pc_icms_desc_item,0)/100) + 
                                   isnull(nsi.vl_ipi,0) + isnull(nsi.vl_frete_item,0) + isnull(nsi.vl_seguro_item,0) + IsNull(nsi.vl_desp_acess_item,0)
                                 else 
                                   isnull(ns.vl_total,0)
                                 end 
                               end
                             end
       end,
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
       case 
        when (IsNull(nsi.cd_pedido_venda,0) > 0)  then
          pvi.nm_fantasia_produto
        else
          nsi.nm_fantasia_produto
       end as nm_fantasia_produto,
       pvi.qt_item_pedido_venda, 
       case when ns.dt_nota_saida < @dt_inicial then 0
       else nsi.qt_item_nota_saida end,
       IsNull(pvi.ic_smo_item_pedido_venda,'N') as 'FatSMO',
       IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0) AS vl_venda, 
       -- Se houver valor no ICMSDESC (Percentual Venda Manaus), retira
       vl_faturado =
       case when ns.dt_nota_saida < @dt_inicial then 0
            when ns.ic_zona_franca='S' then 
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)-
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)*nsi.pc_icms_desc_item/100)) 
       else (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) end,
       case 
        when (IsNull(nsi.cd_pedido_venda,0) > 0)  then
          pvi.nm_produto_pedido
        else
          nsi.nm_produto_item_nota
       end as nm_produto,
       IsNull(p.vl_produto,0)   as 'vl_produto', 
       IsNull(ns.vl_icms,0)     as 'vl_icms',
       IsNull(p.cd_mascara_produto,cast(nsi.cd_grupo_produto as varchar(2))+'9999999')
                                as 'cd_mascara_produto',
       qt_devolucao = 
       case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida
            when nsi.qt_devolucao_item_nota > 0 then nsi.qt_devolucao_item_nota
       else @vl_zero end, 
       devolucao = 
       case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota
            when nsi.qt_devolucao_item_nota > 0 then nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota
       else @vl_zero end, 
       status =
       case when ns.dt_nota_saida < @dt_inicial then 'A' else 'M' end

FROM Nota_Saida_Item nsi 

INNER JOIN Nota_Saida ns ON 
nsi.cd_nota_saida = ns.cd_nota_saida

LEFT OUTER JOIN Nota_Saida_Item_Registro nsir ON
nsi.cd_nota_saida = nsir.cd_nota_saida and
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida

INNER JOIN Vendedor v ON 
ns.cd_vendedor = v.cd_vendedor 

LEFT OUTER JOIN Destinacao_Produto dp ON
ns.cd_destinacao_produto = dp.cd_destinacao_produto

INNER JOIN Cliente c ON 
ns.cd_cliente = c.cd_cliente 

LEFT OUTER JOIN Pedido_Venda_Item pvi ON 
nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 

LEFT OUTER JOIN Produto p ON 
pvi.cd_produto = p.cd_produto

INNER JOIN Categoria_Produto cp ON 
pvi.cd_categoria_produto = cp.cd_categoria_produto 

INNER JOIN Grupo_Categoria gc ON
cp.cd_grupo_categoria = gc.cd_grupo_categoria 

INNER JOIN Operacao_Fiscal ofi ON
ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal

WHERE ns.cd_status_nota <> 7                                         and
      nsi.dt_restricao_item_nota between @dt_inicial and @dt_final   and -- Data de Devolução
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
      ns.vl_total > 0                                                and
     (cp.cd_grupo_categoria = @cd_grupo_categoria or
      @cd_grupo_categoria = 0) and
     (cp.cd_categoria_produto = @cd_categoria_produto or
      @cd_categoria_produto = 0) and
      nsi.cd_status_nota in (3,4) and
      isnull(ns.ic_smo_nota_saida,'N') = 'S'

ORDER BY nm_grupo_categoria, 
         nm_categoria_produto,
         ns.cd_nota_saida,
         nsi.cd_item_nota_saida 


