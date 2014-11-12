
CREATE PROCEDURE pr_mapa_faturamento_resumo_exp

@cd_grupo_categoria   int,
@cd_categoria_produto int,
@dt_inicial           datetime,
@dt_final             datetime 

as

declare @vl_zero int
set @vl_zero = 0

SELECT gc.nm_grupo_categoria, 
       cp.sg_categoria_produto, 
       nsi.cd_nota_saida,
       nsi.cd_item_nota_saida,
       QtdFatExp = nsi.qt_item_nota_saida,
       FaturamentoEXP = (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)

INTO #TMPFaturamentoExp

FROM Nota_Saida_Item nsi 

INNER JOIN Nota_Saida ns ON 
nsi.cd_nota_saida = ns.cd_nota_saida

LEFT OUTER JOIN Produto p ON 
nsi.cd_produto = p.cd_produto

LEFT OUTER JOIN Nota_Saida_Item_Registro nsir ON
nsi.cd_nota_saida = nsir.cd_nota_saida and
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida

LEFT OUTER JOIN Destinacao_Produto dp ON
ns.cd_destinacao_produto = dp.cd_destinacao_produto

LEFT JOIN Vendedor v ON 
ns.cd_vendedor = v.cd_vendedor 

INNER JOIN Cliente c ON 
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

WHERE ns.dt_nota_saida between @dt_inicial and @dt_final             and
      ns.cd_status_nota <> 7                                         and
     (nsi.dt_restricao_item_nota is null or 
      nsi.dt_restricao_item_nota > @dt_final)                        and
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
      ofi.cd_mascara_operacao like '7%'                              and
      ns.vl_total > 0                                                and
     (cp.cd_grupo_categoria = @cd_grupo_categoria or
      @cd_grupo_categoria = 0) and
     (cp.cd_categoria_produto = @cd_categoria_produto or
      @cd_categoria_produto = 0)

UNION

--
-- Devoluções no Mês e Meses Anteriores
--

SELECT gc.nm_grupo_categoria, 
       cp.sg_categoria_produto, 
       nsi.cd_nota_saida,
       nsi.cd_item_nota_saida,
       QtdFatExp = 
       case when ns.dt_nota_saida < @dt_inicial then 0 
       else nsi.qt_item_nota_saida end,
       FaturamentoEXP = 
       case when ns.dt_nota_saida < @dt_inicial then 0
       else (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) end

FROM Nota_Saida_Item nsi 

INNER JOIN Nota_Saida ns ON 
nsi.cd_nota_saida = ns.cd_nota_saida

LEFT OUTER JOIN Produto p ON 
nsi.cd_produto = p.cd_produto

LEFT OUTER JOIN Nota_Saida_Item_Registro nsir ON
nsi.cd_nota_saida = nsir.cd_nota_saida and
nsi.cd_item_nota_saida = nsir.cd_item_nota_saida

LEFT JOIN Vendedor v ON 
ns.cd_vendedor = v.cd_vendedor 

LEFT OUTER JOIN Destinacao_Produto dp ON
ns.cd_destinacao_produto = dp.cd_destinacao_produto

INNER JOIN Cliente c ON 
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
      nsi.dt_restricao_item_nota between @dt_inicial and @dt_final   and -- Data de Devolução
      isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
      ofi.cd_mascara_operacao like '7%'                              and
      ns.vl_total > 0                                                and
     (cp.cd_grupo_categoria = @cd_grupo_categoria or
      @cd_grupo_categoria = 0) and
     (cp.cd_categoria_produto = @cd_categoria_produto or
      @cd_categoria_produto = 0) and
      nsi.cd_status_nota in (3,4)

select nm_grupo_categoria, 
       sg_categoria_produto as 'Categoria', 
       Sum(QtdFatExp) as QtdFatExp,
       Sum(FaturamentoEXP) as FaturamentoEXP
from #TmpFaturamentoExp
group by nm_grupo_categoria, 
         sg_categoria_produto
order by nm_grupo_categoria, 
         sg_categoria_produto

