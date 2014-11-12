
-------------------------------------------------------------------------------
--sp_View_ModuloCadeiaValor
-------------------------------------------------------------------------------
--GBS Global Busines Solution Ltda                                         2004
-------------------------------------------------------------------------------
--Stored Procedure       : Micrisoft Sql Server 2000
--Autor(es)              : Carlos Cardoso Fernandes
--Banco de Dados         : EgisSql ou EgisAdmin
--Objetivo               :
--Data                   : 13/12/2004
--Alteração              : Acerto no Cabçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
create  PROCEDURE sp_View_ModuloCadeiaValor
@cd_cadeia_valor int
AS
  SELECT 
  M.cd_cadeia_valor,
	M.cd_modulo, 
	M.nm_modulo, 
	M.cd_ordem_modulo, 
  cast( M.ds_modulo as varchar(200)) as cl_descricao,
	I.nm_local_imagem, 
	I.nm_arquivo_imagem
  FROM 
	Modulo M LEFT OUTER JOIN 
	Imagem I ON (M.cd_imagem = I.cd_imagem)
  WHERE 
	((@cd_cadeia_valor = 0) or (M.cd_cadeia_valor = @cd_cadeia_valor))
  and 
	IsNull(M.ic_vincular_cadeia_valor,'S') = 'S' and
	IsNull(M.ic_liberado,'S') = 'S'
  ORDER BY cd_ordem_modulo
