
--------------------------------------------------------------------------------------
--pr_clientes_novos_resumo_mensal
--------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Clientes novos por Setor
--Data          : 09.09.2000
--Atualizado    : 09.09.2000
--              : 06/04/2002 - Alterado para o padrão do EGIS - Sandro Campos
--              : 06/04/2002 - Correção da fonte de dados do vinculo entre o cliente e o vendedor
--              : 06.03.2006 - Acerto do (%) Geral - Carlos Fernandes
--------------------------------------------------------------------------------------
create procedure pr_clientes_novos_resumo_mensal
@cd_ano      int,
@cd_vendedor int
as

declare @qt_total_cliente int

set @qt_total_cliente = 0

Select 
	c.cd_vendedor                  as 'setor',
  month(c.dt_cadastro_cliente)         as 'mes',         -- data de cadastro
  count(distinct (c.cd_cliente))       as 'qtdcliente' -- quantidade de clientes 
into 
	#tmpcli
from
  Cliente c
where
  @cd_ano      = year(c.dt_cadastro_cliente)
	and c.cd_vendedor = 
				(case IsNull(@cd_vendedor,0)
				 when 0 then c.cd_vendedor
				 else @cd_vendedor
				 end)
group by 
	month(c.dt_cadastro_cliente), c.cd_vendedor
order by 
	month(c.dt_cadastro_cliente)

-- Monta a tabela com Resumo

select a.setor,               
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
group by a.setor

select
   @qt_total_cliente = sum(isnull(a.qtdcliente,0)) 
from #tmpcli a

if @qt_total_cliente = 0
   set @qt_total_cliente = 1

-- Mostra tabela de Resumo com Nome do Vendedor

select a.nm_fantasia_vendedor as 'Vendedor',
       b.*,
       PercTotal = (Total/@qt_total_cliente)*100
from
    vendedor a,#tmpven b
where
    a.cd_vendedor = b.setor and
    ((a.cd_vendedor = @cd_vendedor) or ( @cd_vendedor = 0))
    
order by b.total desc
