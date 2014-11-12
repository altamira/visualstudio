--pr_cliente_problema_credito_setor
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Clientes com Problema de Crédito por Setor
--Data            : 11.01.2000
--Atualizado    : 11.01.2000
--------------------------------------------------------------------------------------
create procedure pr_cliente_problema_credito_setor
@cd_vendedor int
as
select fan_cli as 'cliente',obscred1,obscred2,obscred3,obscred4,obscred5,obscred6,obscred7,obscred8
from
   CADCLI
Where
   lim_cli            = -1  and -- crédito suspenso 
   @cd_vendedor = CV2_CLI
Order by fan_cli
