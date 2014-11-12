

CREATE PROCEDURE [Representante].[Troca Senha do Representante]
	@Identificador	AS INT,
	@SenhaAtual		AS INT,
	@NovaSenha		AS INT
AS
	SET NOCOUNT ON
	
	UPDATE 
		[Representante]
	SET 
		[Senha] = @NovaSenha
	WHERE 
		[Identificador] = @Identificador
		AND [Senha] = @SenhaAtual
		AND [Acesso Bloqueado] = 0


GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Troca Senha do Representante] TO [altanet]
    AS [dbo];

