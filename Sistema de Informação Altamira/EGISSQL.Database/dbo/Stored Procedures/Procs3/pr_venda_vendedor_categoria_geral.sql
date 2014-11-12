-----------------------------------------------------------------------------------
--pr_venda_vendedor_categoria_geral
-----------------------------------------------------------------------------------
--GBS
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel Carrasco Neto
--Vendas por Vendedor e Categorias
--Data        : 16/11/2006
--Atualizado  : 16.04.2009 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------

CREATE procedure pr_venda_vendedor_categoria_geral
@dt_inicial datetime,
@dt_final   datetime,
@cd_vendedor int,
@cd_moeda   int

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por Vendedor
select cd_vendedor, 
       cd_categoria_produto,       
       sum(qt_item_pedido_venda)                                                    as 'qtd',
       cast(sum(qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda) as decimal(25,2)) as 'Compra'
into #VendaVendedorCategoriaAuxGeral1
from
  vw_venda_bi vw
where
   dt_pedido_venda between @dt_inicial and @dt_final 
  and cd_vendedor = @cd_vendedor
group by 
	cd_vendedor, 
	cd_categoria_produto
order by 3 desc 

declare @qt_total_Vendedor int
declare @vl_total_Vendedor float

-- Total de Vendedor
set @qt_total_Vendedor = @@rowcount

-- Total de Vendas Geral
set     @vl_total_Vendedor = 0
select @vl_total_Vendedor = @vl_total_Vendedor + compra
from
  #VendaVendedorCategoriaAuxGeral1


--select * from categoria_produto

select IDENTITY(int, 1,1) AS 'Posicao', 
       b.cd_mascara_categoria,
       b.nm_categoria_produto,
       b.cd_categoria_produto, 
       b.sg_categoria_produto as 'Categoria',
       a.qtd,
       a.Compra, 
       cast(((a.compra/@vl_total_Vendedor)*100)as decimal(25,2)) as 'Perc',
       c.nm_fantasia_Vendedor                                    as Vendedor
Into #VendaVendedorCategoriaGeral1
from #VendaVendedorCategoriaAuxGeral1 a
left outer join categoria_produto b on  b.cd_categoria_produto=a.cd_categoria_produto
left outer join Vendedor c           on  c.cd_vendedor          =a.cd_vendedor
Order by 
  a.Compra desc
     

--Mostra tabela ao usuário
select * from #VendaVendedorCategoriaGeral1
order by Posicao
