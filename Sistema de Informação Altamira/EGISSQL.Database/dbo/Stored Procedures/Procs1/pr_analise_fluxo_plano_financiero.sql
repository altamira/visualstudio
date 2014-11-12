
CREATE PROCEDURE pr_analise_fluxo_plano_financiero

--sp_helptext pr_analise_fluxo_plano_financiero
-----------------------------------------------------------------------------------------
--GBS Global Business Solution                 2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Carlos Cardoso Fernandes
--Banco de Dados  : EGISSQL
--Objetivo        : Consulta de Movimentação de Plano Financeiro para Fluxo de Caixa
--Data            : 10.09.2007
--Atualizado      : 
------------------------------------------------------------------------------------------------------------------

@dt_inicial 			datetime = '',
@dt_final 			datetime = '',
@cd_loja                        int      = 0

AS

-- Declarando e pegando saldo inicial das contas  
  
declare @SaldoInicial             float  
declare @SaldoContaBanco          float  
declare @cd_conta_banco           int  
declare @ic_pagamento_fluxo       char(1)
declare @dt_vencimento            datetime
declare @vl_saldo_acumulado       float
declare @cd_tipo_lancamento_fluxo int  
declare @dt_saldo_conta           datetime
declare @ic_previsao_saldo        char(1)
declare @ic_saldo_atual_fluxo     char(1)
declare @dt_saldo_hoje            datetime

set @dt_saldo_hoje = cast(convert(int,getdate(),103) as datetime)

set @cd_tipo_lancamento_fluxo = 2 --Realizado  


--Verificar se os Valores Pagos devem ser Considerados no Fluxo
--Carlos 22.11.2005

select
  @ic_pagamento_fluxo   = isnull(ic_pagamento_fluxo,'N'),
  @ic_previsao_saldo    = isnull(ic_previsao_saldo,'N'),
  @ic_saldo_atual_fluxo = isnull(ic_saldo_atual_fluxo,'N')
from
  Parametro_Financeiro
where
  cd_empresa = dbo.fn_empresa()

--Verifica se foi passado o parâmetro loja

set @cd_loja = isnull(@cd_loja,0)

-- set @vl_saldo_acumulado = IsNull(( select top 1 vl_previsto_saldo
--                             from Documento_Previsto_Saldo
--                             where dt_previsto_saldo < @dt_inicial
--                             order by dt_previsto_saldo desc ),0)

set @vl_saldo_acumulado = 0

-- Pegando os valores dos Pagamentos a Receber no período.

SELECT     drp.dt_pagamento_documento              as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           sum( case when @ic_pagamento_fluxo='S' then
              ( isnull(drp.vl_pagamento_documento, 0) - isnull(drp.vl_juros_pagamento, 0)     
           + isnull(drp.vl_desconto_documento, 0) + isnull(drp.vl_abatimento_documento, 0)
           - isnull(drp.vl_despesa_bancaria, 0)+ isnull(drp.vl_reembolso_documento, 0)
           - isnull(drp.vl_credito_pendente, 0)) else 0 end ) as vl_pagamento_documento_receber,
           cast( 0 as Float)                       as vl_pagamento_documento_pagar,
           cast( 0 as Float)                       as vl_saldo_documento_receber,
           cast( 0 as Float)                       as vl_saldo_documento_pagar,
           cast( 0 as Float)                       as vl_saldo_previsto_entrada,
           cast( 0 as Float)                       as vl_saldo_previsto_saida,
           cast( 0 as float)                       as vl_desconto_documento,
           cast( 0 as float)                       as vl_previsao_vendas,
           cast( 0 as float)                       as vl_previsao_compras,
           cast( 0 as float)                       as vl_atraso

into #TabDocumentoReceberPagamento
FROM      
  Documento_Receber_Pagamento drp 
  left outer join Documento_Receber dr on dr.cd_documento_receber = drp.cd_documento_receber
  left outer join Loja l               on l.cd_loja               = dr.cd_loja 
  left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dr.cd_plano_financeiro          
WHERE
  ( drp.dt_pagamento_documento between @dt_inicial and @dt_final  ) and
  --Lote
  ( isnull(dr.cd_lote_receber,0)=0 )                                and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
group by 
  drp.dt_pagamento_documento,
  pf.cd_plano_financeiro


--Buscando os Valores de Documentos Descontados no Período
--Desconto = Entrada no Fluxo de Caixa
--
--select * from documento_receber_desconto

SELECT     drd.dt_desconto_documento                 as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           sum( isnull(drd.vl_desconto_documento,0)) as vl_desconto_documento,
           cast( 0 as float)                         as vl_previsao_vendas,
           cast( 0 as float)                         as vl_previsao_compras,
           cast( 0 as float)                         as vl_atraso



into #TabDocumentoReceberDesconto
FROM      
  Documento_Receber_Desconto drd
  left outer join Documento_Receber dr on dr.cd_documento_receber = drd.cd_documento_receber
  left outer join Loja l               on l.cd_loja               = dr.cd_loja 
  left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dr.cd_plano_financeiro          
          
WHERE
  ( drd.dt_desconto_documento between @dt_inicial and @dt_final  ) and
  --Lote
  ( isnull(dr.cd_lote_receber,0) = 0 )                             and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
group by 
  drd.dt_desconto_documento,
  pf.cd_plano_financeiro

--Buscando os Valores de Documentos Descontados no Período
--Desconto = Saída no Fluxo de Caixa
--

SELECT     dr.dt_vencimento_documento                   as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as float)                            as vl_pagamento_documento_receber,
           cast( 0 as Float)                            as vl_pagamento_documento_pagar,
           sum( isnull(dr.vl_saldo_documento,0)*-1)     as vl_saldo_documento_receber,
           cast( 0 as Float)                            as vl_saldo_documento_pagar,
           cast( 0 as Float)                            as vl_saldo_previsto_entrada,
           cast( 0 as Float)                            as vl_saldo_previsto_saida,
           cast( 0 as Float)                            as vl_desconto_documento,
           cast( 0 as float)                            as vl_previsao_vendas,
           cast( 0 as float)                            as vl_previsao_compras,
           cast( 0 as float)                            as vl_atraso



into #TabDocumentoReceberDescontoSaida
FROM      
  Documento_Receber_Desconto drd with (nolock)
  left outer join Documento_Receber dr on dr.cd_documento_receber = drd.cd_documento_receber
  left outer join Loja l               on l.cd_loja               = dr.cd_loja 
  left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dr.cd_plano_financeiro          
          
WHERE
  ( drd.dt_desconto_documento  between @dt_inicial and @dt_final  ) and
  ( dr.dt_vencimento_documento between @dt_inicial and @dt_final )  and
  --Lote
  ( isnull(dr.cd_lote_receber,0) = 0 )                             and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
group by 
  dr.dt_vencimento_documento,
  pf.cd_plano_financeiro


--select * from #TabDocumentoReceberDescontoSaida

--select * from documento_receber


-- Pegando os valores dos Pagamentos Previstos no Período.

SELECT     dbo.fn_dia_util(dr.dt_vencimento_documento+ IsNull(max(p.qt_credito_efetivo),0),'S','U') as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as Float)                                   as vl_pagamento_documento_receber,
           cast( 0 as Float)                                   as vl_pagamento_documento_pagar,
           sum(IsNull(dr.vl_saldo_documento,0))                as vl_saldo_documento_receber,
           cast( 0 as Float)                                   as vl_saldo_documento_pagar,
           cast( 0 as Float)                                   as vl_saldo_previsto_entrada,
           cast( 0 as Float)                                   as vl_saldo_previsto_saida,
           cast( 0 as float)                                   as vl_desconto_documento,
           cast( 0 as float)                                   as vl_previsao_vendas,
           cast( 0 as float)                                   as vl_previsao_compras,
           case when sum(isnull(dr.vl_saldo_documento,0))>0 and dr.dt_vencimento_documento < getdate() - 1
                then
                  sum(dr.vl_saldo_documento)
                else           
                  cast( 0 as float)
                end                                           as vl_atraso



into #TabDocumentoReceber
FROM
  Documento_Receber dr
  left outer join Portador p on p.cd_portador = dr.cd_portador
  left outer join Loja l     on l.cd_loja     = dr.cd_loja
  left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dr.cd_plano_financeiro          
            
WHERE
  ( dbo.fn_dia_util(( dr.dt_vencimento_documento + IsNull(p.qt_credito_efetivo,0) ),'S','U') between @dt_inicial and @dt_final ) and
  ((dr.dt_cancelamento_documento is null) or (dr.dt_cancelamento_documento > @dt_final)) and
  ((dr.dt_devolucao_documento    is null) or (dr.dt_devolucao_documento    > @dt_final)) and
  ( isnull(dr.cd_lote_receber,0) = 0 )                                                   and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )

group by 
   dr.dt_vencimento_documento,
   pf.cd_plano_financeiro


-- Pegando os valores dos Documentos Pagos no Período.
-- select * from documento_pagar

SELECT     dpp.dt_pagamento_documento                  as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as Float)                           as vl_pagamento_documento_receber,
           sum( case when @ic_pagamento_fluxo='S' then 
               isnull(dpp.vl_pagamento_documento,0)+
               isnull(dpp.vl_juros_documento_pagar,0)-
               isnull(dpp.vl_desconto_documento,0)-
               isnull(dpp.vl_abatimento_documento,0)
                                              else 0 end ) as vl_pagamento_documento_pagar,
           cast( 0 as Float)                           as vl_saldo_documento_receber,
           cast( 0 as Float)                           as vl_saldo_documento_pagar,
           cast( 0 as Float)                           as vl_saldo_previsto_entrada,
           cast( 0 as Float)                           as vl_saldo_previsto_saida,
           cast( 0 as float)                           as vl_desconto_documento,
           cast( 0 as float)                           as vl_previsao_vendas,
           cast( 0 as float)                           as vl_previsao_compras,
           cast( 0 as float)                           as vl_atraso



into #TabDocumentoPagarPagamento

FROM 
  Documento_Pagar_Pagamento dpp
  left outer join Documento_Pagar dp on dp.cd_documento_pagar = dpp.cd_documento_pagar
  left outer join Loja l             on l.cd_loja = dp.cd_loja
  left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dp.cd_plano_financeiro          
                                
WHERE 
  ( dpp.dt_pagamento_documento between @dt_inicial and @dt_final ) and
  ( isnull(dp.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dp.cd_loja,0) end )

group by 
  dpp.dt_pagamento_documento,
  pf.cd_plano_financeiro



-- Pegando os valores dos documentos a pagar no período.

SELECT     dbo.fn_dia_util(dp.dt_vencimento_documento,'S','U') as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as Float)                                   as vl_pagamento_documento_receber,
           cast( 0 as Float)                                   as vl_pagamento_documento_pagar,
           cast( 0 as Float)                                   as vl_saldo_documento_receber,
           sum(IsNull(dp.vl_saldo_documento_pagar,0))          as vl_saldo_documento_pagar,
           cast( 0 as Float)                                   as vl_saldo_previsto_entrada,
           cast( 0 as Float)                                   as vl_saldo_previsto_saida,
           cast( 0 as float)                                   as vl_desconto_documento,
           cast( 0 as float)                                   as vl_previsao_vendas,
           cast( 0 as float)                                   as vl_previsao_compras,
           cast( 0 as float)                                   as vl_atraso

into #TabDocumentoPagar

FROM  
   Documento_Pagar dp  
   left outer join Loja l on l.cd_loja = dp.cd_loja
   left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = dp.cd_plano_financeiro          
                                
WHERE     ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final ) and
          ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final)) and
          ((dp.dt_devolucao_documento is null) or (dp.dt_devolucao_documento > @dt_final)) and
          ( isnull(dp.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dp.cd_loja,0) end )


group by 
  dp.dt_vencimento_documento,
  pf.cd_plano_financeiro


-- Pegando Documentos Previstos de Entrada.

SELECT     
           dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as Float) as vl_pagamento_documento_receber,
           cast( 0 as Float) as vl_pagamento_documento_pagar,
           cast( 0 as Float) as vl_saldo_documento_receber,
           cast( 0 as Float) as vl_saldo_documento_pagar,
           sum(IsNull(dp.vl_vencimento_previsto,0))           as vl_saldo_previsto_entrada,
           cast( 0 as Float)                                  as vl_saldo_previsto_saida,
           cast( 0 as float)                                  as vl_desconto_documento,
           cast( 0 as float)                                  as vl_previsao_vendas,
           cast( 0 as float)                                  as vl_previsao_compras,
           cast( 0 as float)                                  as vl_atraso


into #TabDocumentoPrevistoEntrada
FROM       Documento_Previsto_Vencimento dp  inner join
           Documento_Previsto d   on d.cd_documento_previsto = dp.cd_documento_previsto left outer join
           Portador p             on p.cd_portador = d.cd_portador
           left outer join Loja l on l.cd_loja     = d.cd_loja         
           left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = d.cd_plano_financeiro          
                                
WHERE     ( dbo.fn_dia_util(dp.dt_vencimento_previsto + IsNull(p.qt_credito_efetivo,0),'S','U') between @dt_inicial and @dt_final )  and
          ( d.cd_tipo_operacao = 2 ) and
          ( isnull(d.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(d.cd_loja,0) end )


group by 
  dp.dt_vencimento_previsto,
  pf.cd_plano_financeiro


-- Pegando Documentos Previstos de Saída.

SELECT     dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') as 'Vencimento',
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as Float) as vl_pagamento_documento_receber,
           cast( 0 as Float) as vl_pagamento_documento_pagar,
           cast( 0 as Float) as vl_saldo_documento_receber,
           cast( 0 as Float) as vl_saldo_documento_pagar,
           cast( 0 as Float) as vl_saldo_previsto_entrada,
           sum(IsNull(dp.vl_vencimento_previsto,0))           as vl_saldo_previsto_saida,
           cast( 0 as float)                                  as vl_desconto_documento,
           cast( 0 as float)                                  as vl_previsao_vendas,
           cast( 0 as float)                                  as vl_previsao_compras,
           cast( 0 as float)                                  as vl_atraso


into #TabDocumentoPrevistoSaida

FROM       Documento_Previsto_Vencimento dp  inner join
           Documento_Previsto d   on d.cd_documento_previsto = dp.cd_documento_previsto
           left outer join Loja l on l.cd_loja = d.cd_loja
           left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = d.cd_plano_financeiro          
                                
WHERE     ( dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') between @dt_inicial and @dt_final )  and
          ( d.cd_tipo_operacao = 1 ) and
          ( isnull(d.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(d.cd_loja,0) end )

group by 
  dp.dt_vencimento_previsto,
  pf.cd_plano_financeiro


-----------------------------------------------------------------------------------------
--Previsão de Vendas
-----------------------------------------------------------------------------------------
--select * from pedido_venda_item
--select * from condicao_pagamento_parcela order by cd_condicao_pagamento,cd_condicao_parcela_pgto
--select * from condicao_pagamento

select
 pv.cd_condicao_pagamento,
 pvi.dt_entrega_vendas_pedido,
 pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido as vl_total,
 cp.qt_parcela_condicao_pgto,
 cpp.pc_condicao_parcela_pgto,
 cpp.qt_dia_cond_parcela_pgto,
  ( pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido ) * ( cpp.pc_condicao_parcela_pgto/100) as Parcela,
  pvi.dt_entrega_vendas_pedido + cpp.qt_dia_cond_parcela_pgto                                       as Vencimento,      
  pv.cd_plano_financeiro
into
  #PrevisaoVenda
from
  pedido_venda pv
  inner join pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
  inner join condicao_pagamento cp on cp.cd_condicao_pagamento = pv.cd_condicao_pagamento
  inner join condicao_pagamento_parcela cpp on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
where
  --pv.dt_pedido_venda between @dt_inicial and @dt_final and
  (pvi.dt_entrega_vendas_pedido + cpp.qt_dia_cond_parcela_pgto ) between @dt_inicial and @dt_final and
  pvi.dt_cancelamento_item is null and
  isnull(pvi.qt_saldo_pedido_venda,0)>0

--select * from #previsaovenda

--Montagem da Tabela Final de Previsão de Vendas

SELECT     
           p.Vencimento,
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           cast( 0 as float)                         as vl_desconto_documento,
           sum( p.Parcela )                            as vl_previsao_vendas,
           cast( 0 as float )                        as vl_previsao_compras,
           cast( 0 as float)                         as vl_atraso
     

into #TabPrevisaoVenda
FROM      
 #PrevisaoVenda p
 left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = p.cd_plano_financeiro          

Group by
  p.Vencimento,
  pf.cd_plano_financeiro


--select * from #TabPrevisaoVenda

-----------------------------------------------------------------------------------------
--Previsão de Compras
-----------------------------------------------------------------------------------------
--select * from pedido_compra_item

select

  --Falta colocar o IPI do valor do Produto caso tenha - 25.07.2007

  ( pci.qt_saldo_item_ped_compra * pci.vl_item_unitario_ped_comp ) * ( cpp.pc_condicao_parcela_pgto/100) as Parcela,
  isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto                                       as Vencimento,
  pc.cd_plano_financeiro      
into
  #PrevisaoCompra
from
  pedido_compra pc
  inner join pedido_compra_item pci         on pci.cd_pedido_compra      = pc.cd_pedido_compra
  inner join condicao_pagamento cp          on cp.cd_condicao_pagamento  = pc.cd_condicao_pagamento
  inner join condicao_pagamento_parcela cpp on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
where
  --pc.dt_pedido_compra between @dt_inicial and @dt_final and
  isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto between @dt_inicial and @dt_final and
  pci.dt_item_canc_ped_compra is null and
  isnull(pci.qt_saldo_item_ped_compra,0)>0

--Montagem da Tabela Final de Previsão de Compras

SELECT     
           p.Vencimento,
           pf.cd_plano_financeiro,
           max(isnull(cd_mascara_plano_financeiro,'')) as 'Plano',
           max(isnull(nm_conta_plano_financeiro,''))   as 'Conta',
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           cast( 0 as float)                         as vl_desconto_documento,
           cast( 0 as float )                        as vl_previsao_vendas,    
           sum( p.Parcela )                            as vl_previsao_compras,
           cast( 0 as float)                         as vl_atraso


into #TabPrevisaoCompra
FROM      
 #PrevisaoCompra p
 left outer join Plano_Financeiro pf  on pf.cd_plano_financeiro  = p.cd_plano_financeiro          

Group by
  p.Vencimento,
  pf.cd_plano_financeiro

-----------------------------------------------------------------------------------------
-- Juntando todos os valores em uma tabela.
-----------------------------------------------------------------------------------------

select * into #TabDocPagarReceber 
from #TabDocumentoReceber

insert into #TabDocPagarReceber 
select * from #TabDocumentoReceberPagamento

insert into #TabDocPagarReceber 
select * from #TabDocumentoReceberDesconto

insert into #TabDocPagarReceber 
select * from #TabDocumentoReceberDescontoSaida

insert into #TabDocPagarReceber 
select * from #TabDocumentoPagarPagamento

insert into #TabDocPagarReceber
select * from #TabDocumentoPagar

insert into #TabDocPagarReceber
select * from #TabDocumentoPrevistoEntrada

insert into #TabDocPagarReceber
select * from #TabDocumentoPrevistoSaida

insert into #TabDocPagarReceber
select * from #TabPrevisaoVenda

insert into #TabDocPagarReceber
select * from #TabPrevisaoCompra

create table #TabInicial
 ( Vencimento                  datetime Null,
   cd_plano_financeiro         int,
   Conta                       varchar(40),
   Plano                       varchar(20),
   vl_saldo_documento_receber  float null,
   vl_saldo_documento_pagar    float null,
   vl_saldo_previsto_entrada   float null,
   vl_saldo_previsto_saida     float null,
   vl_desconto_documento       float null,               
   vl_previsao_vendas          float null,
   vl_previsao_compras         float null,
   vl_atraso                   float null )

insert into #TabInicial
select Vencimento,
       cd_plano_financeiro,
       Max(isnull(Plano,'')) as Plano,
       Max(substring(isnull(Conta,''),1,20)) as Conta,
       sum(IsNull(vl_saldo_documento_receber,0) + IsNull(vl_pagamento_documento_receber,0) ) as vl_saldo_documento_receber,
       sum(IsNull(vl_saldo_documento_pagar,0)   + IsNull(vl_pagamento_documento_pagar,0))    as vl_saldo_documento_pagar,
       sum(IsNull(vl_saldo_previsto_entrada,0))                                              as vl_saldo_previsto_entrada,
       sum(IsNull(vl_saldo_previsto_saida,0))                                                as vl_saldo_previsto_saida,
       sum(Isnull(vl_desconto_documento,0))                                                  as vl_desconto_documento,
       sum(Isnull(vl_previsao_vendas,0))                                                     as vl_previsao_vendas,
       sum(Isnull(vl_previsao_compras,0))                                                    as vl_previsao_compras,
       sum(isnull(vl_atraso,0))                                                              as vl_atraso
from #TabDocPagarReceber
group by Vencimento, cd_plano_financeiro


-----------------------------------------------------------------------------------
--Mostra a Tabela final
-----------------------------------------------------------------------------------

select * from #TabInicial order by Vencimento

