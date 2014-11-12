
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE procedure pr_venda_categoria_cliente  
-----------------------------------------------------------------------------------  
--Polimold Industrial S/A                           2002                       
--Stored Procedure : SQL Server Microsoft 7.0    
--Carlos Cardoso Fernandes           
--Vendas por Categoria de Produtos por Cliente  
--Data          : 29.08.2000  
--Atualizado    : 29.08.2000  
--              : 15.01.2001 Alteração da Ordem da Pesquisa : Campo Posicao   
--              : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)  
--              : 12/08/2002 - Migração para o bco. Egis - DUELA  
  
-----------------------------------------------------------------------------------  
@cd_categoria_produto int,  
@dt_inicial dateTime,  
@dt_final   dateTime,  
@cd_moeda   int = 1  
as  
  
-- Geração da tabela auxiliar de Vendas por Categoria  
select cp.nm_categoria_produto                               as 'categoria',   
       cli.nm_fantasia_cliente                               as 'Cliente',  
       max(v.nm_fantasia_vendedor)                           as 'Setor',  
       sum(b.qt_item_pedido_venda)                           as 'Qtd',  
       sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido * dbo.fn_vl_moeda(@cd_moeda)) as 'Venda',  
       max(b.dt_item_pedido_venda)                           as 'UltimaVenda',  
       count(*) as 'pedidos'  
  
into 
  #VendaCategAux  
from  
   pedido_venda a with (nolock)
   inner join Pedido_Venda_Item b with (nolock)
     on a.cd_pedido_venda = b.cd_pedido_venda  
   left outer join Categoria_Produto cp  
     on cp.cd_categoria_produto=b.cd_categoria_produto  
   inner join Cliente cli with (nolock)
     on cli.cd_cliente=a.cd_cliente  
   left outer join Vendedor v  
     on v.cd_vendedor=a.cd_vendedor  
where  
  (a.dt_pedido_venda between @dt_inicial and @dt_final ) and
  (b.dt_cancelamento_item is null)                       and  
  a.vl_total_pedido_venda > 0                            and  
  isnull(a.ic_consignacao_pedido,'N') = 'N'              and  
  b.cd_item_pedido_venda < 80                            and       
  (b.qt_item_pedido_venda*b.vl_unitario_item_pedido* dbo.fn_vl_moeda(@cd_moeda))>0   and  
  isnull(b.ic_smo_item_pedido_venda,'N') = 'N'           and  
  b.cd_categoria_produto  = @cd_categoria_produto  
  
Group by 
  cp.nm_categoria_produto, cli.nm_fantasia_cliente  
order  by 5 desc  
  
declare @qt_total_categ int  
declare @vl_total_categ float  
  
-- Total de Categorias  
set @qt_total_categ = @@rowcount  
  
-- Total de Vendas Geral por Categoria  
set    @vl_total_categ     = 0  

Select 
  @vl_total_categ = sum(venda)
from  
  #VendaCategAux  
  
--Cria a Tabela Final de Vendas por Setor  
select IDENTITY(int, 1,1) AS 'Posicao',  
       a.categoria,  
       a.cliente,  
       a.setor,  
       a.qtd,  
       a.venda,   
      (a.venda/@vl_total_categ)*100 as 'Perc',  
       a.UltimaVenda,  
       a.pedidos  
into 
  #VendaCateg  
from 
  #VendaCategAux a  
order by 
  a.venda desc  
  
--Mostra tabela ao usuário  
Select 
  * 
from 
  #VendaCateg  
order by 
  posicao

