
-------------------------------------------------------------------------------
--pr_consulta_cliente_mp66
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes 
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Clientes sujeitos a MP66
--                   
--
--Data             : 02.10.2005
--Atualizado       : 02.10.2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_cliente_mp66
@dt_inicial datetime,
@dt_final   datetime

as

select
  c.dt_cadastro_cliente     as DataCadastro,
  c.nm_fantasia_cliente     as Cliente,
  c.nm_razao_social_cliente as RazaoSocial,
  sc.nm_status_cliente      as Status,
  c.cd_ddd + c.cd_telefone  as Telefone
from
  Cliente c
left outer join Status_Cliente sc on sc.cd_status_cliente = c.cd_status_cliente  

where
  isnull(ic_mp66_cliente,'N') = 'S'

--select ic_mp66_cliente,* from cliente

order by 
 1,2
  
