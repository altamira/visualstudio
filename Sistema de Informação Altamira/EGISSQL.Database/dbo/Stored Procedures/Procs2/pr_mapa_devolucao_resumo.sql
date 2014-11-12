

CREATE PROCEDURE pr_mapa_devolucao_resumo

@cd_grupo_categoria    int,
@cd_categoria_produto  int,
@dt_inicial            datetime,    --Data Inicial
@dt_final              datetime,    --Data Final
@ic_smo                char(1),
@Operacao              INT = 1
as

if @ic_smo = 'S' -- Considerar Smo
   set @ic_smo = ''

select cp.nm_categoria_produto,
       max(cp.sg_categoria_produto) as sg_categoria_produto,
       max(gc.nm_grupo_categoria)   as nm_grupo_categoria,
       max(cp.cd_grupo_categoria)   as cd_grupo_categoria,
       valorfrete =
       sum(vl_frete_item),
       qtddev =
       sum(case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida
                when nsi.qt_devolucao_item_nota > 0 then nsi.qt_devolucao_item_nota
       else 0 end), 
       devolucao = 
       sum(case when nsi.qt_devolucao_item_nota = 0 then nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota
                when nsi.qt_devolucao_item_nota > 0 then nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota
       else 0 end),
       devolucaocomfrete = 
       sum(case when nsi.qt_devolucao_item_nota = 0 then (nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) + nsi.vl_frete_item
                when nsi.qt_devolucao_item_nota > 0 then (nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota) + nsi.vl_frete_item
       else 0 end) 

FROM Nota_Saida_Item nsi 

LEFT OUTER JOIN Produto p ON 
nsi.cd_produto = p.cd_produto

INNER JOIN Categoria_Produto cp ON 
nsi.cd_categoria_produto = cp.cd_categoria_produto 

INNER JOIN Grupo_Categoria gc ON
cp.cd_grupo_categoria = gc.cd_grupo_categoria 

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

group by cp.nm_categoria_produto
order by cp.nm_categoria_produto

