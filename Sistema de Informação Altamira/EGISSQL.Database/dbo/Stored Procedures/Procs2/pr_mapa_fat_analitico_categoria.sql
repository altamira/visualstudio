  
CREATE PROCEDURE pr_mapa_fat_analitico_categoria  
  
@cd_grupo_categoria    int,  
@cd_categoria_produto  int,  
@dt_inicial            datetime,    --Data Inicial  
@dt_final              datetime,    --Data Final  
@ic_smo                char(1)   
  
as  
  
declare @vl_zero int  
set @vl_zero = 0  
  
if @ic_smo = 'S' -- Considerar Smo  
   set @ic_smo = ''  
  
SELECT cp.nm_categoria_produto,   
       cp.sg_categoria_produto,   
       gc.nm_grupo_categoria,   
       nsi.cd_pedido_venda,   
       nsi.cd_item_pedido_venda,   
       -- LUCIO : Frete  
       IsNull(nsi.vl_frete_item,0)+  
          IsNull(nsi.vl_desp_acess_item,0)+  
          IsNull(nsi.vl_seguro_item,0)          as 'vl_frete_item',   
       IsNull(nsi.vl_seguro_item,0)             as 'vl_seguro_item',   
       IsNull(nsi.vl_desp_acess_item,0)         as 'vl_desp_acess_item',   
       -- LUCIO : IPI  
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
                     end,  
       ns.dt_nota_saida,   
       --ns.cd_nota_saida,   

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
       IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0) as vl_venda,   
       -- Se houver valor no ICMSDESC (Percentual Venda Manaus), retira  
       vl_faturado =  
       case when ns.ic_zona_franca='S' then   
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)-  
          ((nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)*nsi.pc_icms_desc_item/100))   
       else (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) end,  
       vl_faturado_custo = 0.00,  
       nsi.nm_produto_item_nota   as 'nm_produto',  
       IsNull(p.vl_produto,0)     as 'vl_produto',   
       IsNull(nsi.vl_icms_item,0) as 'vl_icms',  
       IsNull(p.cd_mascara_produto,cast(nsi.cd_grupo_produto as varchar(2))+'9999999')  
                                  as 'cd_mascara_produto',  
       qt_devolucao = @vl_zero,  
       devolucao = @vl_zero,  
       'F'                        as 'status',  
       vl_diferenca = 0.00,
       ofi.cd_mascara_operacao    as 'CFOP'  
  
into #FatAnalitico  
  
FROM Nota_Saida_Item nsi  with(nolock)    
  
INNER JOIN Nota_Saida ns  with(nolock) ON nsi.cd_nota_saida = ns.cd_nota_saida  
  
LEFT OUTER JOIN Produto p                     with(nolock) ON nsi.cd_produto = p.cd_produto  
  
LEFT OUTER JOIN Nota_Saida_Item_Registro nsir with(nolock) ON  
nsi.cd_nota_saida = nsir.cd_nota_saida and  
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida  
  
LEFT OUTER JOIN Destinacao_Produto dp         with(nolock) ON  
ns.cd_destinacao_produto = dp.cd_destinacao_produto  
  
INNER JOIN Vendedor v with(nolock) ON   
ns.cd_vendedor = v.cd_vendedor   
  
INNER JOIN Cliente c with(nolock) ON   
ns.cd_cliente = c.cd_cliente   
  
LEFT OUTER JOIN Pedido_Venda_Item pvi with(nolock) ON   
nsi.cd_pedido_venda = pvi.cd_pedido_venda AND   
nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda   
  
INNER JOIN Categoria_Produto cp with(nolock) ON   
pvi.cd_categoria_produto = cp.cd_categoria_produto   
  
INNER JOIN Grupo_Categoria gc   with(nolock) ON  
cp.cd_grupo_categoria = gc.cd_grupo_categoria   
  
INNER JOIN Operacao_Fiscal ofi  with(nolock) ON  
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
     (@ic_smo = '' or  
      isnull(pvi.ic_smo_item_pedido_venda,'N') = @ic_smo)  
  
UNION  
  
--  
-- Devoluções no Mês e Meses Anteriores  
--  
  
SELECT cp.nm_categoria_produto,   
       cp.sg_categoria_produto,   
       gc.nm_grupo_categoria,   
       nsi.cd_pedido_venda,   
       nsi.cd_item_pedido_venda,   
       -- LUCIO : Frete  
       vl_frete_item =   
       case when ns.dt_nota_saida < @dt_inicial then 0  
       else IsNull(nsi.vl_frete_item,0)+  
            IsNull(nsi.vl_desp_acess_item,0)+  
            IsNull(nsi.vl_seguro_item,0) end,   
       IsNull(nsi.vl_seguro_item,0)             as 'vl_seguro_item',   
       IsNull(nsi.vl_desp_acess_item,0)         as 'vl_desp_acess_item',   
       -- LUCIO : IPI  
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
       -- LUCIO : VLR CONTABIL  
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
       nsi.nm_fantasia_produto,  
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
       vl_faturado_custo = 0.00,  
       nsi.nm_produto_item_nota   as 'nm_produto',  
       IsNull(p.vl_produto,0)     as 'vl_produto',   
       vl_icms =  
       case when ns.dt_nota_saida < @dt_inicial then 0  
       else IsNull(nsi.vl_icms_item,0) end,  
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
       case when ns.dt_nota_saida < @dt_inicial then 'A' else 'M' end,  
       vl_diferenca = 0.00,
       ofi.cd_mascara_operacao    as 'CFOP'  
  
  
FROM Nota_Saida_Item nsi  with(nolock)  
  
INNER JOIN Nota_Saida ns  with(nolock) ON   
nsi.cd_nota_saida = ns.cd_nota_saida  
  
LEFT OUTER JOIN Produto p with(nolock) ON   
nsi.cd_produto = p.cd_produto  
  
LEFT OUTER JOIN Nota_Saida_Item_Registro nsir with(nolock) ON  
nsi.cd_nota_saida = nsir.cd_nota_saida and  
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida  
  
INNER JOIN Vendedor v with(nolock) ON   
ns.cd_vendedor = v.cd_vendedor   
  
LEFT OUTER JOIN Destinacao_Produto dp with(nolock) ON  
ns.cd_destinacao_produto = dp.cd_destinacao_produto  
  
INNER JOIN Cliente c with(nolock) ON   
ns.cd_cliente = c.cd_cliente   
  
LEFT OUTER JOIN Pedido_Venda_Item pvi with(nolock) ON   
nsi.cd_pedido_venda = pvi.cd_pedido_venda AND   
nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda   
  
INNER JOIN Categoria_Produto cp with(nolock) ON   
pvi.cd_categoria_produto = cp.cd_categoria_produto   
  
INNER JOIN Grupo_Categoria gc with(nolock) ON  
cp.cd_grupo_categoria = gc.cd_grupo_categoria   
  
INNER JOIN Operacao_Fiscal ofi with(nolock) ON  
ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal  
  
WHERE nsi.dt_restricao_item_nota between @dt_inicial and @dt_final   and -- Data de Devolução  
      ns.cd_status_nota <> 7                                         and  
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and  
      ns.vl_total > 0                                                and  
     IsNull(cp.cd_grupo_categoria,0) = ( case when @cd_grupo_categoria = 0 then  
                                          IsNull(cp.cd_grupo_categoria,0) else  
                                          @cd_grupo_categoria end) and  
     IsNull(cp.cd_categoria_produto,0) = ( case when @cd_categoria_produto = 0 then  
                                            IsNull(cp.cd_categoria_produto,0) else  
                                            @cd_categoria_produto end) and  
      nsi.cd_status_nota in (3,4) and  
      isnull(pvi.ic_smo_item_pedido_venda,'N') = ( case when @ic_smo = '' then  
                                                    isnull(pvi.ic_smo_item_pedido_venda,'N') else  
                                                   @ic_smo end)  
  
ORDER BY nm_grupo_categoria,   
         nm_categoria_produto,  
         ns.cd_nota_saida,  
         nsi.cd_item_nota_saida  
/*  
select --vl_faturado_custo = round((vl_faturado+vl_ipi+vl_frete_item),2),  
       --vl_diferenca      = round(vl_contabil,2) - round((vl_faturado+vl_ipi+vl_frete_item),2),  
       --vl_diferenca2     = round(vl_contabil_teste,2) - round((vl_faturado+vl_ipi+vl_frete_item),2),  
     --  *,  
       vl_faturado_custo = cast(cast(round(sum(vl_faturado)+sum(vl_ipi)+sum(vl_frete_item),2) as varchar(15)) as numeric(15,2)),  
       cd_nota_saida  
         
from #FatAnalitico  
group by cd_nota_saida  
order by cd_nota_saida  
*/  
  
select --vl_faturado_custo = round((vl_faturado+vl_ipi+vl_frete_item),2),  
       --vl_diferenca      = round(vl_contabil,2) - round((vl_faturado+vl_ipi+vl_frete_item),2),  
       --vl_diferenca2     = round(vl_contabil_teste,2) - round((vl_faturado+vl_ipi+vl_frete_item),2),  
       *  
from #FatAnalitico  
order by nm_grupo_categoria,   
         sg_categoria_produto,   
         cd_nota_saida  
  
