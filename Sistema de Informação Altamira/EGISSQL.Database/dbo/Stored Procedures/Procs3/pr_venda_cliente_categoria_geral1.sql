--pr_venda_cliente_categoria_geral1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Vendas por Cliente e Categorias
--Data        : 21.03.2000
--Atualizado  : 06.06.2000 Inclusão campo NcMapa
--            : 05.07.2000 - Lucio (Mudada para Período)
--            : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--            : 06/04/2002 - Alteração para o padrão EGIS - Sandro Campos
--            : 05.08.2002 - Duela. Alteração de Parametro
--            : 03/09/2002 - Carrasco - Alteração para filtrar pelo Código do Cliente.
--            : 30/10/2002 - Correção dos joins
-- 06/11/2003 - Inclusão de moeda - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 11.03.2006 - Mostrar o nome Fantasia do Cliente - Carlos Fernandes
-----------------------------------------------------------------------------------

CREATE procedure pr_venda_cliente_categoria_geral1
@dt_inicial datetime,
@dt_final   datetime,
@cd_cliente int,
@cd_moeda   int

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por Cliente
select cd_cliente, 
       cd_categoria_produto,       
       sum(qt_item_pedido_venda)                                                    as 'qtd',
       cast(sum(qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda) as decimal(25,2)) as 'Compra'
into #VendaClienteCategoriaAuxGeral1
from
  vw_venda_bi vw
where
   dt_pedido_venda between @dt_inicial and @dt_final 
  and cd_cliente = @cd_cliente
group by 
	cd_cliente, 
	cd_categoria_produto
order by 3 desc 

declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set     @vl_total_cliente = 0
select @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteCategoriaAuxGeral1

select IDENTITY(int, 1,1) AS 'Posicao', 
       b.cd_categoria_produto, 
       b.sg_categoria_produto as 'Categoria',
       a.qtd,
       a.Compra, 
       cast(((a.compra/@vl_total_cliente)*100)as decimal(25,2)) as 'Perc',
       c.nm_fantasia_cliente                                    as Cliente
Into #VendaClienteCategoriaGeral1
from #VendaClienteCategoriaAuxGeral1 a
left outer join categoria_produto b on  b.cd_categoria_produto=a.cd_categoria_produto
left outer join cliente c           on  c.cd_cliente          =a.cd_cliente
Order by 
  a.Compra desc
     

--Mostra tabela ao usuário
select * from #VendaClienteCategoriaGeral1
order by Posicao
