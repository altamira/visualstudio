

/****** Object:  Stored Procedure dbo.pr_verifica_ferramenta_cone    Script Date: 13/12/2002 15:08:45 ******/
--pr_verifica_cone
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Verifica a ferramenta associada ao cone
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_verifica_ferramenta_cone
@cd_cone int
as
select a.cd_cone,a.cd_grupo_ferramenta,a.cd_ferramenta,b.nm_ferramenta
from
  Ferramenta_Cone a, Ferramenta b
Where
  a.cd_cone = @cd_cone and
  b.cd_ferramenta=a.cd_ferramenta


