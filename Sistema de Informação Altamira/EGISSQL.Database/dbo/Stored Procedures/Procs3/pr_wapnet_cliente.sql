

/****** Object:  Stored Procedure dbo.pr_wapnet_cliente    Script Date: 13/12/2002 15:08:45 ******/
--pr_wapnet_cliente
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Consulta de Cliente WapNet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
create procedure pr_wapnet_cliente
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

select nm_fantasia_cliente as 'Cliente',
       cd_cliente          as 'CodCliente'
from
   Cliente
Where
   ic_wapnet_cliente = 'S'



