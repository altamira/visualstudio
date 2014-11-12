
CREATE PROCEDURE pr_produto_especial_vendido
@ic_parametro              int,
@nm_fantasia_produto varchar(30),
@cd_pedido_venda_composicao int = 0,
@cd_consulta_composicao int = 0,
@cd_item_composicao int = 0,
@cd_pedido_venda int = 0,
@cd_consulta int = 0,
@cd_item int = 0

AS

Begin
  ------------------------------------------------------------------------------
  If @ic_parametro = 1         -- Listar produto especial vendido
  ------------------------------------------------------------------------------
  Begin
    select pvi.nm_fantasia_produto as Produto,
           pvi.nm_produto_pedido as Descricao,
           c.nm_fantasia_cliente as Cliente,
           0 as Proposta,
           Max(pvi.cd_pedido_venda) as PedidoVenda,
           pvi.cd_item_pedido_venda as Item,
           Round(IsNull(pvi.vl_unitario_item_pedido,0),2) as Valor,
           Max(pv.dt_pedido_venda) as Data,
           Cast(1 as Float) as qt_item_pedido_venda,
           Cast(1 as Float) as qt_saldo_pedido_venda,
           getdate() as dt_entrega_vendas_pedido,
           pvi.pc_desconto_item_pedido,
           pvi.cd_pdcompra_item_pedido,
           pvi.ic_fatura_item_pedido,
           pvi.ic_reserva_item_pedido,
           pvi.ic_subs_tributaria_item,
           pvi.ic_desconto_item_pedido,
           pvi.vl_indice_item_pedido,
           pvi.cd_grupo_produto,
           pvi.cd_grupo_categoria,
           pvi.cd_categoria_produto,
           pvi.ic_smo_item_pedido_venda,
           pvi.ic_controle_pcp_pedido,
           pvi.ic_produto_especial,
           pvi.ic_orcamento_pedido_venda,
           pvi.cd_serie_produto,
           pvi.pc_ipi,
           pvi.pc_icms,
           pvi.qt_dia_entrega_pedido,
           pvi.ic_pedido_venda_item,
           pvi.ic_progfat_item_pedido,
           pvi.qt_progfat_item_pedido,
           pvi.cd_unidade_medida,
           pvi.pc_reducao_icms,
           pvi.ic_gprgcnc_pedido_venda,
           pvi.ic_montagem_item_pedido,
           pvi.vl_frete_item_pedido,
           pvi.cd_moeda_cotacao,
           pvi.vl_moeda_cotacao,
           pvi.dt_moeda_cotacao,
           pvi.ic_controle_mapa_pedido,
           pvi.ic_kit_grupo_produto,
           pvi.cd_mascara_classificacao, 
           pvi.ic_imediato_produto
    from pedido_venda_item pvi with (nolock)
         inner join pedido_venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
         left outer join cliente c on c.cd_cliente = pv.cd_cliente
    where pvi.nm_fantasia_produto like '%' + @nm_fantasia_produto + '%' and
          pvi.ic_produto_especial = 'S'
    Group by pvi.nm_fantasia_produto, pvi.nm_produto_pedido, c.nm_fantasia_cliente, --pvi.cd_pedido_venda,
             pvi.cd_item_pedido_venda, pvi.qt_item_pedido_venda, pvi.vl_unitario_item_pedido,
             pvi.pc_desconto_item_pedido, pvi.cd_pdcompra_item_pedido, pvi.ic_fatura_item_pedido,
             pvi.ic_reserva_item_pedido, pvi.ic_subs_tributaria_item, pvi.ic_desconto_item_pedido,
             pvi.vl_indice_item_pedido, pvi.cd_grupo_produto, pvi.cd_grupo_categoria,
             pvi.cd_categoria_produto, pvi.ic_smo_item_pedido_venda, pvi.ic_controle_pcp_pedido,
             pvi.ic_produto_especial, pvi.ic_orcamento_pedido_venda, pvi.cd_serie_produto,
             pvi.pc_ipi, pvi.pc_icms, pvi.qt_dia_entrega_pedido, pvi.ic_pedido_venda_item,
             pvi.ic_progfat_item_pedido, pvi.qt_progfat_item_pedido, pvi.cd_unidade_medida,
             pvi.pc_reducao_icms, pvi.ic_gprgcnc_pedido_venda, pvi.ic_montagem_item_pedido,
             pvi.vl_frete_item_pedido, pvi.cd_moeda_cotacao, pvi.vl_moeda_cotacao,
             pvi.dt_moeda_cotacao, pvi.ic_controle_mapa_pedido,  pvi.ic_kit_grupo_produto,
             pvi.cd_mascara_classificacao, pvi.ic_imediato_produto

    Union
		
    select ci.nm_fantasia_produto as Produto,
           ci.nm_produto_consulta as Descricao, 
           cl.nm_fantasia_cliente as Cliente,
           Max(ci.cd_consulta) as Proposta,
           0 as PedidoVenda,
           ci.cd_item_consulta as Item,
           Round(IsNull(ci.vl_unitario_item_consulta,0),2) as Valor,        
           Max(c.dt_consulta) as Data,
           Cast(1 as Float) as qt_item_pedido_venda,
           Cast(1 as Float) as qt_saldo_pedido_venda,
           getdate() as dt_entrega_vendas_pedido,
           ci.pc_desconto_item_consulta as pc_desconto_item_pedido,
           ci.cd_pedido_compra_consulta as cd_pdcompra_item_pedido,
           'N' as ic_fatura_item_pedido,
           'S' as ic_reserva_item_pedido,
           ci.ic_subs_tributaria_cons,
           ci.ic_desconto_consulta_item as ic_desconto_item_pedido,
           ci.vl_indice_item_consulta as vl_indice_item_pedido,
           ci.cd_grupo_produto,
           ci.cd_grupo_categoria,
           ci.cd_categoria_produto,
           'N' as ic_smo_item_pedido_venda,
           'N' as ic_controle_pcp_pedido,
           ci.ic_produto_especial,
           ci.ic_orcamento_consulta as ic_orcamento_pedido_venda,
           ci.cd_serie_produto,
           ci.pc_ipi,
           ci.pc_icms,
           ci.qt_dia_entrega_consulta as qt_dia_entrega_pedido,
           ci.ic_consulta_item as ic_pedido_venda_item,
           'N' as ic_progfat_item_pedido, 
           0 as qt_progfat_item_pedido,
           ci.cd_unidade_medida,
           ci.pc_reducao_icms,
           'N' as ic_gprgcnc_pedido_venda,
           ci.ic_montagem_item_consulta as ic_montagem_item_pedido,
           ci.vl_frete_item_consulta as vl_frete_item_pedido,
           ci.cd_moeda_cotacao,
           ci.vl_moeda_cotacao,
           ci.dt_moeda_cotacao,
           ci.ic_considera_mp_orcamento as ic_controle_mapa_pedido,
           ci.ic_kit_grupo_produto,
           ci.cd_mascara_classificacao,
           ci.ic_imediato_produto
    from consulta_itens ci with (nolock)
		     inner join consulta c on c.cd_consulta = ci.cd_consulta
		     left outer join cliente cl on cl.cd_cliente = c.cd_cliente
	 where ci.nm_fantasia_produto like '%' + @nm_fantasia_produto + '%' and
          ci.ic_produto_especial = 'S'
    Group by ci.nm_fantasia_produto, ci.nm_produto_consulta, cl.nm_fantasia_cliente, --ci.cd_consulta,
             ci.cd_item_consulta, ci.qt_item_consulta, ci.vl_unitario_item_consulta,
             ci.pc_desconto_item_consulta, ci.cd_pedido_compra_consulta,
             ci.ic_subs_tributaria_cons, ci.ic_desconto_consulta_item,
             ci.vl_indice_item_consulta, ci.cd_grupo_produto, ci.cd_grupo_categoria,
             ci.cd_categoria_produto, ci.ic_produto_especial, ci.ic_orcamento_consulta,
             ci.cd_serie_produto, ci.pc_ipi, ci.pc_icms, ci.qt_dia_entrega_consulta,
             ci.ic_consulta_item, ci.cd_unidade_medida, ci.pc_reducao_icms, ci.ic_montagem_item_consulta,
             ci.vl_frete_item_consulta, ci.cd_moeda_cotacao, ci.vl_moeda_cotacao, ci.dt_moeda_cotacao,
             ci.ic_considera_mp_orcamento, ci.ic_kit_grupo_produto, ci.cd_mascara_classificacao, ci.ic_imediato_produto
    order by 8 desc, 4 desc, 5 desc, 6 desc
  End
  ------------------------------------------------------------------------------
  Else if @ic_parametro = 2     -- Gravar composicao Pedido Venda / Proposta    
  ------------------------------------------------------------------------------
  Begin                        
    If @cd_pedido_venda > 0     -- Gravar no pedido venda composicao 
    Begin
      If @cd_pedido_venda_composicao > 0
      begin
        Insert into pedido_venda_composicao (cd_pedido_venda, cd_item_pedido_venda, cd_produto,
                                             cd_id_item_pedido_venda, qt_item_produto_comp, cd_fase_produto,
                                             ic_estoque_produto, dt_estoque_produto, cd_ordem_item_composicao,
                                             vl_item_comp_pedido, nm_fantasia_produto)              
                                  select @cd_pedido_venda, @cd_item, cd_produto,
                                         cd_id_item_pedido_venda, qt_item_produto_comp, cd_fase_produto,
                                         ic_estoque_produto, dt_estoque_produto, cd_ordem_item_composicao,
                                         vl_item_comp_pedido, nm_fantasia_produto              
                                  from pedido_venda_composicao
                                  where cd_pedido_venda = @cd_pedido_venda_composicao and
                                        cd_item_pedido_venda = @cd_item_composicao
      End
 
      If @cd_consulta_composicao > 0
      Begin
        Insert into pedido_venda_composicao (cd_pedido_venda, cd_item_pedido_venda, cd_produto,
                                             cd_id_item_pedido_venda, qt_item_produto_comp, cd_fase_produto,
                                             cd_ordem_item_composicao, vl_item_comp_pedido, nm_fantasia_produto)              
                                  select @cd_pedido_venda, @cd_item, cd_produto, 
                                         cd_item_comp_consulta, qt_item_comp_consulta, cd_fase_produto,
                                         cd_ordem_item_composicao, vl_item_comp_consulta, nm_fantasia_produto  
                                  from consulta_item_composicao
                                  where cd_consulta = @cd_consulta_composicao and 
                                        cd_item_consulta = @cd_item_composicao
      End 
    End

    If @cd_consulta > 0     -- Gravar na proposta composicao 
    Begin
      If @cd_pedido_venda_composicao > 0
      begin
        Insert into consulta_item_composicao (cd_consulta, cd_item_consulta, cd_produto, 
                                              cd_item_comp_consulta, qt_item_comp_consulta, cd_fase_produto,
                                              cd_ordem_item_composicao, vl_item_comp_consulta, nm_fantasia_produto)              
                                  select @cd_consulta, @cd_item, cd_produto,
                                         cd_id_item_pedido_venda, qt_item_produto_comp, cd_fase_produto,
                                         cd_ordem_item_composicao, vl_item_comp_pedido, nm_fantasia_produto              
                                  from pedido_venda_composicao
                                  where cd_pedido_venda = @cd_pedido_venda_composicao and
                                        cd_item_pedido_venda = @cd_item_composicao
      End
 
      If @cd_consulta_composicao > 0
      Begin
        Insert into consulta_item_composicao (cd_consulta, cd_item_consulta, cd_produto, 
                                              cd_item_comp_consulta, qt_item_comp_consulta, cd_fase_produto,
                                              cd_ordem_item_composicao, vl_item_comp_consulta, nm_fantasia_produto)              
                                  select @cd_consulta, @cd_item, cd_produto, 
                                         cd_item_comp_consulta, qt_item_comp_consulta, cd_fase_produto,
                                         cd_ordem_item_composicao, vl_item_comp_consulta, nm_fantasia_produto  
                                  from consulta_item_composicao
                                  where cd_consulta = @cd_consulta_composicao and 
                                        cd_item_consulta = @cd_item_composicao
      End 
    End
  End
  ---------------------------------------------------------------------------------------------------
  Else if @ic_parametro = 3     -- listar a composicao dos produtos especiais Pedido Venda / Proposta    
  ---------------------------------------------------------------------------------------------------
  Begin                        
    If @cd_pedido_venda_composicao > 0
      select cd_produto,
             cd_id_item_pedido_venda, 
             qt_item_produto_comp,
             cd_fase_produto,
             ic_estoque_produto, 
             dt_estoque_produto,
             cd_ordem_item_composicao,
             vl_item_comp_pedido, 
             nm_fantasia_produto              
      from pedido_venda_composicao
      where cd_pedido_venda = @cd_pedido_venda_composicao and
            cd_item_pedido_venda = @cd_item_composicao
    
    If @cd_consulta_composicao > 0
      select cd_produto, 
             cd_item_comp_consulta as cd_id_item_pedido_venda, 
             qt_item_comp_consulta as qt_item_produto_comp,
             cd_fase_produto,
             'S' as ic_estoque_produto,
             Cast(Null as DateTime) as dt_estoque_produto,
             cd_ordem_item_composicao, 
             vl_item_comp_consulta as vl_item_comp_pedido,
             nm_fantasia_produto  
      from consulta_item_composicao
      where cd_consulta = @cd_consulta_composicao and 
            cd_item_consulta = @cd_item_composicao
  End
End

--exec pr_produto_especial_vendido 1, 'kabrat000043'
--exec pr_produto_especial_vendido 1, 'kabrat'
--exec pr_produto_especial_vendido 2, '', 57027, 0, 3, 57075, 0, 2
--exec pr_produto_especial_vendido 2, '', 0, 71839, 2, 0, 71841, 2
--exec pr_produto_especial_vendido 2, '', 0, 71839, 2, 57075, 0, 2
--exec pr_produto_especial_vendido 2, '', 57027, 0, 3, 0, 71841, 2
--exec pr_produto_especial_vendido 3, '', 0, 71841, 2
--exec pr_produto_especial_vendido 3, '', 57027, 0, 3

--select * from pedido_venda_composicao where cd_pedido_venda = 57075 and cd_item_pedido_venda = 2
--select * from consulta_item_composicao where cd_consulta = 71841 and cd_item_consulta = 2
--delete from pedido_venda_composicao where cd_pedido_venda = 57075 and cd_item_pedido_venda = 2
--delete from consulta_item_composicao where cd_consulta = 71841 and cd_item_consulta = 2


