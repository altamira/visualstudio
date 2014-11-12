

/****** Object:  Stored Procedure dbo.pr_wapnet_produto    Script Date: 13/12/2002 15:08:45 ******/
--pr_wapnet_produto
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Consulta de Fornecedores WapNet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
create procedure pr_wapnet_produto
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

select p.nm_fantasia_produto as 'Produto',
       p.cd_produto          as 'CodProduto'
      
from
   Produto p
Where  
   p.ic_wapnet_produto= 'S'



