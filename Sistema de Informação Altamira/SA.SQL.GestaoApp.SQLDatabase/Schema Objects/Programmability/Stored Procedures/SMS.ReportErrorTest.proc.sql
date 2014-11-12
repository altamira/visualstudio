CREATE PROCEDURE [SMS].[ReportErrorTest]
AS
BEGIN

	BEGIN TRY
		-- Generate divide-by-zero error.
		SELECT 1/0;
	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError
	END CATCH;

END













