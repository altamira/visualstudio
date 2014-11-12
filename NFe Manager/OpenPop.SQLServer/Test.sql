/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*
USE [SA.SQL.NFe.Database]
GO
*/

DELETE FROM [Mail].[Message]

DECLARE	@return_value int

EXEC	@return_value = [dbo].[Mail.Message.Fetch]
		@host = N'mail.altamira.com.br',
		@port = 110,
		@ssl = false,
		@user = N'forward.nfe@altamira.com.br',
		@pass = N'a1s2d3f4'

SELECT	'Return Value' = @return_value

SELECT * FROM [Mail].[Message] ORDER By [Sent] DESC
SELECT MAX(LEN(MessageId)) FROM [Mail].[Message]

SELECT * 
FROM [dbo].[Mail.Message.List.Attachments](
		N'mail.altamira.com.br',
		110,
		0,
		N'forward.nfe@altamira.com.br',
		N'a1s2d3f4'
		) AS T



GO
