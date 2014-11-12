
CREATE procedure pr_consistencia_comissao_vendedor

@dt_inicial  datetime,
@dt_final    datetime

as

   -- Nota fiscal sem vendedor ou vendedor não cadastrado na tabela Vendedor_Comissao

   select a.dt_nota_saida         as 'Datanota',
          a.cd_nota_saida         as 'Nota',
          e.nm_fantasia_cliente   as 'Cliente',
          a.cd_vendedor           as 'Setor',
          b.cd_item_nota_saida    as 'ItemNF',
          b.cd_pedido_venda       as 'Pedido',   
          b.cd_item_pedido_venda  as 'ItemPV',
          b.qt_item_nota_saida    as 'Qtd',
          b.vl_unitario_item_nota as 'Preco',
          d.cd_mascara_categoria  as 'Mapa',
          d.sg_categoria_produto  as 'Categoria',
          'Produto' =
          case when ( b.cd_produto is null ) then
             b.nm_fantasia_produto else f.nm_fantasia_produto end,
          'Descricao' =
          cast(case when ( b.cd_produto is null ) then
               b.nm_produto_item_nota else f.nm_produto end as varchar(50)),
          pv.dt_pedido_venda,
          f.cd_mascara_produto,
          f.nm_produto

   from
     nota_saida a

     inner join nota_saida_item b on
     a.cd_nota_saida = b.cd_nota_saida

     inner join cliente e on
     a.cd_cliente = e.cd_cliente

     left outer join pedido_venda_item c on
     b.cd_pedido_venda = c.cd_pedido_venda and
     b.cd_item_pedido_venda = c.cd_item_pedido_venda
     
     left outer join pedido_venda pv on
     (pv.cd_pedido_venda = c.cd_pedido_venda)

     left outer join categoria_produto d on
     b.cd_categoria_produto = d.cd_categoria_produto

     left outer join produto f on
     b.cd_produto = f.cd_produto 

     inner join operacao_fiscal g on
     b.cd_operacao_fiscal = g.cd_operacao_fiscal

   where 
      (a.dt_nota_saida between @dt_inicial and @dt_final) and
       a.cd_status_nota <> 7                              and
     ((isnull(a.cd_vendedor,0) = 0) or
      (a.cd_vendedor not in (select cd_vendedor 
                             from vendedor)))             and 
       b.cd_categoria_produto is not null                 and -- é necessário, para não trazer notas de remessa
       c.cd_item_pedido_venda < 80                        and
       isnull(g.ic_comercial_operacao,'N') = 'S' and
       ((pv.cd_pedido_venda is null) or (pv.dt_pedido_venda <= @dt_final))


   order by
      b.cd_nota_saida,
      b.cd_item_nota_saida

