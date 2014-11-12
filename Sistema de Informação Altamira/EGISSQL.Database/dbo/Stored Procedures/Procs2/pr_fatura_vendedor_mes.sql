
--pr_fatura_vendedor_mes
--------------------------------------------------------------------------------------
--GBS
--Stored Procedure : SQL Server Microsoft 2000
--Daniel C. Neto.
--Faturas anuais por vendedor (Mês a Mês)
--Data         : 16/11/2006
--------------------------------------------------------------------------------------
create procedure pr_fatura_vendedor_mes

@cd_ano int,
@cd_vendedor int,
@cd_moeda int

as

set nocount on

declare @ic_devolucao_bi char(1)
declare @vl_total_vendas float
declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

set @ic_devolucao_bi = 'N'

Select 
	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
from 
	Parametro_BI
where
	cd_empresa = dbo.fn_empresa()

Select 
	month(vw.dt_nota_saida)   																	as NumeroMes,
  sum(vw.vl_unitario_item_total) / @vl_moeda as Vendas,
  count(distinct(vw.cd_nota_saida))                           as Pedidos
into 
  #FaturaAnual
from
  vw_faturamento_bi vw
where 
	year(vw.dt_nota_saida) = @cd_ano
  and vw.cd_vendedor = @cd_vendedor
group by 
  month(vw.dt_nota_saida)
order by 1 desc


----------------------------------------------------
-- Devoluções do Mês Corrente
----------------------------------------------------
select 
	month(vw.dt_nota_saida)   																	as NumeroMes,
  sum(vw.vl_unitario_item_total) / @vl_moeda as Vendas,
  count(distinct(vw.cd_nota_saida))                           as Pedidos
into 
  #FaturaDevolucao
from
  vw_faturamento_devolucao_bi vw
where 
	year(vw.dt_nota_saida) = @cd_ano
  and vw.cd_vendedor = @cd_vendedor
group by 
  month(vw.dt_nota_saida)
order by 1 desc

----------------------------------------------------
-- Total de Devoluções do Ano Anterior
----------------------------------------------------
select 
  month(vw.dt_restricao_item_nota)                             as NumeroMes, 
	sum(vw.vl_unitario_item_total) / @vl_moeda as Vendas, 
  count(distinct(vw.cd_nota_saida))                           as Pedidos
into 
  #FaturaDevolucaoAnoAnterior
from
  vw_faturamento_devolucao_mes_anterior_bi vw
where 
	year(vw.dt_nota_saida) = (@cd_ano - 1)
  and year(vw.dt_restricao_item_nota) = @cd_ano
  and vw.cd_vendedor = @cd_vendedor
group by 
  month(vw.dt_restricao_item_nota)
order by 1 desc

----------------------------------------------------
-- Cancelamento do Mês Corrente
----------------------------------------------------
select 
	month(vw.dt_nota_saida)   																	as NumeroMes,
  sum(vw.vl_unitario_item_atual) / @vl_moeda as Vendas,
  count(distinct(vw.cd_nota_saida))                           as Pedidos
into 
  #FaturaCancelado
from
  vw_faturamento_cancelado_bi vw
where 
	year(vw.dt_nota_saida) = @cd_ano
  and vw.cd_vendedor = @cd_vendedor
group by 
  month(vw.dt_nota_saida)
order by 1 desc


select a.NumeroMes as Mes,
			 (Select 
					top 1 nm_fantasia_vendedor 
				from 
					vendedor 
				where cd_vendedor = @cd_vendedor) as vendedor,
  		 cast(IsNull(a.vendas,0) -
  		 (isnull(b.vendas,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.vendas,0)
		 			end) + 
			isnull(d.vendas,0)) as money) as Total

into 
	#FaturaResultado
from 
  #FaturaAnual a
	left outer join  #FaturaDevolucao b
	on a.NumeroMes = b.NumeroMes
  left outer join  #FaturaDevolucaoAnoAnterior c
	on a.NumeroMes = c.NumeroMes
  left outer join  #FaturaCancelado d
	on a.NumeroMes = d.NumeroMes



--Mostra tabela ao usuário com Resumo Mensal

select a.vendedor,
       sum(a.Total)                                    as 'TotalVenda', 
       sum(case a.mes when 1  then a.Total else 0 end) as 'Jan',
       sum(case a.mes when 2  then a.Total else 0 end) as 'Fev',
       sum(case a.mes when 3  then a.Total else 0 end) as 'Mar',
       sum(case a.mes when 4  then a.Total else 0 end) as 'Abr',
       sum(case a.mes when 5  then a.Total else 0 end) as 'Mai',
       sum(case a.mes when 6  then a.Total else 0 end) as 'Jun',
       sum(case a.mes when 7  then a.Total else 0 end) as 'Jul',
       sum(case a.mes when 8  then a.Total else 0 end) as 'Ago',
       sum(case a.mes when 9  then a.Total else 0 end) as 'Set',
       sum(case a.mes when 10 then a.Total else 0 end) as 'Out',
       sum(case a.mes when 11 then a.Total else 0 end) as 'Nov',
       sum(case a.mes when 12 then a.Total else 0 end) as 'Dez' 
from 
	#FaturaResultado a
group by 
	a.vendedor
