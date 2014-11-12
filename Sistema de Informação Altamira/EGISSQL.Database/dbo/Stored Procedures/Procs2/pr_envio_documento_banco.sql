
CREATE PROCEDURE pr_envio_documento_banco
--pr_envio_documento_banco
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: SapSql
--Objetivo: Lista todos os documentos que serão 
--          enviados ao portador selecionado
--Data: 08/02/2002
--Atualizado: 13/03/2002 - Modificado vl_saldo_documento
-- de float p/ decimal - Daniel C. Neto
---------------------------------------------------
  @cd_portador int,
  @ic_parametro int
AS

---------------------------------------------------
-- @ic_movimento = 1 
-- Listar todos os documentos a serem enviados 
-- ao banco
---------------------------------------------------
  If @ic_parametro = 1 Begin
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
      dc.dt_envio_banco_documento is null and 
      dc.cd_portador = @cd_portador and
      dc.vl_saldo_documento > 0   -- Ludinei 31/01/2003
  End Else
------------------------------------------------------
--  Atualização da data de envio
------------------------------------------------------

  If @ic_parametro = 2 Begin

  Update Documento_Receber
  set dt_envio_banco_documento = getdate()
  Where
    ic_envio_documento = 'S' and
    dt_envio_banco_documento is null and
    cd_portador = @cd_portador

  End

