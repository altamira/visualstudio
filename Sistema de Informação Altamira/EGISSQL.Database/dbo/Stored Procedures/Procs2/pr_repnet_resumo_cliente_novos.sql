



--pr_repnet_resumo_cliente_novos
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Resumo Anual de Clientes Novos por Vendedor
--Data          : 07.04.2002
--Atualizado    : 
---------------------------------------------------------------------------------------
create procedure pr_repnet_resumo_cliente_novos
@cd_vendedor  int,
@dt_inicial   datetime,
@dt_final     datetime
as

select cd_vendedor                as 'vendedor',
       month(dt_cadastro_cliente) as 'mes', 
       count(*)                   as 'qtdcliente'  
into #tmpcli
from
    Cliente
where
  cd_vendedor = @cd_vendedor  and
  dt_cadastro_cliente between @dt_inicial and @dt_final 
group by 
  cd_vendedor,month(dt_cadastro_cliente)

order by 
  cd_vendedor,month(dt_cadastro_cliente)

-- Montagem da tabela com Resumo

select      a.vendedor,               
       sum( a.qtdcliente )                                    as 'Total', 
       sum( case a.mes when 1  then a.qtdcliente else 0 end ) as 'Jan',
       sum( case a.mes when 2  then a.qtdcliente else 0 end ) as 'Fev',
       sum( case a.mes when 3  then a.qtdcliente else 0 end ) as 'Mar',
       sum( case a.mes when 4  then a.qtdcliente else 0 end ) as 'Abr',
       sum( case a.mes when 5  then a.qtdcliente else 0 end ) as 'Mai',
       sum( case a.mes when 6  then a.qtdcliente else 0 end ) as 'Jun',
       sum( case a.mes when 7  then a.qtdcliente else 0 end ) as 'Jul',
       sum( case a.mes when 8  then a.qtdcliente else 0 end ) as 'Ago',
       sum( case a.mes when 9  then a.qtdcliente else 0 end ) as 'Set',
       sum( case a.mes when 10 then a.qtdcliente else 0 end ) as 'Out',
       sum( case a.mes when 11 then a.qtdcliente else 0 end ) as 'Nov',
       sum( case a.mes when 12 then a.qtdcliente else 0 end ) as 'Dez' 
into #tmpven
from #tmpcli a
group by 
     a.vendedor

-- Mostra tabela de Resumo com Nome do Vendedor

select a.nm_fantasia_vendedor as 'Vendedor',
       b.*
from
    Vendedor a,#tmpven b
where
    a.cd_vendedor = b.vendedor

order by b.total desc

    




