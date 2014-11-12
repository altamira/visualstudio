
create procedure pr_estorno_retorno_banco_doc_receber

@cd_parametro int,
@cd_portador  int,
@dt_retorno   datetime

as

if @cd_parametro = 1
begin

  select c.nm_fantasia_cliente,
         d.dt_retorno_banco_doc,
         d.cd_documento_receber,
         d.cd_identificacao,
         d.dt_vencimento_documento,
         d.vl_documento_receber,
         d.vl_saldo_documento,
        (dp.vl_pagamento_documento -
         dp.vl_juros_pagamento + 
         dp.vl_desconto_documento + 
         dp.vl_abatimento_documento -
         dp.vl_despesa_bancaria - 
         dp.vl_reembolso_documento +
         dp.vl_credito_pendente) as vl_pago_calculado,
         dp.dt_pagamento_documento,
         d.cd_banco_documento,
         dp.cd_banco,
         d.cd_portador,
         d.cd_banco_documento_recebe,
         dp.vl_pagamento_documento,
         dp.vl_juros_pagamento,
         dp.vl_desconto_documento,
         dp.vl_abatimento_documento,
         dp.vl_despesa_bancaria,
         dp.vl_reembolso_documento,
         dp.vl_credito_pendente

  from documento_receber d,
       documento_receber_pagamento dp,
       cliente c 

  where d.dt_retorno_banco_doc between @dt_retorno and @dt_retorno+1 and
        d.cd_documento_receber *= dp.cd_documento_receber and
        d.cd_portador = @cd_portador and
        d.cd_cliente = c.cd_cliente

  order by d.cd_identificacao

end

if @cd_parametro = 2
begin

  declare @vl_documento_receber    float
  declare @vl_pago_documento       float
  declare @cd_documento_receber    int 
  declare @dt_pagamento_documento  datetime 

  set @vl_documento_receber      = 0
  set @vl_pago_documento         = 0 
  set @cd_documento_receber      = 0
  set @dt_pagamento_documento    = null

  select d.cd_documento_receber,
         max(d.vl_documento_receber)      as vl_documento_receber,
         max(dp.dt_pagamento_documento)   as dt_pagamento_documento,       
         sum(dp.vl_pagamento_documento)   as vl_pagamento_documento,
         sum(dp.vl_juros_pagamento)       as vl_juros_pagamento,
         sum(dp.vl_desconto_documento)    as vl_desconto_documento,
         sum(dp.vl_abatimento_documento)  as vl_abatimento_documento,
         sum(dp.vl_despesa_bancaria)      as vl_despesa_bancaria,
         sum(dp.vl_reembolso_documento)   as vl_reembolso_documento,
         sum(dp.vl_credito_pendente)      as vl_credito_pendente
  ----
  into #TmpDocumentoEstorno
  ----
  from documento_receber d,
       documento_receber_pagamento dp

  where d.dt_retorno_banco_doc between @dt_retorno and @dt_retorno+1 and
        d.cd_documento_receber *= dp.cd_documento_receber and
        d.cd_portador = @cd_portador

  group by d.cd_documento_receber
  order by d.cd_documento_receber

  while exists (select top 1 * from #TmpDocumentoEstorno)
  begin

    select Top 1
           @cd_documento_receber = cd_documento_receber,
           @dt_pagamento_documento = dt_pagamento_documento,
           @vl_pago_documento = ( vl_pagamento_documento -
                                  vl_juros_pagamento + 
                                  vl_desconto_documento + 
                                  vl_abatimento_documento -
                                  vl_despesa_bancaria - 
                                  vl_reembolso_documento +
                                  vl_credito_pendente ),
           @vl_documento_receber = vl_documento_receber

    from #TmpDocumentoEstorno

    -- Grava saldo "sem as baixas" e data de retorno em branco

    if @vl_pago_documento > @vl_documento_receber
       set @vl_pago_documento = @vl_documento_receber

    if @dt_pagamento_documento is not null -- Se teve algum pagamento...
    begin
       update documento_receber
       set vl_saldo_documento = @vl_pago_documento,
           dt_retorno_banco_doc = null
       where cd_documento_receber = @cd_documento_receber

       -- Deleta todas as baixas desse documento
       delete from documento_receber_pagamento
       where cd_documento_receber = @cd_documento_receber
    end

    if @dt_pagamento_documento is null
    -- Se não teve pagamento, zera o número bancário para novo retorno...
    begin
       update documento_receber
       set cd_banco_documento_recebe = null,
           dt_retorno_banco_doc = null
       where cd_documento_receber = @cd_documento_receber
    end

    -- Deleta o documento da tabela temporária
    delete from #TmpDocumentoEstorno
    where cd_documento_receber = @cd_documento_receber

  end
  
end

