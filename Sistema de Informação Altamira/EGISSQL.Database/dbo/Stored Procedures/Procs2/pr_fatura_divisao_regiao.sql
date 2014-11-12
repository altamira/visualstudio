
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_fatura_divisao_regiao
@dt_inicial          datetime,    
@dt_final            datetime,    
@cd_divisao_regiao   int,    
@cd_moeda            int = 1,    
@cd_tipo_mercado     int = 0    
as  
  
  declare @qt_total_vendedor int,  
          @vl_total_vendedor float,  
      @ic_devolucao_bi char(1)  
  
  declare @vl_moeda float  
  
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                    else dbo.fn_vl_moeda(@cd_moeda) end )  
  
  
  
  set @ic_devolucao_bi = 'N'  
    
  --Define se a empresa trabalha com devoluções do mês anterior  
  Select   
   top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')  
  from   
   Parametro_BI  
  where  
   cd_empresa = dbo.fn_empresa()  

select DR.cd_divisao_regiao as cd_divisao_regiao,    
      dr.sg_divisao_regiao,
       count(distinct(c.cd_cliente))  as qtd    
into     
  #Resumo_Divisao    
from    
  cliente c   
  left outer join status_cliente   sc on sc.cd_status_cliente = c.cd_status_cliente --and  
  left outer join Cliente_Endereco Ce on ce.cd_cliente = c.cd_cliente
  left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  left outer join Divisao_Regiao   DR on DR.cd_divisao_regiao = Cep.cd_divisao_regiao
where  
  isnull(sc.ic_analise_status_cliente,'N')='S' and
  IsNull(DR.cd_divisao_regiao,0) = (case when (@cd_divisao_regiao=0) then IsNull(DR.cd_divisao_regiao,0) else @cd_divisao_regiao end)                                    
group by dr.cd_divisao_regiao, dr.sg_divisao_regiao
  
  
  Select   
   IsNull(Cep.cd_divisao_regiao,0) as cd_divisao_regiao,  
   max(vw.dt_nota_saida)                                            as UltimaCompra,  
    sum(vw.vl_unitario_item_total) / isnull(@vl_moeda,1)             as Compra,  
    count(distinct(vw.cd_nota_saida))                                                 as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
      vw.cd_destinacao_produto, @dt_inicial)) as money)     as TotalLiquido,  
   sum(vw.vl_unitario_item_total) / isnull(@vl_moeda,1)       as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))  
      as money) as CustoContabil,  
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,  
    -- Cálculo da Margem de contribuição  
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100  
    Cast(  
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -  
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) / isnull(  
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100) ,1) 
        ) as money) as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')  
         / isnull(@vl_moeda,1))) as money) * dbo.fn_pc_bns() as BNS,  
    max(Cep.cd_divisao_regiao) as Divisao, 
    count ( distinct vw.cd_cliente  )                              as 'Atendimento'     
   
  into   
    #FaturaAnual  
  from  
    vw_faturamento_bi vw  
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto   
    left outer join Cliente_Endereco Ce on ce.cd_cliente = vw.cd_cliente
    left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
   vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      
  group by   
   IsNull(Cep.cd_divisao_regiao,0)  
  order by 1 desc  
    
    
  ----------------------------------------------------  
  -- Devoluções do Mês Corrente  
  ----------------------------------------------------  
  select   
   IsNull(Cep.cd_divisao_regiao,0) as cd_divisao_regiao,  
   max(vw.dt_nota_saida)                                            as UltimaCompra,  
    sum(vw.vl_unitario_item_total) / isnull(@vl_moeda,1)                        as Compra,  
    count(distinct(vw.cd_nota_saida))                                                 as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
      vw.cd_destinacao_produto, @dt_inicial)) as money)                                                           as TotalLiquido,  
   sum(vw.vl_unitario_item_total) / isnull(@vl_moeda,1)                        as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))  
      as money) as CustoContabil,  
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,  
    -- Cálculo da Margem de contribuição  
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100  
    Cast(  
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -  
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) / isnull(  
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100) ,1) 
        ) as money) as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')  
         / isnull(@vl_moeda,1))) as money) * dbo.fn_pc_bns() as BNS,  
    max(Cep.cd_divisao_regiao) as Divisao 
     
  into   
    #FaturaDevolucao  
  from  
    vw_faturamento_devolucao_bi vw  
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto   
    left outer join Cliente_Endereco Ce on ce.cd_cliente = vw.cd_cliente
    left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
 vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      
  group by  
   IsNull(Cep.cd_divisao_regiao,0)  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Total de Devoluções do Ano Anterior  
  ----------------------------------------------------  
  select   
   IsNull(Cep.cd_divisao_regiao,0) as cd_divisao_regiao,  
   max(vw.dt_nota_saida)                                            as UltimaCompra,  
    sum(vw.vl_unitario_item_total) / @vl_moeda                       as Compra,  
    count(distinct(vw.cd_nota_saida))                                                 as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
      vw.cd_destinacao_produto, @dt_inicial)) as money)                                                           as TotalLiquido,  
   sum(vw.vl_unitario_item_total) / @vl_moeda                       as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
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
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')  
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,  
    max(Cep.cd_divisao_regiao) as Divisao 
     
  into   
    #FaturaDevolucaoAnoAnterior  
  from  
    vw_faturamento_devolucao_mes_anterior_bi vw  
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto   
    left outer join Cliente_Endereco Ce on ce.cd_cliente = vw.cd_cliente
    left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  where   
   (vw.dt_nota_saida < @dt_inicial) and  
   vw.dt_restricao_item_nota between @dt_inicial and @dt_final and  
 vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      
  group by   
   IsNull(Cep.cd_divisao_regiao,0)  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Cancelamento do Mês Corrente  
  ----------------------------------------------------  
  select   
   IsNull(Cep.cd_divisao_regiao,0) as cd_divisao_regiao,  
   max(vw.dt_nota_saida)                                            as UltimaCompra,  
    sum(vw.vl_unitario_item_atual) / @vl_moeda                       as Compra,  
    count(distinct(vw.cd_nota_saida))                                                 as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, vw.vl_ipi,   
      vw.cd_destinacao_produto, @dt_inicial)) as money)                                                           as TotalLiquido,  
   sum(vw.vl_unitario_item_total) / @vl_moeda                       as TotalLista,  
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
    max(Cep.cd_divisao_regiao) as Divisao 
     
  into   
    #FaturaCancelado  
  from  
    vw_faturamento_cancelado_bi vw  
    left outer join Produto_Custo pc on vw.cd_produto = pc.cd_produto   
    left outer join Cliente_Endereco Ce on ce.cd_cliente = vw.cd_cliente
    left outer join Cep                 on Cep.cd_cep = ce.cd_cep_cliente
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
 vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end      
  group by   
   IsNull(Cep.cd_divisao_regiao,0)  
  order by 1 desc  
  
  
  select a.cd_divisao_regiao,    
         a.UltimaCompra,   
         a.Pedidos,  
         --Total de Venda  
       cast(IsNull(a.Compra,0) -  
       (isnull(b.Compra,0) +   
         --Verifica o parametro do BI  
       (case @ic_devolucao_bi  
        when 'N' then 0  
        else isnull(c.Compra,0)  
        end) +   
       isnull(d.Compra,0)) as money) as Compra,  
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
        b.Pedidos as QtdDev,  
        c.Pedidos as QtdDevAnt,  
        d.Pedidos as QtdCanc,  
--        dbo.fn_meta_vendedor(a.cd_vendedor,@dt_inicial,@dt_final,0,0) as 'Meta',  
        a.Atendimento    
  
  into   
   #FaturaResultado  
  from   
   #FaturaAnual a  
   left outer join  #FaturaDevolucao b  
   on a.cd_divisao_regiao = b.cd_divisao_regiao  
    left outer join  #FaturaDevolucaoAnoAnterior c  
   on a.cd_divisao_regiao = c.cd_divisao_regiao  
    left outer join  #FaturaCancelado d  
   on a.cd_divisao_regiao = d.cd_divisao_regiao  
  
  
  set @qt_total_vendedor = @@rowcount  
  set @vl_total_vendedor = 0  
    
  Select   
   @vl_total_vendedor = Sum(IsNull(Compra,0))  
  from  
    #FaturaResultado  
    
  --Cria a Tabela Final de Faturas por Setor  
  select   
    IDENTITY(int, 1,1)                as Posicao,   
    a.cd_divisao_regiao               as Divisao,   
    a.Compra                           as Venda,   
    ((a.Compra/@vl_total_vendedor)*100)            as Perc,   
    a.UltimaCompra                 as UltimaVenda,   
    a.Pedidos                           as Pedidos,  
    a.TotalLiquido,  
    a.TotalLista,  
   cast((( a.TotalLista / a.Compra ) * 100) - 100 as decimal (15,2)) as 'Descto',  
    a.CustoContabil,  
    a.MargemContribuicao,  
    a.BNS,  
--    isnull(a.Meta,0)                          as 'Meta',  
--    (a.compra / case when a.Meta>0 then a.Meta else 1 end ) * 100 as 'PercMeta',  
     a.Atendimento  
  
  Into   
 #FaturaResultadoFinal  
  from   
    #FaturaResultado a  
  order by a.Compra desc  
  
  --Mostra tabela ao usuário  
  Select   
    r.*,   
    Cast ((case when isnull(v.sg_divisao_regiao,'') <>'' then v.sg_divisao_regiao  else 'Notas s/ Divisão de Região no Cadastro' end )  as varchar(45) ) as nm_divisao_regiao,
    v.Qtd                  as QtdClientes,  
    particpacao = (cast(r.atendimento as float)/case when v.qtd=0 then 1 else v.qtd end)*100  
  
  from   
   #FaturaResultadoFinal r left outer join  
   #Resumo_Divisao v on r.Divisao = v.cd_divisao_regiao  
  order by   
   Posicao asc  
  

------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------

-- exec pr_fatura_divisao_regiao
-- @dt_inicial = '01/01/2000',   
-- @dt_final = '01/01/2007',   
-- @cd_divisao_regiao   =0,    
-- @cd_moeda            = 1,    
-- @cd_tipo_mercado     = 0  


