﻿









CREATE PROCEDURE [Representante].[Busca de Recados por Período]
	@Sessao			AS UNIQUEIDENTIFIER,
	@DataInicial	AS DATE,
	@DataFinal		AS DATE
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT TOP 1000 
		[Recado].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Recado] ON [Representante].Código = [Recado].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND CAST([Data do Cadastro] AS DATE) >= @DataInicial 
		AND CAST([Data do Cadastro] AS DATE) <= @DataFinal
	ORDER BY 
		[Recado].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Recados por Período', CAST(@DataInicial AS NVARCHAR(10)) + ' à ' + CAST(@DataFinal AS NVARCHAR(10)), @@ROWCOUNT) 


	
END










GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Recados por Período] TO [altanet]
    AS [dbo];

