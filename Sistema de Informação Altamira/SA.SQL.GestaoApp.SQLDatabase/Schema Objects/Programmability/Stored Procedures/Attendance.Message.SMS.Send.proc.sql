CREATE PROCEDURE [Attendance].[Message.SMS.Send]
	@XmlRequest XML,
	@XmlResponse XML OUTPUT
AS
BEGIN
	/*DECLARE @Return INT
	DECLARE @Session XML

	EXEC @Return = Security.[Session.Validate] @SessionGuid, NULL, @Session OUTPUT
	
	IF @Return <> 1
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT PATINDEX('%Attendance Message%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR
		NOT PATINDEX('%Attendance Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END*/
	
	DECLARE @From NVARCHAR(MAX)
	DECLARE @Mobile AS NVARCHAR(14)
	DECLARE @Body AS NVARCHAR(MAX)

	BEGIN TRY

		SET @From = LTRIM(RTRIM(@xmlRequest.value('(/SMS/@From)[1]', 'NVARCHAR(MAX)')))
		
		IF (@From IS NULL)
		BEGIN
			SET @From = '?'
		END
		
		SET @Mobile = (SELECT TOP 1 '55' + 
						LTRIM(RTRIM(@xmlRequest.value('(/SMS/Fone/AreaCode)[1]', 'NVARCHAR(2)'))) + 
						LTRIM(RTRIM(@xmlRequest.value('(/SMS/Fone/Prefix)[1]', 'NVARCHAR(4)'))) + 
						LTRIM(RTRIM(@xmlRequest.value('(/SMS/Fone/Number)[1]', 'NVARCHAR(4)'))))
			
		IF NOT @Mobile IS NULL
		BEGIN
			SET @Body = @xmlRequest.value('(/SMS/Text)[1]', 'NVARCHAR(MAX)')
			INSERT INTO SMS.[Log] ([From], [Mobile], [Message])
			SELECT @From, @Mobile, @Body

			SET @xmlResponse = CAST('<Message>Mensagem SMS encaminhada para o envio !</Message>' AS XML)
		END

	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError
		SET @xmlResponse = CAST('<Error Id="1005">A Mensagem não foi enviada, contate o suporte técnico.</Error>' AS XML)
		RETURN 0
	END CATCH

	RETURN 0
END












