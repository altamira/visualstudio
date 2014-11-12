
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Faturas de Setores por Categoria
--Data        : 01.09.2000
--Atualizado  : 04/09/2002 - Migrado para o Banco EGISSQL. - Daniel C. Neto.
-- 06/11/2003 - Incluído Moeda - Daniel C. Neto.
-----------------------------------------------------------------------------------
CREATE  procedure pr_fatura_setor_categoria
@cd_categoria_produto int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-------------------------------------------------
-- Geração da tabela auxiliar de Setores por Categoria
-------------------------------------------------
select 
  b.cd_categoria_produto    as 'categoria', 
  max(a.cd_vendedor)        as 'Setor',
  sum(b.qt_item_nota_saida) as 'Qtd',
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota / @vl_moeda) as 'Venda', 
  max(a.dt_nota_saida)      as 'UltimaVenda',
  count(distinct a.cd_nota_saida) as 'pedidos'
into #FaturaSetorCategAux
from
   Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida=a.cd_nota_saida
where
  (a.dt_nota_saida between @dt_inicial and @dt_final )  and
  a.dt_cancel_nota_saida is null                        and  
  a.vl_total > 0                                        and
  a.cd_status_nota <> 7                                 and
  ((b.cd_categoria_produto  = @cd_categoria_produto) or
   (@cd_categoria_produto = 0 )) and
  (b.qt_item_nota_saida * b.vl_unitario_item_nota/ @vl_moeda) > 0  and
  b.dt_cancel_item_nota_saida is null        
group by b.cd_categoria_produto, a.cd_vendedor
order  by 1 desc


-------------------------------------------------
-- Total geral do vendedor em todas as categorias
-------------------------------------------------
select 
  a.cd_vendedor as 'setor', 
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) as 'Venda'
into #VendaTotal
from
   Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida=a.cd_nota_saida
where
  (a.dt_nota_saida between @dt_inicial and @dt_final ) and
  a.dt_cancel_nota_saida is null        and  
  a.vl_total > 0          and
  a.cd_status_nota <> 7    and
  (b.qt_item_nota_saida * b.vl_unitario_item_nota/ @vl_moeda) > 0       and
  b.dt_cancel_item_nota_saida is null        
group by a.cd_vendedor

declare @vl_total_setor float
set @vl_total_setor = 0

select @vl_total_setor = @vl_total_setor + venda
from #VendaTotal

select 
  IDENTITY(int,1,1) as 'PosicaoGeral', 
  a.setor, 
  (a.venda/@vl_total_setor)*100 as 'PercGeral'
into #VendaTotalAux
from #VendaTotal a
order by a.Venda desc

select a.* 
into #VendaTotal1
from #VendaTotalAux a
order by a.PosicaoGeral
----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_categ int
declare @vl_total_categ float

--------------------------------
-- Total de Setores
--------------------------------
set @qt_total_categ = @@rowcount

--------------------------------
-- Total de Vendas Geral por Setor
--------------------------------
set    @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #FaturaSetorCategAux

--------------------------------
--Cria a Tabela Final de Vendas por Setor
--------------------------------
select 
  IDENTITY(int, 1,1) AS 'Posicao', 
  c.cd_vendedor as 'Setor', 
  b.nm_categoria_produto, 
  c.nm_fantasia_vendedor, 
  a.qtd,
  a.venda, 
  (a.venda/@vl_total_categ)*100 as 'Perc',
  a.UltimaVenda,
  a.pedidos
into #FaturaSetorCateg
from #FaturaSetorCategAux a, Categoria_Produto b, Vendedor c
where
  a.categoria = b.cd_categoria_produto and
  a.setor     = c.cd_vendedor
order by a.venda desc

--------------------------------
--Mostra tabela ao usuário
--------------------------------
select
  a.*,
  b.PosicaoGeral, 
  b.PercGeral
from #FaturaSetorCateg a, #VendaTotal1 b
where a.Setor = b.setor
order by a.posicao
