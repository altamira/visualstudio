
CREATE PROCEDURE pr_Modulo_Funcao_Menu
AS
SELECT 
   md.nm_modulo as 'Modulo',
   fu.nm_funcao as 'Funcao',
   mn.nm_menu as 'Menu'
from
   Modulo md
left outer join Modulo_Funcao_Menu mfm
   on (mfm.cd_modulo=md.cd_modulo) 
left outer join Funcao fu
   on (fu.cd_funcao=mfm.cd_funcao)
left outer join Menu mn
   on (mn.cd_menu=mfm.cd_menu)
ORDER BY md.nm_Modulo, mfm.cd_indice


