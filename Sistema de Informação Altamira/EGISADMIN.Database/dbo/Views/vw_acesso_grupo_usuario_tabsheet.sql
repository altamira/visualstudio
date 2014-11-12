
CREATE VIEW vw_acesso_grupo_usuario_tabsheet
------------------------------------------------------------------------------------
--vw_acesso_grupo_usuario_tabsheet
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISADMIN
--Objetivo	        : Mostra o acesso na Classe das TabSheets e também o Acesso
--                        do Grupo de Usuário / Usuario
--
--Data                  : 30.07.2004
--Atualização           : 15.08.2005
------------------------------------------------------------------------------------
as

select
  c.cd_classe,
  c.nm_classe,
  ts.nm_tabsheet,
  guc.cd_grupo_usuario,
  uct.cd_usuario
from 
  Classe c
  inner join Classe_TabSheet ct                     on ct.cd_classe    = c.cd_classe
  inner join Tabsheet        ts                     on ts.cd_tabsheet  = ct.cd_tabsheet
  left outer join Grupo_Usuario_Classe_Tabsheet guc on guc.cd_classe   = ct.cd_classe and
                                                       guc.cd_tabsheet = ct.cd_tabsheet
  left outer join Usuario_classe_tabsheet       uct on uct.cd_classe   = ct.cd_classe and
                                                       uct.cd_tabsheet = ct.cd_tabsheet
 
 
