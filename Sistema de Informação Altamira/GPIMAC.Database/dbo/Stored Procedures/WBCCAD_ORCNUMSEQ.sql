
CREATE PROCEDURE [dbo].[WBCCAD_ORCNUMSEQ]
	@ORCNUM NCHAR(8) OUTPUT,
	@MSG NVARCHAR(200) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Numero NCHAR(8)
	DECLARE @Sequencial AS INT
	DECLARE @Num INT
	DECLARE @PrevNum INT
	
	SET @ORCNUM = '0'
	SET @MSG = ''
	
	SET @Numero = (SELECT MAX(ORCNUM) AS NUM FROM [WBCCAD].[dbo].INTEGRACAO_ORCINC)
	
	IF @Numero IS NULL
	BEGIN
		SET @Numero = (SELECT MAX([orclst_numero]) FROM [WBCCAD].[dbo].[Orclst])
	END
	
	SET @PrevNum = (SELECT MAX(ORCNUM) AS NUM FROM [WBCCAD].[dbo].INTEGRACAO_ORCINC WHERE ORCNUM <> @Numero)
	
	IF @PrevNum IS NULL
	BEGIN
		SET @PrevNum = (SELECT MAX([orclst_numero]) FROM [WBCCAD].[dbo].[Orclst] WHERE [orclst_numero] <> @Numero)
	END
	
	IF @PrevNum <> @Numero - 1
	BEGIN
		SET @MSG = 'Numero do Orçamento fora de sequencia. Contate o suporte técnico.'
		RETURN 1
	END
			
	/*SET @Num = (SELECT TOP 1 si_Valor FROM [DBALTAMIRA].dbo.SI_Auxiliar WHERE LTRIM(RTRIM(si_Nome)) = 'pror_NumOrcamento')
	
	IF @Num > CAST(@Numero AS INT)
	BEGIN
		SET @Numero = REPLACE(STR(@Num, 8, 0), ' ', '0')
	END*/
	
	SET @Sequencial = CAST(SUBSTRING(@Numero, 5, 4) AS INT) + 1

	IF @Sequencial = 9999
	BEGIN
	 SET @Numero = REPLACE(STR(CAST(LEFT(@Numero, 4) AS INT) + 1, 4, 0), ' ', '0')
	 SET @Sequencial = 0
	END

	SET @Numero = LEFT(@Numero, 4) + REPLACE(STR(@Sequencial, 4, 0), ' ', '0')
	
	IF NOT @Numero IS NULL
	BEGIN
		SET @ORCNUM = @Numero
	END
								
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WBCCAD_ORCNUMSEQ] TO [interclick]
    AS [dbo];

