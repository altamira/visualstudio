-- =============================================
-- Author:		Denis André
-- Create date: 12/09/2012
-- Description:	Rotina que inclui um registro na 
--              Tabela de Modificações (MODCTR)
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_IncluirControleDeModificacao]
	-- Add the parameters for the stored procedure here
	@NomeDaTabela		NVARCHAR(200),		-- CMod0Tab			Objeto/Tabela				C (  200   )    
	@Identificacao		NVARCHAR(250),		-- CMod0Id			Identificação				C (  250   )    
	@DataHora			DATETIME,			-- CMod0DtH			Data/Hora					T (   10.8 )    
	@NomeDoCampo		NVARCHAR(200),		-- CMod0AttId		Código do Atributo/Campo	C (  200   )    
	@DescricaoDoCampo	NVARCHAR(200),		-- CMod0AttNom		Descrição do Atributo		C (  200   )    
	@Usuario			NVARCHAR(20),		-- CMod0Usu			Usuário						C (   20   )    
	@Data				DATETIME,			-- CMod0Dat			Data						D   
	@Acao				NVARCHAR(10),		-- CMod0Aca			Ação						C (   10   )    
	@ValorAntigo		NVARCHAR(3000),		-- CMod0AttValAnt	Valor Antigo				V ( 3000   )   
	@ValorNovo			NVARCHAR(3000),		-- CMod0AttValNov	Valor Novo					V ( 3000   )   
	@EmailEnviado		NVARCHAR(01),		-- CMod0EmlEnv		E-mail Enviado				C (    1   )  
	@RegistroIncluido	NVARCHAR(01) OUTPUT	-- Registro Gravado (S/N)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @RegistroIncluido = 'N'
	
    -- Insert statements for procedure here
	INSERT INTO [dbo].[MODCTR]
			   ([CMod0Tab]
			   ,[CMod0Id]
			   ,[CMod0DtH]
			   ,[CMod0AttId]
			   ,[CMod0AttNom]
			   ,[CMod0Usu]
			   ,[CMod0Dat]
			   ,[CMod0Aca]
			   ,[CMod0AttValAnt]
			   ,[CMod0AttValNov]
			   ,[CMod0EmlEnv])
		 VALUES
			   (@NomeDaTabela
			   ,@Identificacao
			   ,@DataHora
			   ,@NomeDoCampo
			   ,@DescricaoDoCampo
			   ,@Usuario
			   ,@Data
			   ,@Acao
			   ,@ValorAntigo
			   ,@ValorNovo
			   ,@EmailEnviado)    

	IF @@ROWCOUNT > 0
	BEGIN
		SET @RegistroIncluido = 'S'
	END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_IncluirControleDeModificacao] TO [interclick]
    AS [dbo];

