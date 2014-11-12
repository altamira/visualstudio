
CREATE PROCEDURE pr_analise_movimento_caixa

-----------------------------------------------------------------------------------------
--GBS Global Business Solution                 2003
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Daniel C. Neto.
--Banco de Dados  : EGISSQL
--Objetivo        : Consulta de Movimentação de Plano Financeiro por Centro de Custo.
--Data            : 30/07/2003
--Atualizado      : 26/01/2004 - Modificação pra pegar o valor do documento a pagar. - Daniel C. Neto.
-- 08/03/2004 - Incluído 2 novas colunas referentes a documentos previstos - Daniel C. Neto.
-- 10/03/2004 - Incluído verificação de dias úteis em todos os campos da consulta. Daniel C. Neto.
-- 16/03/2004 - Levar em consideração as baixas
-- 14.02.2005 - Colocar a Seleção da Loja na Consulta
-- 22.11.2005 - Verificação se o sistema deduz o pagamento do documento - Carlos Fernandes
-- 28.11.2005 - Controle de Desconto de Documentos a Receber - Carlos Fernandes
-- 13.07.2006 - Checagem no Portador da Quantidade Dias para Crédito Efetivo - Flowing Bancário - Carlos Fernandes
-- 10.02.2007 - Checagem dos Documento a Receber que foram checados Lotes - Carlos Fernandes
-- 13.04.2007 - Busca do Saldos Iniciais das Contas Correntes - Carlos Fernandes
-- 29.06.2007 - Previsão de Vendas / Previsão de Compras
-- 18.07.2007 - Contas que participam do Fluxo de Caixa - Carlos Fernandes
-- 27.08.2007 - Nova coluna - Atraso / Inadimplência - Carlos Fernandes
-- 11.09.2007 - Pagamento com Desconto - Carlos Fernandes
-- 17.10.2007 - Busca do Saldo do Movimento Bancário - Carlos Fernandes
-- 28.10.2007 - Na Previsão de Compras somar o (%) IPI do Item - Carlos Fernandes
-- 27.12.2007 - Previsão de Vendas, verificar a data de entrega do PCP / Reprogramação - Carlos Fernandes
-- 04.01.2007 - Ajuste na Data de Programação/Reprogramação - Carlos Fernandes
-- 11.01.2008 - Acerto do Desconto - Carlos Fernandes
-- 01.04.2008 - Ajuste das Entradas de Pedido de Venda - Carlos Fernandes
-- 19.09.2008 - Ajuste do Abatimento do contas a receber - Carlos Fernandes
-- 27.11.2008 - Dados dos Pedidos da Importação - Carlos Fernandes
-- 22.12.2008 - Demonstra o Tipo de Pagamento no Fluxo de Caixa - Carlos Fernandes
-- 04.02.2009 - Ajuste do Movimento Lançado Manual a Pagar - Carlos Fernandes
-- 07.02.2009 - Tipo de Fluxo de Caixa
--              0-Geral
--              1-Somente os Pedidos Oficiais / 2-Somente os Pedidos por Fora
-- 09.02.2009 - Ajuste no Fluxo por Tipo de Pedido - Carlos Fernandes
-- 17.02.2009 - Filtro por Tipo de Fluxo no Contas a Pagar - Carlos Fernandes
-- 25.02.2009 - Novo parâmetro para mostrar o Atraso de Dias - Carlos Fernandes
-- 30.04.2009 - Previsão de Vendas do Pedido em Aberto - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------

@dt_inicial 			datetime = '',
@dt_final 			datetime = '',
@cd_loja                        int      = 0,
@dt_saldo_parametro             datetime = null,
@cd_usuario                     int      = 0,
@ic_tipo_fluxo                  int      = 0

AS

-- Declarando e pegando saldo inicial das contas  
  
declare @SaldoInicial              float  
declare @SaldoContaBanco           float  
declare @cd_conta_banco            int  
declare @ic_pagamento_fluxo        char(1)
declare @dt_vencimento             datetime
declare @vl_saldo_acumulado        float
declare @cd_tipo_lancamento_fluxo  int  
declare @dt_saldo_conta            datetime
declare @ic_previsao_saldo         char(1)
declare @ic_saldo_atual_fluxo      char(1)
declare @dt_saldo_hoje             datetime
declare @ic_importacao_fluxo_caixa char(1) 
declare @dt_hoje                   datetime
declare @qt_dia_atraso_fluxo_caixa int

if @dt_saldo_parametro is null
begin
  --set @dt_saldo_hoje = cast(convert(int,getdate(),103) as datetime)
  set @dt_saldo_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end
else
  set @dt_saldo_hoje = @dt_saldo_parametro 


--Data de Hoje para cálculo do Atraso
set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

set @cd_tipo_lancamento_fluxo = 2 --Realizado  

--Verificar se os Valores Pagos devem ser Considerados no Fluxo
--Carlos 22.11.2005
--select * from parametro_financeiro

select
  @ic_pagamento_fluxo        = isnull(ic_pagamento_fluxo,'N'),
  @ic_previsao_saldo         = isnull(ic_previsao_saldo,'N'),
  @ic_saldo_atual_fluxo      = isnull(ic_saldo_atual_fluxo,'N'),
  @ic_importacao_fluxo_caixa = isnull(ic_importacao_fluxo_caixa,'N'),
  @qt_dia_atraso_fluxo_caixa = isnull(qt_dia_atraso_fluxo_caixa,1)    --Parâmetro Default 1 dia
from
  Parametro_Financeiro with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--Verifica se foi passado o parâmetro loja

set @cd_loja = isnull(@cd_loja,0)

-- set @vl_saldo_acumulado = IsNull(( select top 1 vl_previsto_saldo
--                             from Documento_Previsto_Saldo
--                             where dt_previsto_saldo < @dt_inicial
--                             order by dt_previsto_saldo desc ),0)

set @vl_saldo_acumulado = 0

--Busca a Somatória de todas as Contas Correntes

if @vl_saldo_acumulado=0
begin
  
  declare ContaBanco_Cursor CURSOR FOR  

  select cd_conta_banco from Conta_Agencia_Banco  
  where
     isnull(ic_ativo_conta,'S')       = 'S'   and
     isnull(ic_fluxo_caixa_conta,'S') = 'S'

  OPEN ContaBanco_Cursor  
  FETCH NEXT FROM ContaBanco_Cursor  
  INTO @cd_conta_banco  
  
  set @SaldoInicial    = 0.00  

  declare @vl_saldo         float  
  declare @ic_utiliza_conta char(1) 

  --select * from conta_agencia_banco
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  

    set @ic_utiliza_conta = 'N' 

    select 
      @ic_utiliza_conta = isnull(ic_fluxo_caixa_conta,'S')
    from
      Conta_Agencia_Banco with (nolock) 
    where
      cd_conta_banco                   = @cd_conta_banco and
      isnull(ic_ativo_conta,'S')       = 'S'   and
      isnull(ic_fluxo_caixa_conta,'S') = 'S'

    if @ic_utiliza_conta='S'
    begin

      exec pr_saldo_sintetico_movimento_banco  9, 
                                               @dt_inicial,
                                               @cd_conta_banco,
                                               @cd_tipo_lancamento_fluxo,
                                               @dt_inicial,
                                               @dt_inicial,
                                               0, 
                                               1,
                                               0,
                                               @cd_usuario,
                                               @vl_saldo_atual_retorno = @SaldoContaBanco output

     
      --select @dt_inicial,@dt_final,'@SaldoContaBanco', @SaldoContaBanco
  
   
       --select @dt_saldo_conta,@dt_inicial  
  
       --Saldo Inicial  
       --select 'SaldoInicial', @SaldoInicial
       set @SaldoInicial    = @SaldoInicial + isnull(@SaldoContaBanco,0)  

       --select 'SaldoInicial', @SaldoInicial
  
       --print 'conta : '+cast(@cd_conta_banco  as varchar)  
       --print 'saldo : '+cast(@saldocontabanco as varchar)  
  
       --select @cd_conta_banco, @dt_inicial, @SaldoContaBanco, @SaldoInicial  
  
    end

    FETCH NEXT FROM ContaBanco_Cursor
    INTO @cd_conta_banco  
  
  END  
  
  CLOSE      ContaBanco_Cursor  
  DEALLOCATE ContaBanco_Cursor  

  --Atualiza a Tabela Temporária com o Saldo Inicial das Contas Previstos

  --select * from documento_previsto_saldo
  delete from documento_previsto_saldo

  insert into documento_previsto_saldo
   select 
     @dt_inicial-1,
     @SaldoInicial
  
     
  set @vl_saldo_acumulado = @SaldoInicial

end

--select(@vl_saldo_acumulado)

--------------------------------------------------------------------------------------------
-- Pegando os valores dos Pagamentos a Receber no período.
--------------------------------------------------------------------------------------------

SELECT     drp.dt_pagamento_documento              as 'Vencimento',
           sum( case when @ic_pagamento_fluxo='S' then
              ( isnull(drp.vl_pagamento_documento, 0) )

--Comentado Carlos - 11.09.2007
--            - isnull(drp.vl_juros_pagamento, 0)     
--            + isnull(drp.vl_desconto_documento, 0) + isnull(drp.vl_abatimento_documento, 0)
--            - isnull(drp.vl_despesa_bancaria, 0)   + isnull(drp.vl_reembolso_documento, 0)
--            - isnull(drp.vl_credito_pendente, 0))
           else 0 end )

                                                   as vl_pagamento_documento_receber,
           cast( 0 as Float)                       as vl_pagamento_documento_pagar,
           cast( 0 as Float)                       as vl_saldo_documento_receber,
           cast( 0 as Float)                       as vl_saldo_documento_pagar,
           cast( 0 as Float)                       as vl_saldo_previsto_entrada,
           cast( 0 as Float)                       as vl_saldo_previsto_saida,
           cast( 0 as float)                       as vl_desconto_documento,
           cast( 0 as float)                       as vl_previsao_vendas,
           cast( 0 as float)                       as vl_previsao_compras,
           cast( 0 as float)                       as vl_previsao_importacao,
           cast( 0 as float)                       as vl_atraso

into #TabDocumentoReceberPagamento
FROM      
  Documento_Receber_Pagamento drp              with (nolock) 
  left outer join Documento_Receber dr         with (nolock) on dr.cd_documento_receber = drp.cd_documento_receber
  left outer join Loja l                       with (nolock) on l.cd_loja               = dr.cd_loja 
  left outer join Tipo_Liquidacao tld          with (nolock) on tld.cd_tipo_liquidacao  = drp.cd_tipo_liquidacao 
                                                               --and isnull(tld.ic_fluxo_tipo_liquidacao,'S') = 'S'
  left outer join Portador p                   with (nolock) on p.cd_portador           = dr.cd_portador

--select * from tipo_pagamento_documento
--select * from documento_receber_pagamento
          
WHERE
  ( drp.dt_pagamento_documento between @dt_inicial and @dt_final  ) and
  --Lote
  ( isnull(dr.cd_lote_receber,0)=0 )                                and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
  --Não Pode ter ocorrido desconto do Documento
  and dr.cd_documento_receber not in ( select cd_documento_receber from documento_receber_desconto )
  and isnull(tld.ic_fluxo_tipo_liquidacao,'S') = 'S'
  and isnull(p.ic_fluxo_caixa_portador,'S')    = 'S' 

group by 
  drp.dt_pagamento_documento


--select * from #TabDocumentoReceberPagamento

--------------------------------------------------------------------------------------------
--Buscando os Valores de Documentos Descontados no Período
--Desconto = Entrada no Fluxo de Caixa
--------------------------------------------------------------------------------------------
--
--select * from documento_receber_desconto

SELECT     drd.dt_desconto_documento                 as 'Vencimento',
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           sum( isnull(drd.vl_desconto_documento,0)) as vl_desconto_documento,
           cast( 0 as float)                         as vl_previsao_vendas,
           cast( 0 as float)                         as vl_previsao_compras,
           cast( 0 as float)                         as vl_previsao_importacao,
           cast( 0 as float)                         as vl_atraso



into #TabDocumentoReceberDesconto
FROM      
  Documento_Receber_Desconto drd       with (nolock) 
  left outer join Documento_Receber dr with (nolock) on dr.cd_documento_receber = drd.cd_documento_receber
  left outer join Loja l               with (nolock) on l.cd_loja               = dr.cd_loja 
          
WHERE
  ( drd.dt_desconto_documento between @dt_inicial and @dt_final  ) and
  --Lote
  ( isnull(dr.cd_lote_receber,0) = 0 )                             and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
group by 
  drd.dt_desconto_documento

--------------------------------------------------------------------------------------------
--Buscando os Valores de Documentos Descontados no Período
--Desconto = Saída no Fluxo de Caixa
--------------------------------------------------------------------------------------------

SELECT     dr.dt_vencimento_documento                   as 'Vencimento',
           cast( 0 as float)                            as vl_pagamento_documento_receber,
           cast( 0 as Float)                            as vl_pagamento_documento_pagar,
           sum( isnull(dr.vl_saldo_documento,0)*-1)     as vl_saldo_documento_receber,
           cast( 0 as Float)                            as vl_saldo_documento_pagar,
           cast( 0 as Float)                            as vl_saldo_previsto_entrada,
           cast( 0 as Float)                            as vl_saldo_previsto_saida,
           cast( 0 as Float)                            as vl_desconto_documento,
           cast( 0 as float)                            as vl_previsao_vendas,
           cast( 0 as float)                            as vl_previsao_compras,
           cast( 0 as float)                            as vl_previsao_importacao,
           cast( 0 as float)                            as vl_atraso

into #TabDocumentoReceberDescontoSaida
FROM      
  Documento_Receber_Desconto drd       with (nolock) 
  left outer join Documento_Receber dr with (nolock) on dr.cd_documento_receber = drd.cd_documento_receber
  left outer join Loja l               with (nolock) on l.cd_loja               = dr.cd_loja 
          
WHERE
  ( drd.dt_desconto_documento  between @dt_inicial and @dt_final  ) and
  ( dr.dt_vencimento_documento between @dt_inicial and @dt_final )  and
  --Lote
  ( isnull(dr.cd_lote_receber,0) = 0 )                             and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end )
group by 
  dr.dt_vencimento_documento


--select * from #TabDocumentoReceberDescontoSaida

--select * from documento_receber

--------------------------------------------------------------------------------------------
-- Pegando os valores a Receber Previstos no Período.
--------------------------------------------------------------------------------------------
--select * from documento_receber

SELECT     
           dbo.fn_dia_util_efetivo(dr.dt_vencimento_documento,'S','U',
                                    IsNull(max(p.qt_credito_efetivo),0)) as 'Vencimento',
           IsNull(p.qt_credito_efetivo,0)                                as qt_dia_credito,

           sum( IsNull(dr.vl_saldo_documento,0) - 
                isnull(dr.vl_abatimento_documento,0))                    as vl_saldo_documento_receber,

           case when ( sum(isnull(dr.vl_saldo_documento,0))>0  ) and 
                     ( dbo.fn_dia_util(( dr.dt_vencimento_documento + 
                     IsNull(max(p.qt_credito_efetivo),0) ),'S','U') ) < ( @dt_hoje - @qt_dia_atraso_fluxo_caixa )
                then
                  sum(isnull(dr.vl_saldo_documento,0))
                else           
                  cast( 0 as float)
                end                                                      as vl_atraso

into #TabAuxDocumentoReceber
FROM
  Documento_Receber dr       with (nolock)
  left outer join Portador p with (nolock) on p.cd_portador = dr.cd_portador
  left outer join Loja l     with (nolock) on l.cd_loja     = dr.cd_loja
            
WHERE
  ( dbo.fn_dia_util(( dr.dt_vencimento_documento + IsNull(p.qt_credito_efetivo,0) ),'S','U') between @dt_inicial and @dt_final ) and
  ((dr.dt_cancelamento_documento is null) or (dr.dt_cancelamento_documento > @dt_final))      and
  ((dr.dt_devolucao_documento    is null) or (dr.dt_devolucao_documento    > @dt_final))      and
  ( isnull(dr.cd_lote_receber,0) = 0 )                                                        and
  ( isnull(dr.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dr.cd_loja,0) end ) and
  --( isnull(dr.vl_saldo_documento,0) > 0 )                                                     and
  ( cast( isnull(dr.vl_saldo_documento,0) as decimal(25,2)) > 0 )                             and
  --Checa se o Documento Foi Descontado
  dr.cd_documento_receber not in ( select cd_documento_receber from documento_receber_desconto )
  --Checa se o Documento Entra no Fluxo através do Portador
  and isnull(p.ic_fluxo_caixa_portador,'S')    = 'S' 

group by 
  dr.dt_vencimento_documento,
  IsNull(p.qt_credito_efetivo,0) 


--select * from #TabAuxDocumentoReceber

select 
  Vencimento,
  cast( 0 as Float)                                   as vl_pagamento_documento_receber,
  cast( 0 as Float)                                   as vl_pagamento_documento_pagar,
  sum(IsNull(vl_saldo_documento_receber,0))           as vl_saldo_documento_receber,
  cast( 0 as Float)                                   as vl_saldo_documento_pagar,
  cast( 0 as Float)                                   as vl_saldo_previsto_entrada,
  cast( 0 as Float)                                   as vl_saldo_previsto_saida,
  cast( 0 as float)                                   as vl_desconto_documento,
  cast( 0 as float)                                   as vl_previsao_vendas,
  cast( 0 as float)                                   as vl_previsao_compras,
  cast( 0 as float)                                   as vl_previsao_importacao,
  sum(isnull(vl_atraso,0))                            as vl_atraso

into
  #TabDocumentoReceber
from
  #TabAuxDocumentoReceber

group by
  Vencimento

--------------------------------------------------------------------------------------------
-- Pegando os valores dos Documentos Pagos no Período.
--------------------------------------------------------------------------------------------
-- select * from documento_pagar

SELECT     dpp.dt_pagamento_documento                  as 'Vencimento',
           cast( 0 as Float)                           as vl_pagamento_documento_receber,
           sum( case when @ic_pagamento_fluxo='S' then 
               isnull(dpp.vl_pagamento_documento,0)   +
               isnull(dpp.vl_juros_documento_pagar,0) -
               isnull(dpp.vl_desconto_documento,0)    -
               isnull(dpp.vl_abatimento_documento,0)
                                              else 0 end ) as vl_pagamento_documento_pagar,
           cast( 0 as Float)                           as vl_saldo_documento_receber,
           cast( 0 as Float)                           as vl_saldo_documento_pagar,
           cast( 0 as Float)                           as vl_saldo_previsto_entrada,
           cast( 0 as Float)                           as vl_saldo_previsto_saida,
           cast( 0 as float)                           as vl_desconto_documento,
           cast( 0 as float)                           as vl_previsao_vendas,
           cast( 0 as float)                           as vl_previsao_compras,
           cast( 0 as float)                           as vl_previsao_importacao,
           cast( 0 as float)                           as vl_atraso

into #TabDocumentoPagarPagamento

FROM 
  Documento_Pagar_Pagamento dpp                with (nolock) 
  left outer join Documento_Pagar dp           with (nolock) on dp.cd_documento_pagar = dpp.cd_documento_pagar
  left outer join Loja l                       with (nolock) on l.cd_loja = dp.cd_loja
  left outer join Tipo_Pagamento_Documento tpd with (nolock) on tpd.cd_tipo_pagamento   = dpp.cd_tipo_pagamento 
                                                                --and isnull(tpd.ic_fluxo_tipo_pagamento,'S') = 'S'
  left outer join Portador p                   with (nolock) on p.cd_portador = dp.cd_portador
                                
WHERE 
  ( dpp.dt_pagamento_documento between @dt_inicial and @dt_final ) and
  ( isnull(dp.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dp.cd_loja,0) end )
  and isnull(tpd.ic_fluxo_tipo_pagamento,'S') = 'S'
  and isnull(p.ic_fluxo_caixa_portador,'S')   = 'S' 
  and isnull(dp.cd_tipo_fluxo_caixa,0) = case when @ic_tipo_fluxo = 0 then isnull(dp.cd_tipo_fluxo_caixa,0)
                                         else @ic_tipo_fluxo end      
  and isnull(dp.cd_identificacao_document,'')<>''  
group by 
  dpp.dt_pagamento_documento


-- Pegando os valores dos documentos a pagar no período.

SELECT     
           dbo.fn_dia_util(dp.dt_vencimento_documento,'S','U') as 'Vencimento',
           cast( 0 as Float)                                   as vl_pagamento_documento_receber,
           cast( 0 as Float)                                   as vl_pagamento_documento_pagar,
           cast( 0 as Float)                                   as vl_saldo_documento_receber,
           sum(IsNull(dp.vl_saldo_documento_pagar,0) -
               Isnull(dp.vl_abatimento_documento,0 ) -
               isnull(dp.vl_desconto_documento,0)    +
               isnull(dp.vl_juros_documento,0)      )          as vl_saldo_documento_pagar,
           cast( 0 as Float)                                   as vl_saldo_previsto_entrada,
           cast( 0 as Float)                                   as vl_saldo_previsto_saida,
           cast( 0 as float)                                   as vl_desconto_documento,
           cast( 0 as float)                                   as vl_previsao_vendas,
           cast( 0 as float)                                   as vl_previsao_compras,
           cast( 0 as float)                                   as vl_previsao_importacao,
           cast( 0 as float)                                   as vl_atraso

--select * from documento_pagar

into #TabDocumentoPagar

FROM  
   Documento_Pagar dp         with (nolock) 
   left outer join Loja l     with (nolock) on l.cd_loja     = dp.cd_loja
   left outer join Portador p with (nolock) on p.cd_portador = dp.cd_portador
                                
WHERE 
  ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final )  and
  ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final))      and
  ((dp.dt_devolucao_documento is null) or (dp.dt_devolucao_documento > @dt_final))            and
  ( isnull(dp.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(dp.cd_loja,0) end ) and
  ( cast( isnull(dp.vl_saldo_documento_pagar,0) as decimal(25,2)) > 0 )
   and isnull(p.ic_fluxo_caixa_portador,'S')    = 'S' 
   and isnull(dp.cd_tipo_fluxo_caixa,0) = case when @ic_tipo_fluxo = 0 then isnull(dp.cd_tipo_fluxo_caixa,0)
                                          else @ic_tipo_fluxo end      

   and isnull(dp.cd_identificacao_document,'')<>''  

group by 
  dp.dt_vencimento_documento

-- Pegando Documentos Previstos de Entrada.

SELECT     
           dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') as 'Vencimento',
           cast( 0 as Float) as vl_pagamento_documento_receber,
           cast( 0 as Float) as vl_pagamento_documento_pagar,
           cast( 0 as Float) as vl_saldo_documento_receber,
           cast( 0 as Float) as vl_saldo_documento_pagar,
           sum(IsNull(dp.vl_vencimento_previsto,0))           as vl_saldo_previsto_entrada,
           cast( 0 as Float)                                  as vl_saldo_previsto_saida,
           cast( 0 as float)                                  as vl_desconto_documento,
           cast( 0 as float)                                  as vl_previsao_vendas,
           cast( 0 as float)                                  as vl_previsao_compras,
           cast( 0 as float)                                  as vl_previsao_importacao,
           cast( 0 as float)                                  as vl_atraso

into #TabDocumentoPrevistoEntrada
FROM       Documento_Previsto_Vencimento dp  with (nolock) inner join
           Documento_Previsto d              with (nolock) on d.cd_documento_previsto = dp.cd_documento_previsto left outer join
           Portador p                        with (nolock) on p.cd_portador = d.cd_portador
           left outer join Loja l            with (nolock) on l.cd_loja     = d.cd_loja         
                                
WHERE     ( dbo.fn_dia_util(dp.dt_vencimento_previsto + IsNull(p.qt_credito_efetivo,0),'S','U') between @dt_inicial and @dt_final )  and
          ( d.cd_tipo_operacao = 2 ) and
          ( isnull(d.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(d.cd_loja,0) end )


group by 
  dp.dt_vencimento_previsto

-- Pegando Documentos Previstos de Saída.

SELECT     dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') as 'Vencimento',
           cast( 0 as Float) as vl_pagamento_documento_receber,
           cast( 0 as Float) as vl_pagamento_documento_pagar,
           cast( 0 as Float) as vl_saldo_documento_receber,
           cast( 0 as Float) as vl_saldo_documento_pagar,
           cast( 0 as Float) as vl_saldo_previsto_entrada,
           sum(IsNull(dp.vl_vencimento_previsto,0))           as vl_saldo_previsto_saida,
           cast( 0 as float)                                  as vl_desconto_documento,
           cast( 0 as float)                                  as vl_previsao_vendas,
           cast( 0 as float)                                  as vl_previsao_compras,
           cast( 0 as float)                                  as vl_previsao_importacao,
           cast( 0 as float)                                  as vl_atraso

into #TabDocumentoPrevistoSaida

FROM       Documento_Previsto_Vencimento dp  with (nolock) inner join
           Documento_Previsto d              with (nolock) on d.cd_documento_previsto = dp.cd_documento_previsto
           left outer join Loja l            with (nolock) on l.cd_loja = d.cd_loja
                                
WHERE     ( dbo.fn_dia_util(dp.dt_vencimento_previsto,'S','U') between @dt_inicial and @dt_final )  and
          ( d.cd_tipo_operacao = 1 ) and
          ( isnull(d.cd_loja,0) = case when @cd_loja>0 then @cd_loja else isnull(d.cd_loja,0) end )

group by 
  dp.dt_vencimento_previsto

-----------------------------------------------------------------------------------------
--Previsão de Vendas
-----------------------------------------------------------------------------------------
--select * from pedido_venda_item
--select * from condicao_pagamento_parcela order by cd_condicao_pagamento,cd_condicao_parcela_pgto
--select * from condicao_pagamento
--select * from pedido_venda_item

select
 pv.cd_condicao_pagamento,

 case when ( pvi.dt_reprog_item_pedido is not null ) --and ( pvi.dt_reprog_item_pedido>pvi.dt_entrega_vendas_pedido ) 
 then
   pvi.dt_reprog_item_pedido
 else
   case when ( pvi.dt_entrega_fabrica_pedido is not null ) --and ( pvi.dt_entrega_fabrica_pedido>pvi.dt_entrega_vendas_pedido ) 
   then
     pvi.dt_entrega_fabrica_pedido
   else
     pvi.dt_entrega_vendas_pedido
   end
 end                                                     as dt_entrega_vendas_pedido,

-- pvi.dt_entrega_vendas_pedido,

 pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido as vl_total,

 cp.qt_parcela_condicao_pgto,
 cpp.pc_condicao_parcela_pgto,
 cpp.qt_dia_cond_parcela_pgto,
( pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido ) * ( cpp.pc_condicao_parcela_pgto/100) as Parcela,

 case when ( pvi.dt_reprog_item_pedido is not null ) --and ( pvi.dt_reprog_item_pedido>pvi.dt_entrega_vendas_pedido ) 
 then
   pvi.dt_reprog_item_pedido
 else
   case when ( pvi.dt_entrega_fabrica_pedido is not null ) --and ( pvi.dt_entrega_fabrica_pedido>pvi.dt_entrega_vendas_pedido ) 
   then
     pvi.dt_entrega_fabrica_pedido
   else
     pvi.dt_entrega_vendas_pedido
   end
 end

-- pvi.dt_entrega_vendas_pedido

 + isnull(cpp.qt_dia_cond_parcela_pgto,0)                                       as Vencimento      

into
  #PrevisaoVenda
from
  pedido_venda pv                           with (nolock) 
  inner join pedido_venda_item pvi          with (nolock) on pvi.cd_pedido_venda       = pv.cd_pedido_venda
  inner join condicao_pagamento cp          with (nolock) on cp.cd_condicao_pagamento  = pv.cd_condicao_pagamento
  inner join condicao_pagamento_parcela cpp with (nolock) on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
where
  --pv.dt_pedido_venda between @dt_inicial and @dt_final and
  
--  (pvi.dt_entrega_vendas_pedido 

 isnull(pvi.cd_produto_servico,0)=0 and

(
 case when ( pvi.dt_reprog_item_pedido is not null ) --and ( pvi.dt_reprog_item_pedido>pvi.dt_entrega_vendas_pedido ) 
 then
   pvi.dt_reprog_item_pedido
 else
   case when ( pvi.dt_entrega_fabrica_pedido is not null ) --and ( pvi.dt_entrega_fabrica_pedido>pvi.dt_entrega_vendas_pedido ) 
   then
     pvi.dt_entrega_fabrica_pedido
   else
     pvi.dt_entrega_vendas_pedido
   end
 end

 + 

  cpp.qt_dia_cond_parcela_pgto )>@dt_hoje and

--  (pvi.dt_entrega_vendas_pedido 

 ( case when ( pvi.dt_reprog_item_pedido is not null ) --and ( pvi.dt_reprog_item_pedido>pvi.dt_entrega_vendas_pedido ) 
 then
   pvi.dt_reprog_item_pedido
 else
   case when ( pvi.dt_entrega_fabrica_pedido is not null ) --and ( pvi.dt_entrega_fabrica_pedido>pvi.dt_entrega_vendas_pedido ) 
   then
     pvi.dt_entrega_fabrica_pedido
   else
     pvi.dt_entrega_vendas_pedido
   end
 end

 + cpp.qt_dia_cond_parcela_pgto ) between @dt_inicial and @dt_final and
  
  pvi.dt_cancelamento_item is null and
  isnull(pvi.qt_saldo_pedido_venda,0)>0

--select * from #previsaovenda

--Montagem da Tabela Final de Previsão de Vendas

SELECT     
           Vencimento,
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           cast( 0 as float)                         as vl_desconto_documento,
           sum( Parcela )                            as vl_previsao_vendas,
           cast( 0 as float )                        as vl_previsao_compras,
           cast( 0 as float)                         as vl_previsao_importacao,
           cast( 0 as float)                         as vl_atraso
     

into #TabPrevisaoVenda
FROM      
 #PrevisaoVenda
Group by
  Vencimento

--select * from #TabPrevisaoVenda

-----------------------------------------------------------------------------------------
--Previsão de Compras
-----------------------------------------------------------------------------------------
--select * from pedido_compra_item

select

  --Falta colocar o IPI do valor do Produto caso tenha - 25.07.2007
  --select * from pedido_compra_item
  
  (( pci.qt_saldo_item_ped_compra * pci.vl_item_unitario_ped_comp ) +
  (case when isnull(pci.pc_ipi,0)>0 then
    ( pci.qt_saldo_item_ped_compra * pci.vl_item_unitario_ped_comp ) * (pci.pc_ipi/100) 
  else
    0.00
  end ))                                                            * ( cpp.pc_condicao_parcela_pgto/100) as Parcela,
  isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto               as Vencimento      
into
  #PrevisaoCompra
from
  pedido_compra pc                          with (nolock) 
  inner join pedido_compra_item pci         with (nolock) on pci.cd_pedido_compra      = pc.cd_pedido_compra
  inner join condicao_pagamento cp          with (nolock) on cp.cd_condicao_pagamento  = pc.cd_condicao_pagamento
  inner join condicao_pagamento_parcela cpp with (nolock) on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
where
  --pc.dt_pedido_compra between @dt_inicial and @dt_final and
  isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto > @dt_hoje and
  isnull(pci.dt_entrega_item_ped_compr,pc.dt_pedido_compra) + cpp.qt_dia_cond_parcela_pgto between @dt_inicial and @dt_final and
  pci.dt_item_canc_ped_compra is null and
  isnull(pci.qt_saldo_item_ped_compra,0)>0

--Montagem da Tabela Final de Previsão de Compras

SELECT     
           Vencimento,
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           cast( 0 as float)                         as vl_desconto_documento,
           cast( 0 as float )                        as vl_previsao_vendas,    
           sum( Parcela )                            as vl_previsao_compras,
           cast( 0 as float)                         as vl_previsao_importacao,
           cast( 0 as float)                         as vl_atraso


into #TabPrevisaoCompra
FROM      
 #PrevisaoCompra
Group by
  Vencimento


-----------------------------------------------------------------------------------------
--Previsão de Importação
-----------------------------------------------------------------------------------------
--select * from pedido_importacao_item
--select * from pedido_importacao

select
  
  (( pii.qt_saldo_item_ped_imp * pii.vl_item_ped_imp ) 

--  (case when isnull(pii.pc_iiipi,0)>0 then
--    ( pii.qt_saldo_item_ped_imp * pii.vl_item_ped_imp ) * (pci.pc_ipi/100) 
--  else
--    0.00
--  end )
  )                                                            * ( cpp.pc_condicao_parcela_pgto/100)        as Parcela,
  isnull(pii.dt_prev_embarque_ped_imp,p.dt_prev_emb_ped_imp) + cpp.qt_dia_cond_parcela_pgto                as Vencimento      
into
  #PrevisaoImportacao
from
  pedido_importacao p                       with (nolock) 
  inner join pedido_importacao_item pii     with (nolock) on pii.cd_pedido_importacao   = p.cd_pedido_importacao
  inner join condicao_pagamento cp          with (nolock) on cp.cd_condicao_pagamento   = p.cd_condicao_pagamento
  inner join condicao_pagamento_parcela cpp with (nolock) on cpp.cd_condicao_pagamento  = cp.cd_condicao_pagamento
where
  --pc.dt_pedido_compra between @dt_inicial and @dt_final and
  isnull(pii.dt_prev_embarque_ped_imp,p.dt_prev_emb_ped_imp) + cpp.qt_dia_cond_parcela_pgto > @dt_hoje and
  isnull(pii.dt_prev_embarque_ped_imp,p.dt_prev_emb_ped_imp) + cpp.qt_dia_cond_parcela_pgto between @dt_inicial and @dt_final and
  pii.dt_cancel_item_ped_imp is null and
  isnull(pii.qt_saldo_item_ped_imp,0)>0

--select * from #PrevisaoImportacao

--Montagem da Tabela Final de Previsão de Importação

SELECT     
           Vencimento,
           cast( 0 as float)                         as vl_pagamento_documento_receber,
           cast( 0 as Float)                         as vl_pagamento_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_documento_receber,
           cast( 0 as Float)                         as vl_saldo_documento_pagar,
           cast( 0 as Float)                         as vl_saldo_previsto_entrada,
           cast( 0 as Float)                         as vl_saldo_previsto_saida,
           cast( 0 as float)                         as vl_desconto_documento,
           cast( 0 as float )                        as vl_previsao_vendas,    
           cast( 0 as float )                        as vl_previsao_compras,    
           sum( Parcela )                            as vl_previsao_importacao,
           cast( 0 as float)                         as vl_atraso


into #TabPrevisaoImportacao
FROM      
 #PrevisaoImportacao
Group by
  Vencimento


-----------------------------------------------------------------------------------------
-- Movimento Bancário
-----------------------------------------------------------------------------------------
--select * from conta_banco_lancamento

SELECT
           dt_lancamento     as 'Vencimento',
           case  when cd_tipo_operacao = 1 then           --Entrada
             sum( isnull(vl_lancamento,0) )
           else
             cast( 0 as Float) 
           end               as vl_pagamento_documento_receber,

           case when cd_tipo_operacao = 2 then            --Saída
             sum( isnull(vl_lancamento,0))
           else
             cast( 0 as Float)
           end               as vl_pagamento_documento_pagar,
  
           cast( 0 as Float) as vl_saldo_documento_receber,
           cast( 0 as Float) as vl_saldo_documento_pagar,
           cast( 0 as Float) as vl_saldo_previsto_entrada,
           cast( 0 as Float) as vl_saldo_previsto_saida,
           cast( 0 as float)                                  as vl_desconto_documento,
           cast( 0 as float)                                  as vl_previsao_vendas,
           cast( 0 as float)                                  as vl_previsao_compras,
           cast( 0 as float )                                 as vl_previsao_importacao,
           cast( 0 as float)                                  as vl_atraso


into #TabDocumentoBancoLancamento

FROM
  Conta_Banco_Lancamento l with (nolock)
                                
WHERE    
  ( l.dt_lancamento between @dt_inicial and @dt_final )  and
  isnull(l.ic_fluxo_caixa,'N') = 'S'

group by 
  l.dt_lancamento,
  l.cd_tipo_operacao

--select * from #TabDocumentoBancoLancamento

-----------------------------------------------------------------------------------------
-- Juntando todos os valores em uma tabela.
-----------------------------------------------------------------------------------------

select * into #TabDocPagarReceber 
from #TabDocumentoReceber

insert into #TabDocPagarReceber 
select * from #TabDocumentoReceberPagamento

insert into #TabDocPagarReceber 
select * from #TabDocumentoReceberDesconto

-- insert into #TabDocPagarReceber 
-- select * from #TabDocumentoReceberDescontoSaida

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

insert into #TabDocPagarReceber
select * from #TabPrevisaoImportacao

insert into #TabDocPagarReceber
select * from #TabDocumentoBancoLancamento

--select * from #TabDocPagarReceber

create table #TabInicial
 ( Vencimento                 datetime Null,
   vl_saldo_documento_receber float null,
   vl_saldo_documento_pagar   float null,
   vl_saldo_previsto_entrada  float null,
   vl_saldo_previsto_saida    float null,
   vl_desconto_documento      float null,               
   vl_previsao_vendas         float null,
   vl_previsao_compras        float null,
   vl_previsao_importacao     float null,
   vl_atraso                  float null,
   SaldoDiario                float null )

insert into #TabInicial

select Vencimento,
       sum(IsNull(vl_saldo_documento_receber,0) + IsNull(vl_pagamento_documento_receber,0) ) as vl_saldo_documento_receber,
       sum(IsNull(vl_saldo_documento_pagar,0)   + IsNull(vl_pagamento_documento_pagar,0))    as vl_saldo_documento_pagar,
       sum(IsNull(vl_saldo_previsto_entrada,0))                                              as vl_saldo_previsto_entrada,
       sum(IsNull(vl_saldo_previsto_saida,0))                                                as vl_saldo_previsto_saida,
       sum(Isnull(vl_desconto_documento,0))                                                  as vl_desconto_documento,
       sum(Isnull(vl_previsao_vendas,0))                                                     as vl_previsao_vendas,
       sum(Isnull(vl_previsao_compras,0))                                                    as vl_previsao_compras,
       sum(Isnull(vl_previsao_importacao,0))                                                 as vl_previsao_importacao,
       sum(isnull(vl_atraso,0))                                                              as vl_atraso,

       -- isnull(vl_desconto_documento,0)
       -- Desconto não soma no Saldo Diário, porque já está no Total a Receber

       ( sum(IsNull(vl_saldo_documento_receber,0) + IsNull(vl_pagamento_documento_receber,0)  ) - 
         sum(IsNull(vl_saldo_documento_pagar,0)   + IsNull(vl_pagamento_documento_pagar,0))  +
         sum(IsNull(vl_saldo_previsto_entrada,0)) - 
         sum(IsNull(vl_saldo_previsto_saida,0))   -
         sum(Isnull(vl_atraso,0))                 +         
         case when @ic_previsao_saldo='S' then
            sum(Isnull(vl_previsao_vendas,0)) - sum(Isnull(vl_previsao_compras,0)) - sum(isnull(vl_previsao_importacao,0))
         else
          0.00 end
       )                                                                                     as 'SaldoDiario'
from #TabDocPagarReceber
group by Vencimento

--select * from #TabInicial

select
  *, 
  cast(0 as Float) as 'SaldoAcumulado' 
into 
  #Tab_Aux 
from 
  #TabInicial

-- Calculando e fazendo o saldo acumulado de acordo com o saldo Diário.
declare @vl_saldo_diario decimal(25,2)

while exists ( select top 1 * from #TabInicial )
begin

  set @dt_vencimento = ( select top 1 Vencimento 
                       from #TabInicial 
                       order by Vencimento )


  set @vl_saldo_diario = ( select SaldoDiario 
                           from #TabInicial 
                           where Vencimento = @dt_vencimento ) 

  -- Atualizando Saldo  
 if @ic_saldo_atual_fluxo='S' and @dt_vencimento<@dt_saldo_hoje
 begin
   set @vl_saldo_diario = 0.00      
 end

 set @vl_saldo_acumulado = @vl_saldo_acumulado + @vl_saldo_diario


-- ( select SaldoDiario 
--                                                      from #TabInicial 
--                                                      where Vencimento = @dt_vencimento ) 

  update #Tab_Aux
    set SaldoAcumulado = @vl_saldo_acumulado
  where 
    Vencimento = @dt_vencimento

  delete #TabInicial where IsNull(Vencimento,0) = IsNUll(@dt_vencimento,0)

end  

-----------------------------------------------------------------------------------
-- Colocando primeira linha com o valor do Saldo Inicial, nisto todas as outras
-- colunas ficarão zeradas.
-----------------------------------------------------------------------------------

insert into #Tab_Aux
select top 1
  dt_previsto_saldo   as Vencimento,
  cast(null as float) as vl_saldo_documento_receber,
  cast(null as float) as vl_saldo_documento_pagar,
  cast(null as float) as vl_saldo_previsto_entrada,
  cast(null as float) as vl_saldo_previsto_saida,
  cast(null as float) as vl_desconto_documento,
  cast(null as float) as vl_saldo_previsao_vendas,
  cast(null as float) as vl_saldo_previsao_compras,
  cast(null as float) as vl_saldo_previsao_importacao,
  cast(null as float) as vl_atraso,
  vl_previsto_saldo   as 'SaldoDiario',
  vl_previsto_saldo   as 'SaldoAcumulado'
from 
  Documento_Previsto_Saldo with (nolock) 
where 
  dt_previsto_saldo < @dt_inicial
order by
  dt_previsto_saldo desc

-----------------------------------------------------------------------------------
--Mostra a Tabela final
-----------------------------------------------------------------------------------

select 
 isnull((select sg_semana from semana where cd_semana = DATEPART(dw , Vencimento)),'') as dia_semana,
  * 
from
  #Tab_Aux order by Vencimento

