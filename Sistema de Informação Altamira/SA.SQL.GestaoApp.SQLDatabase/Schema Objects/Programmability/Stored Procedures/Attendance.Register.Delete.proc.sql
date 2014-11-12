CREATE PROCEDURE [Attendance].[Register.Delete]	
	@Session AS XML,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	

	BEGIN TRY
	
		IF NOT @xmlRequest.value('(/request/entity/@key)[1]', 'nchar(14)') IS NULL
		BEGIN
			
			DELETE DBALTAMIRA.dbo.VE_Recados WHERE vere_Numero = @xmlRequest.value('(/request/entity/@key)[1]', 'nchar(14)')
			
			IF @@ROWCOUNT > 0
			BEGIN
				SET @xmlResponse = CAST('<response action="' + @xmlRequest.value('(/request/@action)[1]', 'VARCHAR(max)') + '"><error id="0"><message>Os dados foram excluídos com sucesso !</message></error></response>' AS XML)
			END
			ELSE
			BEGIN
				SET @xmlResponse = CAST('<response action="' + @xmlRequest.value('(/request/@action)[1]', 'VARCHAR(max)') + '"><error id="1001"><message>Houve um erro ao excluir, os dados não foram apagados !</message></error></response>' AS XML)
				RETURN 0
			END
		END
	
	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError
		SET @xmlResponse = CAST('<response action="' + @xmlRequest.value('(/request/@action)[1]', 'VARCHAR(max)') + '"><error id="1005"><message>Não foi possível excluir, contate o suporte técnico.</message></error></response>' AS XML)
		RETURN 0
	END CATCH
	
	RETURN 1
	
END











