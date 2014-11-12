

/****** Object:  Stored Procedure dbo.pr_vendedor_repnet    Script Date: 13/12/2002 15:08:44 ******/
--pr_pr_vendedor_repnet
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta dos Vendedores para Consulta/Acesso ao RepNet
--Data          : 07.04.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
create procedure pr_vendedor_repnet
  
as

select cd_vendedor,
       nm_fantasia_vendedor,
       dt_acesso_repnet_vendedor,
       nm_logotipo_vendedor
from       
       Vendedor
where
       ic_ativo = 'A'   and
       ic_repnet_vendedor = 'S'   



