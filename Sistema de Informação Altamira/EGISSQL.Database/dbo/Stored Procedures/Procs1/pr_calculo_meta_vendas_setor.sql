
CREATE  procedure pr_calculo_meta_vendas_setor
@cd_vendedor     int = 0,
@dt_inicial      datetime,
@dt_final        datetime,
@qt_mes_calculo  int = 0,
@pc_crescimento  float = 0

as

--select * from categoria_produto

-- Geração da tabela auxiliar de Vendas por Setor
-- Média dos Ultimos 5 meses

select   a.cd_vendedor                       as 'setor', 
         b.cd_categoria_produto              as 'Categoria',
         sum(b.qt_item_pedido_venda * 
             b.vl_unitario_item_pedido)      as 'Venda'
into 
   #MediaVendasSetor
from
   Pedido_Venda a inner join
   Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda 
where
   a.cd_vendedor = @cd_vendedor                         and
   a.dt_pedido_venda between @dt_inicial and @dt_final  and
   isnull(a.vl_total_pedido_venda,0) > 0                and
   isnull(a.ic_consignacao_pedido,'N') = 'N'            and
   IsNull(b.ic_smo_item_pedido_venda,'N') = 'N'         and
   b.cd_categoria_produto is not null                   and
   (b.dt_cancelamento_item is null)                     and
   a.cd_status_pedido <> 7

Group by 
  a.cd_vendedor, 
  b.cd_categoria_produto

--select ic_consignacao_pedido,* from pedido_venda_item

-- Apresentação da Tabela Final

select  
        c.sg_categoria_produto                         as 'Produto',
        case when @pc_crescimento>0 
        then
           (a.Venda*(1+(@pc_crescimento/100)))/@qt_mes_calculo
        else   
           a.Venda/@qt_mes_calculo
        end                                            as 'MetaSetor',
        c.cd_categoria_produto,
        c.nm_categoria_produto                         as 'Categoria',
        c.cd_mascara_categoria                         as 'Codigo' 

from
    #MediaVendasSetor a, 
    Categoria_Produto c 
Where
    a.Categoria *= c.cd_categoria_produto
order by 
    a.categoria

