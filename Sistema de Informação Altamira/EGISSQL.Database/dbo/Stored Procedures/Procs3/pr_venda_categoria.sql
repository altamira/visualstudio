---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Vendas por Categoria de Produtos
--Data       : 09.01.2000
--Atualizado : 06.06.2000
--           : 10.06.2000 Lucio  - Seleção por Período
--           : 11.12.2000 Carlos - Quantidade da categoria
--           : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--           : 16/08/2002 - Migrado para o EGISSQL - Daniel C. Neto.
--           : 08/11/2002 - Acerto na qtd. de Pedidos de Vendas. Acertos dos joins (DUELA)
-- 06/11/2003 - Inclusão de MOeda - Daniel C. Neto.
-- 19/03/2004 - Incluído coluna de frete - Daniel C. Neto.
-- 30/03/2004 - Acerto para bater com a consulta de pedido do SPE - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 29.04.2006 - Código da Categoria - Carlos Fernandes
-----------------------------------------------------------------------------------
Create procedure pr_venda_categoria
@dt_inicial datetime,
@dt_final   datetime,
@cd_moeda   int = 1,
@cd_tipo_mercado int = 0 

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Categoria
select 
  a.cd_categoria_produto              as 'categoria', 
--  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda) as 'Venda', 
  sum( isnull(a.qt_item_pedido_venda,0) * (a.vl_unitario_item_pedido) / @vl_moeda) as 'Venda',
  sum(a.qt_item_pedido_venda)         as 'Qtd',
  max(a.dt_pedido_venda)              as 'UltimaVenda', 
  count(distinct a.cd_pedido_venda)   as 'pedidos',
  sum(pv.vl_frete_pedido_venda)       as 'Frete'
into #VendaCategAux
from
   vw_venda_bi a left outer join
   Pedido_Venda pv on pv.cd_pedido_venda = a.cd_pedido_venda left outer join
   Cliente cli   on pv.cd_cliente = cli.cd_cliente         

where
  (a.dt_pedido_venda between @dt_inicial and @dt_final )    and
   a.cd_produto is not null and
	cli.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then cli.cd_tipo_mercado else @cd_tipo_mercado end        

group by 
  a.cd_categoria_produto
order by 1 desc


declare @qt_total_categ int
declare @vl_total_categ float

-- Total de Categorias
set @qt_total_categ = @@rowcount

-- Total de Vendas Geral por Categoria
set @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #VendaCategAux


--select * from categoria_produto

--Cria a Tabela Final de Vendas por Setor

select IDENTITY(int, 1,1) AS 'Posicao',
       b.nm_categoria_produto,
       b.cd_mascara_categoria,
       a.qtd,
       a.venda, 
      (a.venda/@vl_total_categ)*100 as 'Perc',
       a.UltimaVenda, a.pedidos,
       a.Frete
into #VendaCateg
from #VendaCategAux a, Categoria_Produto b
where
  a.categoria = b.cd_categoria_produto
order by a.venda desc

--Mostra tabela ao usuário
select * from #VendaCateg
order by posicao
