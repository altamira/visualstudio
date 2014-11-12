
CREATE PROCEDURE pr_fatura_segmento_mercado  
  
------------------------------------------------------------------------------------------------------  
--pr_fatura_segmento_mercado  
------------------------------------------------------------------------------------------------------  
--GBS - Global Business Solution        2002  
--Stored Procedure: Microsoft SQL Server       2000  
--Autor(es)       : Márcio Rodrigues Adão
--Banco de Dados  : EgisSQL  
--Objetivo        : Consulta Faturamento no Período por Segmento de Mercado.  
--Data            : 07/03/2006
--Atualizado      : 11.05.2010 - Devolução - Carlos Fernandes
--                               Falta deduzir as devoluções 
------------------------------------------------------------------------------------------------------------  
  
@cd_ramo_atividade int = 0,  
@dt_inicial        datetime,  
@dt_final          datetime,  
@cd_moeda          int = 1,
@cd_tipo_mercado   int = 0
    
as  
  

  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)

declare @vl_moeda float  
declare @ic_devolucao_bi char(1)
  
set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                  else dbo.fn_vl_moeda(@cd_moeda) end )  
  

  set @ic_devolucao_bi = 'N'

  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()


  Select 
--  	vw.cd_cliente,
     isnull(cli.cd_ramo_atividade,0)              as 'ramo',   

  	max(vw.dt_nota_saida)                     as UltimaVenda,
    count(distinct(vw.cd_nota_saida))             as Pedidos,
  	sum(vw.vl_unitario_item_total) / @vl_moeda as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial))    as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')
         / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente)        as QtdCliente,
    sum(vw.qt_item_nota_saida)           as qt_item_nota_saida,
    count(distinct vw.cd_vendedor)       as QtdVendedor

  into 
    #FaturaAnual

  from
    vw_faturamento_bi vw
    left outer join Produto_Custo pc  on vw.cd_produto = pc.cd_produto 
    left outer join Produto p         on vw.cd_produto = p.cd_produto
    left outer join cliente cli       on vw.cd_cliente = cli.cd_cliente

  where 
    vw.dt_nota_saida between @dt_inicial and @dt_final and
    vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end
    and (cli.cd_ramo_atividade  = 
			case when @cd_ramo_atividade = 0 then 
				   	cli.cd_ramo_atividade 
				  else 
						@cd_ramo_atividade 
				  end )       
  group by 
  	cli.cd_ramo_atividade

  order by 1 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
--  	vw.cd_cliente,
    isnull(cli.cd_ramo_atividade,0)              as 'ramo',   
    max(vw.dt_nota_saida)                        as UltimaVenda,
    count(distinct(vw.cd_nota_saida))            as Pedidos,
  	sum(vw.vl_unitario_item_total) / @vl_moeda as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente)        as QtdCliente,
    sum(vw.qt_item_nota_saida)           as qt_item_nota_saida,
    count(distinct vw.cd_vendedor)       as QtdVendedor

  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
    left outer join Produto p        on vw.cd_produto = p.cd_produto
    left outer join cliente cli      on vw.cd_cliente = cli.cd_cliente

  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final and
        vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end
    and (cli.cd_ramo_atividade  = 
			case when @cd_ramo_atividade = 0 then 
				   	cli.cd_ramo_atividade 
				  else 
						@cd_ramo_atividade 
				  end )     

  group by 
    cli.cd_ramo_atividade

  order by 1 desc
  
  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	--vw.cd_cliente,
    isnull(cli.cd_ramo_atividade,0)                as 'ramo',   
    max(vw.dt_nota_saida)                          as UltimaVenda,
    count(distinct(vw.cd_nota_saida))              as Pedidos,
  	sum(vw.vl_unitario_item_total) / @vl_moeda as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda as TotalLista,
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))
      as money) as CustoContabil,
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    -- Cálculo da Margem de contribuição
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100
    Cast(
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / 
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)
        ) as money) as MargemContribuicao,
  	sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')
         / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente)        as QtdCliente,
    sum(vw.qt_item_nota_saida)           as qt_item_nota_saida,
    count(distinct vw.cd_vendedor)       as QtdVendedor

  into 
    #FaturaDevolucaoAnoAnterior

  from
    vw_faturamento_devolucao_mes_anterior_bi vw
    left outer join Produto_Custo pc  on vw.cd_produto  = pc.cd_produto 
    left outer join Produto p         on vw.cd_produto  = p.cd_produto
    left outer join cliente cli       on cli.cd_cliente = vw.cd_cliente
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
--  	(vw.dt_nota_saida < @dt_inicial) and
   vw.dt_nota_saida < @dt_inicio_periodo and

  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
    vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end

    and (cli.cd_ramo_atividade  = 
			case when @cd_ramo_atividade = 0 then 
				   	cli.cd_ramo_atividade 
				  else 
						@cd_ramo_atividade 
				  end )     
  group by 
  	cli.cd_ramo_atividade 
  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
     isnull(cli.cd_ramo_atividade,0)              as 'ramo',   
  	max(vw.dt_nota_saida)                      as UltimaVenda,
    count(distinct(vw.cd_nota_saida))              as Pedidos,
  	sum(vw.vl_unitario_item_atual) / @vl_moeda as Venda,
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda as TotalLista,
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
  	sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')
         / @vl_moeda)) * dbo.fn_pc_bns() as BNS,
    count(distinct vw.cd_cliente)        as QtdCliente,
    sum(vw.qt_item_nota_saida)           as qt_item_nota_saida,
    count(distinct vw.cd_vendedor)       as QtdVendedor

  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado_bi vw
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto 
    left outer join Produto p        on vw.cd_produto = p.cd_produto
    left outer join cliente cli      on cli.cd_cliente = vw.cd_cliente
  where 
    vw.dt_nota_saida between @dt_inicial and @dt_final and
    vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end
    and (cli.cd_ramo_atividade  = 
			case when @cd_ramo_atividade = 0 then 
				   	cli.cd_ramo_atividade 
				  else 
						@cd_ramo_atividade 
				  end )     
 
  group by 
    cli.cd_ramo_atividade 
  order by 1 desc

  select 
    a.ramo,
    a.UltimaVenda, 
    a.Pedidos,
    --Total Venda
    cast(IsNull(a.Venda,0) -
      (isnull(b.Venda,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    			when 'N' then 0
    			else isnull(c.Venda,0)
    			end) + 
      isnull(d.Venda,0)) as money) as Venda,
    --Total de Liquido
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
    a.QtdCliente,
    --Quantidade
    cast(IsNull(a.qt_item_nota_saida,0) -
      (isnull(b.qt_item_nota_saida,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    			   when 'N' then 0
    			   else isnull(c.qt_item_nota_saida,0)
    			 end) + 
      isnull(d.qt_item_nota_saida,0)) as money) as Qtd,
    a.QtdVendedor

  into 
    #FaturaResultado

  from 
    #FaturaAnual a
    left outer join  #FaturaDevolucao b            on a.ramo = b.ramo
    left outer join  #FaturaDevolucaoAnoAnterior c on a.ramo = c.ramo
    left outer join  #FaturaCancelado d            on a.ramo = d.ramo
 

-- Geração da tabela auxiliar de Vendas por Segmento  
  
-- select   
--         isnull(cli.cd_ramo_atividade,0)              as 'ramo',   
--         sum(b.qt_item_nota_saida )                   as 'Qtd',  
-- --        sum(b.qt_item_nota_saida  *   
-- --            b.vl_unitario_item_nota / @vl_moeda)     as 'Venda',   
-- 
--     sum(case when isnull(b.cd_item_nota_saida,0)>0 then
--       cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
--       then
--         cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
--     		(IsNull(b.qt_item_nota_saida,0))),2)
--         --Adiciona o IPI
--     		+ isnull(b.vl_ipi,0) as money) 
--       else
--         round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
--         (case IsNull(b.ic_iss_servico, 'N') 
--           when 'S' then
--             isnull(a.vl_iss,0)
--           else
--             0.00
--           end)
--        end) +  --Rateio das despesas - Frete/Seguro/Outras
--        IsNull(b.vl_frete_item,0.00) + 
--        IsNull(b.vl_seguro_item,0.00) + 
--        IsNull(b.vl_desp_acess_item,0.00) as money)
--     else
--        isnull(a.vl_total,0)
--     end)                                             as 'Venda',
-- 
-- 
--         max(a.dt_nota_saida)                         as 'UltimaVenda',  
--         count(a.cd_nota_saida)                       as 'pedidos',
--         count(distinct a.cd_cliente)                 as 'QtdCliente',
--         count(distinct a.cd_vendedor)                as 'QtdVendedor'  
-- 
-- into #FaturaGrupoAux  
-- from  
--    Nota_Saida a                        with (nolock)  
--    inner join Nota_Saida_Item b        with (nolock) on a.cd_nota_saida = b.cd_nota_saida   
--    inner join Cliente cli              with (nolock) on cli.cd_cliente    = a.cd_cliente  
--    left outer join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = b.cd_operacao_fiscal
--    left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
-- 
-- where  
--    (cli.cd_ramo_atividade  = 
-- 			case when @cd_ramo_atividade = 0 then 
-- 				   	cli.cd_ramo_atividade 
-- 				  else 
-- 						@cd_ramo_atividade 
-- 				  end )     and  
--    (a.dt_nota_saida between @dt_inicial and @dt_final )     and  
--     isnull(a.vl_total,0) > 0                     and  
--    (b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda ) > 0         and  
--    (isnull(b.dt_cancel_item_nota_saida,@dt_final+1) > @dt_final)     
-- 
--     and ( opf.ic_comercial_operacao = 'S' )           --Considerar apenas as operações fiscais de valor comercial
--     and ( opf.ic_analise_op_fiscal  = 'S' )           --Verifica apenas as operações fiscais selecionadas para o BI
--     and ( gof.cd_tipo_operacao_fiscal = 2 )           --Desconsiderar notas de entrada
-- 
-- Group by   
--   cli.cd_ramo_atividade  
-- 
-- order  by 1 desc  
  
--select * from #VendaGrupoAux  
  
-------------------------------------------------  
-- calculando Potencial.  
-------------------------------------------------  

select   
        isnull(cli.cd_ramo_atividade,0)                                     as cd_ramo_atividade,   
--        sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda )    as 'Potencial'  

    sum(case when isnull(b.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
      then
        cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
    		(IsNull(b.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(b.vl_ipi,0) as money) 
      else
        round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
        (case IsNull(b.ic_iss_servico, 'N') 
          when 'S' then
            isnull(a.vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(b.vl_frete_item,0.00) + 
       IsNull(b.vl_seguro_item,0.00) + 
       IsNull(b.vl_desp_acess_item,0.00) as money)
    else
       isnull(a.vl_total,0)
    end)                                           as 'Potencial'

  
into #Potencial  
from  
   Nota_Saida a                              with (nolock)  
   inner join Nota_Saida_Item b              with (nolock) on a.cd_nota_saida              = b.cd_nota_saida   
   inner join Cliente cli                    with (nolock) on cli.cd_cliente               = a.cd_cliente  
   left outer join Operacao_Fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = b.cd_operacao_fiscal
   left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal

where  
    a.dt_nota_saida < @dt_final-365                         and  
    isnull(a.vl_total,0) > 0                     and  
   (b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda ) > 0         and  
   (isnull(b.dt_cancel_item_nota_saida,@dt_final+1) > @dt_final)                       
    and ( opf.ic_comercial_operacao = 'S' )           --Considerar apenas as operações fiscais de valor comercial
    and ( opf.ic_analise_op_fiscal  = 'S' )           --Verifica apenas as operações fiscais selecionadas para o BI
    and ( gof.cd_tipo_operacao_fiscal = 2 )           --Desconsiderar notas de entrada
  
Group by cli.cd_ramo_atividade  
order  by 1 desc  
  
----------------------------------  
-- Fim da seleção de vendas totais  
----------------------------------  
  
declare @qt_total_grupo int  
declare @vl_total_grupo float  
  
-- Total de Grupos  
set @qt_total_grupo = @@rowcount  
  
-- Total de Vendas Geral por Grupo  
set    @vl_total_grupo = 0  
  
select @vl_total_grupo = @vl_total_grupo + venda  
from  
  #FaturaResultado
  
--Cria a Tabela Final de Vendas por Grupo  
  
  
select IDENTITY(int,1,1)                                   as 'Posicao',  
       a.ramo                                              as cd_ramo_atividade,  
       --isnull(b.nm_ramo_atividade,'Não Cadastrado :' )+' '+cast(a.ramo as varchar(4)) as nm_ramo_atividade,  
       isnull(b.nm_ramo_atividade, 'Sem ramo de Atividade') as nm_ramo_atividade,
       a.venda,   
       cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc',  
       c.Potencial                                          as 'Potencial',
       a.pedidos,
       a.qtdCliente,
       a.qtdVendedor       
  
Into   
  #FaturaGrupo  

from   
  #FaturaResultado a  
   left outer join Ramo_Atividade b on b.cd_ramo_atividade = a.ramo  
   left outer join #Potencial     c on c.cd_ramo_atividade = a.ramo  

--Where  
   --a.ramo = b.cd_ramo_atividade   
  
order by a.Venda desc  
  
select * from #FaturaGrupo    
order by Posicao

