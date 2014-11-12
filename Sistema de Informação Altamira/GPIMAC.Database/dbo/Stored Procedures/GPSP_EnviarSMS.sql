

-- ===================================================
-- Author:		Denis André
-- Create date: 11/10/2012
-- Description:	Incluir Registro na View_SMSEnvio
-- para disparar um torpedo para o telefone desejado
-- ===================================================
CREATE PROCEDURE [dbo].[GPSP_EnviarSMS]	
	-- Parâmetros
	@Origem					NVARCHAR(50)	OUTPUT,
	@Autor					NVARCHAR(20)	OUTPUT,
	@NumeroDoTelefone		NVARCHAR(14)	OUTPUT,
	@Mensagem				NVARCHAR(4000)	OUTPUT,
	@MensagemEnviada		SMALLINT		OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @MensagemEnviada = 0

    -- Incluir Registro na View_SMSEnvio para que o Gatilho seja disparado 
    -- para enviar o torpedo:
	INSERT INTO dbo.view_SMSEnvio
		(Origem,  Usuario, Numero,            Mensagem)
	VALUES
		('GPSP_EnviarSMS:' + @Origem, @Autor,  @NumeroDoTelefone, @Mensagem )
	IF ISNULL(@@ROWCOUNT, 0 ) > 0
		SET @MensagemEnviada = 1	
	
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_EnviarSMS] TO [interclick]
    AS [dbo];

