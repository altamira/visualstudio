
-------------------------------------------------------------------------------
--pr_consulta_ranking_regiao_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 02/08/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_ranking_regiao_cliente  
@ic_parametro    int,  
@dt_inicial      datetime,  
@dt_final        datetime,  
@cd_moeda        int = 0,  
@cd_tipo_mercado int = 0  
  
as  
  
declare @qt_total_regiao_cliente int  
declare @vl_total_regiao_cliente float  
declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)
  
declare @vl_moeda float  
  
set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                  else dbo.fn_vl_moeda(@cd_moeda) end )  
  
  
-----------------------------------------------------------  
if @ic_parametro = 1  -- VENDAS  
-----------------------------------------------------------  
begin  
  -- Geração da Tabela Auxiliar de Vendas por Cliente  
  select   
    cr.cd_cliente_regiao,  
    cr.nm_cliente_regiao as 'Regiao_Cliente'  ,
    cast(sum(qt_item_pedido_venda * (vl_unitario_item_pedido / @vl_moeda)) as decimal(25,2)) as 'Compra',   
    cast(sum(dbo.fn_vl_liquido_venda  
      ('V',(qt_item_pedido_venda*(vl_unitario_item_pedido / @vl_moeda)),   
            pc_icms, pc_ipi, vw.cd_destinacao_produto, @dt_inicial))   
      as decimal(25,2)) as 'TotalLiquido',  
    cast(sum((qt_item_pedido_venda *(vl_lista_item_pedido / @vl_moeda)))   
      as decimal(25,2)) as 'TotalLiSta',  
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))   
      as decimal(25,2)) as 'CustoContabil',  
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /  
         sum((dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda *  
             (vl_unitario_item_pedido / @vl_moeda)), pc_icms,   
             pc_ipi, vw.cd_destinacao_produto, @dt_inicial)))   
      as decimal(25,2)) * 100 as 'MargemContribuicao',  
    cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))   
      as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',  
    max(dt_pedido_venda)                                as 'UltimaCompra',   
    count(distinct cd_pedido_venda)                              as 'pedidos'  
  into #VendaClienteAux1  
  from   
    vw_venda_bi vw  left outer join 
    Cliente cli on vw.cd_cliente=cli.cd_cliente left outer join 
    Cliente_Regiao cr on cli.cd_regiao = cr.cd_cliente_regiao
  left outer join Produto_Custo ps on   
    vw.cd_produto = ps.cd_produto  
  where  
   (vw.dt_pedido_venda between @dt_inicial and @dt_final) and  
    vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  
  group by   
    cr.cd_cliente_regiao, cr.nm_cliente_regiao
  order by   
    Compra desc  
  
  -- Total de Cliente  
  set @qt_total_regiao_cliente = @@rowcount  
  
  -- Total de Vendas Geral  
  set @vl_total_regiao_cliente = 0  
  select @vl_total_regiao_cliente = @vl_total_regiao_cliente + compra  
  from  
    #VendaClienteAux1  
  
  --Cria a Tabela Final de Vendas por Cliente  
  -- Define a posição de Compra do Cliente - IDENTITY  
  select   
    IDENTITY(int, 1,1) as 'Posicao',  
    isnull(cd_cliente_regiao,0) as cd_cliente_regiao, 
    Isnull(Regiao_Cliente, 'Sem Região') as Regiao_Cliente,   
    Compra,   
    TotalLiquido,  
    TotalLista,  
    CustoContabil,  
    MargemContribuicao,  
    BNS,  
    cast(((Compra / @vl_total_regiao_cliente ) * 100) as decimal (25,2)) as 'Perc',  
    UltimaCompra,  
    pedidos,  
    cast((( TotalLista / Compra ) * 100) - 100 as decimal (15,2)) as 'Desc'  
  Into #VendaCliente1  
  from #VendaClienteAux1  
  Order by Compra desc  
  
  --Mostra tabela ao usuário  
  select * from #VendaCliente1  
  order by posicao  
  
end  

-----------------------------------------------------------  
else if @ic_parametro = 2  -- FATURAMENTO  
-----------------------------------------------------------  
begin  
  declare @qt_total_produto int,  
          @vl_total_produto float,  
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
   max(vw.dt_nota_saida) as UltimaVenda,  
    count(distinct(vw.cd_nota_saida)) as Pedidos,  
   sum(vw.vl_unitario_item_total) / @vl_moeda as Venda,  
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item,   
        vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as TotalLiquido,  
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
    count(distinct vw.cd_cliente) as Clientes,  
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida  
  into   
    #FaturaAnual  
  from  
    vw_faturamento_bi vw  
      left outer join   
    Produto_Custo pc  
      on vw.cd_produto = pc.cd_produto   
      left outer join  
    Produto p  
      on vw.cd_produto = p.cd_produto  
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
        vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  group by   
   vw.cd_cliente  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Devoluções do Mês Corrente  
  ----------------------------------------------------  
  select   
   vw.cd_cliente,  
   max(vw.dt_nota_saida) as UltimaVenda,  
    count(distinct(vw.cd_nota_saida)) as Pedidos,  
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
    count(distinct vw.cd_cliente) as Clientes,  
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida  
  into   
    #FaturaDevolucao  
  from  
    vw_faturamento_devolucao_bi vw  
      left outer join   
    Produto_Custo pc  
      on vw.cd_produto = pc.cd_produto   
      left outer join  
    Produto p  
      on vw.cd_produto = p.cd_produto  
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
        vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  group by   
    vw.cd_cliente  
  order by 1 desc  
    
  ----------------------------------------------------  
  -- Total de Devoluções do Ano Anterior  
  ----------------------------------------------------  
  select   
   vw.cd_cliente,  
   max(vw.dt_nota_saida) as UltimaVenda,  
    count(distinct(vw.cd_nota_saida)) as Pedidos,  
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
    count(distinct vw.cd_cliente) as Clientes,  
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida  
  into   
    #FaturaDevolucaoAnoAnterior  
  from  
    vw_faturamento_devolucao_mes_anterior_bi vw  
      left outer join   
    Produto_Custo pc  
      on vw.cd_produto = pc.cd_produto   
      left outer join  
    Produto p  
      on vw.cd_produto = p.cd_produto  
  where   
    year(vw.dt_nota_saida) = year(@dt_inicial) and  
--   (vw.dt_nota_saida < @dt_inicial) and  
   vw.dt_nota_saida < @dt_inicio_periodo and

   vw.dt_restricao_item_nota between @dt_inicial and @dt_final and  
    vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  
  group by   
   vw.cd_cliente  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Cancelamento do Mês Corrente  
  ----------------------------------------------------  
  select   
   vw.cd_cliente,  
   max(vw.dt_nota_saida) as UltimaVenda,  
    count(distinct(vw.cd_nota_saida)) as Pedidos,  
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
    count(distinct vw.cd_cliente) as Clientes,  
    sum(vw.qt_item_nota_saida) as qt_item_nota_saida  
  into   
    #FaturaCancelado  
  from  
    vw_faturamento_cancelado_bi vw  
      left outer join   
    Produto_Custo pc  
      on vw.cd_produto = pc.cd_produto   
      left outer join  
    Produto p  
      on vw.cd_produto = p.cd_produto  
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final and  
        vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
   
  group by   
    vw.cd_cliente  
  order by 1 desc  
  
  select   
    a.cd_cliente,  
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
    a.Clientes,  
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
    
  -- Total de produtoes  
  set @qt_total_produto = @@rowcount  
    
  -- Total de Vendas Geral dos Setores  
  set @vl_total_produto = 0  
  
  Select   
    @vl_total_produto = @vl_total_produto + venda  
  from  
    #FaturaResultado  
    
  --Cria a Tabela Final de Vendas por Setor    
  select   
    a.cd_cliente,  
    a.qtd,  
    a.venda,  
    (a.venda / @vl_total_produto) * 100 as 'Perc',     
    a.UltimaVenda as 'UltimaCompra',    
    a.pedidos as 'Pedidos',  
    a.Clientes as 'Clientes',  
    a.TotalLiquido as 'TotalLiquido',  
    a.TotalLista as 'TotalLista',  
    a.CustoContabil as 'CustoContabil',  
    a.MargemContribuicao as 'MargemContribuicao',  
    a.BNS as 'BNS',  
    (case when (a.Venda = 0) or (a.Venda = 0) then 0  
              else (100 - (a.Venda * 100)/a.Venda)  end ) as 'Desc'   
  Into   
    #FaturaCategoriaAux  
  from   
    #FaturaResultado a    
  Order by   
    a.Venda desc    
     
  --Mostra tabela ao usuário    

  select   
    IDENTITY(int, 1,1) as 'Posicao',  
    b.cd_cliente_regiao,        
    b.nm_cliente_regiao as 'regiao_Cliente',   
    max(UltimaCompra) as 'UltimaCompra',  
    Sum(Pedidos) as 'Pedidos',  
    sum(a.Venda) as 'Compra',  
    sum(a.TotalLiquido) as 'TotalLiquido',  
    sum(a.TotalLista) as 'TotalLista',  
    sum(a.CustoContabil) as 'CustoContabil',  
    sum(a.MargemContribuicao) as 'MargemContribuicao',  
    sum(a.BNS) as 'BNS',  
    sum(cast(((a.Venda / @vl_total_regiao_cliente ) * 100) as decimal (15,2))) as 'Perc',  
    sum(cast(( a.TotalLista / a.Venda ) * 100 as decimal (15,2))) as 'Desc'  
  Into #FaturaResultados  
  from   
    #FaturaCategoriaAux a   
      left outer join   
    Cliente c  
      on a.cd_cliente = c.cd_cliente  
      left outer join  
    Cliente_regiao b   
      on c.cd_regiao = b.cd_cliente_regiao  
  group by  
    b.cd_cliente_regiao,        
    b.nm_cliente_regiao  
  
  select * from #FaturaResultados  
  order by Compra desc  

end

