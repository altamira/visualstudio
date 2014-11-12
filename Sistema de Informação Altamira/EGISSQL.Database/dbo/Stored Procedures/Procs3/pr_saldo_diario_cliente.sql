

/****** Object:  Stored Procedure dbo.pr_saldo_diario_cliente    Script Date: 13/12/2002 15:08:42 ******/

CREATE PROCEDURE pr_saldo_diario_cliente
@cd_cliente    int,                  -- código do cliente
@dt_saldo      datetime,             -- data base
@vl_saldo      float output          -- valor do saldo anterior

AS
BEGIN

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SaldoCliente'
	   AND 	  type = 'U')
    DROP TABLE SaldoCliente

  select 
    distinct
    d.cd_documento_receber as 'CodDocumento',
    isnull(d.vl_documento_receber,0) as 'VlrDocumento'
  into
    dbo.SaldoCliente
  from 
    documento_receber d
  left outer join
    documento_receber_pagamento p
  on
    d.cd_documento_receber = p.cd_documento_receber
  where 
    d.cd_cliente = @cd_cliente and
    (p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_saldo) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_saldo) 

  select
    @vl_saldo = isnull(sum(VlrDocumento),0)
  from
    dbo.SaldoCliente

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SaldoCliente'
	   AND 	  type = 'U')
    DROP TABLE SaldoCliente

end


