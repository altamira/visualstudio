

CREATE  procedure pr_fatura_anual_exportacao_mes

@cd_ano int
as
select month(a.dt_nota_saida)     as 'NumeroMes',
       max(a.dt_nota_saida)       as 'Data',   
       count(*)            as 'Pedidos',
       sum(b.qt_item_nota_saida * b.vl_unitario_item_nota)  as 'Vendas'

into #FaturaMensalExportacao
from
  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal left outer join
  Cliente f            on f.cd_cliente = a.cd_cliente

WHERE
   year(a.dt_nota_saida) = @cd_ano                    and
--   f.est_cli = 'EX' ????                            and 
   IsNull(e.ic_comercial_operacao,'N') = 'S'                      and
   a.vl_total > 0                                     and
   ISNull(b.cd_status_nota,6) <> 7                    and
   ( a.dt_cancel_nota_saida is null )   or 
     year(a.dt_cancel_nota_saida) > @cd_ano           and
  (b.qt_item_nota_saida * b.vl_total_item) > 0        and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'                           

Group by month(a.dt_nota_saida)

-- Devoluções do Mês Corrente

select month(a.dt_nota_saida)     as 'NumeroMes',
       max(a.dt_nota_saida)       as 'Data',   
       count(*)            as 'Pedidos',
       sum(b.qt_item_nota_saida * b.vl_total_item)   as 'Vendas' ,
       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_total_item ) as 'fatdevolucao'

into #FaturaMensalExportacaoDev
from

  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal 

WHERE
   year(a.dt_nota_saida) = @cd_ano             and
   IsNull(e.ic_comercial_operacao,'N') = 'S'               and
   e.cd_mascara_operacao like '7%' 	       and -- Somente as Operações de Exportação!
   a.vl_total > 0                              and
   b.cd_status_nota in (3,4)                   and
  (b.qt_item_nota_saida * b.vl_total_item) > 0 and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'                           

Group by month(a.dt_nota_saida)
-- Devoluções dos Meses Anteriores
select month(a.dt_nota_saida)     as 'NumeroMes',
       max(a.dt_nota_saida)       as 'Data',   
       count(*)            as 'Pedidos',
       sum(b.qt_item_nota_saida * b.vl_total_item)   as 'Vendas',
       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_total_item ) as 'fatdevolucaoant'
into #FaturaMensalExportacaoAnt
from
  Nota_Saida a         inner join
  Nota_Saida_Item b    on b.cd_nota_saida = a.cd_nota_saida                 left outer join
  Pedido_Venda_Item c  on c.cd_pedido_venda = b.cd_pedido_venda and 
                          c.cd_item_pedido_venda = b.cd_item_pedido_venda   left outer join
  Pedido_Venda d       on d.cd_pedido_venda = c.cd_pedido_venda             left outer join
  Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal 

WHERE
   e.cd_mascara_operacao like '7%' 	       and -- Somente as Operações de Exportação!
   IsNull(e.ic_comercial_operacao,'N') = 'S'               and
   a.vl_total > 0                              and
   year(a.dt_nota_saida) < @cd_ano             and
   b.cd_status_nota in (3,4)                   and
  (b.qt_item_nota_saida * b.vl_total_item) > 0 and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'                           

Group by month(a.dt_nota_saida)
select a.NumeroMes,
       a.Data,
       a.Pedidos,
       vendas = (a.vendas-isnull(c.fatdevolucaoant,0)) + 
                (isnull(b.vendas,0) - isnull(b.fatdevolucao,0))
into #FaturaMensalExportacao1
from #FaturaMensalExportacao a, #FaturaMensalExportacaoDev b, 
     #FaturaMensalExportacaoAnt c
where a.NumeroMes *= b.NumeroMes and
      a.NumeroMes *= c.NumeroMes
declare @vl_total_vendas float
set     @vl_total_vendas = 0
select  @vl_total_vendas = @vl_total_vendas + vendas
From
 #FaturaMensalExportacao1

--Meta do Mês
select month(a.dt_inicial_meta_categoria  ) as 'NumeroMes',
       sum(a.vl_fat_meta_categoria )   as 'MetaMes' 
into #MetaAnualMes
from
  Meta_Categoria_Produto a
WHERE
  year(a.dt_inicial_meta_categoria) = @cd_ano  
Group by month(a.dt_inicial_meta_categoria)

-- Mostra a Tabela com dados do Mês
select a.numeromes, DateName(month,a.Data) as 'Mes', a.vendas,
      (a.vendas/@vl_total_vendas)*100 as 'perc',pedidos,b.MetaMes,
      (a.vendas/b.MetaMes)*100 as 'Ating'
from
 #FaturaMensalExportacao1 a,#MetaAnualMes b
where
  a.numeromes *= b.numeroMes
Order by 1 desc

