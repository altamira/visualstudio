--pr_auditoria_precos_geral
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Auditoria de Preços Geral
--Data         : 19.05.2000
--Atualizado : 06/04/2002 - Sandro Campos
-----------------------------------------------------------------------------------
CREATE procedure pr_auditoria_precos_geral
@dt_inicial datetime,
@dt_final  datetime
as

select  b.cd_categoria_produto,
        sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido)      as 'Venda', 
        sum(b.qt_item_pedido_venda*b.vl_lista_item_pedido ) as 'Orçado'
into #MediaVendasSetor
from
   pedido_venda a,pedido_venda_item b
where
   a.dt_pedido_venda between @dt_inicial and @dt_final  and
   a.vl_total_pedido_venda > 0                                     and
   a.cd_pedido_venda = b.cd_pedido_venda                               and
   b.cd_categoria_produto is not null                               and
   (b.dt_cancelamento_item is null or b.dt_cancelamento_item>@dt_final )        
Group by b.cd_categoria_produto

-- Apresentação da Tabela Final

select a.*,
       b.sg_categoria_produto as 'Categoria'
from
    #MediaVendasSetor a,categoria_produto b
Where
    a.cd_categoria_produto = b.cd_categoria_produto   

order by a.categoria

