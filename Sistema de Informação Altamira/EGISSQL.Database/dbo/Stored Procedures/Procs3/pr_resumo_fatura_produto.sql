
CREATE  procedure pr_resumo_fatura_produto
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution - 2003
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor : Daniel C. Neto.
--Desc  : Faturas por Produto
--Data       : 14.08.2000
--Atual : 11.12.2000 - Quantidade da categoria
--      : 16/08/2002 - Migrado para o EGISSQL
--        21/11/2003 - Incluído novas colunas, acertos no filtro - Daniel C. Neto.
--        10/12/2003 - Acerto - Marcio Longhini.
--        13/01/2004 - Inclusão da coluna desconto. - Daniel C. Neto
--        23/04/2004 - Acerto no parametro da fn_vl_liquido_venda - ELIAS
--        04.05.2004 - Alteração dos valores de custo e margem de contriuição para função
--                     fn_valor_custo_produto. Igor Gama
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

-----------------------------------------------------------------------------------
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1,
@cd_tipo_mercado int = 0,
@cd_cliente int = 0,
@cd_produto int = 0,
@cd_vendedor int = 0
as

  declare @qt_total_produto int,
          @vl_total_produto float,
          @vl_total_produto_ano float,
 			 @ic_devolucao_bi char(1)

  declare @vl_moeda float

  set @vl_total_produto_ano = 0

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
  	 vw.cd_cliente,
  	 vw.cd_produto,
	 vw.cd_vendedor,
    vw.cd_categoria_produto,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
    cast(sum(isnull(vw.vl_unitario_item_total,0)) / @vl_moeda as money)   						      as Venda
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left Outer Join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and 
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
      
   and isnull(vw.cd_cliente, 0)  = case isnull(@cd_cliente, 0) when 0 then isnull(vw.cd_cliente, 0)  else isnull(@cd_cliente, 0) end
   and isnull(vw.cd_vendedor, 0) = case isnull(@cd_vendedor, 0) when 0 then isnull(vw.cd_vendedor, 0)  else isnull(@cd_vendedor, 0) end
   and isnull(vw.cd_produto, 0)  = case isnull(@cd_produto, 0) when 0 then isnull(vw.cd_produto, 0)  else isnull(@cd_produto, 0) end
  group by 
   vw.cd_cliente,
  	vw.cd_produto,
   vw.cd_vendedor,
   vw.cd_categoria_produto
  order by 1 desc

--SOMATORIO DO ANO
  Select 
    @vl_total_produto_ano = cast(sum(isnull(vw.vl_unitario_item_total,0) / @vl_moeda) as money)
  from
    vw_faturamento_bi vw left outer join 
    Produto_Custo pc  on vw.cd_produto = pc.cd_produto left Outer Join
    Produto p on vw.cd_produto = p.cd_produto
  where   	
	year(vw.dt_nota_saida) = year(@dt_inicial)and 
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end        
   and isnull(vw.cd_cliente, 0)  = case isnull(@cd_cliente, 0) when 0 then isnull(vw.cd_cliente, 0)  else isnull(@cd_cliente, 0) end
   and isnull(vw.cd_vendedor, 0) = case isnull(@cd_vendedor, 0) when 0 then isnull(vw.cd_vendedor, 0)  else isnull(@cd_vendedor, 0) end
   and isnull(vw.cd_produto, 0)  = case isnull(@cd_produto, 0) when 0 then isnull(vw.cd_produto, 0)  else isnull(@cd_produto, 0) end
  group by 
   vw.cd_cliente,
  	vw.cd_produto,
   vw.cd_vendedor,
   vw.cd_categoria_produto
  order by 1 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  print 'Devoluções do Mês Corrente'
  ----------------------------------------------------
  select 
  	 vw.cd_cliente,
  	 vw.cd_produto,
	 vw.cd_vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
    cast(sum(isnull(vw.vl_unitario_item_total,0)) / @vl_moeda as money)   						      as Venda

  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left Outer Join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and 
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end        

   and isnull(vw.cd_cliente, 0)  = case isnull(@cd_cliente, 0) when 0 then isnull(vw.cd_cliente, 0)  else isnull(@cd_cliente, 0) end
   and isnull(vw.cd_vendedor, 0) = case isnull(@cd_vendedor, 0) when 0 then isnull(vw.cd_vendedor, 0)  else isnull(@cd_vendedor, 0) end
   and isnull(vw.cd_produto, 0)  = case isnull(@cd_produto, 0) when 0 then isnull(vw.cd_produto, 0)  else isnull(@cd_produto, 0) end
  group by 
  	 vw.cd_cliente,
    vw.cd_produto,
    vw.cd_vendedor

  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  print 'Total de Devoluções do Ano Anterior'
  ----------------------------------------------------
  select 
  	 vw.cd_cliente,
  	 vw.cd_produto,
	 vw.cd_vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
    cast(sum(isnull(vw.vl_unitario_item_total,0)) / @vl_moeda as money)   						      as Venda
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left Outer Join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      

   and isnull(vw.cd_cliente, 0)  = case isnull(@cd_cliente, 0) when 0 then isnull(vw.cd_cliente, 0)  else isnull(@cd_cliente, 0) end
   and isnull(vw.cd_vendedor, 0) = case isnull(@cd_vendedor, 0) when 0 then isnull(vw.cd_vendedor, 0)  else isnull(@cd_vendedor, 0) end
   and isnull(vw.cd_produto, 0)  = case isnull(@cd_produto, 0) when 0 then isnull(vw.cd_produto, 0)  else isnull(@cd_produto, 0) end
  group by 
  	 vw.cd_cliente,
  	 vw.cd_produto,
    vw.cd_vendedor
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  print 'Cancelamento do Mês Corrente'
  ----------------------------------------------------
  select 
  	 vw.cd_cliente,
  	 vw.cd_produto,
	 vw.cd_vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								as TotalLiquido,
    cast(sum(isnull(vw.vl_unitario_item_total,0)) / @vl_moeda as money)   						      as Venda
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left Outer Join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    

   and isnull(vw.cd_cliente, 0)  = case isnull(@cd_cliente, 0) when 0 then isnull(vw.cd_cliente, 0)  else isnull(@cd_cliente, 0) end
   and isnull(vw.cd_vendedor, 0) = case isnull(@cd_vendedor, 0) when 0 then isnull(vw.cd_vendedor, 0)  else isnull(@cd_vendedor, 0) end
   and isnull(vw.cd_produto, 0)  = case isnull(@cd_produto, 0) when 0 then isnull(vw.cd_produto, 0)  else isnull(@cd_produto, 0) end
  group by 
  	 vw.cd_cliente,
    vw.cd_produto,
    vw.cd_vendedor
  order by 1 desc


  select a.cd_cliente,
			a.cd_produto,
         a.cd_categoria_produto,
         a.cd_vendedor,
  			 --Quantidade
    		cast(IsNull(a.qt_item_nota_saida,0) -
    		    (isnull(b.qt_item_nota_saida,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			   when 'N' then 0
  		 			   else isnull(c.qt_item_nota_saida,0)
  		 			 end) + 
  			    isnull(d.qt_item_nota_saida,0)) as money) as Qtd,
    		cast(IsNull(a.TotalLiquido,0) -
    		 (isnull(b.TotalLiquido,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLiquido,0)
  		 			end) + 
  			  isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
         --Total de Venda
    		 cast(IsNull(a.Venda,0) -
    		 (isnull(b.Venda,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.Venda,0)
  		 			end) + 
  			  isnull(d.Venda,0)) as money) as Venda
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
  	left outer join  #FaturaDevolucao b
  	on a.cd_produto = b.cd_produto --and a.cd_cliente = b.cd_cliente and a.cd_vendedor = b.cd_vendedor
    left outer join  #FaturaDevolucaoAnoAnterior c
  	on a.cd_produto = c.cd_produto --and a.cd_cliente = c.cd_cliente and a.cd_vendedor = c.cd_vendedor
    left outer join  #FaturaCancelado d
  	on a.cd_produto = d.cd_produto --and a.cd_cliente = d.cd_cliente and a.cd_vendedor = d.cd_vendedor
  
--Select * from #FaturaResultado

  -- Total de produtoes

  set @qt_total_produto = @@rowcount
  
  -- Total de Vendas Geral dos Setores
  set @vl_total_produto = 0

  Select 
    @vl_total_produto = @vl_total_produto + Sum(isnull(venda,0))
  from
    #FaturaResultado


 
  --Cria a Tabela Final de Vendas por Setor  
  select IDENTITY(int, 1,1) AS 'Posicao',  
     	   a.cd_cliente,
         a.cd_vendedor,
         a.cd_produto as Produto,
         a.cd_categoria_produto,
         a.qtd,
         a.TotalLiquido,  
			a.Venda
  Into 
    #FaturaCategoriaAux
  from 
    #FaturaResultado a  
  Order by 
    a.venda desc  
   
  --Mostra tabela ao usuário  
  select distinct b.nm_fantasia_produto,  
         dbo.fn_mascara_produto(b.cd_produto) as 'cd_mascara_produto',  
         b.nm_produto,  
         un.sg_unidade_medida,  
         a.Produto,
         cp.nm_categoria_produto,
			cli.nm_fantasia_cliente,
         ve.nm_fantasia_vendedor,
         cast(((a.Venda * 100) / @vl_total_produto)as money) as MargemPeriodo,
         a.*
  from   
    #FaturaCategoriaAux a
      Left Outer Join
    Produto b 
      on a.Produto = b.cd_produto  
      left outer join   
    Unidade_Medida un on un.cd_unidade_medida = b.cd_unidade_medida left join
    Categoria_Produto Cp On (a.cd_categoria_produto = cp.cd_categoria_produto) left join
	 Cliente cli on (cli.cd_cliente = a.cd_cliente) left join
    Vendedor ve on (a.cd_vendedor = ve.cd_vendedor)
  order by posicao  

