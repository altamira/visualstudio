
CREATE PROCEDURE pr_consulta_programacao_faturamento_aux

@cd_pedido_venda        int   = 0,
@cd_item_pedido_venda   int   = 0,
@ic_parametro           int   = 0,
@cd_produto             int   = 0,
@qt_progfat_item_pedido float = 0

as

Declare @cd_fase_venda_produto int

select 
  @cd_fase_venda_produto = isnull(cd_fase_produto,0)
from 
  Parametro_Comercial with (nolock)
where 
  cd_empresa = dbo.fn_empresa()

If @ic_parametro = 1          -- Composicao
Begin
  select nsi.cd_fase_produto, 
         nsi.cd_produto,
         IsNull(Sum(nsi.qt_item_nota_saida),0) as qt_item_nota_saida
  Into #notastemp
  from nota_saida_item nsi                 with (nolock)
       inner join nota_saida ns            with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
       left outer join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
       left outer join grupo_operacao_fiscal gof with (nolock) on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
  where IsNull(ns.ic_emitida_nota_saida,'N') = 'N' and
        ns.dt_cancel_nota_saida is null and
        IsNull(nsi.ic_movimento_estoque,'N') = 'N' and
        IsNull(opf.ic_estoque_op_fiscal,'N') = 'S' and
        IsNull(nsi.cd_produto,0) <> 0 and
        gof.cd_tipo_operacao_fiscal = 2
  group by nsi.cd_produto, nsi.cd_fase_produto

  union all

  select pvc.cd_fase_produto, 
         pvc.cd_produto,
         IsNull(Sum(nsi.qt_item_nota_saida),0) * IsNull(Sum(pvc.qt_item_produto_comp),0) as qt_item_nota_saida
  from nota_saida_item nsi with (nolock)
       inner join nota_saida ns with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
       left outer join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
       left outer join grupo_operacao_fiscal gof on opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
       left outer join pedido_venda_composicao pvc on pvc.cd_pedido_venda = nsi.cd_pedido_venda and
                                                      pvc.cd_item_pedido_venda = nsi.cd_item_pedido_venda 

  where IsNull(ns.ic_emitida_nota_saida,'N') = 'N' and
        ns.dt_cancel_nota_saida is null and
        IsNull(nsi.ic_movimento_estoque,'N') = 'N' and
        IsNull(opf.ic_estoque_op_fiscal,'N') = 'S' and
        IsNull(nsi.cd_produto,0) = 0 and
        gof.cd_tipo_operacao_fiscal = 2
  group by pvc.cd_produto, pvc.cd_fase_produto

  select cd_produto, 
         cd_fase_produto,
         IsNull(Sum(qt_item_nota_saida),0) as qt_item_nota_saida
  into #notas
  from #notastemp
  group by cd_produto, cd_fase_produto

  select pvc.nm_fantasia_produto as Produto,
         IsNull(pvc.nm_produto_composicao, p.nm_produto) as Descricao,
         Case IsNull(@qt_progfat_item_pedido,0)
           When 0
             Then IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0) 
           Else IsNull(@qt_progfat_item_pedido,0) * IsNull(pvc.qt_item_produto_comp,0)
         End as Quantidade,
         IsNull(ps.qt_saldo_reserva_produto,0)                                as Disponivel, 
         IsNull(ps.qt_saldo_atual_produto,0) - IsNull(n.qt_item_nota_saida,0) as Fisico,
         pvc.cd_id_item_pedido_venda                                          as Item,
         Case IsNull(@qt_progfat_item_pedido,0)
           When 0
             Then 
               Case
                 when ((IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0))) +
                         IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                 Group by pvi.cd_produto),0) +
                         IsNull((select Sum(IsNull(pvi.qt_progfat_item_pedido,0) * IsNull(pcv.qt_item_produto_comp,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                      inner join pedido_venda_composicao pcv with (nolock) on pcv.cd_pedido_venda = pvi.cd_pedido_venda and
                                                                                              pcv.cd_item_pedido_venda = pvi.cd_item_pedido_venda
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0 and
                                       pvi.cd_pedido_venda <> @cd_pedido_venda
                                 Group by pvi.cd_produto),0) + n.qt_item_nota_saida > IsNull(ps.qt_saldo_atual_produto,0)
                   Then 'S'
                 Else 'N'
               End
           Else
               Case
                 when ((IsNull(@qt_progfat_item_pedido,0) * IsNull(pvc.qt_item_produto_comp,0))) +
                         IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                 Group by pvi.cd_produto),0) +
                         IsNull((select Sum(IsNull(pvi.qt_progfat_item_pedido,0) * IsNull(pcv.qt_item_produto_comp,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                      inner join pedido_venda_composicao pcv with (nolock) on pcv.cd_pedido_venda = pvi.cd_pedido_venda and
                                                                                              pcv.cd_item_pedido_venda = pvi.cd_item_pedido_venda
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0 and
                                       pvi.cd_pedido_venda <> @cd_pedido_venda
                                 Group by pvi.cd_produto),0) + n.qt_item_nota_saida > IsNull(ps.qt_saldo_atual_produto,0)
                   Then 'S'
                 Else 'N'
               End
         End as SemEstoque
  from pedido_venda_composicao pvc      with (nolock)
       inner join produto p             with (nolock) on p.cd_produto  = pvc.cd_produto
       left outer join produto_saldo ps with (nolock) on ps.cd_produto = p.cd_produto and
                                                         ps.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda_produto)
       inner join pedido_venda_item pvi with (nolock) on pvi.cd_pedido_venda = pvc.cd_pedido_venda and
                                                         pvi.cd_item_pedido_venda = pvc.cd_item_pedido_venda 
       left outer join #Notas n on n.cd_produto = p.cd_produto and
                                   n.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda_produto)
  
  where pvc.cd_pedido_venda = @cd_pedido_venda and
        pvc.cd_item_pedido_venda = @cd_item_pedido_venda

  order by pvc.cd_id_item_pedido_venda

End

Else if @ic_parametro = 2     -- Reservas        
Begin
  select c.nm_fantasia_cliente as Cliente,
         pvi.dt_entrega_vendas_pedido as DataEntrega,
         IsNull(pvi.qt_saldo_pedido_venda,0) Saldo,
         pv.cd_pedido_venda as PedidoVenda,
         pvi.cd_item_pedido_venda as Item,
         0 as ItemComp
  from pedido_venda pv with (nolock)
       inner join pedido_venda_item pvi with (nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
       inner join cliente c with (nolock) on c.cd_cliente = pv.cd_cliente
  where pvi.cd_produto = @cd_produto and
        pvi.qt_saldo_pedido_venda > 0 and
        pvi.dt_cancelamento_item is null

  Union all

  select c.nm_fantasia_cliente        as Cliente,
         pvi.dt_entrega_vendas_pedido as DataEntrega,
         IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0) Saldo,
         pv.cd_pedido_venda           as PedidoVenda,
         pvi.cd_item_pedido_venda     as Item,
         cd_id_item_pedido_venda      as ItemComp
  from pedido_venda pv  with (nolock)
       inner join pedido_venda_item pvi       with (nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
       inner join cliente c                   with (nolock) on c.cd_cliente = pv.cd_cliente
       inner join pedido_venda_composicao pvc with (nolock) on pvc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                               pvc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  where pvc.cd_produto = @cd_produto and
        pvi.qt_saldo_pedido_venda > 0 and
        pvi.dt_cancelamento_item is null
  order by 2, 4, 5, 6
End

Else If @Ic_parametro = 3     -- Saldo Componentes
Begin
  select pvc.nm_fantasia_produto as Produto,
         IsNull(pvc.nm_produto_composicao, p.nm_produto) as Descricao,
         Case IsNull(@qt_progfat_item_pedido,0)
           When 0
             Then (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0)) +
                         IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                 Group by pvi.cd_produto),0) 
           Else (IsNull(@qt_progfat_item_pedido,0) * IsNull(pvc.qt_item_produto_comp,0)) +
                         IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                 from pedido_venda_item pvi with (nolock) 
                                 where pvi.cd_produto = pvc.cd_produto and
                                       pvi.qt_saldo_pedido_venda > 0 and
                                       pvi.dt_cancelamento_item is null and
                                       IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                 Group by pvi.cd_produto),0)
         End as Quantidade,
         pvc.cd_id_item_pedido_venda as Item
  from pedido_venda_composicao pvc with (nolock)
       inner join produto p with (nolock) on p.cd_produto = pvc.cd_produto
       left outer join produto_saldo ps with (nolock) on ps.cd_produto = p.cd_produto and
                                                         ps.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda_produto)
       inner join pedido_venda_item pvi with (nolock) on pvi.cd_pedido_venda = pvc.cd_pedido_venda and
                                                         pvi.cd_item_pedido_venda = pvc.cd_item_pedido_venda 
  where pvc.cd_pedido_venda = @cd_pedido_venda and
        pvc.cd_item_pedido_venda = @cd_item_pedido_venda and
        IsNull(ps.qt_saldo_atual_produto,0) < Case IsNull(@qt_progfat_item_pedido,0)
                                                When 0
                                                  Then (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0)) +
                                                        IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                                                from pedido_venda_item pvi with (nolock) 
                                                                where pvi.cd_produto = pvc.cd_produto and
                                                                      pvi.qt_saldo_pedido_venda > 0 and
                                                                      pvi.dt_cancelamento_item is null and
                                                                      IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                                                Group by pvi.cd_produto),0) 
                                                  Else (IsNull(@qt_progfat_item_pedido,0) * IsNull(pvc.qt_item_produto_comp,0)) + 
                                                        IsNull((select Sum(IsNull(pvi.qt_saldo_pedido_venda,0)) 
                                                                from pedido_venda_item pvi with (nolock) 
                                                                where pvi.cd_produto = pvc.cd_produto and
                                                                      pvi.qt_saldo_pedido_venda > 0 and
                                                                      pvi.dt_cancelamento_item is null and
                                                                      IsNull(pvi.qt_progfat_item_pedido,0) <> 0
                                                                Group by pvi.cd_produto),0) 
                                              End 

--        (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0)) > ps.qt_saldo_atual_produto

End

-----------------------------------------------------------------------------------------
--Executando
-----------------------------------------------------------------------------------------
--exec pr_consulta_programacao_faturamento_aux 62679, 3, 1, 0, 0
--exec pr_consulta_programacao_faturamento_aux 0, 0, 2, 30988, 0
--exec pr_consulta_programacao_faturamento_aux 62672, 2, 3, 0, 1
--select * from grupo_produto
-----------------------------------------------------------------------------------------

