
create procedure pr_movimento_contas_receber

@dt_inicial  datetime,
@dt_final    datetime

as

  declare @vl_saldo        float
  declare @vl_faturamento  float
  declare @vl_baixa        float
  declare @vl_cancelamento float
  declare @vl_devolucao    float
  declare @dt_aux          datetime
  declare @vl_juros        float
  declare @vl_reembolso    float
  declare @vl_abatimento   float
  declare @vl_desconto     float

  -- Criacao da Tabela Auxiliar

  create table #tabela 
     ( data         datetime null,
       Saldo        float,
       Faturamento  float,
       Cancelamento float,
       Devolucao    float,
       Baixa        float,
       Juros        float,
       Reembolso    float,
       Abatimento   float,
       Desconto     float,
       SaldoAtual   float)


  -- Data Inicial
  set @dt_aux = @dt_inicial
  

while @dt_aux <= @dt_final
begin

  set @vl_saldo       = 0
  set @vl_faturamento = 0
  set @vl_baixa       = 0
  set @vl_cancelamento= 0
  set @vl_devolucao   = 0
  set @vl_juros       = 0
  set @vl_reembolso   = 0
  set @vl_abatimento  = 0
  set @vl_desconto    = 0

  --Saldo Anterior

  select
    @vl_saldo = @vl_saldo + isnull( sum( d.vl_saldo_documento ),0 )
                           
   from 
    documento_receber d
  where
    d.dt_emissao_documento < @dt_aux     and
    d.dt_cancelamento_documento is null  and
    d.dt_devolucao_documento    is null  

  --Documento Cancelado

  select
    @vl_saldo = @vl_saldo + isnull( sum( d.vl_documento_receber ),0)
                           
   from 
    documento_receber d
  where
    d.dt_emissao_documento     < @dt_aux   and
    d.dt_cancelamento_documento>=@dt_aux   and
  ( d.dt_devolucao_documento is null )

  --Documento Devolvido

  select
    @vl_saldo = @vl_saldo + isnull( sum( d.vl_documento_receber ),0 )
                       
  from 
    documento_receber d
  where
    d.dt_emissao_documento  < @dt_aux     and
    d.dt_devolucao_documento>=@dt_aux     and
  ( d.dt_cancelamento_documento is null )
    
  --Documento Pagos

  select
    @vl_saldo     = @vl_saldo      + isnull( sum( drp.vl_pagamento_documento ),0)
                                   - isnull( sum( drp.vl_juros_pagamento     ),0) 
                                   + isnull( sum( drp.vl_desconto_documento  ),0)
                                   + isnull( sum( drp.vl_abatimento_documento),0)
                                   - isnull( sum( drp.vl_reembolso_documento ),0)
                           
   from 
    documento_receber d, 
    documento_receber_pagamento drp
  where
    d.dt_emissao_documento     < @dt_aux                  and
    d.dt_cancelamento_documento is null                   and
    d.dt_devolucao_documento    is null                   and
    d.cd_documento_receber     = drp.cd_documento_receber and
    drp.dt_pagamento_documento >= @dt_aux
  
  --Faturamento do Dia

  select
    @vl_faturamento = @vl_faturamento + isnull( sum(d.vl_documento_receber),0 )
  from
    documento_receber d
  where
    d.dt_emissao_documento between @dt_aux and @dt_aux                          and
  ( d.dt_cancelamento_documento is null or d.dt_cancelamento_documento>=@dt_aux )and
  ( d.dt_devolucao_documento    is null or d.dt_devolucao_documento >=  @dt_aux )  

  --Cancelamento do Dia

  select
    @vl_cancelamento = @vl_cancelamento + isnull( sum(d.vl_documento_receber),0)
  from
    documento_receber d
  where
    d.dt_cancelamento_documento between @dt_aux and @dt_aux and
    d.dt_devolucao_documento    is null   

  --Devolução

  select
    @vl_devolucao = @vl_devolucao + isnull( sum(d.vl_documento_receber),0 )
  from
    documento_receber d
  where
    d.dt_devolucao_documento    between @dt_aux and @dt_aux and
    d.dt_cancelamento_documento is null   

--Baixas - Pagamentos

  select
    @vl_baixa     = @vl_baixa      + isnull( sum( dp.vl_pagamento_documento ),0),
    @vl_juros     = @vl_juros      + isnull( sum( dp.vl_juros_pagamento     ),0),
    @vl_desconto  = @vl_desconto   + isnull( sum( dp.vl_desconto_documento  ),0),
    @vl_abatimento= @vl_abatimento + isnull( sum( dp.vl_abatimento_documento),0),
    @vl_reembolso = @vl_reembolso  + isnull( sum( dp.vl_reembolso_documento ),0)
 
   from
    documento_receber_pagamento dp, 
    documento_receber d
  where
    dp.dt_pagamento_documento between @dt_aux  and @dt_aux and
    dp.cd_documento_receber   = d.cd_documento_receber     and
    d.dt_cancelamento_documento is null                    and
    d.dt_devolucao_documento    is null

-- Atualiza o Valor da Baixa

    set @vl_baixa = @vl_baixa - @vl_juros + @vl_desconto + @vl_abatimento - @vl_reembolso
         
  insert into #tabela (
    Data,
    Saldo,
    Faturamento,
    Cancelamento,
    Devolucao,
    Baixa,
    Juros,
    Reembolso,
    Abatimento,
    Desconto, 
    SaldoAtual ) values (
 
    @dt_aux,                   
    isnull(@vl_saldo,0),           
    isnull(@vl_faturamento,0),     
    isnull(@vl_cancelamento,0),    
    isnull(@vl_devolucao,0),       
    isnull(@vl_baixa,0),           
    isnull(@vl_juros,0),
    isnull(@vl_reembolso,0),
    isnull(@vl_abatimento,0),
    isnull(@vl_desconto,0), 

    isnull(@vl_saldo,0)+
    isnull(@vl_faturamento,0)-(isnull(@vl_cancelamento,0)+
                              isnull(@vl_devolucao,0)+
                              isnull(@vl_baixa,0) ) )

  set @dt_aux = @dt_aux + 1

end

select * from #tabela

--drop table #tabela
