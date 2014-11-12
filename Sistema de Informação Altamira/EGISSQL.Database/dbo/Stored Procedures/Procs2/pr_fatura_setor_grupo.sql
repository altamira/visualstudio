
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution                                              2002
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto
--Faturas de Setores por Grupo
--Criado  : 04/09/2002
--        : 05/11/2003 - Inclusão de consulta por moeda.
-----------------------------------------------------------------------------------
CREATE  procedure pr_fatura_setor_grupo

@cd_grupo_produto int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as
-- Geração da tabela auxiliar de Setores por grupo
select c.cd_grupo_produto              as 'grupo', 
       sum(b.qt_item_nota_saida)             as 'Qtd',
       sum(b.qt_item_nota_saida*b.vl_unitario_item_nota * dbo.fn_vl_moeda(@cd_moeda))     as 'Venda', 
       max(a.dt_nota_saida)         as 'UltimaVenda',
       count(*)              as 'pedidos'

into #FaturaSetorCategAux
from
   Nota_Saida a, Nota_Saida_Item b inner join Produto c on
   b.cd_categoria_produto = c.cd_categoria_produto

where
  (a.dt_nota_saida between @dt_inicial and @dt_final ) and
   a.dt_cancel_nota_saida is null        and  
   a.vl_total > 0          and
   a.cd_status_nota <> 7    and
   a.cd_nota_saida = b.cd_nota_saida             and     
   ((c.cd_grupo_produto  = @cd_grupo_produto) or
    (@cd_grupo_produto = 0 )) and
  (b.qt_item_nota_saida * b.vl_unitario_item_nota* dbo.fn_vl_moeda(@cd_moeda)) > 0       and
   b.dt_cancel_item_nota_saida is null 

Group by c.cd_grupo_produto

order  by 1 desc

--select * from #FaturaSetorCategAux

-------------------------------------------------
-- calculando nº de Clientes
-------------------------------------------------

-- select p.cd_grupo_produto, 
       /* ( select count(cd_cliente) 
         from Nota_Saida x inner join 
              Nota_Saida_item xi on xi.cd_nota_saida = x.cd_pedido_venda inner join
              Produto z on z.cd_produto = xi.cd_produto
         where z.cd_grupo_produto = p.cd_grupo_produto ) as 'Clientes'
       
into #Cliente

from Nota_Saida ns inner join 
     Nota_Saida_item nsi on nsi.cd_nota_saida = ns.cd_pedido_venda inner join
     Produto p on p.cd_produto = nsi.cd_produto

group by p.cd_grupo_produto
order by p.cd_grupo_produto

*/

----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_categ int
declare @vl_total_categ float

-- Total de Setores
set @qt_total_categ = @@rowcount

-- Total de Vendas Geral por Setor
set    @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #FaturaSetorCategAux

--Cria a Tabela Final de Vendas por Setor
select IDENTITY(int, 1,1) AS 'Posicao', 
       d.nm_grupo_produto, 
       a.qtd,a.venda, 
       cast((a.venda/@vl_total_categ)*100 as Decimal(25,2)) as 'Perc',
       a.UltimaVenda,
       a.pedidos, 
       0 as 'Clientes'

Into #FaturaSetorCateg
from #FaturaSetorCategAux a, Grupo_Produto d
Where
     a.grupo = d.cd_grupo_produto 

Order by a.venda desc

--Mostra tabela ao usuário

select a.*
from #FaturaSetorCateg a

order by a.posicao 
