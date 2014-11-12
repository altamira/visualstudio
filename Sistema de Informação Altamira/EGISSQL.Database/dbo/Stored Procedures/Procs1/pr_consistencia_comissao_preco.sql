
CREATE procedure pr_consistencia_comissao_preco


@dt_inicial   datetime,
@dt_final     datetime,
@ic_parametro int = 0

as

--Pedidos Faturados no Período

if @ic_parametro = 0
begin

   --Item de Pedido sem Preço Orçado

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
          case when ( b.cd_produto is null or isnull(b.cd_produto,0)=0 ) then
             b.nm_fantasia_produto else f.nm_fantasia_produto end,
          'Descricao' =
          cast(case when ( b.cd_produto is null or isnull(b.cd_produto,0) = 0 ) then
               b.nm_produto_item_nota else f.nm_produto end as varchar(50)),
          pv.dt_pedido_venda ,
          f.cd_mascara_produto,
          f.nm_produto
   from
     nota_saida a                       with (nolock) 

     inner join nota_saida_item b       with (nolock) on a.cd_nota_saida = b.cd_nota_saida

     inner join cliente e               with (nolock) on a.cd_cliente = e.cd_cliente

     inner join pedido_venda_item c     with (nolock) on b.cd_pedido_venda      = c.cd_pedido_venda and
                                                         b.cd_item_pedido_venda = c.cd_item_pedido_venda

     inner join pedido_venda pv          with (nolock) on pv.cd_pedido_venda = c.cd_pedido_venda
     
     left outer join categoria_produto d with (nolock) on b.cd_categoria_produto = d.cd_categoria_produto

     left outer join vendedor g          with (nolock) on a.cd_vendedor = g.cd_vendedor

     left outer join produto f           with (nolock) on f.cd_produto  = b.cd_produto 

     inner join operacao_fiscal op       with (nolock) on b.cd_operacao_fiscal = op.cd_operacao_fiscal

   where 
      (a.dt_nota_saida between @dt_inicial and @dt_final) and
       a.dt_cancel_nota_saida is null                     and
       b.cd_categoria_produto is not null                 and  -- é necessário, para não trazer notas de remessa
      (round(isnull(c.vl_lista_item_pedido,0),6) = 0 )    and
       isnull(op.ic_comercial_operacao,'N') = 'S'    and                 --Operação Comercial
       --g.ic_consiste_preco_orcado = 'S'    and
      (pv.dt_pedido_venda <= @dt_final)              and
      --Carlos 27.06.2005
      --Verifica se a Categoria de Produto efetua o Cálculo da Comissão
      isnull(d.ic_comissao_categoria,'N') = 'S' 
   order by
       b.cd_nota_saida,
       b.cd_item_nota_saida

end

--Devoluções no Período

if @ic_parametro = 1
begin

   --Item de Pedido sem Preço Orçado

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
          case when ( b.cd_produto is null or isnull(b.cd_produto,0)=0 ) then
             b.nm_fantasia_produto else f.nm_fantasia_produto end,
          'Descricao' =
          cast(case when ( b.cd_produto is null or isnull(b.cd_produto,0)=0 ) then
               b.nm_produto_item_nota else f.nm_produto end as varchar(50)),
          pv.dt_pedido_venda,
          f.cd_mascara_produto,
          f.nm_produto
 
   from
     nota_saida a                    with (nolock) 

     inner join nota_saida_item b    with (nolock) on
     a.cd_nota_saida = b.cd_nota_saida

     inner join cliente e            with (nolock) on
     a.cd_cliente = e.cd_cliente

     inner join pedido_venda_item c  with (nolock) on
     b.cd_pedido_venda      = c.cd_pedido_venda and
     b.cd_item_pedido_venda = c.cd_item_pedido_venda

     inner join pedido_venda pv      with (nolock) on
     pv.cd_pedido_venda = c.cd_pedido_venda
     
     left outer join categoria_produto d with (nolock) on
     b.cd_categoria_produto = d.cd_categoria_produto

     left outer join vendedor g      with (nolock) on
     a.cd_vendedor = g.cd_vendedor

     left outer join produto f       with (nolock) on b.cd_produto = f.cd_produto 

     inner join operacao_fiscal op   with (nolock) on b.cd_operacao_fiscal = op.cd_operacao_fiscal

   where 
      (b.dt_cancel_item_nota_saida between @dt_inicial and @dt_final) and
       b.cd_status_nota in (3,4)                          and --Devolução
       b.cd_categoria_produto is not null                 and  -- é necessário, para não trazer notas de remessa
      (round(isnull(c.vl_lista_item_pedido,0),6) = 0 )    and
       isnull(op.ic_comercial_operacao,'N') = 'S'    and                 --Operação Comercial
       --g.ic_consiste_preco_orcado = 'S'  and
      --Carlos 27.06.2005
      --Verifica se a Categoria de Produto efetua o Cálculo da Comissão
      isnull(d.ic_comissao_categoria,'N') = 'S'
   order by
       b.cd_nota_saida,
       b.cd_item_nota_saida

end

