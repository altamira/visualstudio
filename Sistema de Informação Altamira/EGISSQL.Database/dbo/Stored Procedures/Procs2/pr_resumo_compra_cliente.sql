
CREATE PROCEDURE pr_resumo_compra_cliente

---------------------------------------------------------------------------------------
--pr_resumo_compra_cliente
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Resumo de Compras por Cliente.
--Data          : 05/09/2002
--Atualizado    : 01/11/2002 - Inclusão de Proposta e Perda
--              : 01/04/2003 - Acerto no FIltro de SMO - Daniel C. Neto.
--              : 14.03.2006 - Acertos Gerais - Carlos Fernandes
--              : 03/05/2006 - Acerto para buscar dados independente da existência ou não de 
--                             Pedido de Venda. - ELIAS
--              : 09.05.2006 - Acerto para mostrar a máscara/sigla da categoria de produto
--              : 11.05.2006 - Acerto da Consulta quando o cliente não tiver vendedor - Carlos Fernandes
-------------------------------------------------------------------------------------------------------

@cd_cliente int,
@dt_inicial dateTime,
@dt_final   dateTime

as

-------------------------------------------------
-- Resumo de Vendas
-------------------------------------------------
select 
  b.cd_categoria_produto                                  as 'categoria', 
  sum(b.qt_item_pedido_venda)                             as 'Qtd',
  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido) as 'Venda', 
  max(a.dt_pedido_venda)                                  as 'UltimaVenda'
into #VendaGrupoAux
from
   Pedido_Venda a 
   inner join Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda 
   left outer join Produto p      on  p.cd_produto = b.cd_produto
where
   b.cd_categoria_produto is not null                   and
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
   ((a.dt_cancelamento_pedido is null ) or 
   (a.dt_cancelamento_pedido > @dt_final))                          and
    isnull(a.vl_total_pedido_venda,0) > 0                           and
    isnull(a.ic_consignacao_pedido,'N') <> 'S'                      and
    isnull(a.ic_amostra_pedido_venda,'N') <> 'S'                    and  
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0         and
   ((b.dt_cancelamento_item is null ) or 
   (b.dt_cancelamento_item > @dt_final))                            and
    IsNull(b.ic_smo_item_pedido_venda,'N') = 'N'                    and
    a.cd_cliente = @cd_cliente
Group by 
   b.cd_categoria_produto
order  by 1 

--select * from #VendaGrupoAux

-------------------------------------------------
-- Resumo de Faturamento
-------------------------------------------------
select 
  b.cd_categoria_produto                            as 'categoria', 
  sum(b.qt_item_nota_saida)                         as 'Qtd',
  sum(b.qt_item_nota_saida*b.vl_unitario_item_nota) as 'Faturamento' 
into #FaturaSetorCategAux
from
   Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida
left outer join Produto p on 
  p.cd_produto = b.cd_produto
where
   b.cd_categoria_produto is not null                   and
  (a.dt_nota_saida between @dt_inicial and @dt_final )  and
  ((a.dt_cancel_nota_saida is null) or
   (a.dt_cancel_nota_saida > @dt_final))                and  
   a.vl_total > 0                                       and
   a.cd_cliente = @cd_cliente                           and
  (b.qt_item_nota_saida * b.vl_unitario_item_nota) > 0  and
  ((b.dt_cancel_item_nota_saida is null) or
   (b.dt_cancel_item_nota_saida > @dt_final)) 
Group by 
  b.cd_categoria_produto
order  by 1 

-------------------------------------------------
-- Resumo de Proposta
-------------------------------------------------
select 
  b.cd_categoria_produto              as 'categoria', 
  sum(b.qt_item_consulta)             as 'Qtd',
  sum(b.qt_item_consulta*b.vl_unitario_item_consulta) as 'Proposta' 
into #PropostaSetorCategAux
from
   Consulta a
   left outer join Consulta_Itens b on b.cd_consulta = a.cd_consulta
   left outer join Produto p        on   p.cd_produto = b.cd_produto
where
  b.cd_categoria_produto is not null                    and
  (a.dt_consulta between @dt_inicial and @dt_final )    and
   a.vl_total_consulta > 0                              and
   a.cd_cliente = @cd_cliente                           and
  (b.qt_item_consulta*b.vl_unitario_item_consulta) > 0 
Group by 
  b.cd_categoria_produto
order  by 1 

-------------------------------------------------
-- Resumo de Perda
-------------------------------------------------
select 
  b.cd_categoria_produto              as 'categoria', 
  sum(b.qt_item_consulta)             as 'Qtd',
  sum(b.qt_item_consulta*b.vl_unitario_item_consulta) as 'Perda' 
into #PerdaSetorCategAux
from
   Consulta a
left outer join Consulta_Itens b on
  b.cd_consulta = a.cd_consulta
left outer join Consulta_Item_Perda c on
  c.cd_consulta = a.cd_consulta
left outer join Produto p on 
  p.cd_produto = b.cd_produto
where
   b.cd_categoria_produto is not null                   and
  (b.dt_perda_consulta_itens between @dt_inicial and @dt_final )    and
   a.vl_total_consulta > 0                              and
   a.cd_cliente = @cd_cliente                           and
  (b.qt_item_consulta*b.vl_unitario_item_consulta) > 0  and
  (b.cd_consulta = c.cd_consulta and b.cd_item_consulta=c.cd_item_consulta)
Group by 
  b.cd_categoria_produto
order  by 1 

----------------------------------
-- Fim da seleção de vendas totais
----------------------------------
declare @qt_total_grupo int
declare @vl_total_grupo float

-- Total de Grupos
set @qt_total_grupo = @@rowcount

-- Total de Vendas Geral por Grupo
set @vl_total_grupo     = 0
select @vl_total_grupo = @vl_total_grupo + venda
from
  #VendaGrupoAux

-- Total de Faturamento Geral por Grupo
declare @vl_fatura_total float
set    @vl_fatura_total     = 0
select @vl_fatura_total = @vl_fatura_total + Faturamento
from
  #FaturaSetorCategAux

-- Total de Propostas Geral por Grupo
declare @vl_proposta_total float
set    @vl_proposta_total     = 0
select @vl_proposta_total = @vl_proposta_total + Proposta
from
  #PropostaSetorCategAux

-- Total de Perdas Geral por Grupo
declare @vl_perda_total float
set    @vl_perda_total     = 0
select @vl_perda_total = @vl_perda_total + Perda
from
  #PerdaSetorCategAux

----------------------------------------------------------
--Cria a Tabela Final de Vendas por Grupo
----------------------------------------------------------
select IDENTITY(int,1,1) as 'Posicao',
       b.cd_mascara_categoria,
       b.sg_categoria_produto,
       b.nm_categoria_produto,
--@vl_fatura_total as a,
       isnull(a.qtd,0)   as 'qtd',
       isnull(a.venda,0) as 'venda', 
       isnull(cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)),0) as 'Perc',
       isnull(c.Faturamento,0) as 'faturamento',
       isnull(c.Qtd,0) as 'qtd_fat',
       isnull(cast((c.Faturamento/@vl_fatura_total)*100 as Decimal(25,2)),0) as 'Perc_Fatura',
       isnull(d.Proposta,0) as 'proposta',
       isnull(d.Qtd,0) as 'qtd_proposta',
       isnull(cast((d.Proposta/@vl_proposta_total)*100 as Decimal(25,2)),0) as 'Perc_Proposta',
       isnull(e.Perda,0) as 'perda',
       isnull(e.Qtd,0) as 'qtd_perdas',
       isnull(cast((e.Perda/@vl_perda_total)*100 as Decimal(25,2)),0) as 'Perc_Perda'       
Into #VendaGrupo
from Categoria_Produto b  
  left outer join #PropostaSetorCategAux d on d.categoria = b.cd_categoria_produto
  left outer join #FaturaSetorCategAux c on c.categoria = b.cd_categoria_produto
  left outer join  #VendaGrupoAux a on a.categoria = b.cd_categoria_produto
  left outer join #PerdaSetorCategAux e on e.categoria = b.cd_categoria_produto
where
(a.qtd <> 0) or (a.venda <> 0) or (c.faturamento <> 0) or (c.qtd <> 0) or (d.proposta <> 0) or (d.qtd <> 0) or (e.perda <> 0) or (e.qtd <> 0)
order by a.Venda desc

select 
  * 
from 
  #VendaGrupo  
order by 
  Posicao 

