

CREATE PROCEDURE pr_resumo_consulta_pedido_faturamento_perda_categoria
--pr_resumo_consulta_pedido_faturamento_perda_categoria
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar Magalhães
--Banco de Dados: EgisSql
--Objetivo: Listar um Resumo das Propostas/Pedidos/Faturamento/Perdas por Categoria de Produto
--Data: 11/11/2002
--Atualizado: 
---------------------------------------------------
@dt_inicial as DateTime,
@dt_final as DateTime,
@cd_cliente as int
AS

declare @cd_categoria_produto int,
	@vl_categoria_produto float

Select 
	cd_categoria_produto, 
	nm_categoria_produto,
	cd_mascara_categoria,
	cast(0 as float) as qt_proposta,
	cast(0 as float) as pc_proposta,
	cast(0 as float) as vl_proposta,
	cast(0 as float) as qt_pedido_venda,
	cast(0 as float) as pc_pedido_venda,
	cast(0 as float) as vl_pedido_venda,
	cast(0 as float) as qt_faturado,
	cast(0 as float) as pc_faturado,
	cast(0 as float) as vl_faturado,
	cast(0 as float) as qt_perda,
	cast(0 as float) as pc_perda,
	cast(0 as float) as vl_perda,
	cd_ordem_categoria
Into
	#Resumo
from 
	Categoria_Produto
--Inicializa Valor das Propostas na Categoria
set @vl_categoria_produto = 0
--Filtro geral
Select 
	@vl_categoria_produto = sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2))
from 
	Consulta_Itens
where 	
	dt_item_consulta between @dt_inicial and @dt_final and
	cd_consulta in (Select cd_consulta From Consulta where cd_cliente = @cd_cliente)

--Filtro agrupando por categoria
select 
	cd_categoria_produto, 
	sum(Round(qt_item_consulta,2)) as qt_item_consulta , 
	sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2)) as vl_unitario_item_consulta,
	((sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2)) * 100) / @vl_categoria_produto) as pc_item_consulta
into	
	#Resumo_Proposta
from 
	Consulta_Itens
where 	
	dt_item_consulta between @dt_inicial and @dt_final and
	cd_consulta in (Select cd_consulta From Consulta where cd_cliente = @cd_cliente)
Group by cd_categoria_produto

--Inicializa Valor dos Pedidos na Categoria
set @vl_categoria_produto = 0
--Filtra geral
Select 
	@vl_categoria_produto = sum(ROUND(qt_item_pedido_venda,2) * ROUND(vl_unitario_item_pedido,2))
from 
	Pedido_Venda_Item
where 	
	dt_item_pedido_venda between @dt_inicial and @dt_final

--Filtra agrupando por categoria
select 
	cd_categoria_produto, 
	sum(ROUND(qt_item_pedido_venda,2)) as qt_item_pedido_venda , 
	sum(ROUND(qt_item_pedido_venda,2) * ROUND(vl_unitario_item_pedido,2)) as vl_unitario_item_pedido,
	((sum(ROUND(qt_item_pedido_venda,2) * ROUND(vl_unitario_item_pedido,2)) * 100) / @vl_categoria_produto) as pc_item_pedido 
into	
	#Resumo_Pedido
From
	Pedido_Venda_Item
where 	
	dt_item_pedido_venda between @dt_inicial and @dt_final
	and cd_pedido_venda in (Select cd_pedido_venda from Pedido_Venda where cd_cliente = @cd_cliente)
Group by cd_categoria_produto


--Inicializa Valor dos Faturamentos na Categoria
set @vl_categoria_produto = 0
--Filtra geral
Select 
	@vl_categoria_produto = sum(ROUND(qt_item_nota_saida - IsNull(qt_devolucao_item_nota,0),2) * ROUND(vl_unitario_item_nota,2))
from 
	Nota_Saida_Item
where 
	dt_cancel_item_nota_saida is null and 
	cd_nota_saida in (Select cd_nota_saida from Nota_saida where dt_nota_saida between @dt_inicial and @dt_final)

--Filtra agrupando por categoria
select 
	IsNull(cd_categoria_produto,0) as cd_categoria_produto, 
	sum(ROUND(qt_item_nota_saida - IsNull(qt_devolucao_item_nota,0),2)) as qt_item_nota , 
	sum(ROUND(qt_item_nota_saida - IsNull(qt_devolucao_item_nota,0),2) * ROUND(vl_unitario_item_nota,2)) as vl_unitario_item_nota,
	((sum(ROUND(qt_item_nota_saida - IsNull(qt_devolucao_item_nota,0),2) * ROUND(vl_unitario_item_nota,2)) * 100) / @vl_categoria_produto) as pc_item_nota
into	
	#Resumo_Nota
from 
	Nota_Saida_Item
where 
	dt_cancel_item_nota_saida is null and 
	cd_nota_saida in (Select cd_nota_saida from Nota_saida where dt_nota_saida between @dt_inicial and @dt_final)

Group by cd_categoria_produto


--Inicializa Valor das Propotas Perdidos na Categoria
set @vl_categoria_produto = 0
--Filtra geral
Select 
	@vl_categoria_produto = sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2))
from 
	Consulta_Itens, Consulta_Item_Perda
where
	Consulta_Itens.cd_consulta = Consulta_Item_Perda.cd_consulta and
	Consulta_Itens.cd_item_consulta = Consulta_Item_Perda.cd_item_consulta
	and dt_perda_consulta between @dt_inicial and @dt_final

--Filtra agrupando por categoria
select 
	cd_categoria_produto, 
	sum(Round(qt_item_consulta,2)) as qt_item_consulta , 
	sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2)) as vl_unitario_item_consulta,
	((sum(round(qt_item_consulta,2) * round(vl_unitario_item_consulta,2)) * 100) / @vl_categoria_produto) as pc_item_consulta
into	
	#Resumo_Perda_Proposta
From
	Consulta_Itens, Consulta_Item_Perda
where
	Consulta_Itens.cd_consulta = Consulta_Item_Perda.cd_consulta and
	Consulta_Itens.cd_item_consulta = Consulta_Item_Perda.cd_item_consulta
	and dt_perda_consulta between @dt_inicial and @dt_final
Group by cd_categoria_produto


DECLARE cResumo CURSOR FOR 
SELECT cd_categoria_produto
FROM #Resumo
ORDER BY cd_categoria_produto

OPEN cResumo

FETCH NEXT FROM cResumo INTO @cd_categoria_produto

WHILE @@FETCH_STATUS = 0
BEGIN
	--Atualiza Proposta
	Update #Resumo
	set 
		qt_proposta = rp.qt_item_consulta,
		pc_proposta = rp.pc_item_consulta,
		vl_proposta = rp.vl_unitario_item_consulta
	From
		#Resumo, #Resumo_Proposta rp
	where
		#Resumo.cd_categoria_produto = rp.cd_categoria_produto and
		rp.cd_categoria_produto = @cd_categoria_produto

	--Atualiza Pedido
	Update #Resumo
	set 
		qt_pedido_venda = rp.qt_item_pedido_venda,
		pc_pedido_venda = rp.pc_item_pedido,
		vl_pedido_venda = rp.vl_unitario_item_pedido
	From
		#Resumo, #Resumo_Pedido rp
	where
		#Resumo.cd_categoria_produto = rp.cd_categoria_produto and
		rp.cd_categoria_produto = @cd_categoria_produto

	--Atualiza Nota
	Update #Resumo
	set 
		qt_faturado = rp.qt_item_nota,
		pc_faturado = rp.pc_item_nota,
		vl_faturado = rp.vl_unitario_item_nota
	From
		#Resumo, #Resumo_Nota rp
	where
		#Resumo.cd_categoria_produto = rp.cd_categoria_produto and
		rp.cd_categoria_produto = @cd_categoria_produto


	--Atualiza Proposta Perdidas
	Update #Resumo
	set 
		qt_perda = rp.qt_item_consulta,
		pc_perda = rp.pc_item_consulta,
		vl_perda = rp.vl_unitario_item_consulta
	From
		#Resumo, #Resumo_Perda_Proposta rp
	where
		#Resumo.cd_categoria_produto = rp.cd_categoria_produto and
		rp.cd_categoria_produto = @cd_categoria_produto

	--Move para o próximo	
	FETCH NEXT FROM cResumo INTO @cd_categoria_produto
END

CLOSE cResumo
DEALLOCATE cResumo   

select * from #Resumo 
where
qt_proposta > 0 or 
qt_pedido_venda > 0 or
qt_faturado > 0 or
qt_perda > 0
order by cd_ordem_categoria



