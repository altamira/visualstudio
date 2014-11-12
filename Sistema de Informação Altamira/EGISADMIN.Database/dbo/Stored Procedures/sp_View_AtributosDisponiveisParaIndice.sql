
CREATE PROCEDURE [sp_View_AtributosDisponiveisParaIndice]
@cd_tabela int,
@cd_indice int
AS
SELECT A.cd_tabela, A.cd_atributo, A.nm_atributo
FROM Atributo A
WHERE A.cd_atributo not in 
    (SELECT cd_atributo FROM Indice_Atributo 
     WHERE cd_tabela = @cd_tabela and cd_indice = @cd_indice)
 AND A.cd_tabela = @cd_tabela

