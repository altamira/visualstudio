

/****** Object:  Stored Procedure dbo.pr_wapnet_produto_estoque    Script Date: 13/12/2002 15:08:45 ******/
--pr_wapnet_produto_estoque
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Consulta de Fornecedores WapNet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
create procedure pr_wapnet_produto_estoque
@nm_fantasia_produto varchar(30)
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

select 
  p.cd_produto               as 'CodProduto',
  s.qt_saldo_reserva_produto as 'Disponivel'
      
from
   Produto p, Produto_Saldo s
where  
   p.nm_fantasia_produto = @nm_fantasia_produto and
   p.ic_wapnet_produto= 'S'                     and 
   p.cd_produto       = s.cd_produto            and   
   s.cd_fase_produto  = 3



