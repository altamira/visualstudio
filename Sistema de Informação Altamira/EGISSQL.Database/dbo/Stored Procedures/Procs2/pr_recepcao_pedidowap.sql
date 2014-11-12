

/****** Object:  Stored Procedure dbo.pr_recepcao_pedidowap    Script Date: 13/12/2002 15:08:39 ******/
--pr_recepcao_pedidowap
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                   2002                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes / Leonardo
--Recepcao de Pedidos Wap
--Data          : 03.03.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
create procedure pr_recepcao_pedidowap
as
  select * from recepcao_pedidowap
  order by
     dt_usuario desc


