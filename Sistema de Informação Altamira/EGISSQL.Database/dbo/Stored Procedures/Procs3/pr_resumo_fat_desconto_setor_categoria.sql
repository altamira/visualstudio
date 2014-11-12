--pr_resumo_fat_desconto_setor_categoria
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Resumo de Descontos por Categoria - Faturamento
--Data          : 31.08.2000
--Atualizado    : 06.04.2002 - Adriano - Conversao EGISSQL
--------------------------------------------------------------------------------------
CREATE procedure pr_resumo_fat_desconto_setor_categoria
@ncmapa char(10),
@dt_inicial   datetime,
@dt_final     datetime,
@dt_perc_smo  datetime   -- Data de Mudança da alíquota do cálculo ICMS-SMO
as
declare @vl_zero float
set @vl_zero = 0
select a.cd_Vendedor         as 'Vendedor', 
       b.qt_item_nota_saida               as 'Quantidade',
      (b.qt_item_nota_saida*b.vl_unitario_item_nota)      as 'ValorVenda', 
       orcado =  
       case 
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido)-((b.qt_item_nota_saida*c.vl_lista_item_pedido)*11/100) 
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido)-((b.qt_item_nota_saida*c.vl_lista_item_pedido)*8.8/100) 
          else
             (b.qt_item_nota_saida*c.vl_lista_item_pedido) 
       end,
       descto =
       case
          when ( d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100) 
          when ( d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100) 
          else 
             (100-(b.vl_unitario_item_nota/c.vl_lista_item_pedido)*100) 
       end,
       @vl_zero    as 'fatdevolucao',
       @vl_zero    as 'qtddev',   
       @vl_zero    as 'fatdevolucaoant',
       @vl_zero    as 'qtddevant'   
into #ResumoFatDescontoSetor
from
    Nota_Saida a, Nota_Saida_Item b, Pedido_venda_Item c, Pedido_Venda d, Operacao_Fiscal e 
Where
  (a.dt_nota_saida between @dt_inicial and @dt_final) and
   a.cd_operacao_fiscal     = e.cd_operacao_fiscal                      and
   e.ic_comercial_operacao = 'S'                           and
   a.ic_outras_operacoes < 2                              and
   a.vl_total > 0                              and
   a.cd_nota_saida = b.cd_nota_saida                                 and     
   b.cd_categoria_produto = @ncmapa                          and
   isnull(b.ic_status_item_nota_saida,' ')<>'C'                 and
  (b.dt_cancel_item_nota_saida is null or b.dt_cancel_item_nota_saida>@dt_final )    and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota) > 0                           and
   b.cd_pedido_venda = d.cd_pedido_venda                         and
   d.cd_pedido_venda = c.cd_pedido_venda                       and
   b.cd_item_nota_saida = c.cd_item_pedido_venda                             and 
   c.vl_lista_item_pedido > 0                             and
   c.cd_item_pedido_venda < 80                                 and
   c.ic_smo_item_pedido_venda = 'N'                           

-- Devoluções do Mês
select a.cd_vendedor         as 'Vendedor', 
       b.qt_item_nota_saida               as 'Quantidade',
      (b.qt_item_nota_saida*b.vl_unitario_item_nota)      as 'ValorVenda', 
       orcado =
       case
          when (b.qt_devolucao_item_nota>0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*11/100)
          when (b.qt_devolucao_item_nota>0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*8.8/100)
          when (b.qt_devolucao_item_nota=0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*11/100)
          when (b.qt_devolucao_item_nota=0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*8.8/100)
          when 
             (b.qt_devolucao_item_nota > 0 ) then ( b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1) 
          else
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1) 
       end,
       descto =
       case          
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo)  then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100)
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100)
          else 
             (100-(b.vl_unitario_item_nota/c.vl_lista_item_pedido)*100)
       end,
     ((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota ) as 'fatdevolucao',
       case when isnull(b.qt_devolucao_item_nota,0)>0 then 
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end              as 'qtddev',
       @vl_zero    as 'fatdevolucaoant',
       @vl_zero    as 'qtddevant'   
into #ResumoFatDescontoSetorDev
from
   Nota_Saida a, Nota_Saida_Item b, Pedido_venda_Item c, Pedido_Venda d, Operacao_Fiscal e 
Where
  (a.dt_nota_saida between @dt_inicial and @dt_final) and
   a.cd_operacao_fiscal     = e.cd_operacao_fiscal                      and
   e.ic_comercial_operacao = 'S'                           and
   a.ic_outras_operacoes < 2                              and
   a.vl_total > 0                              and
   a.cd_nota_saida = b.cd_nota_saida                                 and     
   b.cd_categoria_produto = @ncmapa                          and
  (b.dt_cancel_item_nota_saida between @dt_inicial and @dt_final )and
   b.ic_status_item_nota_saida = 'D'                            and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota) > 0                           and
   b.cd_pedido_venda = d.cd_pedido_venda                         and
   d.cd_pedido_venda = c.cd_pedido_venda                       and
   b.cd_item_nota_saida = c.cd_item_pedido_venda                             and 
   c.vl_lista_item_pedido > 0                             and
   c.cd_item_pedido_venda < 80                                 and
   c.ic_smo_item_pedido_venda = 'N'                           
-- Devoluções dos Meses Anteriores
select a.cd_vendedor         as 'Vendedor', 
       b.qt_item_nota_saida               as 'Quantidade',
      (b.qt_item_nota_saida*b.vl_unitario_item_nota)      as 'ValorVenda', 
       orcado =
       case
          when (b.qt_devolucao_item_nota>0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*11/100)
          when (b.qt_devolucao_item_nota>0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)-((b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1)*8.8/100)
          when (b.qt_devolucao_item_nota=0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*11/100)
          when (b.qt_devolucao_item_nota=0 and d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)-((b.qt_item_nota_saida*c.vl_lista_item_pedido*-1)*8.8/100)
          when 
             (b.qt_devolucao_item_nota > 0 ) then ( b.qt_devolucao_item_nota*c.vl_lista_item_pedido*-1) 
          else
             (b.qt_item_nota_saida*c.vl_lista_item_pedido*-1) 
       end,
       descto =
       case          
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida < @dt_perc_smo)  then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100)
          when (d.ic_smo_pedido_venda = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(b.vl_unitario_item_nota/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100)
          else 
             (100-(b.vl_unitario_item_nota/c.vl_lista_item_pedido)*100)
       end,
       @vl_zero    as 'fatdevolucao',
       @vl_zero    as 'qtddev',   
     ((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota ) as 'fatdevolucaoant',
       case when isnull(b.qt_devolucao_item_nota,0)>0 then 
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end              as 'qtddevant'
into #ResumoFatDescontoSetorAnt
from
   Nota_Saida a, Nota_Saida_Item b, Pedido_venda_Item c, Pedido_Venda d, Operacao_Fiscal e 
Where
   a.cd_operacao_fiscal     = e.cd_operacao_fiscal                      and
   e.ic_comercial_operacao = 'S'                           and
   a.ic_outras_operacoes < 2                              and
   a.vl_total > 0                              and
   a.cd_nota_saida = b.cd_nota_saida                                 and     
   b.cd_categoria_produto = @ncmapa                          and
  (b.dt_cancel_item_nota_saida between @dt_inicial and @dt_final )and
  (b.dt_nota_saida < @dt_inicial)                     and
   b.ic_status_item_nota_saida = 'D'                            and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota) > 0                           and
   b.cd_pedido_venda = d.cd_pedido_venda                         and
   d.cd_pedido_venda = c.cd_pedido_venda                       and
   b.cd_item_nota_saida = c.cd_item_pedido_venda                             and 
   c.vl_lista_item_pedido > 0                             and
   c.cd_item_pedido_venda < 80                                 and
   c.ic_smo_item_pedido_venda = 'N'                           
-- Juntar as três querys
insert into #ResumoFatDescontoSetor
Select * from #ResumoFatDescontoSetorDev
insert into #ResumoFatDescontoSetor
Select * from #ResumoFatDescontoSetorAnt
select a.Vendedor         as 'Setor', 
       max(b.fan_ven)     as 'Vendedor',
       Sum(a.Orcado)      as 'ValorOrcado',
       sum(a.quantidade)-sum( 2*a.qtddev) as 'Quantidade',  
       sum(a.valorvenda)  as 'ValorVenda',
      (sum(a.valorvenda) / sum(a.quantidade)) as 'PrecoMedio',
      (100 - ( sum(a.valorvenda) / sum(a.orcado) ) * 100) as 'Desconto' 
from #ResumoFatDescontoSetor a, FTVEND b
where a.Vendedor = b.cod_ven
group by a.vendedor
order by a.vendedor

