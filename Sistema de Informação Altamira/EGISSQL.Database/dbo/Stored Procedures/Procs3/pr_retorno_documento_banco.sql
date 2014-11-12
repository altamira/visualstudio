

/****** Object:  Stored Procedure dbo.pr_retorno_documento_banco    Script Date: 13/12/2002 15:08:41 ******/

CREATE PROCEDURE pr_retorno_documento_banco
--pr_retorno_documento_banco
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: SapSql
--Objetivo: Lista todos os documentos que retornaram
--          do banco
--Filtro  : cd_portador
--Data: 13/02/2002
--Atualizado: 13/03/2002 - Modificação do Campo
-- vl_saldo_documento de Float p/ decimal - Daniel C. Neto
---------------------------------------------------
  @cd_portador int
AS

  select     
    cd_documento_receber,
    cd_identificacao,
    dc.dt_emissao_documento, 
    dc.dt_vencimento_documento, 
    dc.vl_documento_receber, 
    cast(str(dc.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento', 
    dc.ic_envio_documento, 
    cli.nm_fantasia_cliente
  from         
    documento_receber dc inner join cliente cli on 
      dc.cd_cliente = cli.cd_cliente
  where     
    dc.ic_envio_documento = 'S' and 
    dc.dt_envio_banco_documento is not null and 
    dc.cd_portador = @cd_portador



