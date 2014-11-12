
CREATE VIEW [dbo].[Sessões Ativas]
AS

	SELECT [Representante].*
	FROM [Representante].[Representante] INNER JOIN [Representante].[Sessão de Representante] ON Representante.Identificador = [Sessão de Representante].[Identificador do Representante]
	WHERE [Sessão de Representante].[Sessão Válida] = 1
