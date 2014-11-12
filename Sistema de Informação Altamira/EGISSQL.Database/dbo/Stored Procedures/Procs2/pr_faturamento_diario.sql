
CREATE  PROCEDURE pr_faturamento_diario
---------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
---------------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Carrasco Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta o Faturamento Diario
--Data			: 08/05/2002
--Alteração		: 
--Desc. Alteração	: 14/06/2002- Correção Johnny / Daniel C. Neto.
--alteração    : Inclusão do cálculo do resumo certo no faturamento Diário
--             : Filtro para pegar a CFOP com custo financeiro.
--Alteração    :  15/01/2003 Recalcular o valor total de notas devolvidas
-- 19/04/2004 - Incluído campo de devolução anterior - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 18/02/2005 - Trocado ic_comercial_operacao por ic_analise_op_fiscal nos filtros de @ic_comercial - Clelson Camargo
-- 06.02.2006 - Acerto de Notas Fiscais sem Pedido de Venda - Carlos / Diego Borba
-- 18.10.2007 - Soma aos Itens do Produto - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-- 29.11.2010 - Ajustes Diversos - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------
  @ic_parametro  int,
  @dt_inicial    datetime,
  @dt_final      datetime,
  @cd_nota_saida int = 0,
  @ic_comercial  char(1) = 'N',
  @cd_moeda      int = 1

AS


declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-------------------------------------------------------------
if @ic_parametro in (1,3) -- Consulta Totais ou por nota.
--------------------------------------------------------------
begin

  declare @ic_devolucao_bi char(1)

  set @ic_devolucao_bi = 'N'

  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
   	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
    vw.cd_nota_saida,
 
--     case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
--         vw.cd_identificacao_nota_saida
--     else
--         vw.cd_nota_saida                              
--     end                           as cd_nota_saida,

    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,

    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,

    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)                                   as TotalLiquido,
    --Valor do item com os impostos - Fabio Cesar
    cast(sum(vw.vl_unitario_item_total) as money) 								                                          as TotalLiquidoComImposto,

  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 																	as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		                    as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)                                                                     as vl_icms,
    cast(sum(vw.vl_ipi) as money)                                                                           as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)                                                                    as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)                                                                   as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)                                                               as vl_desp_acess_item
  into 
    #FaturaAnual
  from
    vw_faturamento vw
    left outer join  Produto_Custo pc  on vw.cd_produto = pc.cd_produto 
    left outer join  produto p         on vw.cd_produto = p.cd_produto

  where
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
  	vw.cd_nota_saida

  order by 1 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
    vw.cd_nota_saida,

--     case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
--         vw.cd_identificacao_nota_saida
--     else
--         vw.cd_nota_saida                              
--     end                           as cd_nota_saida,

    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,

    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,

    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								                  as TotalLiquido,
    --Valor do item com os impostos - Fabio Cesar
    cast(sum(vw.vl_unitario_item_total) as money) 								                                          as TotalLiquidoComImposto,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 																						as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		                    as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor)                                                                                     as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)                                                               as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)                                                                     as vl_icms,
    cast(sum(vw.vl_ipi) as money)                                                                           as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)                                                                    as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)                                                                   as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)                                                               as vl_desp_acess_item
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
  	vw.dt_nota_saida between @dt_inicial and @dt_final

  group by 
    vw.cd_nota_saida

  order by 1 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    vw.cd_nota_saida,

--     case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
--         vw.cd_identificacao_nota_saida
--     else
--         vw.cd_nota_saida                              
--     end                           as cd_nota_saida,

    sum(vw.vl_unitario_item_total) / @vl_moeda 																						as Venda,

    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,
    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								                  as TotalLiquido,
    --Valor do item com os impostos - Fabio Cesar
    cast(sum(vw.vl_unitario_item_total) as money) 								                                          as TotalLiquidoComImposto,
   	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 																	as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		                    as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor)                                                                           as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)                                                     as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)                                                           as vl_icms,
    cast(sum(vw.vl_ipi) as money)                                                                 as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)                                                          as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)                                                         as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)                                                     as vl_desp_acess_item
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
  group by 
    vw.cd_nota_saida

  order by 1 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
    vw.cd_nota_saida,

--     case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
--         vw.cd_identificacao_nota_saida
--     else
--         vw.cd_nota_saida                              
--     end                           as cd_nota_saida,

    sum(vw.vl_unitario_item_atual) / @vl_moeda 																						as Venda,

    count(distinct(vw.cd_nota_saida))                           																						as Pedidos,

    --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
    --usada para o calculo do valor sem os impostos

    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) 								                  as TotalLiquido,
    --Valor do item com os impostos - Fabio Cesar
    cast(sum(vw.vl_unitario_item_atual) as money) 								                                          as TotalLiquidoComImposto,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 											  					as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,
    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) /
         --Novos parâmentros para função de valor líquido, vl_ipi e vl_icms. Igor Gama - 22.04.2004
  			 cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) * 100 		  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor) as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money) as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money) as vl_icms,
    cast(sum(vw.vl_ipi) as money) as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)       as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)       as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)       as vl_desp_acess_item
  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
      left outer join
    Produto p
      on vw.cd_produto = p.cd_produto
  where 
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
  	vw.dt_nota_saida between @dt_inicial and @dt_final

  group by 
    vw.cd_nota_saida

  order by 1 desc

  select 
    a.*,
    (Select sum(TotalLiquido) from #FaturaCancelado where cd_nota_saida = a.cd_nota_saida) as vl_cancelado,
    (Select sum(TotalLiquido) from #FaturaDevolucao where cd_nota_saida = a.cd_nota_saida) as vl_devolvido,
    (Select sum(TotalLiquido) from #FaturaDevolucaoAnoAnterior where cd_nota_saida = a.cd_nota_saida) as vl_devolvido_mes_anterior,
    (Select sum(TotalLiquidoComImposto) from #FaturaCancelado where cd_nota_saida = a.cd_nota_saida) as vl_cancelado_com_imposto,
    (Select sum(TotalLiquidoComImposto) from #FaturaDevolucao where cd_nota_saida = a.cd_nota_saida) as vl_devolvido_com_imposto,
    (Select sum(TotalLiquidoComImposto) from #FaturaDevolucaoAnoAnterior where cd_nota_saida = a.cd_nota_saida) as vl_devolvido_mes_anterior_com_imposto
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a

  ---------------------------------------------------------
  if @ic_parametro = 3 -- Caso queira valores por nota.
  ---------------------------------------------------------
  begin
    --Caso deva apresentar devoluções do mês anterior

    if ( @ic_devolucao_bi = 'S' )
      Select
         *  
      From
        (
        Select
           ns.cd_identificacao_nota_saida,
           vw.cd_nota_saida,

--           case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--             ns.cd_identificacao_nota_saida
--           else
--             ns.cd_nota_saida                              
--           end                           as cd_nota_saida,

          ns.cd_num_formulario_nota,
          ns.dt_nota_saida,
          ns.dt_saida_nota_saida,
          ns.nm_razao_social_nota,
          ns.cd_mascara_operacao,
          ns.nm_operacao_fiscal,
          ns.cd_tipo_destinatario,
          td.nm_tipo_destinatario,
          ns.nm_fantasia_nota_saida as nm_fantasia_destinatario,
          IsNull(ns.cd_status_nota, 0) cd_status_nota,
          sn.nm_status_nota,
          --Valores sem imposto
          TotalLiquido as vl_total,
          vl_cancelado,
          vl_devolvido,
          --Valores com imposto
          TotalLiquidoComImposto - IsNull(vl_cancelado_com_imposto,0.00) as vl_total_com_imposto,
          vl_cancelado_com_imposto,
          vl_devolvido_com_imposto,
          TotalLiquido - (IsNull(vl_devolvido,0.00) + IsNull(vl_cancelado,0.00)) as vl_total_liquido,
          TotalLiquidoComImposto - (IsNull(vl_devolvido_com_imposto,0.00) + IsNull(vl_cancelado_com_imposto,0.00)) as vl_total_faturado

        from
          #FaturaResultado vw Left Outer Join 
          Nota_Saida ns        on ns.cd_nota_saida        = vw.cd_nota_saida Left Outer Join 
          Tipo_Destinatario td on ns.cd_tipo_destinatario = td.cd_tipo_destinatario Left Outer Join 
          Status_Nota sn       on ns.cd_status_nota = sn.cd_status_nota 

        Union

        Select
           ns.cd_identificacao_nota_saida,

           vw.cd_nota_saida,

--           case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--             ns.cd_identificacao_nota_saida
--           else
--             ns.cd_nota_saida                              
--           end                           as cd_nota_saida,

          ns.cd_num_formulario_nota,
          ns.dt_nota_saida,
          ns.dt_saida_nota_saida,
          ns.nm_razao_social_nota,
          ns.cd_mascara_operacao,
          ns.nm_operacao_fiscal,
          ns.cd_tipo_destinatario,
          td.nm_tipo_destinatario,
          ns.nm_fantasia_nota_saida as nm_fantasia_destinatario,
          IsNull(ns.cd_status_nota, 0) cd_status_nota,
          sn.nm_status_nota,
          --Valores sem imposto
          0 as vl_total,
          0 as vl_cancelado,
          TotalLiquido as vl_devolvido,
          --Valores com imposto
          0 as vl_total_com_imposto,
          0 as vl_cancelado_com_imposto,
          TotalLiquidoComImposto as vl_devolvido_com_imposto,
          - TotalLiquido as vl_total_liquido,
          - TotalLiquidoComImposto as vl_total_faturado
        from
          #FaturaDevolucaoAnoAnterior vw Left Outer Join 
          Nota_Saida ns        on ns.cd_nota_saida = vw.cd_nota_saida Left Outer Join 
          Tipo_Destinatario td on ns.cd_tipo_destinatario = td.cd_tipo_destinatario Left Outer Join 
          Status_Nota sn       on ns.cd_status_nota = sn.cd_status_nota ) as consulta
      Order by
        dt_nota_saida,
        cd_nota_saida
    else
      select
           ns.cd_identificacao_nota_saida,

        vw.cd_nota_saida,
--         case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--           ns.cd_identificacao_nota_saida
--         else
--           ns.cd_nota_saida                              
--         end                           as cd_nota_saida,

        ns.cd_num_formulario_nota,
        ns.dt_nota_saida,
        ns.dt_saida_nota_saida,
        ns.nm_razao_social_nota,
        ns.cd_mascara_operacao,
        ns.nm_operacao_fiscal,
        ns.cd_tipo_destinatario,
        td.nm_tipo_destinatario,
        ns.nm_fantasia_nota_saida as nm_fantasia_destinatario,
        IsNull(ns.cd_status_nota, 0) cd_status_nota,
        sn.nm_status_nota,
        --Valores sem imposto
        ( case when IsNull(vl_cancelado,0.00) > 0 then
           0 else TotalLiquido end ) as vl_total,
        vl_cancelado,
        vl_devolvido,
        --Valores com imposto
        TotalLiquidoComImposto - IsNull(vl_cancelado_com_imposto,0.00) as vl_total_com_imposto,
        vl_cancelado_com_imposto,
        vl_devolvido_com_imposto,
        TotalLiquido - (IsNull(vl_devolvido,0.00) + IsNull(vl_cancelado,0.00)) as vl_total_liquido,
        TotalLiquidoComImposto - (IsNull(vl_devolvido_com_imposto,0.00) + IsNull(vl_cancelado_com_imposto,0.00)) as vl_total_faturado
      from
        #FaturaResultado vw Left Outer Join 
        Nota_Saida ns on ns.cd_nota_saida = vw.cd_nota_saida Left Outer Join 
        Tipo_Destinatario td on ns.cd_tipo_destinatario = td.cd_tipo_destinatario Left Outer Join 
        Status_Nota sn on ns.cd_status_nota = sn.cd_status_nota
      Order by
        ns.dt_nota_saida,
        vw.cd_nota_saida

  end
  -------------------------------------------------------
  if @ic_parametro = 1 -- Consulta Resumo de Faturamento
  -------------------------------------------------------
  begin

    Declare @Bruto       Decimal(25,2)
    Declare @Devolucao   Decimal(25,2)
    Declare @Liquido     Decimal(25,2)
    Declare @Canceladas  Decimal(25,2)
    Declare @DevAnterior Decimal(25,2)

    Declare @BrutoComImposto       Decimal(25,2)
    Declare @DevolucaoComImposto   Decimal(25,2)
    Declare @LiquidoComImposto     Decimal(25,2)
    Declare @CanceladasComImposto  Decimal(25,2)
    Declare @DevAnteriorComImposto Decimal(25,2)

    -- Pegando devoluções.    
    select
      @Devolucao = sum(TotalLiquido),
      @DevolucaoComImposto = sum(TotalLiquidoComImposto)
    from 
      #FaturaDevolucao

    -- Pegando devoluções anteriores.    
    if ( @ic_devolucao_bi = 'S' )
      select   
        @DevAnterior =	IsNull(Sum(TotalLiquido),0),
        @DevAnteriorComImposto = IsNull(Sum(TotalLiquidoComImposto),0)
      from 
        #FaturaDevolucaoAnoAnterior
    else
      Select
        @DevAnterior = 0,
        @DevAnteriorComImposto = 0

    --Notas com status de cancelada
    select
      @Canceladas = sum(TotalLiquido),
      @CanceladasComImposto = sum(TotalLiquidoComImposto)
    from
      #FaturaCancelado

    --Soma de todas as notas que não foram devolvidas e não foram canceladas.
    select
      @Bruto = sum(TotalLiquido),
      @BrutoComImposto = sum(TotalLiquidoComImposto)
    from 
      #FaturaResultado

    select
      @Liquido = ISNULL(@Bruto,0) - (ISNULL(@Canceladas,0) + ISNULL(@Devolucao,0) + ISNULL(@DevAnterior,0)),
      @LiquidoComImposto = ISNULL(@BrutoComImposto,0) - (ISNULL(@CanceladasComImposto,0) + ISNULL(@DevolucaoComImposto,0) + ISNULL(@DevAnteriorComImposto,0) )
  
  Select 
    @Bruto - @Canceladas   as Bruto, 
    @Liquido               as Liquido,
    @Canceladas            as Canceladas,
    @Devolucao             as Devolucao,
    @DevAnterior           as DevAnterior,
    @BrutoComImposto  - @CanceladasComImposto   as BrutoComImposto,
    @LiquidoComImposto     as LiquidoComImposto,
    @CanceladasComImposto  as CanceladasComImposto,
    @DevolucaoComImposto   as DevolucaoComImposto,
    @DevAnteriorComImposto as DevAnteriorComImposto
  end
end
---------------------------------------------------
-- Consulta itens de uma determinada Nota
else if ( @ic_parametro = 2 )
---------------------------------------------------
begin
    select
      Case 
        When ni.cd_produto is not null then 'P'
        Else ''
      End                          as sg_tipo_item,

      ns.cd_identificacao_nota_saida,
      ns.cd_nota_saida,

--       case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--          ns.cd_identificacao_nota_saida
--       else
--          ns.cd_nota_saida                              
--       end                           as cd_nota_saida,

      ns.cd_num_formulario_nota,
      ns.dt_nota_saida,
      ns.dt_saida_nota_saida,
      ns.nm_razao_social_nota,
      ns.cd_mascara_operacao,
      ns.nm_operacao_fiscal,
      ns.cd_tipo_destinatario,
      td.nm_tipo_destinatario,
      ns.nm_fantasia_destinatario,
      ni.cd_item_nota_saida,
      ni.cd_item_pedido_venda,
      ni.cd_pedido_venda,
      ni.cd_produto                as cd_produto_servico,
      ni.nm_fantasia_produto       as nm_fantasia,    
      ni.pc_icms                   as pc_icms_iss,
      ni.pc_ipi                    as pc_ipi_irrf,
      ni.qt_item_nota_saida,
      ni.vl_unitario_item_nota,
      ni.qt_liquido_item_nota,
      ni.qt_bruto_item_nota_saida,
      ni.cd_os_item_nota_saida,
      Cast(ni.ds_item_nota_saida as varchar(255)) as ds_item_nota_saida,
      ni.cd_pd_compra_item_nota,
      ni.cd_posicao_item_nota,
      ni.vl_total_item
--     Into
--       #Tabela
    from
      Nota_Saida ns       with (nolock) 
       Left Outer Join
      Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        Left Outer Join
      Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
        Left Outer join
      Tipo_Destinatario td
        on ns.cd_tipo_destinatario = td.cd_tipo_destinatario
        Left Outer join
      Nota_Saida_Item ni
        on ns.cd_nota_saida = ni.cd_nota_saida
    Where
      IsNull(op.ic_analise_op_fiscal,'S') = ( case  
                                                 when ( @ic_comercial = 'S' ) then 'S'
                                                 else IsNull(op.ic_analise_op_fiscal,'S')
                                               end ) and
      gop.cd_tipo_operacao_fiscal = 2 and
      ni.cd_produto is not null and
      ns.cd_nota_saida = @cd_nota_saida

Union All

    Select
      Case 
        When ni.cd_servico is not null then 'S'
        Else ''
      End                          as sg_tipo_item,

      ns.cd_identificacao_nota_saida,
      ns.cd_nota_saida,

--       case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--          ns.cd_identificacao_nota_saida
--       else
--          ns.cd_nota_saida                              
--       end                           as cd_nota_saida,

      ns.cd_num_formulario_nota,
      ns.dt_nota_saida,
      ns.dt_saida_nota_saida,
      ns.nm_razao_social_nota,
      ns.cd_mascara_operacao,
      ns.nm_operacao_fiscal,
      ns.cd_tipo_destinatario,
      td.nm_tipo_destinatario,
      ns.nm_fantasia_destinatario,
      ni.cd_item_nota_saida,
      ni.cd_item_pedido_venda,
      ni.cd_pedido_venda,
      ni.cd_servico                as cd_produto_servico,
      Cast(ni.ds_servico as varchar(255)) as nm_fantasia,
      ni.pc_irrf_serv_empresa      as pc_icms_iss,
      ni.pc_iss_servico            as pc_ipi_irrf,
      ni.qt_item_nota_saida,
      ni.vl_unitario_item_nota,
      ni.qt_liquido_item_nota,
      ni.qt_bruto_item_nota_saida,
      ni.cd_os_item_nota_saida,
      Cast(ni.ds_item_nota_saida as varchar(255)) as ds_item_nota_saida,
      ni.cd_pd_compra_item_nota,
      ni.cd_posicao_item_nota,
      ni.vl_total_item

    from
      Nota_Saida ns      with (nolock) 
        Left Outer join
      Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        Left Outer Join
      Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
        Left Outer join
       Tipo_Destinatario td
        on ns.cd_tipo_destinatario = td.cd_tipo_destinatario
        Left Outer join
      Nota_Saida_Item ni
        on ns.cd_nota_saida = ni.cd_nota_saida
    Where
      IsNull(op.ic_analise_op_fiscal,'S') = ( case  
                                                 when ( @ic_comercial = 'S' ) then 'S'
                                                 else IsNull(op.ic_analise_op_fiscal,'S')
                                               end ) and
      gop.cd_tipo_operacao_fiscal = 2 and
      ni.cd_servico is not null and 
      ns.cd_nota_saida = @cd_nota_saida
    
end

