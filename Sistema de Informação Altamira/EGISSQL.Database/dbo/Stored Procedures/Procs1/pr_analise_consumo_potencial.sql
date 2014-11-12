
CREATE PROCEDURE pr_analise_consumo_potencial

---------------------------------------------------------------------------------------------------
--pr_analise_consumo_potencial
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Compras de Cliente no Período 
--Filtrado por Vendedor, Por Categoria, e por uma Tolerância Limite.
--
--Data          : 05/09/2002
--Atualizado    : 04/11/2002 - Acerto de joins (DUELA)
--              : 28.04.2006 - Verificação e Acertos Gerais - Carlos Fernandes
--                             Status do cliente
--              : 04.05.2006 - Código do Cliente - Carlos Fernandes
----------------------------------------------------------------------------------------------------

@cd_vendedor       int   = 0,
@cd_cat_compra     int   = 0,
@cd_cat_nao_compra int   = 0,
@pc_limite         float = 0,
@dt_inicial        datetime,
@dt_final          dateTime

as


--Possibilidade de se incluir um quantidade de dias para cálculo do potencial
--Caso, for utilizar criar o campo qt_dia_potencial na tabela parametro_bi, no egisadmin.
--

-- declare @qt_dia_potencial int
-- 
-- declare
--   @qt_dia_potencial = isnull(qt_dia_potencial,30)
-- from
--   parametro_bi
-- where
--   cd_empresa = dbo.fn_empresa()

--select * from status_cliente


-- Geração da tabela auxiliar de Vendas pela Categoria Escolhida comprada.

select 
  a.cd_cliente                                               as 'cliente', 
  sum(b.qt_item_pedido_venda)                                as 'Qtd',
  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)    as 'Venda',

  --Valor Total de Venda para o cliente

  (select sum(y.qt_item_pedido_venda * y.vl_unitario_item_pedido)
   from
     Pedido_Venda x 
   left outer join Pedido_Venda_Item y on   x.cd_pedido_venda = y.cd_pedido_venda 
   left outer join Cliente z           on  z.cd_cliente = x.cd_cliente
   where
     (x.dt_pedido_venda between @dt_inicial and @dt_final )       and
     ((x.dt_cancelamento_pedido is null ) or 
     (x.dt_cancelamento_pedido > @dt_final))                      and
     isnull(x.vl_total_pedido_venda,0) > 0                        and
     isnull(x.ic_consignacao_pedido,'N') = 'N'                    and
     (y.qt_item_pedido_venda * y.vl_unitario_item_pedido) > 0     and
     ((y.dt_cancelamento_item is null ) or 
     (y.dt_cancelamento_item > @dt_final))                        and
     isnull(y.ic_smo_item_pedido_venda,'N') = 'N'                             and
     ((z.cd_vendedor  = @cd_vendedor) or (@cd_vendedor = 0))      and
     x.cd_cliente = a.cd_cliente 
     group by 
     x.cd_cliente             )                          as 'Vl_Total'
into #VendaGrupoAux
from
  Pedido_Venda a   
  left outer join Pedido_Venda_Item b on b.cd_pedido_venda    = a.cd_pedido_venda 
  left outer join Cliente cli         on  cli.cd_cliente      = a.cd_cliente
  left outer join Status_Cliente sc   on sc.cd_status_cliente = cli.cd_status_cliente
 
where
   (a.dt_pedido_venda between @dt_inicial and @dt_final )                          and
   ((a.dt_cancelamento_pedido is null ) or (a.dt_cancelamento_pedido > @dt_final)) and
   isnull(a.vl_total_pedido_venda,0) > 0                           and
   isnull(a.ic_consignacao_pedido,'N') = 'N'                       and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0        and
   ((b.dt_cancelamento_item is null ) or (b.dt_cancelamento_item > @dt_final))               and
   isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                              and
   cli.cd_vendedor  = case when @cd_vendedor = 0 then cli.cd_vendedor else @cd_vendedor end  and
   b.cd_categoria_produto = @cd_cat_compra                        
 --and isnull(sc.ic_analise_status_cliente,'N')='S' 

Group by a.cd_cliente
order by 1 desc

--select * from #VendaGrupoAux

------------------------------------------------------------------------------------
-- Excluindo os clientes que compraram o @cd_cat_compra, mas não podem ter comprado
-- @cd_cat_nao_compra
-----------------------------------------------------------------------------------

select  
  a.cd_cliente                                             as 'cliente', 
  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)  as 'VendaNaoCompra'
into
  #ClienteNaoCompra
from
  Pedido_Venda a 
  left outer join Pedido_Venda_Item b on b.cd_pedido_venda = a.cd_pedido_venda
  left outer join Cliente cli         on cli.cd_cliente    = a.cd_cliente
where
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
   ((a.dt_cancelamento_pedido is null ) or 
   (a.dt_cancelamento_pedido > @dt_final))                          and
    isnull(a.vl_total_pedido_venda,0) > 0                           and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                       and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0         and
   ((b.dt_cancelamento_item is null ) or (b.dt_cancelamento_item > @dt_final)) and
    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                               and
   cli.cd_vendedor  = case when @cd_vendedor = 0 then cli.cd_vendedor else @cd_vendedor end  and
   b.cd_categoria_produto = @cd_cat_nao_compra
group by a.cd_cliente
order by 1 desc

--select * from #ClienteNaoCompra

--------------------------------------------------------------------------------------
-- Calculando total por Cliente que não compra para definir uma porcentagem limite.
--------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Tabela Final para Eliminar os Clientes num Limite de Compra em % pré-estabelecido.
-----------------------------------------------------------------------------------
select   
  a.cliente                                            as 'cliente',
  cast((VendaNaoCompra*100)/vl_total as Decimal(25,2)) as 'Perc'
into 
  #ClienteNaoCompra2
from
  #ClienteNaoCompra a, #VendaGrupoAux b
where
  a.cliente = b.cliente   

--select * from #ClienteNaoCompra2

-------------------------------------------------
-- Calculando Potencial.
-------------------------------------------------
select 
  cli.cd_cliente, 
  sum(b.qt_item_pedido_venda)                                as 'Qtd_Pot',
  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)    as 'Potencial',
  sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)/12 as 'Media'
into 
  #Potencial
from
  Pedido_Venda a 
  left outer join Pedido_Venda_Item b on b.cd_pedido_venda = a.cd_pedido_venda
  left outer join Cliente cli         on cli.cd_cliente = a.cd_cliente
where
  (a.dt_pedido_venda between @dt_inicial-365 and @dt_final )    and --1 Ano
  ((a.dt_cancelamento_pedido is null ) or 
  (a.dt_cancelamento_pedido > @dt_final))                    and
  isnull(a.vl_total_pedido_venda,0) > 0                      and
  isnull(a.ic_consignacao_pedido,'N') = 'N'                  and
  (b.qt_item_pedido_venda * b.vl_unitario_item_pedido) > 0   and
  ((b.dt_cancelamento_item is null ) or 
  (b.dt_cancelamento_item > @dt_final))                      and
   isnull(b.ic_smo_item_pedido_venda,'N') = 'N'              and
  ((cli.cd_vendedor  = @cd_vendedor) or (@cd_vendedor = 0))
group by cli.cd_cliente
order by 1 desc

--select * from #Potencial

--Cria a Tabela Final de Vendas por Grupo

select 
  b.cd_cliente,
  v.nm_fantasia_vendedor,
  b.nm_fantasia_cliente,
  a.qtd,
  a.venda,
  c.Qtd_Pot,
  c.Potencial,
  a.Vl_Total,
  isnull(d.Perc,0) as Perc,
  c.Media,
  e.VendaNaoCompra
into
  #Resultado   
from 
  #VendaGrupoAux a, 
  Cliente b, 
  #Potencial c, 
  #ClienteNaoCompra2 d, 
  #ClienteNaoCompra  e, 
  Vendedor v

where
  a.cliente       = b.cd_cliente      and
  c.cd_cliente    = a.cliente         and
  a.cliente       *= d.cliente        and
  a.cliente       *= e.cliente        and
  b.cd_vendedor   = v.cd_vendedor

if @pc_limite > 0
   delete #Resultado where isnull(Perc,0)>=@pc_limite        

select 
  * 
from 
  #Resultado
order by 
  Potencial desc,
  nm_fantasia_cliente

