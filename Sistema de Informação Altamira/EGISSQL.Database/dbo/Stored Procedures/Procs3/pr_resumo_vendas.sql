
create procedure pr_resumo_vendas
------------------------------------------------------------------------
--pr_resumo_vendas
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                               2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Resumo de Vendas por período
--Data			: 05.05.2004
--Alteração             : 09/08/2004 - Inclusão do Campo QtdPedidos, para manter a 
--                        compatibilidade com a janela - ELIAS
--                      : 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--                        - Daniel C. Neto.
--                      : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 24.05.2006 - Acertos diversos - Carlos Fernandes
--                      : 30.05.2006 - Tipo de Mercado - Carlos Fernandes
--                      : 26.03.2007 - Frete, IPI - Carlos Fernandes
--                      : 28.03.2007 - Acerto no total geral ( somar frete )  - Anderson
---------------------------------------------------------------------------------------------------------------------

 @dt_inicial      datetime,
 @dt_final        datetime,
 @cd_moeda        int = 1,
 @cd_tipo_mercado int = 0

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


  Select
    pv.dt_pedido_venda,
    cast(count(distinct pv.cd_pedido_venda) as float) as 'QtdPedido',

    sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)  - 

      sum(case when (IsNull(pvi.dt_cancelamento_item,'') <> '') or (IsNull(pv.dt_cancelamento_pedido,'') <> '')
               then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)
               else 0
          end)                                                                           as 'ValorTotal',

    sum(dbo.fn_vl_liquido_venda('V',(pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) / @vl_moeda, 
                                 pvi.pc_icms, pvi.pc_ipi, pv.cd_destinacao_produto, '')) as 'ValorLiquido',
 
    sum(pvi.qt_item_pedido_venda * pvi.vl_lista_item_pedido / @vl_moeda)  - 
      sum(case when (IsNull(pvi.dt_cancelamento_item,'') <> '') or (IsNull(pv.dt_cancelamento_pedido,'') <> '')
               then (pvi.qt_item_pedido_venda * pvi.vl_lista_item_pedido / @vl_moeda)
               else 0
          end)                     as 'ValorLista',
 
    count(distinct pv.cd_cliente)  as 'Clientes',
    count(distinct pv.cd_vendedor) as 'Vendedor',
    sum(case when pvi.qt_saldo_pedido_venda > 0 
             then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda) -
                  (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)
                      
             else (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)
        end) as 'ValorFaturada',
    sum(case when IsNull(pvi.dt_cancelamento_item,'') <> ''
             then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)
             else 0
        end) as 'ValorCancelado',
    sum( isnull(pvi.vl_frete_item_pedido,0))                                                     as 'ValorFrete',
    sum( (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (pvi.pc_ipi/100))/@vl_moeda ) as 'ValorIPI',

    sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda) 
    + --Frete
    sum( isnull(pv.vl_frete_pedido_venda,0))
    + --IPI
     sum((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (pvi.pc_ipi/100))/@vl_moeda)
    - --Cancelamento
    sum(case when (IsNull(pvi.dt_cancelamento_item,'') <> '') or (IsNull(pv.dt_cancelamento_pedido,'') <> '')
               then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido / @vl_moeda)
               else 0
          end)                                                                                   as 'ValorTotalIPI'


  From
    Pedido_Venda pv
    Left outer join Pedido_Venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda
    Left outer join cliente c             on c.cd_cliente       = pv.cd_cliente   
  Where
    convert(varchar(7),isnull(pvi.dt_cancelamento_item, DateAdd(month,1,pv.dt_pedido_venda)),121) > 
    convert(varchar(7),pv.dt_pedido_venda,121)                 AND
    isnull(pv.ic_consignacao_pedido, 'N') <> 'S'               AND 
    pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido > 0 AND 
    isnull(pv.ic_amostra_pedido_venda,'N') <> 'S'              AND
    isnull(pv.vl_total_pedido_venda,0) > 0                     and                           
    pv.dt_pedido_venda between @dt_inicial and @dt_final
    and isnull(pv.ic_consignacao_pedido,'N') <> 'S'
    and pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido >  0
    and isnull(c.cd_tipo_mercado,0) = case when isnull(@cd_tipo_mercado,0) = 0 then isnull(c.cd_tipo_mercado,0) else @cd_tipo_mercado end 
  Group By
    pv.dt_pedido_venda
  Order by pv.dt_pedido_venda

