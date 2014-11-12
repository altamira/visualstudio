

/****** Object:  Stored Procedure dbo.pr_verifica_cone    Script Date: 13/12/2002 15:08:44 ******/
--pr_verifica_cone
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Monstra a Movimentaçao por Máquina
--Data         : 15.12.2000
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_cone
@cd_cone int
as
select cd_cone,ic_status_cone
from
  Cone
Where
  cd_cone = @cd_cone


