
CREATE  PROCEDURE pr_resumo_faturamento
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Johnny Mendes de Souza
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta Resumo do Faturamento
--Data			: 08/05/2002
--Alteração		: Mudança em todo o procedimento - Fabio
--Desc. Alteração	: 
-- 19/04/2004 - Colocado valores de icms e ipi - Daniel C. Neto.
-- 19/04/2004 - Colocado dev. anterior - Daniel C. Neto.
-- 23/04/2004 - Alterado parametro da fn_vl_liquido_venda - ELIAS
-- 08.06.2003 - Correção para bater os valores - FABIO
-- 09/08/2004 - Alterado Cálculo da Margem de Contribuição, a divisão é verificada
--              e caso a fn_vl_liquido_venda retorne 0 é feitoa a divisão por 1 - ELIAS
-- 11/09/2004 - Modificado cálculo de vl_faturamento_bruto - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar - Daniel C. Neto.
-- 17/02/2005 - Trocado ic_comercial_operacao por ic_analise_op_fiscal nos filtros de @ic_comercial - Clelson Camargo
-- 04.01.2006 - Análise dos valores de Faturamento Líquido - Carlos Fernandes
-- 11.03.2006 - Total do Faturamento deduzir o valor do IPI conforme parâmetro - Carlos Fernandes
-- 26.10.2006 - Inserção de Varias colunas de Valores - Márcio Rodrigues
-- 14.11.2006 - Cálculo do PIS/COFIS  e Contribuição do Faturamento 
--              Quando não está destacado no Resumo - Carlos Fernandes
-- 24.06.2007 - Dados da Nota, quando o Item estiver zerado - Carlos Fernandes
-- 07.02.2008 - Notas Fiscais Complementares - Carlos Fernandes
-- 04.08.2008 - Ajuste do Faturamento sem Itens da Nota Fiscal - Carlos Fernandes
-- 23.09.2008 - Valor Cotação / U$
-- 07.02.2008 - Complemento das Colunas / Separação por Grupo de Produto - Carlos Fernandes
-- 27.05.2009 - Ajustes Diversos - Carlos Fernades
-- 02.07.2009 - Verificação de Arredondamento - Carlos Fernandes
-- 04.08.2009 - Ajuste do Grupo de Cliente - Carlos Fernandes
-- 22.08.2009 - Separação da Devolução - Carlos Fernandes
-- 24.08.2009 - Destinação - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-- 18.11.2010 - Verificação do Tipo de SQL Server/Tratamento de Data Diferente - DD/MM/AAAA - Carlos Fernandes
-- 10.12.2010 - Ajustes Diversos/Zona Franca - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------

  @dt_inicial       datetime = '',
  @dt_final         datetime = '',
  @ic_comercial     char(1)  = 'N',
  @cd_moeda         int      = 1,
  @ic_parametro     int      = 0,
  @cd_cliente_grupo int      = 0,
  @vl_faturamento   float    = 0 OUTPUT,
  @ic_tipo_sql      int      = 0 
  
AS



  declare @dt_inicio_periodo datetime

  set @ic_tipo_sql = 0

  if @ic_tipo_sql = 0 --SQL 2000
  begin
    set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )
  end

  if @ic_tipo_sql = 8 --SQL 2008
  begin
    set
      @dt_inicio_periodo = cast( '01'+'/'+cast(month(@dt_final) as char(02))+'/'+cast(year(@dt_final) as char(04)) as datetime )
  end

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)

--select * from cliente_grupo
--select cd_cliente_grupo,* from Cliente
--select cd_cliente_grupo,* from vw_faturamento

---------------------------------------------------------------------------------------------------------------------
--Consulta do Resumo
---------------------------------------------------------------------------------------------------------------------

if @cd_cliente_grupo is null
begin
  set @cd_cliente_grupo = 0
end

--Ajusta o Grupo de Cliente

update 
  cliente
set
  cd_cliente_grupo = 1
from
  cliente with (nolock) 
where
  isnull(cd_cliente_grupo,0)=0

---------------------------------------------------------------------------------------------------------------------
 
if @ic_parametro = 0 or @ic_parametro = 5 or @ic_parametro = 7
begin

  declare @qt_total_produto          int,
          @vl_total_produto          float,
          @ic_devolucao_bi           char(1),
          @cd_aplicacao_markup       int,
          @ic_ipi_resumo_faturamento char(1),
          @ic_filtro_tipo_pedido     char(1)  --Filtrar os Pedidos sem Impostos ( Desenvolver )
  
  declare @cd_moeda_cotacao int
  declare @vl_moeda         float

  set @cd_moeda_cotacao = 2 --U$ Dólar

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  set @ic_devolucao_bi = 'N'

  --select * from parametro_bi
  
  Select 
  	top 1 @ic_devolucao_bi           = isnull(ic_devolucao_bi,'N'),
              @cd_aplicacao_markup       = isnull(cd_aplicacao_markup_fat,0),
              @ic_ipi_resumo_faturamento = isnull(ic_ipi_resumo_faturamento,'N')
              --@ic_filtro_tipo_pedido     = isnull(ic_filtro_tipo_pedido,'N')
  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()

------------------------------------------------------------------------------------------
--Montagem da Tabela Auxiliar para Checagem do Valor Total
------------------------------------------------------------------------------------------

--   select 
--     ns.cd_nota_saida,
--     ns.dt_nota_saida,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_total,0)                                         
--     end                                                                as TotalNota,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_produto,0)                                          
--     end                                                                as TotalProduto,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_frete,0)                                          
--     end                                                                as TotalFrete,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_seguro,0)   
--     end                                                                as TotalSeguro,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_desp_acess,0)                                    
--     end                                                                as TotalDespesas,
-- 
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else 
--       isnull(ns.vl_bc_icms,0)                                       
--     end                                                                as BaseICMS,
--     
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_icms,0)                                            
--     end                                                                as ValorICMS,
-- 
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_bc_subst_icms,0)  
--     end                                                                as BaseICMSSubs,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_icms_subst,0) end                                   as ValorICMSSubs,
-- 
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_bc_ipi,0) end                                       as BaseIPI,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_ipi,0)                      
--     end                                                                as ValorIPI,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_iss,0) end                                          as vl_iss,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_servico,0)                                         
--     end                                                                as vl_servico,
-- 
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--     
--     isnull(ns.vl_irrf_nota_saida,0)                                    as vl_irrf_nota_saida,
--     case when ns.cd_status_nota = 7 
--     then
--       isnull(ns.vl_total,0)
--     else
--       0.00
--     end                                                                as vl_cancelamento,
--     case when ns.cd_status_nota in (3,4) then
--       isnull(ns.vl_total,0)
--     else
--       0.00 
--     end                                                                as vl_devolucao,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(vl_inss_nota_saida,0)                                     
--     end                                                                as vl_inss_nota_saida,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(vl_csll,0) end                                            as vl_csll,
--     case when vl_pis>0    then isnull(vl_pis,0)   
--                           else isnull(vl_total,0)*(1.65/100)
--     end                                                                as vl_pis,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       case when vl_cofins>0 
--       then isnull(vl_cofins,0)
--       else isnull(vl_total,0)*(7.6/100) end  
--     end                                                                as vl_cofins,
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_mp_aplicada_nota,0) end                             as vl_mp_aplicada_nota,
--  
--     case when ns.cd_status_nota = 7 
--     then 
--       0.00
--     else
--       isnull(ns.vl_mo_aplicada_nota,0)                                
--     end                                                                as vl_mo_aplicada_nota,
--   into
--     #NotaAux
--   from
--     Nota_Saida ns with (nolock) 
--     left outer join Operacao_Fiscal    opf with (nolock)  on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
--   where
--     dt_nota_saida between @dt_inicial and @dt_final and
--     IsNull(opf.ic_analise_op_fiscal,'S') = ( case 
--                                               when (@ic_comercial = 'S' ) then 'S'
--                                               else IsNull(opf.ic_analise_op_fiscal,'S')
--                                              end ) and
--     ( IsNull(opf.cd_tipo_destinatario,1) = ( case 
--                                             when ( @ic_comercial = 'S' ) then 1
--                                             else IsNull(ns.cd_tipo_destinatario,1)
--                                           end ) or
--     IsNull(opf.cd_tipo_destinatario,2) = ( case 
--                                             when ( @ic_comercial = 'S' ) then 2
--                                             else IsNull(ns.cd_tipo_destinatario,2)
--                                           end ) ) 
-- 

  Select 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida,

--     cast(sum(
--         case when isnull(vw.cd_status_nota,5)<>7 
--         then
--           vw.vl_unitario_item_total
--         else
--           0.00
--         end) / @vl_moeda as money )                                                        as Venda,


    cast( sum(vw.vl_unitario_item_total -
          case when vw.zfm = 'N' then 0.00 else vw.Desconto_ZFM  end   
          )/@vl_moeda  as money
        )                                                                                  as Venda,
  
    count(distinct(vw.cd_nota_saida))  		                                           as Pedidos,

    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             IsNull(vw.vl_ipi,0), vw.cd_destinacao_produto, @dt_inicial)) as money)        as TotalLiquido,  

    --Valor de Lista do Produto 
    sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda                                  as TotalLista,

    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) as CustoContabil,

    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) / 
      (case when isnull(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)),0) = 0 then 1
       else cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) end) * 100  as MargemContribuicao,
  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,

    max(vw.cd_vendedor)                                                                    as Vendedor,

    cast(sum(vw.qt_item_nota_saida) as money)                                              as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item)       as money)                                              as vl_icms,
    cast(sum(vw.vl_icms_subst)      as money)                                              as vl_icms_subst,

    cast(sum(vw.vl_ipi)             as money)                                              as vl_ipi,
    cast(sum(vw.vl_frete_item)      as money)                                              as vl_frete_item,
    cast(sum(vw.vl_seguro_item)     as money)                                              as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)                                              as vl_desp_acess_item,
    cast(sum(vw.vl_produto)         as money)                                              as vl_produto,
    cast(sum(vw.vl_servico)         as money)                                              as vl_servico,
    cast(sum(vw.vl_inss_nota_saida) as money)                                              as vl_inss_nota_saida,
    cast(sum(vw.vl_csll)            as money)                                              as vl_csll,
    cast(sum(vw.vl_pis)             as money)                                              as vl_pis,            
    cast(sum(vw.vl_cofins)          as money)                                              as vl_cofins,   
    cast(sum(vw.vl_irrf_nota_saida) as money)                                              as vl_irrf_nota_saida,
    cast(sum(vw.vl_iss)             as money)                                              as vl_iss,

    --Cotaçao do U$

    isnull((select top 1 case when isnull(vm.vl_moeda,1) = 0 then 1 else isnull(vm.vl_moeda,1) end
               from Valor_Moeda vm with (nolock) 
               where 
                  vm.cd_moeda     = @cd_moeda_cotacao 
                  and vm.dt_moeda = vw.dt_nota_saida
               order by vm.dt_moeda desc),1)                                              as cotacao,

    max(nm_cliente_grupo)                                                                 as nm_cliente_grupo,
    max(cd_cliente_grupo)                                                                 as cd_cliente_grupo 



  into 
    #FaturaAnual

  from
    vw_faturamento vw
    left outer join  Produto_Custo pc  on vw.cd_produto = pc.cd_produto 
    left outer join  Produto p         on vw.cd_produto = p.cd_produto

  where

    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when (@ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and

    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or

    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) )     
   --Data de Faturamento
   and vw.dt_nota_saida between @dt_inicial and @dt_final

   and isnull(vw.cd_cliente_grupo,0) = case when isnull(@cd_cliente_grupo,0) = 0 then isnull(vw.cd_cliente_grupo,0) else isnull(@cd_cliente_grupo,0) end

  group by 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida

  order by 1 desc

-- select @cd_moeda_cotacao
-- select * from #FaturaAnual

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------

  select 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida,
--    cast(sum(vw.vl_unitario_item_total) / @vl_moeda as money )					as Venda,

    cast( sum(vw.vl_unitario_item_total -
          case when vw.zfm = 'N' then 0.00 else vw.Desconto_ZFM  end   
          )/@vl_moeda  as money
        )                                                                                       as Venda,


    count(distinct(vw.cd_nota_saida))   							as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)                       as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 																	as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money)      as CustoContabil,

    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) / 
      (case when isnull(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)),0) = 0 then 1
       else cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) end) * 100 		              as MargemContribuicao,

  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor)                              as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)        as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)              as vl_icms,
    cast(sum(vw.vl_icms_subst)      as money)        as vl_icms_subst,
    cast(sum(vw.vl_ipi) as money)                    as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)             as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)            as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)        as vl_desp_acess_item,
    cast(sum(vw.vl_produto) / @vl_moeda as money)    as vl_produto,
    cast(sum(vw.vl_servico) / @vl_moeda as money )   as vl_servico,
    cast(sum(vl_inss_nota_saida) as money)           as vl_inss_nota_saida,
    cast(sum(vl_csll) as money)                      as vl_csll,
    cast(sum(vl_pis) as money)                       as vl_pis,            
    cast(sum(vl_cofins) as money)                    as vl_cofins,   
    cast(sum(vl_irrf_nota_saida) as money)           as vl_irrf_nota_saida,
    cast(sum(vl_iss) as money)                       as vl_iss,
    max(nm_cliente_grupo)                            as nm_cliente_grupo,
    max(vw.cd_cliente_grupo)                         as cd_cliente_grupo

  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao vw      with (nolock) 
    left outer join Produto_Custo pc with (nolock) on vw.cd_produto = pc.cd_produto 
    left outer join Produto p        with (nolock) on vw.cd_produto = p.cd_produto
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

   --Grupo de Cliente
   --and vw.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then vw.cd_cliente_grupo else @cd_cliente_grupo end

   and isnull(vw.cd_cliente_grupo,0) = case when isnull(@cd_cliente_grupo,0) = 0 then isnull(vw.cd_cliente_grupo,0) else isnull(@cd_cliente_grupo,0) end


  group by 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida

  order by 1 desc

--  select * from #FaturaDevolucao

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------

  select 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_restricao_item_nota,
--    cast(sum(vw.vl_unitario_item_total) / @vl_moeda as money )					as Venda,

    cast( sum(vw.vl_unitario_item_total -
          case when vw.zfm = 'N' then 0.00 else vw.Desconto_ZFM  end   
          )/@vl_moeda  as money
        )                                                                                       as Venda,

    count(distinct(vw.cd_nota_saida))         							as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)                       as TotalLiquido,
  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda 					as TotalLista,
    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money)      as CustoContabil,

    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) / 
      (case when isnull(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)),0) = 0 then 1
       else cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) end) * 100 		              as MargemContribuicao,

  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns() 																																									as BNS,
    max(vw.cd_vendedor)                                  as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)            as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)                  as vl_icms,
    cast(sum(vw.vl_icms_subst)      as money)            as vl_icms_subst,
    cast(sum(vw.vl_ipi) as money)                        as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)                 as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)                as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)            as vl_desp_acess_item,
    cast(sum(vw.vl_produto) / @vl_moeda as money )       as vl_produto,
    cast(sum(vw.vl_servico) / @vl_moeda as money )       as vl_servico,
    cast(sum(vl_inss_nota_saida) as money)               as vl_inss_nota_saida,
    cast(sum(vl_csll) as money)                          as vl_csll,
    cast(sum(vl_pis) as money)                           as vl_pis,            
    cast(sum(vl_cofins) as money)                        as vl_cofins,   
    cast(sum(vl_irrf_nota_saida) as money)               as vl_irrf_nota_saida,
    cast(sum(vl_iss) as money)                           as vl_iss,
    max(nm_cliente_grupo)                                as nm_cliente_grupo,
    max(vw.cd_cliente_grupo)                             as cd_cliente_grupo

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

--  	(vw.dt_nota_saida < @dt_inicial) and

   (vw.dt_nota_saida < @dt_inicio_periodo) and
   vw.dt_restricao_item_nota between @dt_inicial and @dt_final

   --Grupo de Cliente
   --and vw.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then vw.cd_cliente_grupo else @cd_cliente_grupo end

   and isnull(vw.cd_cliente_grupo,0) = case when isnull(@cd_cliente_grupo,0) = 0 then isnull(vw.cd_cliente_grupo,0) else isnull(@cd_cliente_grupo,0) end


  group by 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_restricao_item_nota

  order by 
    1 desc

--select * from #FaturaDevolucaoAnoAnterior

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------

  select 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida,
 
--     cast(sum( case when isnull(vw.vl_unitario_item_atual,0)>0 
--     then vw.vl_unitario_item_atual
--     else vw.vl_total end ) / @vl_moeda as money )			                                as Venda,

     cast( sum( case when isnull(vw.vl_unitario_item_atual,0)>0 
                then vw.vl_unitario_item_atual
                else vw.vl_total end 
          -
          case when vw.zfm = 'N' then 0.00 else vw.Desconto_ZFM  end   
          )/@vl_moeda  as money
        )                                                                                       as Venda,


    count(distinct(vw.cd_nota_saida))          								as Pedidos,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money)                               as TotalLiquido,

  	sum(vw.qt_item_nota_saida * p.vl_produto) / @vl_moeda                                           as TotalLista,

    cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money)              as CustoContabil,

    cast(sum(vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda) as money) / 
      (case when isnull(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)),0) = 0 then 1
       else cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
                  vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) end) * 100 		              as MargemContribuicao,


  	cast(sum((vw.qt_item_nota_saida * pc.vl_custo_contabil_produto / @vl_moeda)) as money) 
  			 * dbo.fn_pc_bns()                                    as BNS,
    max(vw.cd_vendedor)                                                       as Vendedor,
    cast(sum(vw.qt_item_nota_saida) as money)                                 as qt_item_nota_saida,
    cast(sum(vw.vl_icms_item) as money)                                       as vl_icms,
    cast(sum(vw.vl_icms_subst)      as money)                                 as vl_icms_subst,
    cast(sum(vw.vl_ipi) as money)                                             as vl_ipi,
    cast(sum(vw.vl_frete_item) as money)                                      as vl_frete_item,
    cast(sum(vw.vl_seguro_item) as money)                                     as vl_seguro_item,
    cast(sum(vw.vl_desp_acess_item) as money)                                 as vl_desp_acess_item,
    cast(sum(vw.vl_produto)         as money)                                 as vl_produto,
    cast(sum(vw.vl_servico)        as money )                                 as vl_servico,
    cast(sum(vl_inss_nota_saida)   as money)                                  as vl_inss_nota_saida,
    cast(sum(vl_csll) as money)                                               as vl_csll,
    cast(sum(vl_pis) as money)                                                as vl_pis,            
    cast(sum(vl_cofins) as money)                                             as vl_cofins,   
    cast(sum(vl_irrf_nota_saida) as money)                                    as vl_irrf_nota_saida,
    cast(sum(vl_iss) as money)                                                as vl_iss,
    max(nm_cliente_grupo)                                                     as nm_cliente_grupo,
    max(vw.cd_cliente_grupo)                                                  as cd_cliente_grupo

  into 
    #FaturaCancelado

  from
    vw_faturamento_cancelado vw      with (nolock) 
    left outer join Produto_Custo pc with (nolock) on vw.cd_produto = pc.cd_produto 
    left outer join Produto p        with (nolock) on vw.cd_produto = p.cd_produto

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

   --Grupo de Cliente
--   and vw.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then vw.cd_cliente_grupo else @cd_cliente_grupo end

   and isnull(vw.cd_cliente_grupo,0) = case when isnull(@cd_cliente_grupo,0) = 0 then isnull(vw.cd_cliente_grupo,0) else isnull(@cd_cliente_grupo,0) end

  group by 
    vw.cd_tipo_operacao_fiscal,
    vw.dt_nota_saida

  order by 1 desc

  --select * from #FaturaCancelado

  select 
    a.cd_tipo_operacao_fiscal,
    a.dt_nota_saida, 
    a.Pedidos,

    --Valores com Imposto
    --Valor Total

  	cast(IsNull(a.Venda,0) - IsNull(d.Venda,0) as money)           as vl_faturamento_bruto,

    --Devolução
    cast(IsNull(b.Venda,0) as money)                                   as vl_devolucao,
    --Devolução Anterior
		(case @ic_devolucao_bi
	 	  when 'N' then 0
	 		else cast(IsNull(c.Venda,0) as money)
	 		end)                                           as vl_dev_anterior,
    --Cancelamento
    cast(IsNull(d.Venda,0) as money)                                   as vl_cancelamento,

    --Líquido
    cast(IsNull(a.Venda,0) - 
      ( IsNull(b.Venda,0) + (case @ic_devolucao_bi
                        	 	  when 'N' then 0
                        	 		else cast(IsNull(c.Venda,0) as money)
                       	 		 end)
        + IsNull(d.Venda,0) ) as money )                               as vl_faturamento_liquido,

    --Líquido sem Devolução do Mês Anterior
    cast(IsNull(a.Venda,0) - 
      ( IsNull(b.Venda,0) + IsNull(c.Venda,0)
                          + IsNull(d.Venda,0) ) as money )             as vl_faturamento_liquido_devolucao,


    --Líquido sem Imposto
    cast(IsNull(a.TotalLiquido,0) - 
      ( IsNull(b.TotalLiquido,0) + (case @ic_devolucao_bi
                        	 	  when 'N' then 0
                        	 		else cast(IsNull(c.TotalLiquido,0) as money)
                       	 		 end)
        + IsNull(d.TotalLiquido,0) ) as money )                       as vl_faturamento_liquido_sem_imposto,

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

  	cast(IsNull(a.vl_icms,0) -
  		(isnull(b.vl_icms,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_icms,0)
		 			 end) + 
			isnull(d.vl_icms,0)) as money) as vl_icms,

  	cast(IsNull(a.vl_icms_subst,0) -
  		(isnull(b.vl_icms_subst,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_icms_subst,0)
		 			 end) + 
			isnull(d.vl_icms_subst,0)) as money) as vl_icms_subst,

  	cast(IsNull(a.vl_ipi,0) -
  		(isnull(b.vl_ipi,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_ipi,0)
		 			 end) + 
			isnull(d.vl_ipi,0)) as money) as vl_ipi,

  	cast(IsNull(a.vl_seguro_item,0) -
  		(isnull(b.vl_seguro_item,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_seguro_item,0)
		 			 end) + 
			isnull(d.vl_seguro_item,0)) as money) as vl_seguro_item,
  	cast(IsNull(a.vl_frete_item,0) -
  		(isnull(b.vl_frete_item,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_frete_item,0)
		 			 end) + 
			isnull(d.vl_frete_item,0)) as money) as vl_frete_item,
  	cast(IsNull(a.vl_desp_acess_item,0) -
  		(isnull(b.vl_desp_acess_item,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_desp_acess_item,0)
		 			 end) + 
			isnull(d.vl_desp_acess_item,0)) as money) as vl_desp_acess_item,

  	cast(IsNull(a.vl_produto,0) -
  		(isnull(b.vl_produto,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_produto,0)
		 			 end) + 
			isnull(d.vl_produto,0)) as money)                                         as vl_produto,

  	cast(IsNull(a.vl_servico,0) -
  		(isnull(b.vl_servico,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_servico,0)
		 			 end) + 
			isnull(d.vl_servico,0)) as money)                                         as vl_servico,

  	cast(IsNull(a.vl_inss_nota_saida,0) -
  		(isnull(b.vl_inss_nota_saida,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_inss_nota_saida,0)
		 			 end) + 
			isnull(d.vl_inss_nota_saida,0)) as money)                                                as vl_inss_nota_saida,

  	cast(IsNull(a.vl_csll,0) -
  		(isnull(b.vl_csll,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_csll,0)
		 			 end) + 
			isnull(d.vl_csll,0)) as money)                                                      		 as vl_csll,

  	cast(IsNull(a.vl_pis,0) -
  		(isnull(b.vl_pis,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_pis,0)
		 			 end) + 
			isnull(d.vl_pis,0)) as money)                                                   		 as vl_pis,            

  	cast(IsNull(a.vl_cofins,0) -
  		(isnull(b.vl_cofins,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_cofins,0)
		 			 end) + 
			isnull(d.vl_cofins,0)) as money)                                                         as vl_cofins,   

  	cast(IsNull(a.vl_irrf_nota_saida,0) -
  		(isnull(b.vl_irrf_nota_saida,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_irrf_nota_saida,0)
		 			 end) + 
			isnull(d.vl_irrf_nota_saida,0)) as money)                                               as vl_irrf_nota_saida,

  	cast(IsNull(a.vl_iss,0) -
  		(isnull(b.vl_iss,0) + 
   		--Verifica o parametro do BI
			(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.vl_iss,0)
		 			 end) + 
			isnull(d.vl_iss,0)) as money)                                                           as vl_iss,

   a.cotacao,

    --Cotaçao do U$

--     isnull((select top 1 case when isnull(vm.vl_moeda,1) = 0 then 1 else isnull(vm.vl_moeda,1) end
--                from Valor_Moeda vm with (nolock) 
--                where 
--                   vm.cd_moeda = @cd_moeda_cotacao 
--                   and vm.dt_moeda <= a.dt_nota_saida
--                order by vm.dt_moeda desc),1)                                              as cotacao 


   (cast(IsNull(a.Venda,0) - IsNull(d.Venda,0) as money)/a.cotacao)        as vl_faturamento_bruto_moeda,

   (cast(IsNull(a.TotalLiquido,0) - 
      ( IsNull(b.TotalLiquido,0) + (case @ic_devolucao_bi
                        	 	  when 'N' then 0
                        	 		else cast(IsNull(c.TotalLiquido,0) as money)
                       	 		 end)
        + IsNull(d.TotalLiquido,0) ) as money )/a.cotacao)                 as vl_fat_liq_sem_imposto_moeda,
   a.nm_cliente_grupo,
   a.cd_cliente_grupo

  into 
    #FaturaResultado

  from 
    #FaturaAnual a 
    left outer join #FaturaDevolucao            b with (nolock) on a.dt_nota_saida           = b.dt_nota_saida and
                                                                   a.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal 
                                                                   --and a.cd_cliente_grupo        = b.cd_cliente_grupo

    left outer join #FaturaDevolucaoAnoAnterior c with (nolock) on a.dt_nota_saida           = c.dt_restricao_item_nota and
                                                                   a.cd_tipo_operacao_fiscal = c.cd_tipo_operacao_fiscal
                                                                   --and a.cd_cliente_grupo        = c.cd_cliente_grupo

    left outer join #FaturaCancelado            d with (nolock) on a.dt_nota_saida           = d.dt_nota_saida           and
                                                                   a.cd_tipo_operacao_fiscal = d.cd_tipo_operacao_fiscal 
                                                                   --and a.cd_cliente_grupo        = d.cd_cliente_grupo

--  select * from #FaturaResultado
  --Caso a empresa trabalha com dedução das devoluções de nota emitidas no mês anterior

  if ( @ic_devolucao_bi = 'S' )
  begin
    Insert into #FaturaResultado
    select 
      cd_tipo_operacao_fiscal,
     -- cd_cliente_grupo,
      dt_restricao_item_nota                             as dt_nota_saida,
      Pedidos,
      cast(0 as money)                                   as vl_faturamento_bruto,
      cast(0 as money)                                   as vl_devolucao,
      cast(Venda as money)                               as vl_dev_anterior,
      --Cancelamento
      cast(0 as money)                                   as vl_cancelamento,
      --Líquido
      cast( - IsNull(Venda,0) as money)                  as vl_faturamento_liquido,

      cast(0 as money )                                  as vl_faturamento_liquido_devolucao,
      --Líquido sem Imposto
      cast( - IsNull(TotalLiquido,0) as money)           as vl_faturamento_liquido_sem_imposto,
  		--Custo Contábil
    	cast( 0 as money)                                  as CustoContabil,
  		--Margem de Contribuição
  		cast( 0 as money)                                  as MargemContribuicao,
  		--BNS
    	cast( 0 as money)                                  as BNS,
      a.Vendedor,
  		--Quantidade
    	cast(IsNull(qt_item_nota_saida,0) as money)        as Qtd,
    	cast( 0 as money)       as vl_icms,
    	cast( 0 as money)       as vl_icms_subst,
    	cast( 0 as money)       as vl_ipi,
    	cast( 0 as money)       as vl_seguro_item,
    	cast( 0 as money)       as vl_frete_item,
    	cast( 0 as money)       as vl_desp_acess_item,
    	cast( 0 as money)       as vl_inss_nota_saida,
    	cast( 0 as money)       as vl_csll,
    	cast( 0 as money)       as vl_pis,
    	cast( 0 as money)       as vl_cofins,
    	cast( 0 as money)       as vl_iss,
        cast( 0 as money)       as vl_produto,
    	cast( 0 as money)       as vl_servico,
    	cast( 0 as money)       as vl_irrf_nota_saida,
        cast( 0 as money)       as vl_iss,
        cast( 0 as money)       as vl_faturamento_bruto_moeda,
        cast( 0 as money)       as vl_fat_liq_sem_imposto_moeda,
        cast('' as varchar(40)) as nm_cliente_grupo,
        cast( a.cd_cliente_grupo as int)         as cd_cliente_grupo

    from 
      #FaturaDevolucaoAnoAnterior a

    where
      not exists( Select 'x' from #FaturaResultado b where b.dt_nota_saida = a.dt_restricao_item_nota and
           b.cd_tipo_operacao_fiscal = a.cd_tipo_operacao_fiscal)  

--select * from #FaturaResultado

  end

  ----------------------------------------------------
  --Mostra o Resumo Final
  ----------------------------------------------------

  if @ic_parametro = 0
  begin
  select 
    a.dt_nota_saida,
    b.nm_tipo_operacao_fiscal                                          as  TipoOperacao,
    Pedidos                                                            as  Quantidade,
    0                                                                  as  vl_faturamento_comercial, --Compatibilidade
    vl_faturamento_bruto   - 
      case when @ic_ipi_resumo_faturamento='N' then vl_ipi else 0 end  as  vl_faturamento_bruto,

    vl_faturamento_liquido - 
      case when @ic_ipi_resumo_faturamento='N' then vl_ipi else 0 end  as vl_faturamento_liquido,

    vl_faturamento_liquido - 
      case when @ic_ipi_resumo_faturamento='N' then vl_ipi else 0 end  
    +

    vl_dev_anterior                                                    as vl_faturamento_liquido_mes,

    vl_faturamento_liquido_devolucao,
    vl_faturamento_liquido_sem_imposto                                 as vl_faturamento_liquido_imposto,

    isnull(vl_icms,0)                                                  as vl_icms,
    isnull(vl_icms_subst,0)                                            as vl_icms_subst,
    isnull(vl_ipi,0)                                                   as vl_ipi,
    isnull(vl_frete_item,0)                                            as vl_frete,
    isnull(vl_seguro_item,0)                                           as vl_seguro,
    isnull(vl_desp_acess_item,0)                                       as vl_desp_acess,
    vl_cancelamento,
    vl_dev_anterior,
    vl_devolucao,
    isnull(vl_inss_nota_saida,0)                                       as vl_inss_nota_saida,
    --csll sobre o Lucro
    isnull(vl_csll,0)                                                  as vl_csll,
    case when vl_pis>0    then isnull(vl_pis,0)   
                          else isnull(vl_faturamento_bruto,0)*(1.65/100)
    end                                                                as vl_pis,
    case when vl_cofins>0 
    then isnull(vl_cofins,0)
    else isnull(vl_faturamento_bruto,0)*(7.6/100) end                  as vl_cofins,
    isnull(vl_iss,0)                                                   as vl_iss,
--     isnull(vl_faturamento_liquido_sem_imposto,0)-
--     isnull(vl_servico,0)                                               as vl_produto,
    isnull(vl_produto,0)                                               as vl_produto,
    isnull(vl_servico,0)                                               as vl_servico,
    isnull(vl_irrf_nota_saida,0)                                       as vl_irrf_nota_saida,
    --vl_iss,
    cotacao,
    vl_faturamento_bruto_moeda,
    vl_fat_liq_sem_imposto_moeda,
    nm_cliente_grupo,
    a.cd_cliente_grupo,
    a.cd_tipo_operacao_fiscal

  into
    #FaturaResultadoB

  from 
    #FaturaResultado a
    left outer join Tipo_Operacao_Fiscal b on a.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal

  order by 1

  select
    *,

    (select 
       sum(vl_faturamento_liquido) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as SumVl_faturamento_liquidoC,

    (select 
       sum(vl_faturamento_liquido) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as SumVl_faturamento_liquidoCO,

    (select 
       sum(vl_faturamento_liquido_mes) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as SumVl_faturamento_liquidomesC,

    (select 
       sum(vl_faturamento_liquido_mes) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as SumVl_faturamento_liquidomesCO,

    (select 
       sum(vl_ipi) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_ipiC,

    (select 
       sum(vl_ipi) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_ipiCO,

    (select 
       sum(vl_faturamento_bruto) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_faturamento_brutoC,

    (select 
       sum(vl_faturamento_bruto) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_faturamento_brutoCO,

    (select 
       sum(vl_icms) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_icmsC,

    (select 
       sum(vl_icms) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_icmsCO,

    (select 
       sum(vl_icms_subst) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_icms_substC,

    (select 
       sum(vl_icms_subst) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_icms_substCO,

    (select 
       sum(vl_iss) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_issC,

    (select 
       sum(vl_iss) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_issCO,


    (select 
       sum(vl_fat_liq_sem_imposto_moeda) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_fat_liq_sem_impostoC,

    (select 
       sum(vl_fat_liq_sem_imposto_moeda) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_fat_liq_sem_impostoCO,

    (select 
       sum(vl_faturamento_bruto_moeda) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_faturamento_bruto_moC,

    (select 
       sum(vl_faturamento_bruto_moeda) 
     from 
       #FaturaResultadoB c 
     where 
       c.cd_cliente_grupo        = b.cd_cliente_grupo and 
       c.cd_tipo_operacao_fiscal = b.cd_tipo_operacao_fiscal) as Sumvl_faturamento_bruto_moCO

  from
    #FaturaResultadoB b

  order by
    cd_cliente_grupo,
    cd_tipo_operacao_fiscal,
    dt_nota_saida

  end

  --Resumo do Período Completo

  if @ic_parametro = 5
  begin

    select 
      sum( vl_faturamento_liquido_sem_imposto ) as vl_faturamento_liquido_imposto
    from
      #FaturaResultado a

  end

 --Retorno em variável

 if @ic_parametro = 7
  begin
    select 
      @vl_faturamento = sum( vl_faturamento_liquido_sem_imposto )
    from
      #FaturaResultado a

  end

end

---------------------------------------------------------------------------------------------------------------------
--Consulta das Notas fiscais no Período
---------------------------------------------------------------------------------------------------------------------

if @ic_parametro = 9
begin

  --select * from serie_nota_fiscal  
  --select * from nota_saida
  --select * from status_nota

  select 
    sn.nm_status_nota,
--    ns.cd_nota_saida,

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                              as cd_nota_saida,

    ns.cd_num_formulario_nota,
    ns.dt_nota_saida,
    td.nm_tipo_destinatario,
    ns.nm_fantasia_nota_saida,
    t.nm_fantasia                     as nm_fantasia_transportadora,
    d.nm_destinacao_produto,
    f.nm_tipo_pagamento_frete,
    v.nm_fantasia_vendedor,
    cp.nm_condicao_pagamento,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(round(ns.vl_total,2),0)                                         
    end                                                                as TotalNota,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_produto,0)                                          
    end                                                                as TotalProduto,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_frete,0)                                          
    end                                                                as TotalFrete,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_seguro,0)   
    end                                                                as TotalSeguro,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_desp_acess,0)                                    
    end                                                                as TotalDespesas,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else 
      isnull(ns.vl_bc_icms,0)                                       
    end                                                                as BaseICMS,
    
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms,0)                                            
    end                                                                as ValorICMS,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_subst_icms,0)  
    end                                                                as BaseICMSSubs,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms_subst,0) end                                   as ValorICMSSubs,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_ipi,0) end                                       as BaseIPI,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_ipi,0)                      
    end                                                                as ValorIPI,
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_iss,0) end                                          as vl_iss,
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_servico,0)                                         
    end                                                                as vl_servico,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_irrf_nota_saida,0)  end                             as vl_irrf_nota_saida,

    case when ns.cd_status_nota = 7 
    then
      isnull(ns.vl_total,0)
    else
      0.00
    end                                                                as vl_cancelamento,

    case when ns.cd_status_nota in (3,4) then
      isnull(ns.vl_total,0)
    else
      0.00 
    end                                                                as vl_devolucao,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_inss_nota_saida,0)                                     
    end                                                                as vl_inss_nota_saida,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_csll,0) end                                            as vl_csll,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_pis>0  then isnull(vl_pis,0)   
                          else isnull(vl_total,0)*(1.65/100)
      end
    end                                                                as vl_pis,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_cofins>0 
      then isnull(vl_cofins,0)
      else isnull(vl_total,0)*(7.6/100) end  
    end                                                                as vl_cofins,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mp_aplicada_nota,0) end                             as vl_mp_aplicada_nota,
 
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mo_aplicada_nota,0)                                
    end                                                                as vl_mo_aplicada_nota,
    ns.dt_cancel_nota_saida,
    ns.nm_mot_cancel_nota_saida,
    ns.dt_saida_nota_saida,
    ns.dt_entrega_nota_saida,
    ns.cd_mascara_operacao,
    ns.nm_operacao_fiscal,
    ns.cd_mascara_operacao2,
    ns.nm_operacao_fiscal2,
    ns.cd_mascara_operacao3,
    ns.nm_operacao_fiscal3,
    sf.sg_serie_nota_fiscal,

    --Valor Líquido para Comparativo para o CPV

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_total,0) - 
    ( isnull(ns.vl_icms,0)  + 
      isnull(ns.vl_ipi,0)   +
      case when ns.vl_pis>0  then isnull(vl_pis,0)   
                             else isnull(vl_total,0)*(1.65/100) end +
   
      case when ns.vl_cofins>0  then isnull(ns.vl_cofins,0)
                                else isnull(ns.vl_total,0)*(7.6/100) end  
    )
                                               
    end                                                                as TotalLiquidoNota,

    vl_moeda_cotacao = isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),1),

    isnull(opf.ic_zfm_operacao_fiscal,'N')                             as 'ZFM',

    case when isnull(opf.ic_zfm_operacao_fiscal,'N')='S' and 
              ns.cd_status_nota <> 7    
    then
      ns.vl_produto - ns.vl_total
    else
      0.00
    end                                                                as 'Desconto_ZFM'
 


--select * from operacao_fiscal
    
  from
    Nota_Saida ns                             with (nolock) 
    left outer join Transportadora t          with (nolock)  on t.cd_transportadora       = ns.cd_transportadora
    left outer join Destinacao_Produto d      with (nolock)  on d.cd_destinacao_produto   = ns.cd_destinacao_produto
    left outer join Tipo_Pagamento_Frete  f   with (nolock)  on f.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete
    left outer join Vendedor              v   with (nolock)  on v.cd_vendedor             = ns.cd_vendedor
    left outer join Status_Nota           sn  with (nolock)  on sn.cd_status_nota         = ns.cd_status_nota
    left outer join Tipo_Destinatario     td  with (nolock)  on td.cd_tipo_destinatario   = ns.cd_tipo_destinatario
    left outer join Condicao_Pagamento    cp  with (nolock)  on cp.cd_condicao_pagamento  = ns.cd_condicao_pagamento
    left outer join Serie_Nota_Fiscal     sf  with (nolock)  on sf.cd_serie_nota_fiscal   = ns.cd_serie_nota
    left outer join Operacao_Fiscal       opf with (nolock)  on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof with (nolock)  on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join Tipo_Operacao_Fiscal  tof with (nolock)  on tof.cd_tipo_operacao_fiscal = gof.cd_tipo_operacao_fiscal

  where
    dt_nota_saida between @dt_inicial and @dt_final and

    IsNull(opf.ic_analise_op_fiscal,'S') = ( case 
                                              when (@ic_comercial = 'S' ) then 'S'
                                              else IsNull(opf.ic_analise_op_fiscal,'S')
                                             end ) and

    ( IsNull(opf.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(ns.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(opf.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(ns.cd_tipo_destinatario,2)
                                          end ) ) 
    --Saídas
    and tof.cd_tipo_operacao_fiscal = 2

    --Valor Comercial
    and isnull(opf.ic_comercial_operacao,'N')='S'

  order by
    cd_nota_saida

end

--Devolução

if @ic_parametro = 10
begin

  --select * from serie_nota_fiscal  
  --select * from nota_saida
  --select * from status_nota

  select 
    sn.nm_status_nota,
--    ns.cd_nota_saida,

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                           as cd_nota_saida,

    ns.cd_num_formulario_nota,
    ns.dt_nota_saida,
    td.nm_tipo_destinatario,
    ns.nm_fantasia_nota_saida,
    t.nm_fantasia                     as nm_fantasia_transportadora,
    d.nm_destinacao_produto,
    f.nm_tipo_pagamento_frete,
    v.nm_fantasia_vendedor,
    cp.nm_condicao_pagamento,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(round(ns.vl_total,2),0)                                         
    end                                                                as TotalNota,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_produto,0)                                          
    end                                                                as TotalProduto,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_frete,0)                                          
    end                                                                as TotalFrete,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_seguro,0)   
    end                                                                as TotalSeguro,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_desp_acess,0)                                    
    end                                                                as TotalDespesas,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else 
      isnull(ns.vl_bc_icms,0)                                       
    end                                                                as BaseICMS,
    
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms,0)                                            
    end                                                                as ValorICMS,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_subst_icms,0)  
    end                                                                as BaseICMSSubs,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms_subst,0) end                                   as ValorICMSSubs,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_ipi,0) end                                       as BaseIPI,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_ipi,0)                      
    end                                                                as ValorIPI,
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_iss,0) end                                          as vl_iss,
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_servico,0)                                         
    end                                                                as vl_servico,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_irrf_nota_saida,0)  end                             as vl_irrf_nota_saida,

    case when ns.cd_status_nota = 7 
    then
      isnull(ns.vl_total,0)
    else
      0.00
    end                                                                as vl_cancelamento,

    case when ns.cd_status_nota in (3,4) then
      isnull(ns.vl_total,0)
    else
      0.00 
    end                                                                as vl_devolucao,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_inss_nota_saida,0)                                     
    end                                                                as vl_inss_nota_saida,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_csll,0) end                                            as vl_csll,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_pis>0  then isnull(vl_pis,0)   
                          else isnull(vl_total,0)*(1.65/100)
      end
    end                                                                as vl_pis,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_cofins>0 
      then isnull(vl_cofins,0)
      else isnull(vl_total,0)*(7.6/100) end  
    end                                                                as vl_cofins,

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mp_aplicada_nota,0) end                             as vl_mp_aplicada_nota,
 
    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mo_aplicada_nota,0)                                
    end                                                                as vl_mo_aplicada_nota,
    ns.dt_cancel_nota_saida,
    ns.nm_mot_cancel_nota_saida,
    ns.dt_saida_nota_saida,
    ns.dt_entrega_nota_saida,
    ns.cd_mascara_operacao,
    ns.nm_operacao_fiscal,
    ns.cd_mascara_operacao2,
    ns.nm_operacao_fiscal2,
    ns.cd_mascara_operacao3,
    ns.nm_operacao_fiscal3,
    sf.sg_serie_nota_fiscal,

    --Valor Líquido para Comparativo para o CPV

    case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_total,0) - 
    ( isnull(ns.vl_icms,0)  + 
      isnull(ns.vl_ipi,0)   +
      case when ns.vl_pis>0  then isnull(vl_pis,0)   
                             else isnull(vl_total,0)*(1.65/100) end +
   
      case when ns.vl_cofins>0  then isnull(ns.vl_cofins,0)
                                else isnull(ns.vl_total,0)*(7.6/100) end  
    )
                                               
    end                                                                as TotalLiquidoNota,

    vl_moeda_cotacao = isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),1)   
     
    
  from
    Nota_Saida ns                             with (nolock) 
    left outer join Transportadora t          with (nolock)  on t.cd_transportadora       = ns.cd_transportadora
    left outer join Destinacao_Produto d      with (nolock)  on d.cd_destinacao_produto   = ns.cd_destinacao_produto
    left outer join Tipo_Pagamento_Frete  f   with (nolock)  on f.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete
    left outer join Vendedor              v   with (nolock)  on v.cd_vendedor             = ns.cd_vendedor
    left outer join Status_Nota           sn  with (nolock)  on sn.cd_status_nota         = ns.cd_status_nota
    left outer join Tipo_Destinatario     td  with (nolock)  on td.cd_tipo_destinatario   = ns.cd_tipo_destinatario
    left outer join Condicao_Pagamento    cp  with (nolock)  on cp.cd_condicao_pagamento  = ns.cd_condicao_pagamento
    left outer join Serie_Nota_Fiscal     sf  with (nolock)  on sf.cd_serie_nota_fiscal   = ns.cd_serie_nota
    left outer join Operacao_Fiscal       opf with (nolock)   on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join Tipo_Operacao_Fiscal  tof with (nolock) on tof.cd_tipo_operacao_fiscal = gof.cd_tipo_operacao_fiscal
  where
    dt_nota_saida between @dt_inicial and @dt_final and

    IsNull(opf.ic_analise_op_fiscal,'S') = ( case 
                                              when (@ic_comercial = 'S' ) then 'S'
                                              else IsNull(opf.ic_analise_op_fiscal,'S')
                                             end ) and

    ( IsNull(opf.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(ns.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(opf.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(ns.cd_tipo_destinatario,2)
                                          end ) ) 
    --Saídas
    and tof.cd_tipo_operacao_fiscal = 2

    --Valor Comercial
    and isnull(opf.ic_comercial_operacao,'N')='S'

    --Somente o Status de Devolução
    --select * from status_nota
    and ns.cd_status_nota in ( 3,4 ) --Devolução 

  order by
    cd_nota_saida

end

--Faturamento por Cliente

if @ic_parametro = 11
begin

  --select * from serie_nota_fiscal  
  --select * from nota_saida
  --select * from status_nota

  select 
   
    td.nm_tipo_destinatario,
    ns.nm_fantasia_nota_saida,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(round(ns.vl_total,2),0)                                         
    end)                                                                as TotalNota,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_produto,0)                                          
    end)                                                                as TotalProduto,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_frete,0)                                          
    end)                                                                as TotalFrete,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_seguro,0)   
    end)                                                                as TotalSeguro,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_desp_acess,0)                                    
    end)                                                                as TotalDespesas,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else 
      isnull(ns.vl_bc_icms,0)                                       
    end)                                                                as BaseICMS,
    
    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms,0)                                            
    end)                                                                as ValorICMS,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_subst_icms,0)  
    end)                                                                as BaseICMSSubs,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_icms_subst,0)
    end)                                                                as ValorICMSSubs,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_bc_ipi,0)
    end)                                                                as BaseIPI,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_ipi,0)                      
    end)                                                                as ValorIPI,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_iss,0)
    end)                                                                as vl_iss,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_servico,0)                                         
    end)                                                                as vl_servico,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_irrf_nota_saida,0)  
    end)                                                                as vl_irrf_nota_saida,

    sum(case when ns.cd_status_nota = 7 
    then
      isnull(ns.vl_total,0)
    else
      0.00
    end)                                                                as vl_cancelamento,

    sum(case when ns.cd_status_nota in (3,4) then
      isnull(ns.vl_total,0)
    else
      0.00 
    end)                                                                as vl_devolucao,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_inss_nota_saida,0)                                     
    end)                                                                as vl_inss_nota_saida,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(vl_csll,0)
    end)                                                                as vl_csll,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_pis>0  then isnull(vl_pis,0)   
                          else isnull(vl_total,0)*(1.65/100)
      end
    end)                                                                as vl_pis,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      case when vl_cofins>0 
      then isnull(vl_cofins,0)
      else isnull(vl_total,0)*(7.6/100) end  
    end)                                                                as vl_cofins,

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mp_aplicada_nota,0)
    end)                                                                as vl_mp_aplicada_nota,
 
    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_mo_aplicada_nota,0)                                
    end)                                                                as vl_mo_aplicada_nota,

    --Valor Líquido para Comparativo para o CPV

    sum(case when ns.cd_status_nota = 7 
    then 
      0.00
    else
      isnull(ns.vl_total,0) - 
    ( isnull(ns.vl_icms,0)  + 
      isnull(ns.vl_ipi,0)   +
      case when ns.vl_pis>0  then isnull(vl_pis,0)   
                             else isnull(vl_total,0)*(1.65/100) end +
   
      case when ns.vl_cofins>0  then isnull(ns.vl_cofins,0)
                                else isnull(ns.vl_total,0)*(7.6/100) end  
    )
                                               
    end)                                                                as TotalLiquidoNota

     
    
  from
    Nota_Saida ns                             with (nolock) 
    left outer join Transportadora t          with (nolock)  on t.cd_transportadora       = ns.cd_transportadora
    left outer join Destinacao_Produto d      with (nolock)  on d.cd_destinacao_produto   = ns.cd_destinacao_produto
    left outer join Tipo_Pagamento_Frete  f   with (nolock)  on f.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete
    left outer join Vendedor              v   with (nolock)  on v.cd_vendedor             = ns.cd_vendedor
    left outer join Status_Nota           sn  with (nolock)  on sn.cd_status_nota         = ns.cd_status_nota
    left outer join Tipo_Destinatario     td  with (nolock)  on td.cd_tipo_destinatario   = ns.cd_tipo_destinatario
    left outer join Condicao_Pagamento    cp  with (nolock)  on cp.cd_condicao_pagamento  = ns.cd_condicao_pagamento
    left outer join Serie_Nota_Fiscal     sf  with (nolock)  on sf.cd_serie_nota_fiscal   = ns.cd_serie_nota
    left outer join Operacao_Fiscal       opf with (nolock)   on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join Tipo_Operacao_Fiscal  tof with (nolock) on tof.cd_tipo_operacao_fiscal = gof.cd_tipo_operacao_fiscal
  where
    dt_nota_saida between @dt_inicial and @dt_final and

    IsNull(opf.ic_analise_op_fiscal,'S') = ( case 
                                              when (@ic_comercial = 'S' ) then 'S'
                                              else IsNull(opf.ic_analise_op_fiscal,'S')
                                             end ) and

    ( IsNull(opf.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(ns.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(opf.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(ns.cd_tipo_destinatario,2)
                                          end ) ) 
    --Saídas
    and tof.cd_tipo_operacao_fiscal = 2

    --Valor Comercial
    and isnull(opf.ic_comercial_operacao,'N')='S'

    --Somente o Status de Devolução
    --select * from status_nota
    --and ns.cd_status_nota in ( 3,4 ) --Devolução 

  group by
    td.nm_tipo_destinatario,
    ns.nm_fantasia_nota_saida

  order by
    td.nm_tipo_destinatario,
    ns.nm_fantasia_nota_saida

end



--select * from grupo_operacao_fiscal
--select * from tipo_operacao_fiscal
--select * from operacao_fiscal
---------------------------------------------------------------------------------------------------------------------
--Consulta das Notas fiscais no Ano
--Desenvolver
---------------------------------------------------------------------------------------------------------------------
-- if @ic_parametro=5
-- begin
-- 
-- end

