
CREATE procedure pr_consistencia_comissao_categoria

@dt_inicial  datetime,
@dt_final    datetime,
@ic_corrigir_categoria char(1) = 'N'

as

  set @ic_corrigir_categoria = isnull(@ic_corrigir_categoria,'N')

   -- Itens de Nota Fiscal sem Categoria de Produto

   select a.dt_nota_saida         as 'Datanota',
          a.cd_nota_saida         as 'Nota',
          e.nm_fantasia_cliente   as 'Cliente',
          a.cd_vendedor           as 'Setor',
          b.cd_item_nota_saida    as 'ItemNF',
          b.cd_pedido_venda       as 'Pedido',   
          b.cd_item_pedido_venda  as 'ItemPV',
          b.qt_item_nota_saida    as 'Qtd',
          b.vl_unitario_item_nota as 'Preco',
          d.cd_mascara_categoria  as 'MapaPedido',
          d.sg_categoria_produto  as 'CategoriaPedido',

          'Produto' =
          case when ( b.ic_tipo_nota_saida_item = 'P' )
            then case when ( b.cd_produto is null )
                   then b.nm_fantasia_produto
                   else f.nm_fantasia_produto
                 end
            else
                 case when ( b.cd_servico is null )
                   then b.nm_fantasia_produto
                   else s.nm_servico
                 end
          end,

          'Descricao' =
          case when ( b.ic_tipo_nota_saida_item = 'P' )
            then cast(case when ( b.cd_produto is null )
                        then b.nm_produto_item_nota 
                        else f.nm_produto 
                      end as varchar(50))
            else
                cast (case when ( b.cd_servico is null )
                        then b.nm_produto_item_nota
                        else s.nm_servico
                      end as varchar(50))
          end,

          pv.dt_pedido_venda,
          b.cd_produto,
          b.cd_servico 
   into
     #ItensSemCategoria
   from
     nota_saida a

     inner join nota_saida_item b on
     a.cd_nota_saida = b.cd_nota_saida

     inner join cliente e on
     a.cd_cliente = e.cd_cliente

     inner join pedido_venda_item c on
     b.cd_pedido_venda = c.cd_pedido_venda and
     b.cd_item_pedido_venda = c.cd_item_pedido_venda

     inner join pedido_venda pv on
     pv.cd_pedido_venda = c.cd_pedido_venda

     -- Buscar categoria do pedido (se existir)
     left outer join categoria_produto d on
     c.cd_categoria_produto = d.cd_categoria_produto

     inner join operacao_fiscal ope on 
     b.cd_operacao_fiscal = ope.cd_operacao_fiscal 

     left outer join vendedor g on
     a.cd_vendedor = g.cd_vendedor

     left outer join produto f on
     b.cd_produto = f.cd_produto 

     left outer join servico s on
     b.cd_servico = s.cd_servico

   where 
      (a.dt_nota_saida between @dt_inicial and @dt_final) and
      a.cd_status_nota <> 7
      and
      g.ic_consiste_preco_orcado <> 'N'
      and
      isnull(b.cd_item_pedido_venda,0) < 80 and
      b.cd_categoria_produto is null
      and
      isnull(d.ic_comissao_categoria,'S') = 'S'
      and
--   ((b.cd_categoria_produto is null and   -- Se não houver categoria na nota e
--     c.cd_pedido_venda is null) or        -- não houver pedido     ou
--     c.cd_categoria_produto is null) and  -- o pedido também não têm categoria
      ope.ic_comercial_operacao = 'S'
      and
      (pv.dt_pedido_venda <= @dt_final)

   order by
       b.cd_nota_saida,
       b.cd_item_nota_saida

  -- Corrrigir as Categorias
  if ( @ic_corrigir_categoria = 'S' )
  begin

    print ''

    declare @cd_nota_saida int,
            @cd_pedido_venda int,
            @cd_produto int,
            @cd_servico int

    declare cr cursor for
      select Nota, Pedido, cd_produto, cd_servico from  #ItensSemCategoria

    open cr

    FETCH NEXT FROM cr
      INTO @cd_nota_saida, @cd_pedido_venda, @cd_produto, @cd_servico

    while ( @@FETCH_STATUS = 0 )
    begin
        --Atualiza Tabela Nota_Item_Saida (cd_categoria_produto), de acordo com o código do serviço
        update nota_saida_item
          set cd_categoria_produto = s.cd_categoria_produto
        from
          nota_saida_item nsi, servico s
        where
          (nsi.cd_nota_saida = @cd_nota_saida) and
          (nsi.cd_categoria_produto is null)
          and
          (s.cd_servico = nsi.cd_servico)
        
        --Atualiza Tabela Pedido_Venda_Item (cd_categoria_produto), de acordo com o código do serviço
        update pedido_venda_item
          set cd_categoria_produto = s.cd_categoria_produto
        from
          pedido_venda_item pvi, servico s
        where
         (pvi.cd_pedido_venda = @cd_pedido_venda) and
         (pvi.cd_categoria_produto is null)
         and
         (s.cd_servico = pvi.cd_servico)

        --Atualiza Tabela Nota_Saida_Item (cd_categoria_produto), de acordo com o código do Produto
        update nota_saida_item
         set cd_categoria_produto = p.cd_categoria_produto
        from
         nota_saida_item nsi, produto p
        where
         (nsi.cd_nota_saida = @cd_nota_saida) and
         (nsi.cd_categoria_produto is null)
         and
         (p.cd_produto = nsi.cd_produto)

        --Atualiza Tabela Pedido_Venda_Item (cd_categoria_produto), de acordo com o código do Produto
        update pedido_venda_item
         set cd_categoria_produto = p.cd_categoria_produto
        from
         pedido_venda_item pvi, produto p
        where
         (pvi.cd_pedido_venda = @cd_pedido_venda) and
         (pvi.cd_categoria_produto is null)
         and
         (p.cd_produto = pvi.cd_produto)

      FETCH NEXT FROM cr
        INTO @cd_nota_saida, @cd_pedido_venda, @cd_produto, @cd_servico
    end

    close cr
    deallocate cr
    
  end
  else
  begin
    select * from #ItensSemCategoria
  end

