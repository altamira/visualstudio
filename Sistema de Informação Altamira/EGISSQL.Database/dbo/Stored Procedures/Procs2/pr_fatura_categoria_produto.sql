

/****** Object:  Stored Procedure dbo.pr_fatura_categoria_produto    Script Date: 13/12/2002 15:08:30 ******/
--pr_fatura_categoria_produto
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Faturas por Cliente e Categorias
--Data        : 11.08.2000
--Atualizado  : 28.11.2000 Alteração do Where : Idem Mapa Faturamento
--            : 02.08.2002 - Migração para o bco. EgisSql (Duela)
--            : 03/09/2002 - Acertado , Alterado para Filtrar por Cód. Cliente - Daniel C. Neto.
-----------------------------------------------------------------------------------
CREATE procedure pr_fatura_categoria_produto

@dt_inicial datetime,
@dt_final   datetime,
@cd_categoria_produto int

as

------------------------------------
-- Geraçao da Tabela Auxiliar de Faturas por Cliente
------------------------------------
select nsi.cd_categoria_produto,
       max(ns.cd_vendedor)                     as 'Setor',
       sum(nsi.qt_item_nota_saida)                        as 'qtd',
       sum(nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'Venda',
       max(ns.dt_nota_saida)       as 'UltimaVenda',
       count(*)             as 'pedidos'

into #FaturaClienteCategoriaGeral
from
  Nota_Saida ns inner join
  Nota_Saida_Item nsi   on ns.cd_nota_saida         = nsi.cd_nota_saida        inner join
  Pedido_Venda_Item pvi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda inner join
  Operacao_Fiscal op    on ns.cd_operacao_fiscal    = op.cd_operacao_fiscal    

where
  (ns.dt_nota_saida between @dt_inicial and @dt_final)  and
   ((nsi.cd_categoria_produto = @cd_categoria_produto)    or
    (@cd_categoria_produto = 0))                        and
   op.ic_comercial_operacao = 'S'                       and
   isnull(nsi.ic_status_item_nota_saida,'')<>'C'        and
   (nsi.dt_cancel_item_nota_saida is null or nsi.dt_cancel_item_nota_saida>@dt_final) and
   (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0 and
    pvi.ic_smo_item_pedido_venda = 'N'

group by nsi.cd_categoria_produto, 
         ns.cd_vendedor
order by 3 desc 

-----------
-- Tabela Auxiliar para Calcular o total da Nota.
-----------

select max(ns.cd_vendedor)                     as 'Setor',
       sum(nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'Venda'
      
into #VendaTotal
from
  Nota_Saida ns inner join
  Nota_Saida_Item nsi   on ns.cd_nota_saida         = nsi.cd_nota_saida        inner join
  Pedido_Venda_Item pvi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda inner join
  Operacao_Fiscal op    on ns.cd_operacao_fiscal    = op.cd_operacao_fiscal    

where
  (ns.dt_nota_saida between @dt_inicial and @dt_final)  and
   op.ic_comercial_operacao = 'S'                       and
   isnull(nsi.ic_status_item_nota_saida,'')<>'C'        and
   (nsi.dt_cancel_item_nota_saida is null or nsi.dt_cancel_item_nota_saida>@dt_final) and
   (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0 and
    pvi.ic_smo_item_pedido_venda = 'N'

group by nsi.cd_categoria_produto

declare @vl_total_setor float
set @vl_total_setor = 0

select @vl_total_setor = @vl_total_setor + venda
from #VendaTotal

select IDENTITY(int,1,1) as 'PosicaoGeral', a.setor, (a.venda/@vl_total_setor)*100 as 'PercGeral'
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

-- Total de Setores
set @qt_total_categ = @@rowcount

-----------------------------------
-- Devoluções do Mês Corrente
------------------------------------
select nsi.cd_categoria_produto,
       sum(nsi.qt_item_nota_saida)                        as 'qtd',
       sum(nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'Venda',
      sum(case when isnull(nsi.qt_devolucao_item_nota,0)>0 then
          nsi.qt_devolucao_item_nota else nsi.qt_item_nota_saida end ) as 'Qtd_Dev',
      sum(case when isnull(nsi.qt_devolucao_item_nota,0)>0 then
          nsi.qt_devolucao_item_nota else nsi.qt_item_nota_saida end ) * nsi.vl_unitario_item_nota as 'Fat_Devolucao'
into #FaturaClienteCategoriaGeralDev
from
  Nota_Saida ns inner join
  Nota_Saida_Item nsi   on ns.cd_nota_saida         = nsi.cd_nota_saida        inner join
  Pedido_Venda_Item pvi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda inner join
  Operacao_Fiscal op    on ns.cd_operacao_fiscal    = op.cd_operacao_fiscal    

where
  (ns.dt_nota_saida between @dt_inicial and @dt_final)  and
   ((nsi.cd_categoria_produto = @cd_categoria_produto)    or
    (@cd_categoria_produto = 0))                        and
   op.ic_comercial_operacao = 'S'                       and
   nsi.ic_status_item_nota_saida='D'                    and
   (nsi.dt_cancel_item_nota_saida is null or nsi.dt_cancel_item_nota_saida>@dt_final) and
   (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0 and
    pvi.ic_smo_item_pedido_venda='N'

group by nsi.cd_categoria_produto, 
         ns.cd_vendedor,
         nsi.vl_unitario_item_nota

order by 3 desc

------------------------------------
-- Devoluções do Mês Anterior
------------------------------------
select nsi.cd_categoria_produto,
       sum(nsi.qt_item_nota_saida)                        as 'qtd',
       sum(nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'Venda',
      sum(case when isnull(nsi.qt_devolucao_item_nota,0)>0 then
          nsi.qt_devolucao_item_nota else nsi.qt_item_nota_saida end ) as 'Qtd_Dev_Ant',
      sum(case when isnull(nsi.qt_devolucao_item_nota,0)>0 then
          nsi.qt_devolucao_item_nota else nsi.qt_item_nota_saida end ) * nsi.vl_unitario_item_nota as 'Fat_Devolucao_Ant'
into #FaturaClienteCategoriaGeralAnt
from
  Nota_Saida ns inner join
  Nota_Saida_Item nsi   on ns.cd_nota_saida         = nsi.cd_nota_saida        inner join
  Pedido_Venda_Item pvi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda inner join
  Operacao_Fiscal op    on ns.cd_operacao_fiscal    = op.cd_operacao_fiscal    

where
  (ns.dt_nota_saida < @dt_inicial)                      and
   ((nsi.cd_categoria_produto = @cd_categoria_produto)    or
    (@cd_categoria_produto = 0))                        and
   op.ic_comercial_operacao = 'S'                       and
   nsi.ic_status_item_nota_saida='D'                    and
   (nsi.dt_cancel_item_nota_saida is null or nsi.dt_cancel_item_nota_saida>@dt_final) and
   (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0 and
    pvi.ic_smo_item_pedido_venda='N'

group by nsi.cd_categoria_produto,
	 ns.cd_vendedor,
         nsi.vl_unitario_item_nota

order by 3 desc

------------------------------------
-- Junta as três Querys
------------------------------------
select a.cd_categoria_produto,
       qtd = a.Qtd+isnull(b.Qtd,0)-isnull(b.Qtd_Dev,0)-isnull(c.Qtd_Dev_Ant,0),
       venda = (a.Venda-isnull(c.Fat_Devolucao_Ant,0)) + isnull(b.Venda,0),
       a.setor,
       a.UltimaVenda,
       a.pedidos       

into #FaturaClienteCategoriaGeral1
from #FaturaClienteCategoriaGeral a, #FaturaClienteCategoriaGeralDev b, 
     #FaturaClienteCategoriaGeralAnt c
where a.cd_categoria_produto *= b.cd_categoria_produto and
      a.cd_categoria_produto *= c.cd_categoria_produto

-- Total de Vendas Geral por Setor
set    @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #FaturaClienteCategoriaGeral1

--Cria a Tabela Final de Vendas por Setor

select IDENTITY(int,1,1) as 'Posicao',
       b.nm_categoria_produto,
       c.nm_fantasia_vendedor,
       a.setor,
       a.qtd,
       a.venda, 
      (a.venda/@vl_total_categ)*100 as 'Perc',
       a.UltimaVenda,
       a.pedidos
Into #VendaCateg
from #FaturaClienteCategoriaGeral1 a, Categoria_Produto b, Vendedor c 
Where
     a.cd_categoria_produto = b.cd_categoria_produto and
     a.setor     = c.cd_vendedor 

Order by a.venda desc

--Mostra tabela ao usuário

select a.*,
       b.PosicaoGeral, 
       b.PercGeral
from #VendaCateg a, #VendaTotal1 b
where a.setor = b.setor
order by a.posicao



