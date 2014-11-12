
create procedure pr_venda_vendedor_mes
--------------------------------------------------------------------------------------
--GBS
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Consulta do Total de Vendas por vendedor Mês a Mês
--Data         : 16/11/2006
--------------------------------------------------------------------------------------

@cd_ano     int,
@cd_vendedor int,
@cd_moeda   int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por vendedor
select c.nm_fantasia_vendedor       as 'vendedor',
       month(a.dt_pedido_venda)    as 'Mes', 
       cast(sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido/ @vl_moeda) as decimal(25,2)) as 'Total'
into #VendavendedorMes
from
  pedido_venda a left outer join 
  pedido_venda_item b on b.cd_pedido_venda = a.cd_pedido_venda left outer join 
  vendedor c on c.cd_vendedor = a.cd_vendedor
Where
  a.cd_vendedor = @cd_vendedor                                         and
  year(a.dt_pedido_venda)=@cd_ano                                    and
  (b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda) > 0      and
  isnull(a.ic_consignacao_pedido,'N') <> 'S'            and
  IsNull(year(b.dt_cancelamento_item),@cd_ano + 1) > @cd_ano and --Desconsidera itens cancelados depois da data final
  IsNull(year(a.dt_cancelamento_pedido),@cd_ano+1) > @cd_ano --Desconsider pedidos de venda cancelados                

Group by a.cd_vendedor,month(a.dt_pedido_venda), c.nm_fantasia_vendedor
order by 2 desc

--Mostra tabela ao usuário com Resumo Mensal

select a.vendedor,
       sum( a.total )                                    as 'TotalVenda', 
       sum( case a.mes when 1  then a.total else 0 end ) as 'Jan',
       sum( case a.mes when 2  then a.total else 0 end ) as 'Fev',
       sum( case a.mes when 3  then a.total else 0 end ) as 'Mar',
       sum( case a.mes when 4  then a.total else 0 end ) as 'Abr',
       sum( case a.mes when 5  then a.total else 0 end ) as 'Mai',
       sum( case a.mes when 6  then a.total else 0 end ) as 'Jun',
       sum( case a.mes when 7  then a.total else 0 end ) as 'Jul',
       sum( case a.mes when 8  then a.total else 0 end ) as 'Ago',
       sum( case a.mes when 9  then a.total else 0 end ) as 'Set',
       sum( case a.mes when 10 then a.total else 0 end ) as 'Out',
       sum( case a.mes when 11 then a.total else 0 end ) as 'Nov',
       sum( case a.mes when 12 then a.total else 0 end ) as 'Dez' 
       
from #VendavendedorMes a
group by a.vendedor

