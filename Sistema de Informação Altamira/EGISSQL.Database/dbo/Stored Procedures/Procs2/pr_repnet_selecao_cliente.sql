




--pr_repnet_selecao_cliente
-----------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                            2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes         
--Selecao de Cliente para Utilizar no RepNet
--Data          : 07.04.2002
--Atualizado    :  
-----------------------------------------------------------------------------------
create procedure pr_repnet_selecao_cliente
@cd_vendedor         int,
@nm_fantasia_cliente varchar(15)
as

select
  cd_cliente          as 'Codigo',
  nm_fantasia_cliente as 'Cliente'  
from
  Cliente
where
  @cd_vendedor = cd_vendedor and
  @nm_fantasia_cliente = nm_fantasia_cliente




