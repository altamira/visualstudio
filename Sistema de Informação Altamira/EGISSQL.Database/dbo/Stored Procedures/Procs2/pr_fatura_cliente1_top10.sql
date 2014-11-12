
create procedure pr_fatura_cliente1_top10
--------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda.
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei  / Carlos Cardoso Fernandes       
--Consulta do Total de Faturas por Cliente
--Data         : 11.08.2000
--             : 28.11.2000 Atualização do Where : Idem ao Mapa Faturamento 
--             : 26.12.2000 Alterada a forma de junção das três querys finais 
--             : 26.12.2000 Alteração na disposição do campo POSICAO
--Atualizado   : 02.08.2002 - Migração para o bco. EgisSql (Duela)
--             : 03/09/2002 - Incluido Código do Cliente - Daniel C. Neto.
--             : 31/10/2002 - Ajustes nos joins
--             : 21/11/2003 - Incluído novas colunas, acertos nos filtros - Daniel C. Neto.
--               10/12/2003- Acerto relacionamento Pedido_Venda_Item - Daniel C. Neto.
--               23/04/2004 - Acerto no parametro da fn_vl_liquido_venda - ELIAS
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 14.03.2006 - Tipo de Mercado - Carlos Fernandes
-- 16.03.2006 - Mostrar no nome do tipo de mercado - Carlos Fernandes/Danilo
-- 03.04.2007 - Correção do Order By de uma das tabelas temporarias - Anderson - PIC
-- 10.07.2007 - Verificação da Procedure - Carlos Fernandes
-- 25.07.2007 - Acerto de duplicidade de vendedores - Carlos Fernandes
-- 27.12.2007 - Acerto da coluna valor líquido outra moeda - Carlos Fernandes - Carlos Fernandes
-- 09.04.2008 - Acerto do Ramo Atividade/Segmento de Mercado - Carlos Fernandes
-- 06.08.2008 - Ajuste de Nota cancelada sem item da Nota - Carlos Fernandes
-- 14.10.2008 - Ajuste da Consulta duplicidade de Cliente - Carlos Fernandes
-- 03.08.2009 - Clientes sem Valor Total - ( Cancelado ) - Não Mostrar - Carlos Fernandes
-- 11.05.2010 - Checagem da Devolução - Carlos Fernandes
-- 03.07.2010 - Ajuste da Dev. Meses Anteriores - Carlos Fernandes/Márcio 
--------------------------------------------------------------------------------------
@dt_inicial      datetime,  
@dt_final        datetime,  
@cd_moeda        int = 1,  
@cd_tipo_mercado int = 0
--@qt_top_ranking  int = 0  
  
as  
  
--   declare @qt_top_ranking int
-- 
--   if @qt_top_ranking is null
--      set @qt_top_ranking = 0

  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)


  declare @qt_total_cliente  int,  
          @vl_total_cliente  float,  
          @ic_devolucao_bi   char(1)  
    
  declare @vl_moeda float  
   
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                    else dbo.fn_vl_moeda(@cd_moeda) end )  
  
  set @ic_devolucao_bi = 'N'  
    
  Select   
   top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')  
  from   
   Parametro_BI  with (nolock) 
  where  
   cd_empresa = dbo.fn_empresa()  
    
  Select   
   vw.cd_cliente,  
   max(vw.dt_nota_saida)                                             as UltimaCompra,  
--   sum( isnull(vw.vl_unitario_item_total,0) ) / @vl_moeda            as Compra,  
    sum(case when vw.vl_unitario_item_total>0 then vw.vl_unitario_item_total else vw.vl_total end) / @vl_moeda                        as Compra,  

   count(distinct(vw.cd_nota_saida))                                 as Pedidos,  
   cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
     vw.cd_destinacao_produto, @dt_inicial)) as money) / @vl_moeda   as TotalLiquido,  

   sum(vw.vl_lista_produto) / @vl_moeda                              as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, ''))  
      as money) / @vl_moeda                                          as CustoContabil,  
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,  
    -- Cálculo da Margem de contribuição  
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100  
    Cast(  
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -  
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')) /   
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)  
        ) as money)/ @vl_moeda                                       as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, '')  
         / @vl_moeda)) as money) * dbo.fn_pc_bns()                   as BNS,  
    max(vw.cd_vendedor)                                              as Vendedor,  
    max(vw.nm_tipo_mercado)                                          as nm_tipo_mercado,
    max(vw.nm_ramo_atividade)                                        as nm_ramo_atividade,
    max(vw.nm_pais)                                                  as nm_pais,
    max(vw.nm_estado)                                                as nm_estado,
    max(vw.nm_cidade)                                                as nm_cidade,
    max(vw.nm_cliente_regiao)                                        as nm_cliente_regiao      
   
  into   
    #FaturaAnual  

  from  
    vw_faturamento_bi vw  
    left outer join Produto_Custo pc     with (nolock) on vw.cd_produto = pc.cd_produto   
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final  
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
    and vw.cd_tipo_mercado = case when @cd_tipo_mercado = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  

  group by   
--   vw.cd_cliente, vw.cd_vendedor, vw.nm_tipo_mercado  
     vw.cd_cliente
  order by 1 desc  

 -- select * from #faturaanual 
  
  ----------------------------------------------------  
  -- Devoluções do Mês Corrente  
  ----------------------------------------------------  

  select   
   vw.cd_cliente,    
   max(vw.dt_nota_saida)                                             as UltimaCompra,  
    sum(vw.vl_unitario_item_total) / @vl_moeda                       as Compra,  
    count(distinct(vw.cd_nota_saida))                                as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
     vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda    as TotalLiquido,  
   sum(vw.vl_lista_produto) / @vl_moeda                              as TotalLista,  
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
        )/ @vl_moeda as money) as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')  
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,  
    vw.cd_vendedor as Vendedor  
  into   
    #FaturaDevolucao  
  from  
    vw_faturamento_devolucao_bi vw  
    left outer join   Produto_Custo pc  on vw.cd_produto = pc.cd_produto   
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final  
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
  group by   
     vw.cd_cliente, vw.cd_vendedor  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Total de Devoluções do Ano Anterior  
  ----------------------------------------------------  
  select   
   vw.cd_cliente,  
   max(vw.dt_restricao_item_nota)                                            as UltimaCompra,  
    sum(vw.vl_unitario_item_total) / @vl_moeda                       as Compra,  
    count(distinct(vw.cd_nota_saida))                                                 as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
     vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda   as TotalLiquido,  
   sum(vw.vl_lista_produto) / @vl_moeda                             as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D'))        as money)
                                                        / @vl_moeda as CustoContabil,  
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,  
    -- Cálculo da Margem de contribuição  
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100  
    Cast(  
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -  
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')) /   
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)  
        )/ @vl_moeda as money) as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'D')  
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,  
    vw.cd_vendedor                                 as Vendedor  
  into   
    #FaturaDevolucaoAnoAnterior  
  from  
    vw_faturamento_devolucao_mes_anterior_bi vw  
    left outer join Produto_Custo pc  on vw.cd_produto = pc.cd_produto   
  where   
    year(vw.dt_restricao_item_nota) = year(@dt_inicial) and  
  -- (vw.dt_nota_saida < @dt_inicial) and  
   vw.dt_restricao_item_nota < @dt_inicio_periodo and
   vw.dt_restricao_item_nota between @dt_inicial and @dt_final  
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
  group by   
  vw.cd_cliente, vw.cd_vendedor  
  order by 1 desc  
  
  ----------------------------------------------------  
  -- Cancelamento do Mês Corrente  
  ----------------------------------------------------  
  select   
   vw.cd_cliente,  
   max(vw.dt_nota_saida)                                            as UltimaCompra,  
    sum(case when isnull(vw.vl_unitario_item_atual,0)>0 then vw.vl_unitario_item_atual else vw.vl_total end) / @vl_moeda                      as Compra,  
    count(distinct(vw.cd_nota_saida))                               as Pedidos,  
    -- ELIAS 23/04/2004  
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi,   
     vw.cd_destinacao_produto, @dt_inicial)) as money)/ @vl_moeda   as TotalLiquido,  
   sum(vw.vl_lista_produto) / @vl_moeda                             as TotalLista,  
    --Foi alterado para função de cálculo de custo do produto. Igor Gama . 04.05.2004  
    cast(sum(dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C'))  
      as money)/ @vl_moeda as CustoContabil,  
    --cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,  
    -- Cálculo da Margem de contribuição  
    --MC = (Fat. Líq - Custo) / Fat. Líq * 100  
    Cast(  
     sum((dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) -  
          dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')) /   
         (dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial) * 100)  
        ) as money)/ @vl_moeda as MargemContribuicao,  
   cast(sum((vw.qt_item_nota_saida * dbo.fn_valor_custo_produto(vw.cd_nota_saida,  vw.cd_item_nota_saida, vw.cd_produto, vw.cd_fase_produto, vw.dt_nota_saida, @dt_inicial, @dt_final, 'C')  
         / @vl_moeda)) as money) * dbo.fn_pc_bns() as BNS,  
    vw.cd_vendedor as Vendedor  
  into   
    #FaturaCancelado  
  from  
    vw_faturamento_cancelado_bi vw  
      left outer join   
    Produto_Custo pc  
      on vw.cd_produto = pc.cd_produto   
  where   
   vw.dt_nota_saida between @dt_inicial and @dt_final  
    and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes  
  group by   
     vw.cd_cliente, vw.cd_vendedor  
  order by 1 desc  
  
  select a.cd_cliente,  
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
         a.Vendedor,  
         a.nm_tipo_mercado,
         a.nm_ramo_atividade,
         a.nm_pais,
         a.nm_estado,
         a.nm_cidade,
         a.nm_cliente_regiao  
  into   
   #FaturaResultado  

  from   
    #FaturaAnual a  
   left outer join  #FaturaDevolucao b             on a.cd_cliente = b.cd_cliente  
   left outer join  #FaturaDevolucaoAnoAnterior c  on a.cd_cliente = c.cd_cliente  
   left outer join  #FaturaCancelado d             on a.cd_cliente = d.cd_cliente  
  order by a.Compra desc  
    
  set @qt_total_cliente = @@rowcount  
  set @vl_total_cliente = 0  

--print 'Teste'   
    
  Select   
   @vl_total_cliente = sum(IsNull(Compra,0))  
  from  
    #FaturaResultado  

  --select * from #FaturaResultado
    
  select   
         a.cd_cliente,  
         1 as cd_tipo_destinatario, --1-Cliente, mantido apenas para compatibilidade com a tela  
         b.nm_fantasia_cliente as Cliente,   
         a.UltimaCompra,  
         c.nm_fantasia_vendedor as Setor, --Nome do Vendedor  
         Pedidos,  
         a.Compra,  
         a.TotalLiquido,  
         a.TotalLista,  
         a.CustoContabil,  
         a.MargemContribuicao,  
         a.BNS,
	 case
           when isnull(@vl_total_cliente,0)=0 then
             0
           else
             cast(((a.Compra / @vl_total_cliente ) * 100) as money)
         end as Perc,  
         --cast(((a.Compra / @vl_total_cliente ) * 100) as money) as Perc,  
         case 
           when isnull(a.Compra,0) = 0 then
             0  
           else  
             case
               when isnull(a.TotalLista,0)=0 then
                 0
               else
                 100 - cast(((a.Compra * 100)/ a.TotalLista) as money)
               end
             --100 - cast(((a.Compra * 100)/ a.TotalLista) as money)  
         end as 'Desc',  
        a.nm_tipo_mercado,
        a.nm_ramo_atividade,
        a.nm_pais,
        a.nm_estado,
        a.nm_cidade,
        a.nm_cliente_regiao,  
        cc.nm_classificacao_cliente
  
  Into   
   #FaturaResultadoFinal  
  from   
   #FaturaResultado a   
   left outer join Cliente b   on a.cd_cliente = b.cd_cliente  
   left outer join Vendedor c on a.Vendedor = c.cd_vendedor   
   left outer join Agrupamento_Cliente ac on ac.cd_cliente = b.cd_cliente
   left outer join Classificacao_cliente cc on cc.cd_classificacao_cliente = ac.cd_classificacao_cliente

  where
    a.Compra>0
  order by a.Compra desc  
    
  --Mostra tabela ao usuário  
  Select   
   IDENTITY(int, 1,1) as 'Posicao',
   *   
  into
    #FaturaResultadoFinal2
  from   
   #FaturaResultadoFinal  
  order by   
   Compra Desc

--   Select   
--    *   
--   from   
--    #FaturaResultadoFinal2
--   order by   
--    Posicao

--   if @qt_top_ranking <> 0
--   begin
-- 

    declare  @vl_total_top10     float
    declare  @vl_total_diferenca float


    Select   
      top 10
      a.Posicao,
      a.Cliente,
      a.Compra   
    into
      #ClienteTop10
    from   
      #FaturaResultadoFinal2 a
    order by   
      Posicao

    select @vl_total_top10 = sum(Compra)
    from
      #ClienteTop10

    set @vl_total_diferenca = @vl_total_cliente - @vl_total_top10

    --select * from       #ClienteTop10

   SET IDENTITY_INSERT #ClienteTop10 ON

    insert into
      #ClienteTop10
    select
      11                  as Posicao,
      'OTHERS'            as Cliente,
      @vl_total_diferenca as Compra
      
    select
      *,
      Perc = Compra/@vl_total_cliente
    from
      #ClienteTop10

    order by   
      Posicao

--  end

