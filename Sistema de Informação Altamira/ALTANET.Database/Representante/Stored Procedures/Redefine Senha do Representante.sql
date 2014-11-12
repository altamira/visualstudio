

CREATE PROCEDURE [Representante].[Redefine Senha do Representante]
	@Identificador	AS INT,
	@NovaSenha		AS INT
AS
	SET NOCOUNT ON
	
	UPDATE 
		[Representante]
	SET 
		[Senha] = @NovaSenha
	WHERE 
		[Identificador] = @Identificador
		AND [Acesso Bloqueado] = 0


GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Redefine Senha do Representante] TO [altanet]
    AS [dbo];

