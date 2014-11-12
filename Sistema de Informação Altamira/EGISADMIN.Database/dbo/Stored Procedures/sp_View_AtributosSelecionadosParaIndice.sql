
CREATE PROCEDURE [sp_View_AtributosSelecionadosParaIndice]
@cd_tabela int,
@cd_indice int
AS
SELECT IA.cd_tabela, IA.cd_indice, IA.cd_atributo, IA.cd_sequencia,
       A.nm_atributo FROM Indice_Atributo IA, Atributo A
WHERE IA.cd_tabela  = @cd_tabela 
  AND IA.cd_indice  = @cd_indice
  AND A.cd_tabela   = @cd_tabela
  AND A.cd_atributo = IA.cd_atributo 

