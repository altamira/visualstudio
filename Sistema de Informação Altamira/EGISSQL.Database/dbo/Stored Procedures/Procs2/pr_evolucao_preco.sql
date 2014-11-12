
-----------------------------------------------------------------------------------
--pr_evolucao_preco
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004
-----------------------------------------------------------------------------------                     
--Stored Procedure     : SQL Server Microsoft 2000
--Autor (es)           : Carlos Cardoso Fernandes         
--Banco Dados          : EGISSQL
--Objetivo             : Evolução de Preço de Produto
--Data                 : 04.09.2003
--Atualizado           : 05.09.2003 - Incluido a funcao para formatar a Máscara - RAFAEL
--                     : 04/01/2005 - Acerto do Cabeçalho -Sérgio Cardoso 
--		       : 20.07.2005 - Mudança para filtragem ser realizada via parâmetro
-----------------------------------------------------------------------------------
create procedure pr_evolucao_preco
@ic_tipo_filtragem char(1) = 'P', --P - Produto / G - Grupo
@cd_grupo_produto int,
@cd_produto int,
@dt_inicial datetime,
@dt_final   datetime

as


select 
  ph.cd_produto,
  datepart(year,dt_historico_produto)  as ano,
  datepart(month,dt_historico_produto) as mes,
  (Select top 1 vl_historico_produto 
	from produto_historico with (nolock) 
	where cd_produto = ph.cd_produto and 
	dt_historico_produto = max(ph.dt_historico_produto)) as Preco
into
  #Evolucao_preco_produto
from 
  produto_historico ph with (nolock)
  inner join Produto p with (nolock)
  on p.cd_produto = ph.cd_produto
where 
  IsNull(p.cd_grupo_produto,0) = (case @ic_tipo_filtragem 
			  	   when 'G' then @cd_grupo_produto
			  	   else IsNull(p.cd_grupo_produto,0)
				  end) and
  IsNull(p.cd_produto,0)       = (case @ic_tipo_filtragem 
			  	   when 'P' then @cd_produto
			  	   else IsNull(p.cd_produto,0)
				  end) and
  year(dt_historico_produto) = year(@dt_inicial)
group by
  ph.cd_produto, 
  datepart(year,dt_historico_produto), 
  datepart(month,dt_historico_produto)

Select 
  p.cd_produto,          
  dbo.fn_mascara_produto(p.cd_produto) as codigo,
  max(p.nm_fantasia_produto) as fantasia,
  max(p.nm_produto)          as descricao ,
  max(u.sg_unidade_medida)  as unidade,
  max(p.vl_produto)          as PrecoVenda,
  sum(case when mes =1  then isnull(preco,0) else 0 end) as 'jan',
  sum(case when mes =2  then isnull(preco,0) else 0 end) as 'fev',
  sum(case when mes =3  then isnull(preco,0) else 0 end) as 'mar',
  sum(case when mes =4  then isnull(preco,0) else 0 end) as 'abr',
  sum(case when mes =5  then isnull(preco,0) else 0 end) as 'mai',
  sum(case when mes =6  then isnull(preco,0) else 0 end) as 'jun',
  sum(case when mes =7  then isnull(preco,0) else 0 end) as 'jul',
  sum(case when mes =8  then isnull(preco,0) else 0 end) as 'ago',
  sum(case when mes =9  then isnull(preco,0) else 0 end) as 'set',
  sum(case when mes =10 then isnull(preco,0) else 0 end) as 'out',
  sum(case when mes =11 then isnull(preco,0) else 0 end) as 'nov',
  sum(case when mes =12 then isnull(preco,0) else 0 end) as 'dez',
  --Preço Médio
  sum(preco)/12                                          as 'preco_medio',
  --(%) Variação
  sum(case when mes=1  then ((( p.vl_produto/isnull(preco,0))*100)-100) else 0 end) as 'variacao',
  --Preço Minimo em função do Preço Vendido
  (select min(vl_unitario_item_pedido) 
       from pedido_venda_item 
       where cd_produto=@cd_produto and 
             dt_item_pedido_venda between @dt_inicial and @dt_final 
       group by cd_produto ) as 'minimo',
  --Preço Máximo em função do Preço Vendido
  (select max(vl_unitario_item_pedido) 
       from pedido_venda_item 
       where cd_produto=@cd_produto and 
             dt_item_pedido_venda between @dt_inicial and @dt_final
       group by cd_produto ) as 'maximo',
  --Preço de Custo
    sum( pc.vl_custo_produto ) as 'custo',
    sum( pc.vl_custo_contabil_produto ) as 'custo_contabil'
 
  
from 
  Produto p 
  inner join #Evolucao_Preco_Produto e 
    on p.cd_produto = e.cd_produto 
  inner join Unidade_Medida u
    on p.cd_unidade_medida = u.cd_unidade_medida
  left outer join Produto_Custo pc
    on p.cd_produto = pc.cd_produto
group by
  p.cd_produto
  
