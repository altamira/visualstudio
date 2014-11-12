

CREATE  procedure pr_fatura_anual_exportacao

@cd_ano int

as
-- Total de Faturas Anual
select year(a.dt_nota_saida)     as 'Ano', 
       sum(b.qt_item_nota_saida * b.vl_unitario_item_nota)  as 'Vendas', 
       count(*)           as 'Pedidos'
into #FaturaAnualExp
from

  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal 

WHERE
--   year(a.dt_nota_saida) > 1994                       and
--   f.est_cli = 'EX' ????                            and
   e.cd_mascara_operacao like '7%' 	       and -- Somente as Operações de Exportação!
   e.ic_comercial_operacao = 'S'                      and
   a.vl_total > 0 				      and
   ISNull(b.cd_status_nota,6) <> 7                    and
   ( a.dt_cancel_nota_saida is null )   or 
     year(a.dt_cancel_nota_saida) > getdate()          and
  (b.qt_item_nota_saida * b.vl_total_item) > 0        and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'      

Group by year(a.dt_nota_saida)
Order by 1 desc

-- Devoluções do Mês Corrente
select year(a.dt_nota_saida)     as 'Ano', 
       sum(b.qt_item_nota_saida * b.vl_total_item)  as 'Vendas', 
       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_total_item ) as 'fatdevolucao'
into #FaturaAnualExpDev

from
  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal 

WHERE
--   year(a.dt_nota_saida) > 1994                              and
   e.cd_mascara_operacao like '7%' 	       and -- Somente as Operações de Exportação!
   e.ic_comercial_operacao = 'S'                             and
   a.vl_total > 0                                       and
   year(a.dt_cancel_nota_saida) > 1994                       and
   IsNull(b.cd_status_nota,6) in (3,4)                       and
  (b.qt_item_nota_saida * b.vl_total_item) > 0               and
   c.ic_smo_item_pedido_venda = 'N'                 

Group by year(a.dt_nota_saida)
Order by 1 desc

-- Devoluções dos Meses Anteriores
select year(a.dt_nota_saida)     as 'Ano', 
       sum(b.qt_item_nota_saida * b.vl_total_item)  as 'Vendas', 
       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_total_item ) as 'fatdevolucaoant'
into #FaturaAnualExpAnt
from
  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal

WHERE
--   year(a.dt_nota_saida) > 1994                              and
   e.cd_mascara_operacao like '7%' 	       and -- Somente as Operações de Exportação!
   e.ic_comercial_operacao = 'S'                      and
   a.vl_total > 0                                       and
   year(a.dt_cancel_nota_saida) > 1994                       and
--   year(b.dt_nota_saida) <= 1994 ????                      and
   IsNull(b.cd_status_nota,6) in (3,4)                       and
  (b.qt_item_nota_saida * b.vl_total_item) > 0          and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'         

Group by year(a.dt_nota_saida)
Order by 1 desc

select a.Ano,
       a.Pedidos,
       vendas = (a.vendas-isnull(c.fatdevolucaoant,0)) + 
                (isnull(b.vendas,0) - isnull(b.fatdevolucao,0))
into #FaturaAnualExp1
from #FaturaAnualExp a, #FaturaAnualExpDev b, #FaturaAnualExpAnt c
where a.ano *= b.ano and
      a.ano *= c.ano and
      ((a.ano = @cd_ano) or (@cd_ano = 0))
declare @vl_total_vendas float
set     @vl_total_vendas = 0
select  @vl_total_vendas = @vl_total_vendas + vendas
From
 #FaturaAnualExp1
select ano, vendas, (vendas/@vl_total_vendas)*100 as 'perc', pedidos,        vendas/12                    as 'media_anual', 0 as 'metames'
from
 #FaturaAnualExp1

