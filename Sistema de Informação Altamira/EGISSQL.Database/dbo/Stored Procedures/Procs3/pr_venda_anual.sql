
CREATE PROCEDURE pr_venda_anual
--------------------------------------------------------------------------------------
--GBS-GLOBAL BUSINESS SOLUTION LDA                                                2000                     
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Vendas Anuais
--Data          : 24.01.2000
--Atualizado    : 30.01.2000
--              : 06.06.2000 - Carlos  
--              : 26.10.2000 - Lucio : Incluida a linha "set nocount on" 
--              : 15.01.2001 - Média Anual
--              : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--              : 01.08.2002 - Duela
--              : 04/09/2002 - Filtro por Ano - Daniel C. Neto.
--              : 20/11/2003 - Acertos no Cálculo - Daniel C. Neto.
--              : 23.04.2004 - Inclusão de coluna para cálculo do Valor Líquido - Igor Gama
--                09/09/2004 - Acerto para trazer todos os anos quando ano = 0 - Daniel C. Neto.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 02.11.2007 - Mostrar o Saldo em Carteira de Pedidos - Carlos Fernandes
-- 21.11.2007 - Mostrar o Soma Total de Quantidade de Produtos - Carlos Fernandes
-- 27.12.2007 - Data de Entrega - Carlos Fernandes
-- 13.04.2010 - Conversão pela Moeda - Carlos Fernandes
--------------------------------------------------------------------------------------
@cd_ano   int = 0,
@cd_moeda int = 1

as

  declare @vl_moeda                float
  declare @ic_tipo_conversao_moeda char(1)

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  Select 
    top 1 
      @ic_tipo_conversao_moeda  = isNull(ic_tipo_conversao_moeda,'U')
  from 
      Parametro_BI with (nolock) 
  where
      cd_empresa = dbo.fn_empresa()

  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount on

  ----------------------------------------------------
  -- Total de Vendas Anual
  ----------------------------------------------------
  select 
    year(dt_pedido_venda)                                             as 'Ano' , 
    sum(qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda)   as 'Vendas', 
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido *
        qt_item_pedido_venda) / @vl_moeda, 
        pc_icms, pc_ipi, cd_destinacao_produto, ''))                  as 'TotalLiquido',
    count(distinct cd_pedido_venda)                                   as 'Pedidos',

    --por data de emissão do Pedido

    sum (case when isnull(qt_saldo_pedido_venda,0)>0 then
          qt_saldo_pedido_venda * vl_unitario_item_pedido / @vl_moeda
          --qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda
         else 0 end )                                                 as 'TotalCarteiraEntrega',

    sum(qt_item_pedido_venda)                                         as 'Quantidade',

    --Por data de Entrega

    ( select sum (case when isnull(we.qt_saldo_pedido_venda,0)>0 
      then
          we.qt_saldo_pedido_venda * we.vl_unitario_item_pedido / @vl_moeda
      else
          0.00 end )
      from
        vw_venda_bi we
      where
        isnull(we.qt_saldo_pedido_venda,0) > 0 and
        year(we.dt_entrega_vendas_pedido)=case when @cd_ano = 0 then year(we.dt_pedido_venda) else @cd_ano end ) 
        

          --qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda
                                                          as 'TotalCarteira'
  into 
    #VendaAnual
  from
    vw_venda_bi wi

  where
  	year(dt_pedido_venda) = (case when @cd_ano = 0 then
                              year(dt_pedido_venda) else @cd_ano end)

  Group by 
  	year(dt_pedido_venda) 
  Order by 
  	1 desc


  declare   @vl_total_vendas      float
  declare   @vl_total_meta_vendas float  
  
  set       @vl_total_vendas      = 0
  set       @vl_total_meta_vendas = 0

  select    
  	@vl_total_vendas = @vl_total_vendas + vendas
  From
   	#VendaAnual

  --Busca o Valor Total da Meta
  select
    @vl_total_meta_vendas = sum ( isnull(vl_venda_mes_meta,0) )
  from
   Meta_venda
  where
   year(dt_final_meta_venda ) = case when @cd_ano = 0 then year(dt_final_meta_venda) else @cd_ano end

  select 
    ano,
    vendas,
    (vendas/12)                   as 'media_anual',
    (vendas/@vl_total_vendas)*100 as 'perc',
    pedidos,
    @vl_total_meta_vendas         as 'metames',  -- Não foi definido.
    TotalLiquido,
    TotalCarteira, 
    Quantidade,
    TotalCarteiraEntrega

  from
   #VendaAnual

--select * from meta_venda

