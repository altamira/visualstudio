
-----------------------------------------------------------------------------------
--pr_notas_vendedor_categoria
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.                                           2006
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor        : Daniel C. neto. 
--Objetivo     : Consulta de Notas por vendedor e Categoria
--Data         : 16/11/2006
--             : 
-- Atualizado  : 16.04.2009 - Ajuste do Código - Carlos Fernandes
--------------------------------------------------------------------------------------

create procedure pr_notas_vendedor_categoria
@cd_vendedor int,
@cd_mapa     varchar(10),
@dt_inicial  datetime,
@dt_final    datetime,
@cd_moeda    int

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


declare @ic_devolucao_bi char(1)

set @ic_devolucao_bi = 'N'

Select 
	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
from 
	Parametro_BI with (nolock) 
where
	cd_empresa = dbo.fn_empresa()

----------------------------------------------------
-- Faturamento Bruto
----------------------------------------------------
Select 
	vw.cd_nota_saida,
	vw.dt_nota_saida,
	vw.cd_item_nota_saida,
	vw.qt_item_nota_saida,
	vw.nm_produto_item_nota,
        vw.cd_categoria_produto,
	vw.cd_pedido_venda,
        vw.cd_item_pedido_venda,
        vw.vl_unitario_item_total / @vl_moeda as Total,
        vw.cd_produto
into 
  #FaturaAnual
from
  vw_faturamento_bi vw
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
	and vw.cd_categoria_produto = @cd_mapa
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
       
order by 1 desc

--select * from vw_faturamento


----------------------------------------------------
-- Devoluções do Mês Corrente
----------------------------------------------------
Select 
	vw.cd_nota_saida,
	vw.cd_item_nota_saida,
	vw.qt_item_nota_saida,
        vw.vl_unitario_item_total / @vl_moeda as Total,
        vw.cd_produto

into 
  #FaturaDevolucao
from
  vw_faturamento_devolucao_bi vw
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
	and vw.cd_categoria_produto = @cd_mapa
  and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
order by 1 desc

----------------------------------------------------
-- Total de Devoluções do Ano Anterior
----------------------------------------------------
Select 
	vw.cd_nota_saida,
	vw.cd_item_nota_saida,
	vw.qt_item_nota_saida,
        vw.vl_unitario_item_total / @vl_moeda as Total,
        vw.cd_produto

into 
  #FaturaDevolucaoAnoAnterior
from
  vw_faturamento_devolucao_mes_anterior_bi vw
where 
  year(vw.dt_nota_saida) = year(@dt_inicial) and
	(vw.dt_nota_saida < @dt_inicial)
	and vw.dt_restricao_item_nota between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
	and vw.cd_categoria_produto = @cd_mapa
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
order by 1 desc

----------------------------------------------------
-- Cancelamento do Mês Corrente
----------------------------------------------------
Select 
	vw.cd_nota_saida,
	vw.cd_item_nota_saida,
	vw.qt_item_nota_saida,
        vw.vl_unitario_item_total / @vl_moeda as Total,
        vw.cd_produto

into 
  #FaturaCancelado
from
  vw_faturamento_cancelado_bi vw
where 
	vw.dt_nota_saida between @dt_inicial and @dt_final
	and vw.cd_vendedor = @cd_vendedor
	and vw.cd_categoria_produto = @cd_mapa
        and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a vendedors
order by 1 desc


select a.cd_nota_saida,
       a.dt_nota_saida, 
			 a.cd_item_nota_saida, 
			 a.nm_produto_item_nota, 
			 a.cd_categoria_produto, 
			 a.cd_pedido_venda,
			 a.cd_item_pedido_venda,
       --Total de Venda
  		 cast(IsNull(a.qt_item_nota_saida,0) -
  		 (isnull(b.qt_item_nota_saida,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.qt_item_nota_saida,0)
		 			end) + 
			  isnull(d.qt_item_nota_saida,0)) as money) as qt_item_nota_saida,
			 --Total da Nota Fiscal
			cast(IsNull(a.Total,0) -
  		 (isnull(b.Total,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.Total,0)
		 			end) + 
			  isnull(d.Total,0)) as money) as Total,
     cli.nm_fantasia_vendedor,
     p.cd_mascara_produto,
     p.nm_fantasia_produto,
     um.sg_unidade_medida    
from 
  #FaturaAnual a
	left outer join  #FaturaDevolucao b
	on a.cd_nota_saida = b.cd_nota_saida
		 and a.cd_item_nota_saida = b.cd_item_nota_saida
  left outer join  #FaturaDevolucaoAnoAnterior c
	on a.cd_nota_saida = c.cd_nota_saida
		 and a.cd_item_nota_saida = c.cd_item_nota_saida
  left outer join  #FaturaCancelado d
	on a.cd_nota_saida = d.cd_nota_saida
          and a.cd_item_nota_saida = d.cd_item_nota_saida
  left outer join vendedor cli      with (nolock) on cli.cd_vendedor      = @cd_vendedor
  left outer join Produto p         with (nolock) on p.cd_produto         = a.cd_produto
  left outer join Unidade_Medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
order by
	a.dt_nota_saida desc
	
