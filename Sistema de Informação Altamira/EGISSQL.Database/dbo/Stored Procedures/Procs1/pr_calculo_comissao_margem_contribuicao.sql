
create procedure pr_calculo_comissao_margem_contribuicao
@cd_vendedor integer,
@dt_inicial  datetime,
@dt_final    datetime
as

  -- PERGUNTAS  
  -- 1 - QUAIS COLUNAS EXISTIRÃO NESTA CONSULTA
  -- 2 - QUANDO A MARGEM DE CONTRIBUIÇÃO ESTRAPOLAR OS LIMITES INFERIOR E EXTERIOR, QUAL 
  --     PERCENTUAL UTILIZAR

  declare @cd_markup int

  -- Markup
  select @cd_markup = cd_aplicacao_markup
  from parametro_comissao_empresa
  where cd_empresa = dbo.fn_empresa()

  select
    dbo.fn_comissao_margem_contribuicao( 
    -- Valor NET Corrigido
    ((pc.vl_net_outra_moeda * pvi.vl_moeda_cotacao) /
    -- Valor de Venda
    (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) - 
    ((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
     dbo.fn_indice_markup(@cd_markup,0))))
  from
    Pedido_Venda_Item pvi
  inner join Produto_Custo pc on pc.cd_produto = pvi.cd_produto
  where pvi.cd_pedido_venda = 6898

  


