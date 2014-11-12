

/****** Object:  Stored Procedure dbo.pr_verifica_maquina_cone    Script Date: 13/12/2002 15:08:45 ******/
--pr_verifica_maquina_cone
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Verifica a maquina onde o cone está
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_maquina_cone
@cd_cone int
as
select a.cd_movimento,a.cd_cone,a.cd_maquina,b.nm_fantasia_maquina
from
  Movimento_Cone a, Maquina b
Where
  cd_cone = @cd_cone and
  cd_movimento= (select max(cd_movimento) from Movimento_Cone Where cd_cone = @cd_cone) and
  a.cd_maquina=b.cd_maquina


