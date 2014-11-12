

/****** Object:  Stored Procedure dbo.pr_wapnet_fornecedor    Script Date: 13/12/2002 15:08:45 ******/
--pr_wapnet_fornecedor
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Consulta de Fornecedores WapNet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
create procedure pr_wapnet_fornecedor
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

select nm_fantasia_fornecedor as 'Fornecedor',
       cd_fornecedor          as 'CodFornecedor'
from
   Fornecedor
Where
   ic_wapnet_fornecedor= 'S'



