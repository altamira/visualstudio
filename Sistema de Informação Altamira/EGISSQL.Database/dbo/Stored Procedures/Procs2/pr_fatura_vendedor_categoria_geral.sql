
CREATE procedure pr_fatura_vendedor_categoria_geral
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Faturas por vendedor e Categorias
--Data        : 16/11/2006
-----------------------------------------------------------------------------------

@dt_inicial datetime,
@dt_final   datetime,
@cd_vendedor int,
@cd_moeda   int = 1

as

------------------------------------
-- Geraçao da Tabela Auxiliar de Faturas por vendedor
------------------------------------
declare @qt_total_vendedor float,
				@vl_total_vendedor float,
				@ic_devolucao_bi char(1)
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

----------------------------------------------------
-- Faturamento Bruto
----------------------------------------------------
Select 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto																		  as Categoria,
  sum(vw.vl_unitario_item_total) / @vl_moeda as Compra,
	sum(vw.qt_item_nota_saida)																	as Qtd
into 
  #FaturaAnual
from
  vw_faturamento_bi vw
  left outer join Categoria_Produto cp
  on vw.cd_categoria_produto = cp.cd_categoria_produto 
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
group by
        vw.cd_vendedor, 
	vw.cd_categoria_produto,
	cp.nm_categoria_produto
order by 3 desc


----------------------------------------------------
-- Devoluções do Mês Corrente
----------------------------------------------------
Select 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto																		  as Categoria,
  sum(vw.vl_unitario_item_total) / @vl_moeda as Compra,
	sum(vw.qt_item_nota_saida)																	as Qtd
into 
  #FaturaDevolucao
from
  vw_faturamento_devolucao_bi vw
  left outer join Categoria_Produto cp
  on vw.cd_categoria_produto = cp.cd_categoria_produto 
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
group by 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto
order by 3 desc


----------------------------------------------------
-- Total de Devoluções do Ano Anterior
----------------------------------------------------
Select 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto																		  as Categoria,
  sum(vw.vl_unitario_item_total) / @vl_moeda as Compra,
	sum(vw.qt_item_nota_saida)																	as Qtd
into 
  #FaturaDevolucaoAnoAnterior
from
  vw_faturamento_devolucao_mes_anterior_bi vw
  left outer join Categoria_Produto cp
  on vw.cd_categoria_produto = cp.cd_categoria_produto 
where 
  year(vw.dt_nota_saida) = year(@dt_inicial) and
	(vw.dt_nota_saida < @dt_inicial) and
	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
group by 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto
order by 3 desc


----------------------------------------------------
-- Cancelamento do Mês Corrente
----------------------------------------------------
Select 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto																		  as Categoria,
  sum(vw.vl_unitario_item_atual) / @vl_moeda as Compra,
	sum(vw.qt_item_nota_saida)																	as Qtd
into 
  #FaturaCancelado
from
  vw_faturamento_cancelado_bi vw
  left outer join Categoria_Produto cp
  on vw.cd_categoria_produto = cp.cd_categoria_produto 
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
group by 
        vw.cd_vendedor,
	vw.cd_categoria_produto,
	cp.nm_categoria_produto
order by 3 desc

select a.cd_categoria_produto,
       a.Categoria, 
       --Total de Venda
  		 cast(IsNull(a.Compra,0) -
  		 (isnull(b.Compra,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.Compra,0)
		 			end) + 
			  isnull(d.Compra,0)) as money) as Compra,
			 --Margem de Contribuição
			cast(IsNull(a.Qtd,0) -
  		 (isnull(b.Qtd,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.Qtd,0)
		 			end) + 
			  isnull(d.Qtd,0)) as money) as Qtd,
        cli.nm_fantasia_vendedor as vendedor
into 
	#FaturaResultado
from 
  #FaturaAnual a
	left outer join  #FaturaDevolucao b
	on a.cd_categoria_produto = b.cd_categoria_produto
  left outer join  #FaturaDevolucaoAnoAnterior c
	on a.cd_categoria_produto = c.cd_categoria_produto
  left outer join  #FaturaCancelado d
	on a.cd_categoria_produto = d.cd_categoria_produto
  left outer join vendedor cli on cli.cd_vendedor = a.cd_vendedor

------------------------------------
-- Total de vendedor
------------------------------------
set @qt_total_vendedor = @@rowcount

------------------------------------
-- Total de Vendas Geral
------------------------------------
set @vl_total_vendedor = 0

select 
	@vl_total_vendedor = sum(IsNull(Compra,0))
from
  #FaturaResultado

select IDENTITY(int, 1,1) 															 as Posicao, 
       cd_categoria_produto, 
       Categoria,
       Qtd,
       cast(Compra as money) 														 as Compra,
       cast(((compra / @vl_total_vendedor)*100) as money) as Perc,
       vendedor

Into 
	#FaturaResultadoFinal
from 
	#FaturaResultado
Order by 
	Compra desc

------------------------------------
--Mostra tabela ao usuário
------------------------------------
select 	
	* 
from 
	#FaturaResultadoFinal
order by 
	Posicao

