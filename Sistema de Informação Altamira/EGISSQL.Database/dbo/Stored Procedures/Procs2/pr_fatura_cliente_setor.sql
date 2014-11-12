
--pr_fatura_cliente_setor
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Faturas por Cliente e Setor
--Data       : 14.08.2000
--Atualizado : 24.11.2000 Incluido o Campo PagCli (Ref. do Mapa)
--           : 26.12.2000 Alterada a forma de junção das três querys finais
--           : 26.12.2000 Alteração na disposição do campo POSICAO
--           : 15.08.2002 Migração bco. Egis - DUELA
-- 06/11/2003 - Inclusão de MOeda - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 06.03.2006 - Acerto da geral - Carlos Fernandes
-----------------------------------------------------------------------------------
CREATE procedure pr_fatura_cliente_setor

@cd_vendedor int,
@dt_inicial datetime,
@dt_final datetime,
@cd_moeda int = 1

as

---------------------------------------
-- Geraçao da Tabela Auxiliar de Faturas por Cliente
---------------------------------------
declare @zero float
set @zero = 0

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


select 
  f.nm_fantasia_vendedor   as 'Vendedor',
  g.nm_fantasia_cliente    as 'Cliente', 
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) as 'Compra',

--select * from nota_saida_item

  TotalLiquido = 0, --cast(dbo.fn_vl_liquido_venda('F',b.vl_unitario_item_nota, b.vl_icms_item, b.vl_ipi, a.cd_destinacao_produto, @dt_inicial) as money), 				

  (select distinct
     count(ns.cd_nota_saida)
   from
     Nota_Saida ns 
   left outer join Operacao_Fiscal opf on 
     opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
   where  
    (ns.dt_nota_saida between @dt_inicial and @dt_final) and
    (ns.cd_vendedor = @cd_vendedor)                      and
    ns.cd_cliente=a.cd_cliente                           and
    opf.ic_comercial_operacao = 'S'                      and
    opf.cd_tipo_movimento_estoque=11                     and
    ns.dt_cancel_nota_saida is null ) as 'Pedidos',

--  count(a.cd_nota_saida) as 'Pedidos',
  max(a.dt_nota_saida)     as 'UltimaCompra', 
  @zero                    as 'Fat_Devolucao',
  @zero                    as 'Fat_Devolucao_Ant'
into #FaturaCliSetor
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida  
left outer join Pedido_Venda_Item c on
  (c.cd_pedido_venda = b.cd_pedido_venda and
   c.cd_item_pedido_venda = b.cd_item_pedido_venda)
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal = a.cd_operacao_fiscal 
left outer join Vendedor f on
  f.cd_vendedor = a.cd_vendedor
left outer join Cliente g on
  g.cd_cliente = a.cd_cliente
where
  (a.dt_nota_saida between @dt_inicial and @dt_final) and
  (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)      and
  e.ic_comercial_operacao = 'S'                       and
  e.cd_tipo_movimento_estoque=11                      and
  isnull(b.ic_status_item_nota_saida,'')<>'C'         and
  a.dt_cancel_nota_saida is null                      and
  b.dt_cancel_item_nota_saida is null                 and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>=0   and
  c.cd_item_pedido_venda<80                           and
  c.ic_smo_item_pedido_venda='N'                          
group by 
   f.nm_fantasia_vendedor, 
   a.cd_cliente, 
   g.nm_fantasia_cliente, 
   b.qt_item_nota_saida, 
   b.vl_unitario_item_nota
order by 1 desc

---------------------------------------
-- Devoluções do Mês Corrente
---------------------------------------
select 
  f.nm_fantasia_vendedor   as 'Vendedor',
  g.nm_fantasia_cliente as 'Cliente', 
  compra=        
    case 
      when b.qt_devolucao_Item_nota > 0 then 
        (b.qt_devolucao_Item_nota*b.vl_unitario_item_nota/ @vl_moeda*-1) 
      else 
         (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda*-1)
    end,

  TotalLiquido = cast(dbo.fn_vl_liquido_venda('F',b.vl_unitario_item_nota , b.vl_icms_item, b.vl_ipi, a.cd_destinacao_produto, @dt_inicial) as money),


  @zero           as 'pedidos1',
  a.dt_nota_saida as 'ultimacompra1', 
  (case when isnull(b.qt_devolucao_Item_nota,0)>0 then
     b.qt_devolucao_Item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota / @vl_moeda as 'Fat_Devolucao',
  @zero as 'Fat_Devolucao_Ant' 
into #FaturaCliSetorDev
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida  
left outer join Pedido_Venda_Item c on
  (c.cd_pedido_venda = b.cd_pedido_venda and
   c.cd_item_pedido_venda = b.cd_item_pedido_venda)
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal = a.cd_operacao_fiscal 
left outer join Vendedor f on
  f.cd_vendedor = a.cd_vendedor
left outer join Cliente g on
  g.cd_cliente = a.cd_cliente
Where
   (a.dt_nota_saida between @dt_inicial and @dt_final) and
   (b.dt_cancel_item_nota_saida between @dt_inicial and @dt_final) and
   (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)      and
   e.ic_comercial_operacao = 'S'                       and
   e.cd_tipo_movimento_estoque=11                      and
   b.ic_status_item_nota_saida='D'                     and
   (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>0    and
   c.cd_item_pedido_venda<80                           and
   c.ic_smo_item_pedido_venda='N'                          
order by 1


---------------------------------------
-- Devoluções do Mês Anterior
---------------------------------------
select 
  f.nm_fantasia_vendedor as 'Vendedor',
  g.nm_fantasia_cliente  as 'Cliente', 
  compra=        
    case 
      when b.qt_devolucao_Item_nota > 0 then 
        (b.qt_devolucao_Item_nota*b.vl_unitario_item_nota/ @vl_moeda*-1) 
      else 
        (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda*-1)
    end,

  TotalLiquido = cast(dbo.fn_vl_liquido_venda('F',b.vl_unitario_item_nota , b.vl_icms_item, b.vl_ipi,a.cd_destinacao_produto, @dt_inicial) as money),
 				
  @zero           as 'pedidos1',
  a.dt_nota_saida as 'ultimacompra1', 
  (case when isnull(b.qt_devolucao_Item_nota,0)>0 then
    b.qt_devolucao_Item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota/ @vl_moeda as 'Fat_Devolucao',
  @zero as 'Fat_Devolucao_Ant' 
into #FaturaCliSetorAnt
from
  Nota_Saida a
left outer join Nota_Saida_Item b on
  b.cd_nota_saida = a.cd_nota_saida  
left outer join Pedido_Venda_Item c on
  (c.cd_pedido_venda = b.cd_pedido_venda and
   c.cd_item_pedido_venda = b.cd_item_pedido_venda)
left outer join Operacao_Fiscal e on
  e.cd_operacao_fiscal = a.cd_operacao_fiscal 
left outer join Vendedor f on
  f.cd_vendedor = a.cd_vendedor
left outer join Cliente g on
  g.cd_cliente = a.cd_cliente
where
  a.dt_nota_saida < @dt_inicial                    and 
  (b.dt_cancel_item_nota_saida between @dt_inicial and @dt_final) and
  (@cd_vendedor=a.cd_vendedor or @cd_vendedor=0)   and
  e.ic_comercial_operacao = 'S'                    and
  e.cd_tipo_movimento_estoque=11                   and
  b.ic_status_item_nota_saida='D'                  and
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda)>0 and
  c.cd_item_pedido_venda<80                        and
  c.ic_smo_item_pedido_venda='N'                          
order by 1


---------------------------------------
-- Juntar as três querys
---------------------------------------
insert into #FaturaCliSetor
select * from #FaturaCliSetorDev

insert into #FaturaCliSetor
select * from #FaturaCliSetorAnt

declare @qt_total_cliente int
declare @vl_total_cliente float

set @qt_total_cliente = @@rowcount
set @vl_total_cliente = 0

select a.Vendedor,
       a.Cliente,
       Sum(a.Compra) as 'Compra',
       Sum(a.TotalLiquido) as 'TotalLiquido',
       Sum(a.Fat_Devolucao) as 'Fat_Devolucao',
       Max(a.UltimaCompra) as 'UltimaCompra',
       a.pedidos as 'Pedidos'--,
--       Max(b.Pag_Cli) as 'Referencia'

Into #FaturaCliSetor1
from #FaturaCliSetor a
group by a.Vendedor, a.Cliente, a.pedidos

select * 
into #FaturaCliSetor2
from #FaturaCliSetor1
order by compra+fat_devolucao desc

select @vl_total_cliente = @vl_total_cliente + compra
from
  #FaturaCliSetor2

---------------------------------------
-- Identifica as posições da amostra
---------------------------------------
select IDENTITY(int, 1,1) AS 'Posicao',
       a.Vendedor,
       a.Cliente,
       a.Compra + a.Fat_Devolucao as 'Compra',
       a.TotalLiquido             as 'TotalLiquido',
       a.UltimaCompra,
       a.Pedidos,
--       a.Referencia, 
        ((a.Compra/@vl_total_cliente)*100) as 'Perc'
into #FaturaCliSetor3
from #FaturaCliSetor2 a

---------------------------------------
--Mostra tabela ao usuário
---------------------------------------
select * from #FaturaCliSetor3
order by posicao
