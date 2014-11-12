
CREATE PROCEDURE [sp_View_FuncoesDisponiveisParaModulo]
@cd_modulo int
AS
SELECT F.cd_funcao, F.nm_funcao
FROM Funcao F
WHERE F.cd_funcao not in 
    (SELECT cd_funcao FROM Modulo_Funcao_Menu
     WHERE cd_modulo = @cd_modulo)
ORDER BY nm_funcao

