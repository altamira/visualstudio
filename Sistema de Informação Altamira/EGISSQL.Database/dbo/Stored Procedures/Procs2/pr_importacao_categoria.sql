-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Márcio Rodrigues
--Vendas por Categoria de Produtos
--Data       : 29/06/2005

-----------------------------------------------------------------------------------
Create procedure pr_importacao_categoria
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Categoria
select 
  isnull(a.cd_categoria_produto,0) as 'categoria', 
--  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda) as 'Venda', 
  sum( isnull(a.qt_item_ped_imp,0) * (a.vl_item_ped_imp) / @vl_moeda) as 'Venda',
  sum(a.qt_item_ped_imp)         as 'Qtd',
  max(a.dt_pedido_importacao)    as 'UltimaVenda', 
  count(distinct a.cd_pedido_importacao) as 'pedidos'
into #ImportacaoCategAux
from
   vw_importacao_bi a left outer join
   Pedido_Importacao pv on pv.cd_pedido_Importacao = a.cd_pedido_importacao
where
  (a.dt_pedido_importacao between @dt_inicial and @dt_final )    and
  a.cd_produto is not null

group by a.cd_categoria_produto
order by 1 desc


declare @qt_total_categ int
declare @vl_total_categ float

-- Total de Categorias
set @qt_total_categ = @@rowcount

-- Total de Vendas Geral por Categoria
set @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #ImportacaoCategAux

--Cria a Tabela Final de Vendas por Setor

select IDENTITY(int, 1,1) AS 'Posicao',
       b.nm_categoria_produto,
       a.qtd,
       a.venda, 
      (a.venda/@vl_total_categ)*100 as 'Perc',
       a.UltimaVenda, a.pedidos
into #ImportacaoCateg
from #ImportacaoCategAux a, Categoria_Produto b
where
  a.categoria = b.cd_categoria_produto
order by a.venda desc

--Mostra tabela ao usuário
select * from #ImportacaoCateg
order by posicao
