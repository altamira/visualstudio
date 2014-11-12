
CREATE  procedure pr_fatura_servico
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution - 2004
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Faturas por Serviço
--Data       : 19/03/2004
-----------------------------------------------------------------------------------
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as

  declare @ic_devolucao_bi char(1)
  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )

  
  select @ic_devolucao_bi = IsNull(ic_devolucao_bi, 'N') 
  from Parametro_BI 
  where cd_empresa = dbo.fn_empresa()
  
  -- Geraçao da tabela auxiliar de Faturas por servico
  select   
    a.cd_servico           as 'servico',   
    sum(a.qt_item_nota_saida)          as 'qtd',  
    sum(a.qt_item_nota_saida * a.vl_unitario_item_nota / @vl_moeda) as 'venda',   
    
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida*  
                                         (a.vl_unitario_item_nota / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiquido',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida*  
                                         (c.vl_lista_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiSta',  
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) as 'CustoContabil',  
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda))  /  
  --       sum((b.qt_item_nota_saida* b.vl_unitario_item_nota / @vl_moeda))  
  -- as decimal(25,2)) * 100 as 'MargemContribuicao',  
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) * dbo.fn_pc_bns() as 'BNS',  
   
    max(a.dt_nota_saida)                 as 'UltimaVenda',   
    count(distinct a.cd_pedido_venda)    as 'Pedidos'  
    
  into #FaturaCategoria  
  from  
    vw_faturamento_bi a 
      left outer join  
    Pedido_Venda d 
      on d.cd_pedido_venda = a.cd_pedido_venda 
      left outer join  
    Pedido_Venda_Item c 
      on c.cd_pedido_venda = d.cd_pedido_venda and 
         a.cd_item_pedido_venda = c.cd_item_pedido_venda     
  where  
    (a.dt_nota_saida between @dt_inicial and @dt_final) and  
     isnull(d.ic_consignacao_pedido,'N') <> 'S' and
     IsNull(a.cd_servico,0) > 0
  Group by a.cd_servico     
  Order by 2 desc  
  
  ---------------------------------------------------
  -- Devoluções do Mês Corrente  
  ---------------------------------------------------
  
  select   
    a.cd_servico           as 'servico',   
    sum(a.qt_item_nota_saida)          as 'qtd',  
    sum(a.qt_item_nota_saida * a.vl_unitario_item_nota/ @vl_moeda) as 'venda',   
    cast(sum(dbo.fn_vl_liquido_venda('V',  
                                         (a.qt_item_nota_saida*  
                                         (a.vl_unitario_item_nota / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiquido',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida*  
                                         (c.vl_lista_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiSta'
  --  cast(sum((a.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) as 'CustoContabil',  
  --  cast(sum((a.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda))  /  
  --       sum((b.qt_item_nota_saida* b.vl_unitario_item_nota / @vl_moeda))  
  -- as decimal(25,2)) * 100 as 'MargemContribuicao',  
   
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) * dbo.fn_pc_bns() as 'BNS'  
    
  into #FaturaCategoriaDev  
  from  
     vw_faturamento_devolucao_bi a left outer join   
     Pedido_Venda d on d.cd_pedido_venda = a.cd_pedido_venda left outer join  
     Pedido_Venda_Item c on c.cd_pedido_venda = a.cd_pedido_venda and c.cd_item_pedido_venda = a.cd_item_pedido_venda 
  where  
    (a.dt_nota_saida between @dt_inicial and @dt_final)  and  
    isnull(d.ic_consignacao_pedido,'N') <> 'S' and
    IsNull(a.cd_servico,0) > 0 
    
  Group by a.cd_servico  
  Order by 2 desc  

  ---------------------------------------------------
  -- Devoluções do Mês Anterior
  ---------------------------------------------------
  
  select   
    a.cd_servico           as 'servico',   
    sum(a.qt_item_nota_saida)          as 'qtd',  
    sum(a.qt_item_nota_saida * a.vl_unitario_item_nota/ @vl_moeda) as 'venda',   
    
    cast(sum(dbo.fn_vl_liquido_venda('V',  
                                         (a.qt_item_nota_saida*  
                                         (a.vl_unitario_item_nota / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiquido',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida*  
                                         (c.vl_lista_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiSta'
  --  cast(sum((a.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) as 'CustoContabil',  
  --  cast(sum((a.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda))  /  
  --       sum((b.qt_item_nota_saida* b.vl_unitario_item_nota / @vl_moeda))  
  -- as decimal(25,2)) * 100 as 'MargemContribuicao',  
   
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) * dbo.fn_pc_bns() as 'BNS'  
    
  into #FaturaCategoriaDevAnt
  from  
     vw_faturamento_devolucao_mes_anterior_bi a left outer join   
     Pedido_Venda d on d.cd_pedido_venda = a.cd_pedido_venda left outer join  
     Pedido_Venda_Item c on c.cd_pedido_venda = a.cd_pedido_venda and c.cd_item_pedido_venda = a.cd_item_pedido_venda 
  where 
    year(a.dt_nota_saida) = year(@dt_inicial) and
  	(a.dt_nota_saida < @dt_inicial) and
  	(a.dt_restricao_item_nota between @dt_inicial and @dt_final ) and 
    IsNull(a.cd_servico,0) > 0 and
    @ic_devolucao_bi = 'S'
    
  Group by a.cd_servico  
  Order by 2 desc  
  
  ----------------------------------------------------  
  -- Cancelamento do Mês Corrente  
  ----------------------------------------------------  
  select   
    a.cd_servico           as 'servico',   
    sum(a.qt_item_nota_saida)          as 'qtd',  
    sum( a.qt_item_nota_saida * a.vl_unitario_item_total / @vl_moeda ) as 'venda',   
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida * a.vl_unitario_item_total *dbo.fn_vl_moeda(@cd_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiquido',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_nota_saida*  
                                         (pvi.vl_lista_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(38,2)) as 'TotalLiSta' 
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(38,2)) as 'CustoContabil',  
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda))  /  
  --       sum((b.qt_item_nota_saida* b.vl_unitario_item_nota / @vl_moeda))  
  -- as decimal(38,2)) * 100 as 'MargemContribuicao',  
  --  cast(sum((b.qt_item_nota_saida* ps.vl_custo_contabil_servico / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS'  
    
  into   
    #FaturaMensalCancel  
  from  
    vw_faturamento_cancelado_bi a left outer join
    Pedido_Venda pv on pv.cd_pedido_venda = a.cd_pedido_venda left outer join  
    Pedido_Venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda and a.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  WHERE  
    (a.dt_nota_saida between @dt_inicial and @dt_final) and  
    isnull(pv.ic_consignacao_pedido,'N') <> 'S' and
    IsNull(a.cd_servico,0) > 0
  Group by a.cd_servico  
  Order by 2 desc  
  
  
  select a.servico,  
         a.UltimaVenda,   
         a.Pedidos,  
         qtd   = (IsNull(a.qtd,0) - ( IsNull(b.qtd,0) + IsNull(c.qtd,0) + IsNull(d.qtd,0))),  
         venda = (isnull(a.venda,0) - ( isnull(b.venda,0) + isnull(c.venda,0) + IsNull(d.venda,0))),  
         TotalLiquido = (IsNull(a.TotalLiquido,0) - ( IsNull(b.TotalLiquido,0) + IsNull(c.TotalLiquido,0) + IsNull(d.TotalLiquido,0))),  
         TotalLista = (IsNull(a.TotalLiSta,0) - (IsNull(b.TotalLiSta,0) + IsNull(c.TotalLiSta,0) + IsNull(d.TotalLista,0)))  
  --       CustoContabil = ( IsNull(a.CustoContabil,0)- ( IsNull(b.CustoContabil,0) + IsNull(c.CustoContabil,0))),  
  --       MargemContribuicao = ( IsNull(a.MargemContribuicao,0) - ( IsNull(b.MargemContribuicao,0) + IsNull(c.MargemContribuicao,0))),  
  --       BNS = IsNull(a.BNS,0) - ( IsNull(b.BNS,0) + IsNull(c.BNS,0))  
     
  into #FaturaCategoria1  
  from #FaturaCategoria    a left outer join
       #FaturaCategoriaDev b on b.servico = a.servico  left outer join
       #FaturaMensalCancel c on a.servico = c.servico left outer join
       #FaturaCategoriaDevAnt d on d.servico = a.servico and @ic_devolucao_bi = 'S'
   
  declare @qt_total_categ int  
  declare @vl_total_categ float  
    
  -- Total de servicos  
  set @qt_total_categ = @@rowcount  
  -- Total de Vendas Geral por servico  
  set @vl_total_categ     = 0  
  select @vl_total_categ = @vl_total_categ + venda  
  from  
    #FaturaCategoria1  
  --Cria a Tabela Final de Vendas por Setor  
  select IDENTITY(int, 1,1) AS 'Posicao',  
         a.servico,  
         a.qtd,  
         a.venda,   
        (a.venda/@vl_total_categ)*100 as 'Perc',   
         a.UltimaVenda,   
         a.pedidos,  
         a.TotalLiquido,  
         a.TotalLista,  
  --       a.CustoContabil,  
  --       a.MargemContribuicao,  
  --       a.BNS,
        (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
         else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc'
   
    
  Into #FaturaCategoriaAux  
  from #FaturaCategoria1 a  
  Order by a.venda desc  
    
  --Mostra tabela ao usuário  
  select b.nm_servico,  
         b.cd_mascara_servico,  
  --       b.nm_servico,  
  --       un.sg_unidade_medida,  
         a.*   
  from   
    #FaturaCategoriaAux a, servico b --left outer join   
  --  Unidade_Medida un on un.cd_unidade_medida = b.cd_unidade_medida  
  Where  
     a.servico = b.cd_servico  
  order by posicao  

