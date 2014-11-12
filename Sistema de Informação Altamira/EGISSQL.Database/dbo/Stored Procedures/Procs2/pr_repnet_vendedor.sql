




--pr_pr_vendedor_repnet
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta dos Vendedores para Consulta/Acesso ao RepNet
--Data          : 07.04.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE  procedure pr_repnet_vendedor
  
as

select 
  cd_vendedor,
  nm_fantasia_vendedor,
  dt_acesso_repnet_vendedor,
  nm_logotipo_vendedor
from       
       Vendedor
where
       ic_ativo = 'A'   and
       ic_repnet_vendedor = 'S'   
order by nm_fantasia_vendedor 





