
--------------------------------------------------------------------------------------
--pr_analise_fat_preco_setor_categoria
--------------------------------------------------------------------------------------
--GBS- Global Business Sollution                                                  2002                     
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto
--Análise de preço por setor e categoria (Faturamento)
--Obs: - Baseado na procedure de mesmo nome do SAP.
--Data          : 05.08.2002
-- Alterado     : 09/08/2002 - Colocado IsNull em nos campos de ic_smo_item_pedido_venda
--                           - Daniel C. Neto.
--              : 30.05.2006 - Categoria do Produto - Carlos Fernandes
--------------------------------------------------------------------------------------

CREATE  procedure pr_analise_fat_preco_setor_categoria
@cd_vendedor int,
@cd_categoria_produto varchar(10),
@dt_inicial      datetime,
@dt_final        datetime,
@dt_perc_smo     datetime

as
declare @vl_zero float
set @vl_zero = 0

select cli.nm_fantasia_cliente as 'Cliente', 
       v.nm_fantasia_vendedor as 'Vendedor',
       d.cd_pedido_venda as 'Pedido', 
       a.cd_nota_saida  as 'Nro. NF',
       a.dt_nota_saida  as 'Data',
       b.cd_item_nota_saida as 'Item', 
       b.qt_item_nota_saida as 'Qtd', 
       b.nm_produto_item_nota as 'Descricao',
       b.vl_total_item as 'Venda', 
       c.vl_lista_item_pedido as 'OrcadoOriginal',
       d.ic_smo_pedido_venda as 'SMO',
       orcado =  
       case 
          when (IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (IsNull(b.qt_item_nota_saida,'N') * IsNull(c.vl_lista_item_pedido,0))-((IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0))*11/100) 
          when (IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido, 0))-((IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0))*8.8/100) 
          else
             (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0))
       end,
       '(%)' =
       case
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (100-(IsNull(b.vl_total_item,0) / (IsNull(c.vl_lista_item_pedido,0) - (IsNull(c.vl_lista_item_pedido,0) * 11/100)))*100) 
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(IsNull(b.vl_total_item,0) / (IsNull(c.vl_lista_item_pedido,0) - (IsNull(c.vl_lista_item_pedido,0)*8.8/100)))*100) 
          else 
             (100-(IsNull(b.vl_total_item,0) / (IsNull(c.vl_lista_item_pedido,0) * 100))) 
       end,
       @vl_zero    as 'fatdevolucao',
       @vl_zero    as 'qtddev',   
       @vl_zero    as 'fatdevolucaoant',
       @vl_zero    as 'qtddevant'   
into #AnaliseFatPrecoSetor
from
   Nota_Saida a inner join 
   Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida left outer join
   Vendedor v on v.cd_vendedor = a.cd_vendedor            left outer join
   Cliente cli on cli.cd_cliente = a.cd_cliente           left outer join
   Pedido_Venda_Item c on c.cd_pedido_venda = b.cd_pedido_venda left outer join
   Pedido_Venda d on d.cd_pedido_venda = c.cd_pedido_venda left outer join
   Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal
Where
  (a.dt_nota_saida between @dt_inicial and @dt_final)      and
   ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))  and
   IsNull(e.ic_comercial_operacao,'N') = 'S'                           and
   IsNull(a.vl_total,0) > 0					   and
   ((b.cd_categoria_produto = @cd_categoria_produto) or
     (@cd_categoria_produto = 0))                          and 
   isnull(b.cd_status_nota,1)<> 7                          and
  (a.dt_cancel_nota_saida is null or 
   a.dt_cancel_nota_saida > @dt_final)                     and
  (IsNull(b.qt_item_nota_saida,0) * IsNull(b.vl_total_item,0)) > 0             and
   IsNull(c.vl_lista_item_pedido,0) > 0                              and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'


Order by 12 desc

-- Devoluções do Mês

select cli.nm_fantasia_cliente as 'Cliente', 
       v.nm_fantasia_vendedor as 'Vendedor',
       d.cd_pedido_venda as 'Pedido', 
       a.cd_nota_saida  as 'Nro. NF',
       a.dt_nota_saida  as 'Data',
       b.cd_item_nota_saida as 'Item', 
       b.qt_item_nota_saida as 'Qtd', 
       b.nm_produto_item_nota as 'Descricao',
       b.vl_total_item as 'Venda', 
       c.vl_lista_item_pedido as 'OrcadoOriginal',
       d.ic_smo_pedido_venda as 'SMO',
       orcado =
       case
          when (IsNull(b.qt_devolucao_item_nota,0) > 0 and IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0)  *-1)-
             ((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) *-1)*11/100)
          when (IsNull(b.qt_devolucao_item_nota,0) > 0 and IsNull(d.ic_smo_pedido_venda,0) = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) * -1)-((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) * -1)*8.8/100)
          when (IsNull(b.qt_devolucao_item_nota,0) = 0 and ISNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             ((IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0) * -1)*11/100)
          when (IsNull(b.qt_devolucao_item_nota,0) = 0 and IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0) * -1)-((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0)*-1)*8.8/100)
          when 
             (IsNull(b.qt_devolucao_item_nota,0) > 0 ) then ( IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) * -1) 
          else
             (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0) * -1) 
       end,
       '(%)' =
       case
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (100-(IsNull(b.vl_total_item,0) / (IsNull(c.vl_lista_item_pedido,0) - (IsNull(c.vl_lista_item_pedido,0)*11/100)))*100) 
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(IsNull(b.vl_total_item,0)/(IsNull(c.vl_lista_item_pedido,0)-(IsNull(c.vl_lista_item_pedido,0)*8.8/100)))*100) 
          else 
             (100-(IsNull(b.vl_total_item,0)/(IsNull(c.vl_lista_item_pedido,0)*100))) 

       end,

     ((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          isNull(b.qt_devolucao_item_nota,0) else IsNull(b.qt_item_nota_saida,0) end ) * IsNull(b.vl_total_item,0) ) as 'fatdevolucao',
       case when isnull(b.qt_devolucao_item_nota,0)>0 then 
          IsNull(b.qt_devolucao_item_nota,0) else IsNull(b.qt_item_nota_saida,0) end              as 'qtddev',
       @vl_zero    as 'fatdevolucaoant',
       @vl_zero    as 'qtddevant'   
into #AnaliseFatPrecoSetorDev
from
   Nota_Saida a inner join 
   Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida left outer join
   Cliente cli on cli.cd_cliente = a.cd_cliente           left outer join
   Vendedor v on v.cd_vendedor = a.cd_vendedor            left outer join
   Pedido_Venda_Item c on c.cd_pedido_venda = b.cd_pedido_venda left outer join
   Pedido_Venda d on d.cd_pedido_venda = c.cd_pedido_venda left outer join
   Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal
Where
  (a.dt_nota_saida between @dt_inicial and @dt_final)      and
   ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))  and
   IsNull(e.ic_comercial_operacao,'N') = 'S'                           and
   IsNull(a.vl_total,0) > 0                                     and
   ((b.cd_categoria_produto = @cd_categoria_produto) or
     (@cd_categoria_produto = 0))                          and 
   isnull(b.cd_status_nota,1) in (3,4)                     and
  (a.dt_cancel_nota_saida is null or 
   a.dt_cancel_nota_saida > @dt_final)                     and
  (b.qt_item_nota_saida * b.vl_total_item) > 0             and
   IsNull(c.vl_lista_item_pedido,0) > 0                              and
   IsNull(c.ic_smo_item_pedido_venda,'N') = 'N'

order by 12 Desc

-- Devoluções dos Meses Anteriores
select cli.nm_fantasia_cliente as 'Cliente', 
       v.nm_fantasia_vendedor as 'Vendedor',
       d.cd_pedido_venda as 'Pedido', 
       a.cd_nota_saida  as 'Nro. NF',
       a.dt_nota_saida  as 'Data',
       b.cd_item_nota_saida as 'Item', 
       b.qt_item_nota_saida as 'Qtd', 
       b.nm_produto_item_nota as 'Descricao',
       b.vl_total_item as 'Venda', 
       c.vl_lista_item_pedido as 'OrcadoOriginal',
       d.ic_smo_pedido_venda as 'SMO',
       orcado =
       case
          when (IsNull(b.qt_devolucao_item_nota,0) > 0 and IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
               (IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) *-1)-
               ((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0)*-1)*11/100)
          when ((IsNull(b.qt_devolucao_item_nota,0)>0 and IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo)) then 
               ((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0) * -1) - ((IsNull(b.qt_devolucao_item_nota,0) * Isnull(c.vl_lista_item_pedido,0)*-1)*8.8/100))
          when ((IsNull(b.qt_devolucao_item_nota,0) = 0 and IsNull(d.ic_smo_pedido_venda, 'N') = 'S' and a.dt_nota_saida < @dt_perc_smo)) then 
               ((IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0)*-1)*11/100)
          when (IsNull(b.qt_devolucao_item_nota,0) = 0 and IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
               (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0)*-1)-((IsNull(b.qt_devolucao_item_nota,0) * IsNull(c.vl_lista_item_pedido,0)*-1)*8.8/100)
          when 
               (IsNull(b.qt_devolucao_item_nota,0) > 0 ) then ( IsNull(b.qt_devolucao_item_nota,0)* c.vl_lista_item_pedido*-1) 
          else
               (IsNull(b.qt_item_nota_saida,0) * IsNull(c.vl_lista_item_pedido,0)*-1) 
       end,
       '(%)' =
       case
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida < @dt_perc_smo) then 
             (100-(b.vl_total_item/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*11/100)))*100) 
          when ( IsNull(d.ic_smo_pedido_venda,'N') = 'S' and a.dt_nota_saida >= @dt_perc_smo) then 
             (100-(b.vl_total_item/(c.vl_lista_item_pedido-(c.vl_lista_item_pedido*8.8/100)))*100) 
          else 
             (100-(b.vl_total_item/(c.vl_lista_item_pedido*100))) 

       end,
       @vl_zero    as 'fatdevolucao',
       @vl_zero    as 'qtddev',   
     ((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_total_item ) as 'fatdevolucaoant',
       case when isnull(b.qt_devolucao_item_nota,0)>0 then 
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end              as 'qtddevant'
into #AnaliseFatPrecoSetorAnt
from
   Nota_Saida a inner join 
   Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida left outer join
   Cliente cli on cli.cd_cliente = a.cd_cliente           left outer join
   Vendedor v on v.cd_vendedor = a.cd_vendedor            left outer join
   Pedido_Venda_Item c on c.cd_pedido_venda = b.cd_pedido_venda left outer join
   Pedido_Venda d on d.cd_pedido_venda = c.cd_pedido_venda left outer join
   Operacao_Fiscal e on e.cd_operacao_fiscal = a.cd_operacao_fiscal
Where
  (a.dt_cancel_nota_saida between @dt_inicial and @dt_final)      and
   ((a.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))  and
   IsNull(e.ic_comercial_operacao,'N') = 'S'                           and
   a.vl_total > 0                                     and
   ((b.cd_categoria_produto = @cd_categoria_produto) or
     (@cd_categoria_produto = 0))                          and 
   isnull(b.cd_status_nota,1) in (3,4)                     and
   a.dt_nota_saida < @dt_final                     and
  (b.qt_item_nota_saida * b.vl_total_item) > 0             and
   c.vl_lista_item_pedido > 0                              and
   ISNull(c.ic_smo_item_pedido_venda,'N') = 'N'

order by 12 Desc
-- Juntar as três querys
insert into #AnaliseFatPrecoSetor
Select * from #AnaliseFatPrecoSetorDev
insert into #AnaliseFatPrecoSetor
Select * from #AnaliseFatPrecoSetorAnt
select * from #AnaliseFatPrecoSetor
order by 12 desc

