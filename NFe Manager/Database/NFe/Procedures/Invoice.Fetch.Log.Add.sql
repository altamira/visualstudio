CREATE PROCEDURE [NFe].[Invoice.Fetch.Log.Add]
	@History AS NVARCHAR(MAX)
AS
	SET NOCOUNT ON; 
	
	INSERT INTO [NFe].[Invoice.Fetch.Log] ([History]) VALUES (@History)
RETURN 0
