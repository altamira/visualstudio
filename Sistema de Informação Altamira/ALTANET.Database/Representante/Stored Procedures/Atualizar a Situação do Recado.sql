



CREATE PROCEDURE [Representante].[Atualizar a Situação do Recado]
	@Representante		INT,
	@Numero				INT,
	@Situacao			NVARCHAR(50),
	@TipoMaterial		NVARCHAR(50),
	@Probabilidade		NUMERIC(3,0),
	@Concorrentes		NVARCHAR(50),
	@ProximoContato		DATE,
	@Observacao			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	/*IF (EXISTS(SELECT * FROM [Informações Adicionais do Orçamento] WHERE [Número do Orçamento] = @Numero))
	BEGIN
		UPDATE [Informações Adicionais do Orçamento]
		SET 
			[Tipo de Material] = @TipoMaterial,
			[Probabilidade de Fechamento] = @Probabilidade,
			[Concorrentes] = @Concorrentes,
			[Próximo Contato] = @ProximoContato
		WHERE [Número do Orçamento] = @Numero
	END
	ELSE
	BEGIN
		INSERT INTO [Informações Adicionais do Orçamento] 
			([Número do Orçamento], 
			[Tipo de Material],
			[Probabilidade de Fechamento],
			[Concorrêntes],
			[Próximo Contato])
		VALUES 
			(@Numero,
			@TipoMaterial,
			@Probabilidade,
			@Concorrentes,
			@ProximoContato)
	END
	
	IF @@ROWCOUNT > 0
	BEGIN
		INSERT INTO [Histórico da Situação do Orçamento]
			([Número do Orçamento], [Última Atualização], [Situação], [Observações])
			VALUES (@Numero, GETDATE(), @Situacao, @Observacao)
	END*/
END



