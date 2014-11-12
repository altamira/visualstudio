--------------------------------------------------------------------------------------
--pr_analise_preco_setor_categoria
--------------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                         	           2004
-------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Análise de preço por setor e categoria
--Data            : 25.01.2000
--Atualizado      : 30.05.2000
--                : 05/08/2002 - Conversão para EGISSQL - Daniel C. Neto
--                : 09/08/2002 - Colocado IsNull em ic_smo_item_pedido_venda - Daniel C. Neto.
--                : 30.05.2006 - Categoria do Produto - Carlos Fernandes
--------------------------------------------------------------------------------------
CREATE procedure pr_analise_preco_setor_categoria
@cd_vendedor          int,
@cd_categoria_produto int,
@dt_inicial           datetime,
@dt_final             datetime,
@dt_perc_smo          datetime
as

select
    cli.nm_fantasia_cliente     as 'Cliente',
    v.nm_fantasia_vendedor      as 'Vendedor',
    a.cd_pedido_venda           as 'Pedido',
    0                           as 'NroNF',
    a.dt_pedido_venda           as 'Data',
    b.cd_item_pedido_venda      as 'Item',
    b.qt_item_pedido_venda      as 'Qtd',
    b.nm_produto_pedido         as 'Descricao',
    b.vl_unitario_item_pedido   as 'VENDA',
    b.vl_lista_item_pedido      as 'OrcadoOriginal',
    Orcado =
       case
          when (IsNull(a.ic_smo_pedido_venda,'N') ='S' and a.dt_pedido_venda < @dt_perc_smo) then 
             IsNull(b.vl_lista_item_pedido,0) - (IsNull(b.vl_lista_item_pedido,0) * 11/100)
          when (a.ic_smo_pedido_venda ='S' and a.dt_pedido_venda >= @dt_perc_smo) then 
             IsNull(b.vl_lista_item_pedido,0) - (isNull(b.vl_lista_item_pedido,0) * 8.8/100)
          else
             b.vl_lista_item_pedido
       end,

    'Perc' =
       case
          when (IsNull(a.ic_smo_pedido_venda,'N') ='S' and a.dt_pedido_venda < @dt_perc_smo) then  
             (100-(IsNull(b.vl_unitario_item_pedido,0) / (IsNull(b.vl_lista_item_pedido,0) - (IsNull(b.vl_lista_item_pedido,0) *11/100)))*100)
          when (a.ic_smo_pedido_venda ='S' and a.dt_pedido_venda >= @dt_perc_smo) then  
             (100-(IsNull(b.vl_unitario_item_pedido,0) / (IsNull(b.vl_lista_item_pedido,0) - (IsNull(b.vl_lista_item_pedido,0) *8.8/100)))*100)
          else 
             (100-(IsNull(b.vl_unitario_item_pedido,0) / (IsNull(b.vl_lista_item_pedido,0))) * 100)
       end,
    c.nm_categoria_produto  as 'DescricaoCategoria',
    c.sg_categoria_produto  as 'Categoria',
    a.ic_smo_pedido_venda   as 'SMO'
from
    Pedido_Venda a inner join 
    Pedido_Venda_Item b on b.cd_pedido_venda = a.cd_pedido_venda left outer join
    Cliente cli on cli.cd_cliente = a.cd_cliente            left outer join
    Vendedor v  on v.cd_vendedor  = a.cd_vendedor           left outer join
    Categoria_Produto c on c.cd_categoria_produto = b.cd_categoria_produto
Where
    a.dt_pedido_venda between @dt_inicial and @dt_final                               and
    ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))                            and
    a.dt_cancelamento_pedido is null                                                  and
    ((b.cd_categoria_produto = @cd_categoria_produto) or (@cd_categoria_produto = 0)) and 
    b.dt_cancelamento_item is null                                                    and
    IsNull(a.cd_status_pedido,7) <> 7                                                           and
    IsNull(b.ic_smo_item_pedido_venda,'N') = 'N'                                                       and
    IsNull(b.vl_lista_item_pedido,0) > 0                          

Order by Orcado desc
