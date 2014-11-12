

/****** Object:  Stored Procedure dbo.pr_pedidowap    Script Date: 13/12/2002 15:08:38 ******/
--pr_pedidowap
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                   2002                     
--Stored Procedure : SQL Server Microsoft 2000  
--Leonardo
--Pedido Wap
--Data          : 15.03.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
create procedure pr_pedidowap
as

  select * from pedidowap
  order by
     dt_usuario desc



