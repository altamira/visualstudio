
CREATE VIEW vw_cliente_autorizado_nota_fiscal
------------------------------------------------------------------------------------
--vw_cliente_autorizado_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Clientes Autorizados para Emissão do Lay-Out da Nota Fiscal
--                        
--Banco de Dados	: EGISSQL
--Objetivo	        : Montagem da Linha com os CPF's autorizados para 
--                        Nota Fiscal
--Data                  : 30/09/2008
--
--Atualização           : 
--
------------------------------------------------------------------------------------
as
 
--
select 
  c.cd_cliente,
  c.nm_fantasia_cliente,
  cr.nm_cliente_representante,
  cr.cd_cpf_cliente

from
  cliente_representante cr with (nolock) 
  inner join cliente    c  with (nolock) on c.cd_cliente = cr.cd_cliente


