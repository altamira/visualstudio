
-------------------------------------------------------------------------------
--pr_ajusta_cliente_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste do Cadastro de cliente com os Vendedores
--Data             : 19.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ajusta_cliente_vendedor
as

--select * from cliente_vendedor

select 
  c.cd_vendedor  as Vendedor_Cliente, 
  cv.cd_vendedor as Vendedor_Cliente_Vendedor,
  v.cd_tipo_vendedor
from 
  cliente c
  left outer join cliente_vendedor cv on cv.cd_cliente = c.cd_cliente
  left outer join Vendedor v          on v.cd_vendedor = cv.cd_vendedor
where 
  isnull(c.cd_vendedor,0) = 0  and
  v.cd_tipo_vendedor = 2

update
  cliente 
set
  cd_vendedor = cv.cd_vendedor
from
  Cliente c
  left outer join cliente_vendedor cv on cv.cd_cliente = c.cd_cliente
  left outer join Vendedor v          on v.cd_vendedor = cv.cd_vendedor
where 
  isnull(c.cd_vendedor,0) = 0  and
  v.cd_tipo_vendedor = 2

