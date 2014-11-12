

/****** Object:  Stored Procedure dbo.pr_documento_receber_razao_cliente    Script Date: 13/12/2002 15:08:28 ******/

CREATE PROCEDURE pr_documento_receber_razao_cliente
@ic_parametro as int,
@cd_cliente   as int,
@dt_inicial   as datetime,
@dt_final     as datetime
AS

--------------------------------------------------------------------------------------------
if  @ic_parametro = 1 -- Consulta de Razão Auxiliar por Cliente (Duplicatas)
--------------------------------------------------------------------------------------------  
  Begin
    select
      dr.cd_cliente,
      dr.cd_documento_receber      as 'Duplicata',
      dr.dt_emissao_documento      as 'Emissao',
      dr.dt_vencimento_documento   as 'Vencimento',
--      case when ( dt_pto_dup between @dt_inicial and @dt_final ) then a.vlr_dup - a.vl_pgp_dup else 0 end as 'Debito',
      dr.vl_documento_receber      as 'Valor',
      drp.dt_pagamento_documento   as 'Pagamento',
      cic.vl_saldo_atual_aberto    as 'Saldo_Atual_Aberto',
      case when (drp.dt_pagamento_documento<>'') then dr.vl_documento_receber end as 'Credito',
      case when (drp.dt_pagamento_documento='')  then dr.vl_documento_receber end as 'Debito'
    from
     Documento_Receber dr

    left outer join Documento_Receber_Pagamento drp on
      drp.cd_documento_receber=dr.cd_documento_receber
    left outer join Portador por on
      por.cd_portador=dr.cd_portador
    left outer join Tipo_Documento td on
      td.cd_tipo_documento=dr.cd_tipo_documento
    left outer join Cliente_Informacao_Credito cic on
      cic.cd_cliente=dr.cd_cliente

    WHERE     
     dr.cd_cliente = @cd_cliente and
     dr.cd_tipo_documento=1 and
     ((dr.dt_emissao_documento between @dt_inicial and @dt_final) and
      (dr.dt_vencimento_documento between @dt_inicial and @dt_final))
    ORDER BY
      dr.cd_documento_receber

  End Else

--------------------------------------------------------------------------------------------
if  @ic_parametro = 2
--------------------------------------------------------------------------------------------  
  Begin
    print('Atenção, não existe consulta para esse parâmetro!')
  End



