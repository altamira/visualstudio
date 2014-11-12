

CREATE PROCEDURE pr_exclusao_projeto_engenharia
-- =======================================================
--                   Parâmetro(s)
-- =======================================================
@cd_projeto INTEGER


AS

DELETE FROM
	Projeto_Composicao

WHERE
	cd_projeto = @cd_projeto

DELETE FROM
	Projeto_Composicao_Material

WHERE
	cd_projeto = @cd_projeto

DELETE FROM
	Projeto_Revisao

WHERE
	cd_projeto = @cd_projeto

DELETE FROM
	Projeto

WHERE
	cd_projeto = @cd_projeto

