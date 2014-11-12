
CREATE PROCEDURE pr_ViewCliente_Atendido_Transportadora
@cd_transportadora int,@cd_usuario int = 0
AS

SELECT  distinct
   c.nm_fantasia_cliente as nm_razao_social_cliente, 
   '(' + IsNull(c.cd_ddd,'0') + ') ' + c.cd_telefone as 'cd_telefone_cliente', 
   cid.nm_cidade, 
   e.sg_estado as nm_estado, 
   p.nm_pais, 
   v.nm_fantasia_vendedor as nm_vendedor
FROM 
   dbo.Cliente c
   INNER JOIN dbo.Cidade cid
   ON c.cd_cidade = cid.cd_cidade 
   INNER JOIN dbo.Pais p
   ON c.cd_pais = p.cd_pais 
   INNER JOIN dbo.Estado e
   ON c.cd_estado = e.cd_estado AND c.cd_pais = e.cd_pais 
   LEFT OUTER JOIN dbo.Vendedor v ON v.cd_vendedor = c.cd_vendedor 

WHERE (c.cd_transportadora = @cd_transportadora)
--Define para trazer apenas vendedor externo
and (v.cd_tipo_vendedor = 2)
and c.cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then c.cd_vendedor else dbo.fn_vendedor(@cd_usuario) END)     
order by 
   c.nm_fantasia_cliente
