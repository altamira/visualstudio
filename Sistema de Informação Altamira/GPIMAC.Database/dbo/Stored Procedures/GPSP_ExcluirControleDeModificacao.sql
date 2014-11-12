-- =============================================
-- Author:		Denis André
-- Create date: 12/09/2012
-- Description:	Rotina que inclui um registro na 
--              Tabela de Modificações (MODCTR)
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_ExcluirControleDeModificacao]
	-- Add the parameters for the stored procedure here
	@NomeDaTabela		NVARCHAR(200),				-- CMod0Tab			Objeto/Tabela				C (  200   )    
	@Identificacao		NVARCHAR(250),				-- CMod0Id			Identificação				C (  250   )    
	@DataHora			DATETIME,					-- CMod0DtH			Data/Hora					T (   10.8 )    
	@NomeDoCampo		NVARCHAR(200),				-- CMod0AttId		Código do Atributo/Campo	C (  200   )    
	@RegistroExcluido	NVARCHAR(01)		OUTPUT	-- Registro Gravado (S/N)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @RegistroExcluído = 'N'
	
    -- Insert statements for procedure here
	DELETE FROM [dbo].[MODCTR]
			WHERE 
					[CMod0Tab]		= @NomeDaTabela
				AND [CMod0Id]		= @Identificacao
				AND [CMod0DtH]		= @DataHora
				AND [CMod0AttId]	= @NomeDoCampo

	IF @@ROWCOUNT > 0
	BEGIN
		SET @RegistroExcluído = 'S'
	END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_ExcluirControleDeModificacao] TO [interclick]
    AS [dbo];

