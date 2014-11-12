

/****** Object:  Stored Procedure dbo.pr_vw_Cliente_Endereco    Script Date: 13/12/2002 15:08:45 ******/

CREATE PROCEDURE pr_vw_Cliente_Endereco
AS

  Select
    c.cd_cliente,
    c.cd_cliente_sap,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    e.cd_ddd_cliente + e.cd_telefone_cliente as 'Telefone',
    e.cd_fax_cliente  
  From
    Cliente c
  Left outer join
    cliente_endereco e
  on
    c.cd_cliente = e.cd_cliente and
    e.cd_tipo_endereco = 1
  Order By
    c.nm_fantasia_cliente


