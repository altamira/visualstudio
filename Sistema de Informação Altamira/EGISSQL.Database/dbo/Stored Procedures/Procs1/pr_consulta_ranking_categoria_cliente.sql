
create procedure pr_consulta_ranking_categoria_cliente
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor: Daniel Duela
--Consulta do Ranking de Categoria de Clientes
--Data : 12/01/2004
--------------------------------------------------------------------------------------
@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_moeda int

as

declare @qt_total_categoria_cliente int
declare @vl_total_categoria_cliente float
declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

-----------------------------------------------------------
if @ic_parametro = 1  -- VENDAS
-----------------------------------------------------------
begin
  -- Geração da Tabela Auxiliar de Vendas por Cliente
  select 
    cli.cd_categoria_cliente,
    cast(sum(qt_item_pedido_venda * (vl_unitario_item_pedido / @vl_moeda)) as decimal(25,2)) as 'Venda', 
    cast(sum(dbo.fn_vl_liquido_venda
      ('V',(qt_item_pedido_venda*(vl_unitario_item_pedido / @vl_moeda)), 
       pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
    cast(sum((qt_item_pedido_venda *(vl_lista_item_pedido / @vl_moeda))) 
      as decimal(25,2)) as 'TotalLiSta',
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) 
      as decimal(25,2)) as 'CustoContabil',
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
         sum((dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda *
             (vl_unitario_item_pedido / @vl_moeda)), pc_icms, 
              vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial))) 
      as decimal(25,2)) * 100 as 'MargemContribuicao',
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) 
      as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
    max(dt_pedido_venda)                                as 'UltimaVenda', 
    count(distinct cd_pedido_venda)                              as 'pedidos'
  into #VendaClienteAux1
  from 
    vw_venda_bi vw
      left outer join 
    Cliente cli 
      on vw.cd_cliente = cli.cd_cliente 
      left outer join 
    Produto_Custo ps 
      on vw.cd_produto = ps.cd_produto
  where
   (vw.dt_pedido_venda between @dt_inicial and @dt_final) 
  group by 
    cli.cd_categoria_cliente
  order by 
    Venda desc

  -- Total de Cliente
  set @qt_total_categoria_cliente = @@rowcount

  -- Total de Vendas Geral
  set @vl_total_categoria_cliente = 0
  select @vl_total_categoria_cliente = @vl_total_categoria_cliente + Venda
  from
    #VendaClienteAux1

  --Cria a Tabela Final de Vendas por Cliente
  -- Define a posição de Venda do Cliente - IDENTITY
  select 
    IDENTITY(int, 1,1) as 'Posicao',
    a.cd_categoria_cliente,
    cc.nm_categoria_cliente as 'Categoria_Cliente',
    Venda as 'Compra', 
    TotalLiquido,
    TotalLista,
    CustoContabil,
    MargemContribuicao,
    BNS,
    cast(((Venda / @vl_total_categoria_cliente ) * 100) as decimal (25,2)) as 'Perc',
    UltimaVenda as 'UltimaCompra',
    pedidos,
    cast((( TotalLista / Venda ) * 100) - 100 as decimal (15,2)) as 'Desc'
  Into #VendaCliente1
  from 
    #VendaClienteAux1 a
      Left Outer join
    Categoria_Cliente cc
      on a.cd_categoria_cliente = cc.cd_categoria_cliente
  Order by Venda desc

  --Mostra tabela ao usuário
  select * from #VendaCliente1
  order by posicao
end

-----------------------------------------------------------
else if @ic_parametro = 2  -- FATURAMENTO
-----------------------------------------------------------
begin
  -- Geraçao da Tabela Auxiliar de Faturas por Cliente

  declare @qt_total_categoria_produto int,
          @vl_total_categoria_produto float,
  				@ic_devolucao_bi char(1)
  
  set @ic_devolucao_bi = 'N'
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                                     vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(vw.vl_lista_produto) / @vl_moeda 																						      as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
  	vw.cd_cliente
  order by 1 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                                     vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(vw.vl_lista_produto) / @vl_moeda 																						      as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
    vw.cd_cliente
  order by 1 desc
  
  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                                     vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(vw.vl_lista_produto) / @vl_moeda 																						      as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
  group by 
  	vw.cd_cliente
  order by 1 desc
 
  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_cliente,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Venda,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
  	sum(vw.vl_lista_produto) / @vl_moeda 																						      as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto * dbo.fn_vl_moeda(@cd_moeda))) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
    vw.cd_cliente
  order by 1 desc

  select a.cd_cliente,
         a.UltimaVenda, 
         a.Pedidos,
         --Total de Venda
    		 cast(IsNull(a.Venda,0) -
    		 (isnull(b.Venda,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.Venda,0)
  		 			end) + 
  			  isnull(d.Venda,0)) as money) as Venda,
        --Total Líquido
    		cast(IsNull(a.TotalLiquido,0) -
    		 (isnull(b.TotalLiquido,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLiquido,0)
  		 			end) + 
  			  isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
        --Total de Lista
    		cast(IsNull(a.TotalLista,0) -
    		 (isnull(b.TotalLista,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLista,0)
  		 			end) + 
  			  isnull(d.TotalLista,0)) as money) as TotalLista,
  			 --Custo Contábil
    		cast(IsNull(a.CustoContabil,0) -
    		 (isnull(b.CustoContabil,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.CustoContabil,0)
  		 			end) + 
  			  isnull(d.CustoContabil,0)) as money) as CustoContabil,
  			 --Margem de Contribuição
  			cast(IsNull(a.MargemContribuicao,0) -
    		 (isnull(b.MargemContribuicao,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.MargemContribuicao,0)
  		 			end) + 
  			  isnull(d.MargemContribuicao,0)) as money) as MargemContribuicao,
  			 --BNS
    		cast(IsNull(a.BNS,0) -
    		 (isnull(b.BNS,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.BNS,0)
  		 			end) + 
  			  isnull(d.BNS,0)) as money) as BNS,
         a.Vendedor,
  			 --Quantidade
    		cast(IsNull(a.qt_item_nota_saida,0) -
    		    (isnull(b.qt_item_nota_saida,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			   when 'N' then 0
  		 			   else isnull(c.qt_item_nota_saida,0)
  		 			 end) + 
  			    isnull(d.qt_item_nota_saida,0)) as money) as Qtd
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
    	left outer join  
    #FaturaDevolucao b
  	  on a.cd_cliente = b.cd_cliente
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_cliente = c.cd_cliente
      left outer join  
    #FaturaCancelado d
  	  on a.cd_cliente = d.cd_cliente
  
  set @qt_total_categoria_cliente = @@rowcount

  set @vl_total_categoria_cliente = 0
  select @vl_total_categoria_cliente = @vl_total_categoria_cliente + Venda
  from
    #FaturaResultado

  select 
    IDENTITY(int, 1,1) as 'Posicao',
    b.cd_categoria_cliente,      
    b.nm_categoria_cliente as 'Categoria_Cliente', 
    Max(UltimaVenda) as UltimaCompra, --Por motivo de compatibilidade com o programa
    Sum(Pedidos) Pedidos,
    Sum(a.Venda) as Compra, --Por motivo de compatibilidade com o programa
    Sum(a.TotalLiquido) TotalLiquido,
    Sum(a.TotalLista) TotalLista,
    Sum(a.CustoContabil) CustoContabil,
    Sum(a.MargemContribuicao) as MargemContribuicao,
    Sum(a.BNS) as BNS,
    Sum(cast(((Venda / @vl_total_categoria_cliente ) * 100) as decimal (15,2))) as 'Perc',
    Sum((case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
     else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end )) as 'Desc'   
  Into 
    #FaturaResultadoFinal
  from 
    #FaturaResultado a 
      left outer join 
    Cliente c
      on a.cd_cliente = c.cd_cliente
      left outer join
    Categoria_Cliente b 
      on c.cd_categoria_cliente = b.cd_categoria_cliente
  Group by
    b.cd_categoria_cliente,      
    b.nm_categoria_cliente  
  order by Posicao desc
  
  select * from #FaturaResultadoFinal
end

