

/****** Object:  Stored Procedure dbo.pr_consulta_documento_receber_individual    Script Date: 13/12/2002 15:08:19 ******/

CREATE PROCEDURE pr_consulta_documento_receber_individual

@cd_documento_receber varchar(25)

AS

  select
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_documento_receber,
    d.cd_cliente,
    c.nm_fantasia_cliente,
    e.cd_telefone_cliente
    
 from
    documento_receber d,
    cliente c
 left outer join
    cliente_endereco e
 on
   c.cd_cliente = e.cd_cliente

 where 
  d.cd_identificacao = @cd_documento_receber



