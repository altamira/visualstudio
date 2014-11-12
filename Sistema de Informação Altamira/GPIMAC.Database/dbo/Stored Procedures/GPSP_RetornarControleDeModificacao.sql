-- =============================================
-- Author:		Denis André
-- Create date: 12/09/2012
-- Description:	Rotina que inclui um registro na 
--              Tabela de Modificações (MODCTR)
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_RetornarControleDeModificacao]
	-- Add the parameters for the stored procedure here
	@NomeDaTabela		NVARCHAR(200),			-- CMod0Tab			Objeto/Tabela				C (  200   )    
	@Identificacao		NVARCHAR(250),			-- CMod0Id			Identificação				C (  250   )    
	@DataHora			DATETIME,				-- CMod0DtH			Data/Hora					T (   10.8 )    
	@NomeDoCampo		NVARCHAR(200),			-- CMod0AttId		Código do Atributo/Campo	C (  200   )    
	@DescricaoDoCampo	NVARCHAR(200)	OUTPUT,	-- CMod0AttNom		Descrição do Atributo		C (  200   )    
	@Usuario			NVARCHAR(20)	OUTPUT,	-- CMod0Usu			Usuário						C (   20   )    
	@Data				DATETIME		OUTPUT,	-- CMod0Dat			Data						D   
	@Acao				NVARCHAR(10)	OUTPUT,	-- CMod0Aca			Ação						C (   10   )    
	@ValorAntigo		NVARCHAR(3000)	OUTPUT,	-- CMod0AttValAnt	Valor Antigo				V ( 3000   )   
	@ValorNovo			NVARCHAR(3000)	OUTPUT,	-- CMod0AttValNov	Valor Novo					V ( 3000   )   
	@EmailEnviado		NVARCHAR(01)	OUTPUT,	-- CMod0EmlEnv		E-mail Enviado				C (    1   )  
	@RegistroRetornado	NVARCHAR(01)	OUTPUT	-- Registro Gravado (S/N)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @RegistroRetornado = 'N'
	
    -- Insert statements for procedure here
	SELECT TOP 01
			    @DescricaoDoCampo	= [CMod0AttNom]
			   ,@Usuario			= [CMod0Usu]
			   ,@Data				= [CMod0Dat]
			   ,@Acao				= [CMod0Aca]
			   ,@ValorAntigo		= [CMod0AttValAnt]
			   ,@ValorNovo			= [CMod0AttValNov]
			   ,@EmailEnviado		= [CMod0EmlEnv]
			FROM [dbo].[MODCTR]
			WHERE 
					[CMod0Tab]		= @NomeDaTabela
				AND [CMod0Id]		= @Identificacao
				AND [CMod0DtH]		= @DataHora
				AND [CMod0AttId]	= @NomeDoCampo

	IF @@ROWCOUNT > 0
	BEGIN
		SET @RegistroRetornado = 'S'
	END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarControleDeModificacao] TO [interclick]
    AS [dbo];

