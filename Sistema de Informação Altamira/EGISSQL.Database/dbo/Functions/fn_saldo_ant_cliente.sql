
CREATE FUNCTION fn_saldo_ant_cliente
  (@dt_inicial datetime, 
   @cd_cliente int)
RETURNS @SaldoAnterior TABLE 
	(cd_cliente int, 
	 SaldoAnterior float)

AS
BEGIN

-------------------------------------------------------------
-- Descobrindo saldo anterior
-------------------------------------------------------------

  -- criar a tabela temporária na memória
  declare @Tabela_Documento table 
  ( cd_cliente int,
    vl_documento float)

  declare @Tabela_Pagamento table 
  ( cd_cliente int,
    vl_pagamento float)



--Soma dos Documentos Anteriores
  insert into @Tabela_Documento
  select 
    cd_cliente,
    sum(vl_documento_receber) as 'vl_documento'
  from
    (
      select distinct
        d.cd_cliente,
        d.cd_documento_receber,
        cast(str(isnull(d.vl_documento_receber,0),25,2) as decimal(25,2)) as 'vl_documento_receber'
      from Documento_Receber d inner join
        Documento_Receber di on di.cd_documento_receber = d.cd_documento_receber and
                                di.cd_cliente = ( case when @cd_cliente = 0 then d.cd_cliente 
                                                  else @cd_cliente end)
        left outer join Documento_Receber_Pagamento dp on 
           dp.cd_documento_receber = d.cd_documento_receber 
      where 
         ( ((d.vl_Saldo_documento > 0) and
           (d.dt_emissao_documento < @dt_inicial)) or

           ((dp.dt_pagamento_documento >= @dt_inicial-1) and
           (d.dt_emissao_documento < @dt_inicial)) or

           ((d.dt_devolucao_documento >@dt_inicial-1) and
           (d.dt_emissao_documento < @dt_inicial)) ) and

          (d.dt_cancelamento_documento is null) ) a
  group by cd_cliente

  --Soma dos Pagamentos Anteriores
  insert into @Tabela_Pagamento
  select isnull(d.cd_cliente,tda.cd_cliente) as 'cd_cliente',
         sum(cast(str(isnull(dp.vl_pagamento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_juros_pagamento, 0),25,2) as decimal(25,2))
             + cast(str(isnull(dp.vl_desconto_documento, 0),25,2) as decimal(25,2))
             + cast(str(isnull(dp.vl_abatimento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_despesa_bancaria, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_reembolso_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_credito_pendente, 0),25,2) as decimal(25,2))) as 'vl_pagamento'
   from Documento_Receber d inner join
    (
      select distinct
        d.cd_cliente,
        d.cd_documento_receber,
        cast(str(isnull(d.vl_documento_receber,0),25,2) as decimal(25,2)) as 'vl_documento_receber'
      from Documento_Receber d inner join
        Documento_Receber di on di.cd_documento_receber = d.cd_documento_receber and
                                di.cd_cliente = ( case when @cd_cliente = 0 then d.cd_cliente 
                                                  else @cd_cliente end)
        left outer join Documento_Receber_Pagamento dp on 
           dp.cd_documento_receber = d.cd_documento_receber 
      where 
                  ( ((d.vl_Saldo_documento > 0) and
           (d.dt_emissao_documento < @dt_inicial)) or

           ((dp.dt_pagamento_documento >= @dt_inicial-1) and
           (d.dt_emissao_documento < @dt_inicial)) or

           ((d.dt_devolucao_documento >@dt_inicial-1) and
           (d.dt_emissao_documento < @dt_inicial)) ) and

          (d.dt_cancelamento_documento is null) ) tda on

     tda.cd_documento_receber=d.cd_documento_receber
     left outer join Documento_Receber_Pagamento dp on 
       dp.cd_documento_receber = d.cd_documento_receber 
   where 
     dp.dt_pagamento_documento < @dt_inicial and
     d.cd_cliente = ( case when @cd_cliente = 0 then d.cd_cliente 
                           else @cd_cliente end) and
    (d.dt_cancelamento_documento is null)       
   group by d.cd_cliente, tda.cd_cliente

  --Diferença entre o Valor Bruto do Documento e os Pagamentos
  insert into @SaldoAnterior
  select
    td.cd_cliente,
    (isnull(td.vl_documento,0) - isnull(tp.vl_pagamento,0)) as 'SaldoAnterior'
  from 
    @Tabela_Documento td left outer join 
    @Tabela_Pagamento tp on tp.cd_cliente=td.cd_cliente


  RETURN
END
