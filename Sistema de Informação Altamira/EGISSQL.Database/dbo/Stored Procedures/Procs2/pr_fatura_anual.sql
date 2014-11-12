
CREATE PROCEDURE pr_fatura_anual
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2002                     
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000  
--Carlos Cardoso Fernandes         
--Faturas Anual
--Data          : 11.08.2000
--Atualizado    : 12.08.2000
--              : 15.01.2001 - Média 
--              : 06.04.2002 - Migração p/ Banco EGISSQL - Elias
--              : 01.08.2002 - Duela
--              : 04/09/2002 - Filtro por Ano - Daniel C. Neto.
--                03/11/2003 - Filtro por Moeda - Daniel C. Neto.
--              : 23.04.2004 - Inclusão de campo TotalLiquido - Igor Gama
--                23/04/2004 - Acerto no parametro da fn_vl_liquido_venda - ELIAS
-- 16/09/2004 - Acerto para permitir consulta de todos os anos - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 02.11.2007 - Saldo em Carteira - Carlos Fernandes
-- 21.11.2007 - Total em Quantidade - Carlos Fernandes
-- 27.12.2007 - Saldo por Data de Entrega - Carlos Fernandes
-- 06.08.2008 - Ajuste de Nota Cancelada - Carlos Fernandes
-- 13.04.2010 - Conversão pela Moeda - Carlos Fernandes

--------------------------------------------------------------------------------------
@cd_ano      int,
@cd_moeda    int

as

  declare @ic_devolucao_bi         char(1)
  declare @vl_total_vendas         float
  declare @ic_tipo_conversao_moeda char(1)
  
  set @ic_devolucao_bi = 'N'
  
  Select top 1
    @ic_devolucao_bi           = IsNull(ic_devolucao_bi,'N'),
     @ic_tipo_conversao_moeda  = isNull(ic_tipo_conversao_moeda,'U')

  from Parametro_BI with (nolock) 
  where 
    cd_empresa = dbo.fn_empresa()

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )



  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount on

  ----------------------------------------------------
  -- Total de Faturas Anual
  ----------------------------------------------------
  select 
    year(vw.dt_nota_saida)              	                    as 'Ano', 
    sum(vw.vl_unitario_item_total
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                            as 'Vendas', 

    sum(dbo.fn_vl_liquido_venda('F',vl_unitario_item_total,                             
                                    vw.vl_icms_item, 
                                    vw.vl_ipi, 
                                    vw.cd_destinacao_produto, '')
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end
    )                                                               as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                               as 'Pedidos',
    sum(vw.qt_item_nota_saida)                                      as 'Quantidade'

  into 
    #FaturaAnual

  from
    vw_faturamento_bi vw
  where 
  	year(vw.dt_nota_saida) = (case when @cd_ano = 0 then year(vw.dt_nota_saida) else @cd_ano end)
  group by 
    year(vw.dt_nota_saida)
  order by 1 desc
  
  ----------------------------------------------------
  -- Total de Devoluções Anual
  ----------------------------------------------------
  select 
    year(vw.dt_nota_saida)                                           as 'Ano', 

    sum(vw.vl_unitario_item_total
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                            as 'Vendas', 

    -- ELIAS 23/04/2004

    sum(dbo.fn_vl_liquido_venda('F',vl_unitario_item_total, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, '')

    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                            as 'TotalLiquido',

    count(distinct(vw.cd_nota_saida))                               as 'Pedidos',

    sum(vw.qt_item_nota_saida)                                      as 'Quantidade'

  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao_bi vw
  where 
  	year(vw.dt_nota_saida) = @cd_ano
  group by 
    year(vw.dt_nota_saida)
  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    year(vw.dt_restricao_item_nota)                              				as 'Ano', 
    sum(case when isnull(vw.vl_unitario_item_total,0)>0 then vw.vl_unitario_item_total else vw.vl_total end
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)               
                                                                    as 'Vendas', 
    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vl_unitario_item_total, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, '')
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)
                                                                   as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                              as 'Pedidos',
    sum(vw.qt_item_nota_saida)                                     as 'Quantidade'

  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
  where 
  	year(vw.dt_restricao_item_nota) = ((case when @cd_ano = 0 then 
                                year(vw.dt_restricao_item_nota) else @cd_ano end)  - 1)
    and year(vw.dt_restricao_item_nota) = (case when @cd_ano = 0 then 
                                year(vw.dt_restricao_item_nota) else @cd_ano end)
  group by 
    year(vw.dt_restricao_item_nota)
  order by 1 desc


  ----------------------------------------------------
  -- Total de Canceladas Anual
  ----------------------------------------------------
  select 
    year(vw.dt_nota_saida)                              				as 'Ano', 
--    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Vendas', 
    sum(case when isnull(vw.vl_unitario_item_atual,0)>0 then vw.vl_unitario_item_atual else vw.vl_total end
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                                                as 'Vendas',
    --sum(vw.vl_unitario_item_total) / @vl_moeda as 'Vendas', 
    -- ELIAS 23/04/2004
    sum(dbo.fn_vl_liquido_venda('F',vl_unitario_item_total,
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, '')
    /
    case when @cd_moeda <> 1 and vw.vl_moeda_cotacao<> 0 then
      vw.vl_moeda_cotacao
    else
      @vl_moeda
    end)                                                         as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                            as 'Pedidos',
    sum(vw.qt_item_nota_saida)                                   as 'Quantidade'

  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
  where 
  	year(vw.dt_nota_saida) = (case when @cd_ano = 0 then 
                                year(vw.dt_nota_saida) else @cd_ano end)
  group by 
    year(vw.dt_nota_saida)
  order by 1 desc

  --Critério
  --Notas Faturadas - (Notas Canceladas + Notas Devolvidas)

  select 
    a.Ano,
    a.Pedidos,
    IsNull(a.vendas,0) -
    (isnull(b.vendas,0) + 
     --Verifica o parametro do BI
  		(case @ic_devolucao_bi
  		 when 'N' then 0
  		 else isnull(c.vendas,0)
  		 end) + 
  	isnull(d.vendas,0)) as Vendas,
    IsNull(a.TotalLiquido,0) -
    (isnull(b.TotalLiquido,0) + 
     --Verifica o parametro do BI
  		(case @ic_devolucao_bi
  		 when 'N' then 0
  		 else isnull(c.TotalLiquido,0)
  		 end) + 
  	isnull(d.TotalLiquido,0)) as TotalLiquido,
    IsNull(a.quantidade,0) -
    (isnull(b.quantidade,0) + 
     --Verifica o parametro do BI
  		(case @ic_devolucao_bi
  		 when 'N' then 0
  		 else isnull(c.quantidade,0)
  		 end) + 
  	isnull(d.quantidade,0)) as Quantidade

  into 
    #FaturaResultado
  from 
    #FaturaAnual a
  	left outer join  #FaturaDevolucao b
  	on a.Ano = b.Ano
    left outer join  #FaturaDevolucaoAnoAnterior c
  	on a.Ano = c.Ano
    left outer join  #FaturaCancelado d
  	on a.Ano = d.Ano

  --Define o total de vendas como zero
  
  select  
  	@vl_total_vendas = IsNull(vendas,0)
  From
  	#FaturaResultado
  
 
  --Busca o Valor Total da Meta
  --select * from meta_faturamento
  declare @vl_total_meta_faturamento float

  select
    @vl_total_meta_faturamento = sum ( isnull(vl_meta_faturamento,0) )
  from
   Meta_Faturamento 
  where
   year(dt_fim_meta_faturamento ) = case when @cd_ano = 0 then year(dt_fim_meta_faturamento) else @cd_ano end


  select 
    Ano, 
    Vendas, 
    (Vendas / 12) as 'media_anual',
    (Vendas /@vl_total_vendas) * 100  as 'perc', 
    Pedidos,
    @vl_total_meta_faturamento        as 'metames',
    TotalLiquido,
    TotalCarteira = 
    ( select sum (case when isnull(qt_saldo_pedido_venda,0)>0 then
          qt_saldo_pedido_venda * vl_unitario_item_pedido / @vl_moeda
          --qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda
         else 0 end )
      from 
        vw_venda_bi with(nolock)
      where
        year(dt_entrega_vendas_pedido) = Ano ),
    Quantidade 

  from
    #FaturaResultado

  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount off

