-- =============================================
-- Author:		Denis André
-- Create date: 12/09/2012
-- Description:	Rotina que inclui um registro na 
--              Tabela de Modificações (MODCTR)
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_IncluirAlterarExcluirRetornarControleDeModificacao]
	-- Add the parameters for the stored procedure here
	@Modo               NVARCHAR(30),			-- Modo (INCLUIR, ALTERAR, EXCLUIR, RETORNAR)
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
	@RegistroAfetado	NVARCHAR(01)	OUTPUT,	-- Registro Gravado (S/N)
	@ErroCodigo         INT				OUTPUT,	-- Código do Erro
	@ErroDescricao      NVARCHAR(3000)	OUTPUT	-- Descrição do Erro
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Modo2			CHAR(30)

	SET @RegistroAfetado  = 'N'
	SET @ErroCodigo       = 0
	SET @ErroDescricao    = ''
	SET @Modo2			  = UPPER(LTRIM(RTRIM(@Modo ) ) )
	
	IF @Modo2 = 'INCLUIR' 
	BEGIN
					EXEC dbo.GPSP_IncluirControleDeModificacao   @NomeDaTabela,     @Identificacao, @DataHora,     @NomeDoCampo, 
																 @DescricaoDoCampo, @Usuario,       @Data,         @Acao, 
																 @ValorAntigo,      @ValorNovo,     @EmailEnviado, @RegistroAfetado
	END 
	ELSE 
	BEGIN
		IF @Modo2 = 'ALTERAR' 
		BEGIN
					EXEC dbo.GPSP_AlterarControleDeModificacao   @NomeDaTabela,     @Identificacao, @DataHora,     @NomeDoCampo, 
																 @DescricaoDoCampo, @Usuario,       @Data,         @Acao, 
																 @ValorAntigo,      @ValorNovo,     @EmailEnviado, @RegistroAfetado
		END	
		ELSE 
		BEGIN 
			IF @Modo2 = 'EXCLUIR'
			BEGIN
					EXEC dbo.GPSP_ExcluirControleDeModificacao   @NomeDaTabela,     @Identificacao, @DataHora,     @NomeDoCampo, 
																 @RegistroAfetado
			END
			ELSE
			BEGIN
				IF @Modo2 = 'RETORNAR'
				BEGIN
					EXEC dbo.GPSP_RetornarControleDeModificacao  @NomeDaTabela,     @Identificacao, @DataHora,     @NomeDoCampo, 
		                                                         @DescricaoDoCampo, @Usuario,       @Data,         @Acao, 
		                                                         @ValorAntigo,      @ValorNovo,     @EmailEnviado, @RegistroAfetado
				END
				ELSE
				BEGIN
					SET @ErroCodigo    = 1
					SET @ErroDescricao = 'Modo Inválido (' + @Modo2 + ').'
				END
			END
			
		END
	END

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_IncluirAlterarExcluirRetornarControleDeModificacao] TO [interclick]
    AS [dbo];

