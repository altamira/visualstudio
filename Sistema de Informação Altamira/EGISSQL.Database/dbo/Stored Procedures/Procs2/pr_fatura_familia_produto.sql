
CREATE  procedure pr_fatura_familia_produto
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution - 2003
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
-----------------------------------------------------------------------------------
--Autor : Daniel C. Neto.
--Desc  : Faturas por Produto
--Data  : 14.08.2000
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
--         22.02.2007 - Valor Total sem IPI - Carlos Fernandes
-- 27.12.2007 - Acerto do Valor Outra Moeda - Carlos Fernandes
-- 10.01.2008 - Acerto das Colunas do Valor do Impostos - Carlos Fernandes
-- 24.03.2008 - Acerto do Cálculo da Valor Líquido que estão calculando PIS/CONFINS para todas as CFOP's 
--              indenpendente do flag do cadastro da CFOP - Carlos Fernandes
-- 06.08.2008 - Ajuste de item de Nota Cancelada - Carlos Fernandes
-- 12.04.2010 - Ajuste para Conversão pelo Dolar - Carlos Fernandes
-- 11.05.2010 - Devolução - Carlos Fernandes
-- 10.06.2010 - Família de Produto - Carlos Fernandes
-----------------------------------------------------------------------------------

@dt_inicial      datetime,
@dt_final        datetime,
@cd_moeda        int = 1,
@cd_tipo_mercado int = 0 

as

--select * from parametro_bi

--Geração do Cálculo do PIS/COFINS

exec pr_gera_calculo_pis_cofins_item_nota @dt_inicial,@dt_final

--Consulta

  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)


  declare @qt_total_produto        int,
          @vl_total_produto        float,
          @ic_devolucao_bi         char(1),
          @ic_tipo_conversao_moeda char(1)

  declare @vl_moeda float

  set @vl_moeda = 1

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 
                    then 1.00
                    else dbo.fn_vl_moeda(@cd_moeda)
                    end )

  
  set @ic_devolucao_bi = 'N'


  --Parâmetro do BI
  
  Select 
    top 1 @ic_devolucao_bi          = IsNull(ic_devolucao_bi,'N'),
          @ic_tipo_conversao_moeda  = isNull(ic_tipo_conversao_moeda,'U')
  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()
  
  Select 
    fp.nm_familia_produto                  as nm_familia_produto,

    max(vw.dt_nota_saida)                                        as UltimaVenda,
    sum( vw.vl_unitario_item_total 
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                         as Venda,
--    sum(case when vw.vl_unitario_item_total>0 then vw.vl_unitario_item_total else vw.vl_total end ) / @vl_moeda 	         as Venda,

    sum( (vw.vl_unitario_item_total-vw.vl_ipi)
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                          as VendaSemIPI,

    count(distinct(vw.cd_nota_saida))                             as Pedidos,
    
    cast( sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                                          vw.vl_ipi, vw.cd_destinacao_produto,@dt_inicial)

    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end
    ) as money)                                                   as TotalLiquido,


    sum( vw.vl_unitario_item_liquido 
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                          as TotalLiquidoSoma,

    sum(p.vl_produto * vw.qt_item_nota_saida
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                          as TotalLista,

    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004

    cast(  sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end
      )
      as money)                                                                as CustoContabil,

    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100

    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end
        )
        as money)                          as MargemContribuicao,

    cast(sum( (vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))
         /
         case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
           vw.vl_moeda_cotacao
         else
           @vl_moeda
         end
         ) as money) * dbo.fn_pc_bns() as BNS,

    max(vw.cd_vendedor)                                 as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)           as qt_item_nota_saida,

    sum ( vw.vl_pis
        /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                as vl_pis,
    sum ( vw.vl_cofins
        /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                               as vl_cofins,
    sum ( vw.vl_icms_item
        /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end )                                              as vl_icms,
 
    sum ( vw.vl_ipi
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                               as vl_ipi


  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
    left outer join Produto_Custo pc   on vw.cd_produto       = pc.cd_produto 
    left Outer Join Produto p          on vw.cd_produto       = p.cd_produto
    left outer join Grupo_Produto gp   on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Marca_Produto mp   on mp.cd_marca_produto = p.cd_marca_produto
    left outer join Familia_Produto fp on fp.cd_familia_produto = p.cd_familia_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and 
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end        
  group by 
     fp.nm_familia_produto             

  order by 1 desc


  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------

  select 

    fp.nm_familia_produto                  as nm_familia_produto,

  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda	         as Venda,
    sum(vw.vl_unitario_item_total-vw.vl_ipi) / @vl_moeda as VendaSemIPI,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda as TotalLiquido,
    sum( vw.vl_unitario_item_liquido )/ @vl_moeda                                    as TotalLiquidoSoma,

  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money)/ @vl_moeda as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money)/ @vl_moeda as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
              / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor)                                 as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)           as qt_item_nota_saida,
    sum ( vw.vl_pis )       / @vl_moeda as vl_pis,
    sum ( vw.vl_cofins)     / @vl_moeda as vl_cofins,
    sum ( vw.vl_icms_item ) / @vl_moeda as vl_icms,
    sum ( vw.vl_ipi )       / @vl_moeda as vl_ipi


  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
    left Outer Join Produto p        on vw.cd_produto = p.cd_produto
    left outer join Grupo_Produto gp   on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Marca_Produto mp   on mp.cd_marca_produto = p.cd_marca_produto
    left outer join Familia_Produto fp on fp.cd_familia_produto = p.cd_familia_produto

  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and 
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end        
  group by 
    fp.nm_familia_produto         

  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    fp.nm_familia_produto                  as nm_familia_produto,
    max(vw.dt_nota_saida)     																																							as UltimaVenda,
    sum(vw.vl_unitario_item_total) / @vl_moeda	         as Venda,
    sum(vw.vl_unitario_item_total-vw.vl_ipi) / @vl_moeda as VendaSemIPI,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda as TotalLiquido,
    sum( vw.vl_unitario_item_liquido ) / @vl_moeda                                   as TotalLiquidoSoma,

    sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money)/ @vl_moeda as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money)/ @vl_moeda as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
              / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    sum ( vw.vl_pis )       / @vl_moeda as vl_pis,
    sum ( vw.vl_cofins)     / @vl_moeda as vl_cofins,
    sum ( vw.vl_icms_item ) / @vl_moeda as vl_icms,
    sum ( vw.vl_ipi )       / @vl_moeda as vl_ipi


  into 
    #FaturaDevolucaoAnoAnterior

  from
    vw_faturamento_devolucao_mes_anterior_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
    left Outer Join    Produto p     on vw.cd_produto = p.cd_produto
    left outer join Grupo_Produto gp   on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Marca_Produto mp   on mp.cd_marca_produto = p.cd_marca_produto
    left outer join Familia_Produto fp on fp.cd_familia_produto = p.cd_familia_produto

  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
    vw.dt_nota_saida < @dt_inicio_periodo and

   --(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      

  group by 
    fp.nm_familia_produto       

  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------

  select 
    fp.nm_familia_produto                  as nm_familia_produto,
  	max(vw.dt_nota_saida)     																																							as UltimaVenda,
--    sum(vw.vl_unitario_item_total) / @vl_moeda	         as Venda,
    sum(case when isnull(vw.vl_unitario_item_atual,0)>0 then vw.vl_unitario_item_atual else vw.vl_total end) / @vl_moeda	         as Venda,
    sum(vw.vl_unitario_item_total-vw.vl_ipi) / @vl_moeda as VendaSemIPI,
    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    -- ELIAS 23/04/2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda as TotalLiquido,
    sum( vw.vl_unitario_item_liquido ) / @vl_moeda                                   as TotalLiquidoSoma,

  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista,
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')
              / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,
    max(vw.cd_vendedor)                                 as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)           as qt_item_nota_saida,
    sum ( vw.vl_pis )       / @vl_moeda as vl_pis,
    sum ( vw.vl_cofins)     / @vl_moeda as vl_cofins,
    sum ( vw.vl_icms_item ) / @vl_moeda as vl_icms,
    sum ( vw.vl_ipi )       / @vl_moeda as vl_ipi


  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
    left Outer Join Produto p        on vw.cd_produto = p.cd_produto
    left outer join Grupo_Produto gp   on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Marca_Produto mp   on mp.cd_marca_produto = p.cd_marca_produto
    left outer join Familia_Produto fp on fp.cd_familia_produto = p.cd_familia_produto

  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
	vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end    
  group by 
    fp.nm_familia_produto              

  order by 1 desc

  select 
         a.nm_familia_produto,
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

         --Total de Venda sem IPI
    		 cast(IsNull(a.VendasemIPI,0) -
    		 (isnull(b.VendasemIPI,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.VendasemIPI,0)
  		 			end) + 
  			  isnull(d.VendasemIPI,0)) as money) as VendasemIPI,

        --Total Líquido
    		cast(IsNull(a.TotalLiquido,0) -
    		 (isnull(b.TotalLiquido,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLiquido,0)
  		 			end) + 
  			  isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
        --Total Líquido Soma
    		cast(IsNull(a.TotalLiquidoSoma,0) -
    		 (isnull(b.TotalLiquidoSoma,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLiquidoSoma,0)
  		 			end) + 
  			  isnull(d.TotalLiquidoSoma,0)) as money) as TotalLiquidoSoma,

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
  			    isnull(d.qt_item_nota_saida,0)) as money) as Qtd,
         --pis
    		cast(IsNull(a.vl_pis,0) -
    		 (isnull(b.vl_pis,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.vl_pis,0)
  		 			end) + 
  			  isnull(d.vl_pis,0)) as money) as vl_pis,
         --cofins
    		cast(IsNull(a.vl_cofins,0) -
    		 (isnull(b.vl_cofins,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.vl_cofins,0)
  		 			end) + 
  			  isnull(d.vl_cofins,0)) as money) as vl_cofins,

         --icms
    		cast(IsNull(a.vl_icms,0) -
    		 (isnull(b.vl_icms,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.vl_icms,0)
  		 			end) + 
  			  isnull(d.vl_icms,0)) as money) as vl_icms,

         --ipi
    		cast(IsNull(a.vl_ipi,0) -
    		 (isnull(b.vl_ipi,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.vl_ipi,0)
  		 			end) + 
  			  isnull(d.vl_ipi,0)) as money) as vl_ipi


  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
  	left outer join  #FaturaDevolucao b
  	on a.nm_familia_produto = b.nm_familia_produto
    left outer join  #FaturaDevolucaoAnoAnterior c
  	on a.nm_familia_produto = c.nm_familia_produto
    left outer join  #FaturaCancelado d
  	on a.nm_familia_produto = d.nm_familia_produto
  
  -- Total de produtoes
  set @qt_total_produto = @@rowcount
  
  -- Total de Vendas Geral dos Setores
  set @vl_total_produto = 0

  Select 
    @vl_total_produto = @vl_total_produto + venda
  from
    #FaturaResultado
    

  --Cria a Tabela Final de Vendas por Setor  
  select IDENTITY(int, 1,1) AS 'Posicao',  
         a.nm_familia_produto,
         a.qtd,  
         a.venda,   
         a.vendasemipi,
         (a.venda/@vl_total_produto)*100 as 'Perc',   
         a.UltimaVenda,   
         a.pedidos,  
--         a.TotalLiquido,  
         a.TotalLiquidoSoma as TotalLiquido,
         a.TotalLista,  
         a.CustoContabil,  
         a.MargemContribuicao,  
         a.BNS,
        (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
         else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc',
         a.vl_pis,
         a.vl_cofins, 
         a.vl_icms,
         a.vl_ipi
 
  Into 
    #FaturaCategoriaAux
  from 
    #FaturaResultado a  
  Order by 
    a.venda desc  
   
  --Mostra tabela ao usuário  
  select
     distinct
         a.*
  from   
    #FaturaCategoriaAux a
  order by posicao  

