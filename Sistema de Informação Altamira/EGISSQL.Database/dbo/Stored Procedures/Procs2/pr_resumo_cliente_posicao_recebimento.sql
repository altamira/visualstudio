
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_cliente_posicao_recebimento
-------------------------------------------------------------------------------
--pr_resumo_cliente_posicao_recebimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo com a Posição de Contas a Receber por Cliente
--Data             : 21.09.2009
--Alteração        : 
-- 31.10.2009 - Ajustes conforme solicitação valores em aberto - Carlos Fernandes
-- 08.02.2010 - Ajuste de baixas parciais  - Carlos Fernandes
---------------------------------------------------------------------------------
create procedure pr_resumo_cliente_posicao_recebimento
@cd_cliente int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from cliente
--select * from documento_receber
--select * from documento_receber_pagamento

--select * from tipo_pessoa
--select * from vw_destinatario

select
  c.cd_cliente,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente,
  max(c.cd_cliente_filial)                      as 'Filial',
--  max(c.cd_tipo_pessoa)                         as 'TipoPessoa',

  max( case when c.cd_tipo_pessoa=2 then
      dbo.fn_Formata_Mascara('999.999.999-99',ltrim(rtrim(c.cd_cnpj_cliente)))  
    else 
      dbo.fn_Formata_Mascara('99.999.999/9999-99',ltrim(rtrim(c.cd_cnpj_cliente)))  
  end)                                            as 'CNPJ',

  --max(c.cd_cnpj_cliente)                        as 'CNPJ',

  max(e.sg_estado)                              as 'UF',
  max(cid.nm_cidade)                            as 'Cidade',

  --Saldo em Aberto-----------------------------------------------------------------

  isnull(( select
      sum( isnull(d.vl_saldo_documento,0) )

    from
      Documento_receber d                    with (nolock) 
      --left outer join documento_receber_pagamento dp on dp.cd_documento_receber = d.cd_document_receber
    where
      --Data de Emissão
      d.dt_emissao_documento           < @dt_inicial and

      --d.dt_vencimento_documento      < @dt_inicial and
      isnull(d.vl_saldo_documento,0)>0             and
      d.cd_cliente = c.cd_cliente                  and
      d.dt_devolucao_documento       is null       and
      d.dt_cancelamento_documento    is null ),0)   as 'Saldo_Aberto_Auxiliar',

  --Total em Aberto-----------------------------------------------------------------

  isnull(( select
      sum( isnull(d.vl_saldo_documento,0) )

    from
      Documento_receber d                    with (nolock) 
    where
      isnull(d.vl_saldo_documento,0)>0        and

      d.cd_cliente = c.cd_cliente             and
      d.dt_devolucao_documento       is null  and
      d.dt_cancelamento_documento    is null ),0)   as 'Total_Aberto',

  --Total em Aberto no Período-------------------------------------------------------

  isnull(( select
      sum(
      cast(round(
                  isnull(d.vl_saldo_documento,0)
                  + 
                    (isnull(drp.vl_pagamento_documento,0) -
                    isnull(drp.vl_juros_pagamento,0)     +
                    isnull(drp.vl_desconto_documento,0) )
 
                                        ,2)   as decimal(25,2))) 
    from
      Documento_receber d                        with (nolock) 
      inner join documento_receber_pagamento drp with (nolock) on drp.cd_documento_receber = d.cd_documento_receber 
    where
      ( isnull(d.vl_saldo_documento,0)>0  or drp.dt_pagamento_documento > d.dt_vencimento_documento and drp.dt_pagamento_documento > @dt_final    )  and
      d.dt_vencimento_documento between @dt_inicial and @dt_final and
      d.cd_cliente = c.cd_cliente             and
      d.dt_devolucao_documento       is null  and
      d.dt_cancelamento_documento    is null ),0)   as 'Total_Aberto_Periodo',

  --Total Pago pelo Cliente no Período----------------------------------------------

  isnull(( select
      sum( 
        isnull(drp.vl_pagamento_documento,0)
        - isnull(drp.vl_juros_pagamento, 0)
        + isnull(drp.vl_desconto_documento, 0)
        + isnull(drp.vl_abatimento_documento, 0)
        + isnull(drp.vl_despesa_bancaria, 0)
        - isnull(drp.vl_reembolso_documento, 0)
        - isnull(drp.vl_credito_pendente, 0) )
         
    from
      Documento_receber d                       with (nolock) 
      inner join Documento_Receber_Pagamento drp with (nolock) on drp.cd_documento_receber = d.cd_documento_receber
    where
      isnull(drp.vl_pagamento_documento,0)>0                       and
      drp.dt_pagamento_documento between @dt_inicial and @dt_final and
      d.cd_cliente = c.cd_cliente                                 and
      d.dt_devolucao_documento       is null                      and
      d.dt_cancelamento_documento    is null ),0)   as 'Total_Pago',  

  isnull(( select
      sum( d.vl_documento_receber ) 
--    sum(     
--         isnull(drp.vl_pagamento_documento,0)
--         - isnull(drp.vl_juros_pagamento, 0)
--         + isnull(drp.vl_desconto_documento, 0)
--         + isnull(drp.vl_abatimento_documento, 0)
--         + isnull(drp.vl_despesa_bancaria, 0)
--         - isnull(drp.vl_reembolso_documento, 0)
--         - isnull(drp.vl_credito_pendente, 0) )
         
    from
      Documento_receber d                       with (nolock) 
      inner join Documento_Receber_Pagamento drp with (nolock) on drp.cd_documento_receber = d.cd_documento_receber
    where
      d.dt_emissao_documento < @dt_inicial                         and
      isnull(drp.vl_pagamento_documento,0)>0                       and
      --drp.dt_pagamento_documento between @dt_inicial and @dt_final and
      drp.dt_pagamento_documento > @dt_final and
      d.cd_cliente = c.cd_cliente                                  and
      d.dt_devolucao_documento       is null                       and
      d.dt_cancelamento_documento    is null ),0)   as 'Total_Pago_Apos_Periodo',  

  isnull(( select
      sum( 
        isnull(drp.vl_pagamento_documento,0)
        - isnull(drp.vl_juros_pagamento, 0)
        + isnull(drp.vl_desconto_documento, 0)
        + isnull(drp.vl_abatimento_documento, 0)
        + isnull(drp.vl_despesa_bancaria, 0)
        - isnull(drp.vl_reembolso_documento, 0)
        - isnull(drp.vl_credito_pendente, 0) )
         
    from
      Documento_receber d                       with (nolock) 
      inner join Documento_Receber_Pagamento drp with (nolock) on drp.cd_documento_receber = d.cd_documento_receber
    where
      d.dt_emissao_documento < @dt_inicial                         and
      isnull(drp.vl_pagamento_documento,0)>0                       and
      drp.dt_pagamento_documento between @dt_inicial and @dt_final and
      d.cd_cliente = c.cd_cliente                                  and
      d.dt_devolucao_documento       is null                       and
      d.dt_cancelamento_documento    is null ),0)   as 'Total_Pago_Aberto_Periodo',  

--  0.00                                              as 'Total_Pago',

  --Total Faturado pelo Cliente no Período----------------------------------------------

  isnull(( select
      sum( isnull(d.vl_documento_receber,0) )
    from
      Documento_receber d                       with (nolock) 
    where
      --isnull(d.vl_documento_receber,0)>0                       and
      d.dt_emissao_documento between @dt_inicial and @dt_final and
      d.cd_cliente = c.cd_cliente                               and
      --d.dt_devolucao_documento       is null                   and
      d.dt_cancelamento_documento    is null
      ),0)                                                      as 'Total_Faturado',

   --Dias de Pagamento-----------------------------------------------------------------

    isnull(( select
      sum( isnull( cast(dp.dt_pagamento_documento-d.dt_vencimento_documento as int ),0) )
    from
      Documento_receber d                       with (nolock) 
      inner join Documento_Receber_Pagamento dp with (nolock) on dp.cd_documento_receber = d.cd_documento_receber
    where
      isnull(dp.vl_pagamento_documento,0)>0                       and
      dp.dt_pagamento_documento between @dt_inicial and @dt_final and
      d.cd_cliente = c.cd_cliente                                 and
      d.dt_devolucao_documento       is null                      and
      d.dt_cancelamento_documento    is null ),0)   as 'Dias_Pago'

  
  --0.00                                              as 'Total_Faturado',
--  0.00                                              as 'Perc_Faturado',
--  0.00                                              as 'PMR'

into
  #AuxPosicaoCliente

from
  Cliente c                            with (nolock) 
  left outer join Estado e             with (nolock) on e.cd_estado       = c.cd_estado
  left outer join Cidade cid           with (nolock) on cid.cd_cidade     = c.cd_cidade
  left outer join Tipo_Pessoa tp       with (nolock) on tp.cd_tipo_pessoa = c.cd_tipo_pessoa  

group by
  c.cd_cliente,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente

declare @vl_total_faturamento float
set @vl_total_faturamento = 0.00

select
  @vl_total_faturamento = sum( isnull(Total_Faturado,0) )
from
  #AuxPosicaoCliente

select
  identity(int,1,1) as Posicao,
  *,
  
  Perc_Faturado = ( Total_Faturado / @vl_total_faturamento )*100,
  
  PMR = case when Total_Faturado>0 
        then 
          Total_Aberto / ( case when Total_Faturado>0 then Total_Faturado else 1 end ) * Dias_Pago
        else
          0.00
        end,

  Saldo_Aberto          = ( Saldo_aberto_auxiliar + Total_Pago_Apos_Periodo + Total_Pago_Aberto_Periodo),
  Saldo_Aberto_Seguinte = ( Saldo_Aberto_auxiliar + Total_Faturado + Total_Pago_Aberto_Periodo + Total_Pago_Apos_Periodo ) - case when Total_Pago>0 then Total_Pago else 0.00 end
        
 
into
  #PosicaoClienteRecebimento

from
  #AuxPosicaoCliente
order by
  Total_Aberto desc

select 
  * 
from 
  #PosicaoClienteRecebimento

order by
  nm_razao_social_cliente

--  Posicao




