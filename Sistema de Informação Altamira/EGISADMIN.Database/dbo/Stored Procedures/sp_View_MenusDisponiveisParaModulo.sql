
CREATE PROCEDURE [sp_View_MenusDisponiveisParaModulo]
@cd_modulo int
AS
/*
SELECT M.cd_menu, M.nm_menu
FROM Menu M
WHERE M.cd_menu not in 
    (SELECT cd_menu FROM Modulo_Funcao_Menu
     WHERE cd_modulo = @cd_modulo)
ORDER BY nm_menu
*/

SELECT 
  M.cd_menu, 
  M.nm_menu,
  case when isnull(c.nm_classe,'')<>'' 
       then c.nm_classe 
       else 
         case when isnull(p.nm_sql_procedimento,'')<>'' 
                then 'sp: '+p.nm_sql_procedimento
                else 'não cadastrado no menu'
         end
  end as nm_classe,
  p.nm_procedimento,
  p.nm_sql_procedimento
FROM
   Menu M
   left outer join classe c       on m.cd_classe       = c.cd_classe
   left outer join procedimento p on p.cd_procedimento = m.cd_procedimento
ORDER BY nm_menu


