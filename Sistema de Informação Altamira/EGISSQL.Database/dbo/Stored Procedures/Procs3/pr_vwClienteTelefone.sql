

/****** Object:  Stored Procedure dbo.pr_vwClienteTelefone    Script Date: 13/12/2002 15:08:45 ******/

CREATE PROCEDURE pr_vwClienteTelefone
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
  left outer join 
  (Select distinct cd_cliente, cd_ddd_cliente, cd_telefone_cliente, cd_fax_cliente  
   From Cliente_Endereco
   Where cd_telefone_cliente is not null) e

On
  c.cd_cliente = e.cd_cliente
Order By
  nm_fantasia_cliente



