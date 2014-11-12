

/****** Object:  Stored Procedure dbo.pr_documento_receber_movimento    Script Date: 13/12/2002 15:08:27 ******/

CREATE PROCEDURE pr_documento_receber_movimento
@ic_parametro as int,
@cd_cliente as int
AS

--------------------------------------------------------------------------------------------
--  ic_parametro = 1 - Consulta de Movimento de Duplicata por Cliente
--------------------------------------------------------------------------------------------  
  If @ic_parametro = 1
  Begin
    select
      dr.cd_cliente,
      dr.cd_documento_receber      as 'Duplicata',
      dr.dt_emissao_documento      as 'Emissao',
      dr.dt_vencimento_documento   as 'Vencimento',
      dr.vl_documento_receber      as 'Valor',
      (select sum(dr.vl_saldo_documento) from Documento_Receber dr     
       where dr.cd_cliente = @cd_cliente and dr.cd_tipo_documento=1) as  'Saldo_Acumulado',
      dr.dt_cancelamento_documento as 'Cancelamento',
      drp.dt_pagamento_documento   as 'Pagamento',
      por.nm_portador              as 'Portador',
      td.nm_tipo_documento         as 'Tipo_Documento'
    from
      Documento_Receber dr
    left outer join Documento_Receber_Pagamento drp on
      drp.cd_documento_receber=dr.cd_documento_receber
    left outer join Portador por on
      por.cd_portador=dr.cd_portador
    left outer join Tipo_Documento td on
      td.cd_tipo_documento=dr.cd_tipo_documento

    WHERE     
     dr.cd_cliente = @cd_cliente and
     dr.cd_tipo_documento=1
    ORDER BY
      dr.cd_documento_receber

  End Else

--------------------------------------------------------------------------------------------
--  ic_parametro = 2
--------------------------------------------------------------------------------------------  
  If @ic_parametro = 2
  Begin
    print('Atenção, não existe consulta para esse parâmetro!')
  End




