CREATE FUNCTION [Security].[Session.Get](@Guid AS UNIQUEIDENTIFIER)
RETURNS XML
AS
BEGIN
	DECLARE @xmlResponse AS XML
	
	SET @xmlResponse =	(SELECT [Session].[Guid] AS '@Guid', 
								[Session].CreateDate AS 'CreateDate', 
								[Session].[CreateBy.Security.User.Id] AS 'CreateBy', 
								[Session].[ExpireDate] AS 'ExpireDate', 
								[Session].[Language] AS 'Language',
								(SELECT [User].Id AS '@Id',
										[User].FirstName AS 'FirstName',
										[User].LastLoginDate AS 'LastLoginDate',
										[User].Rules AS 'Rules'
								FROM [Security].[User] [User]
								WHERE [Session].[CreateBy.Security.User.Id] = [User].Id 
								FOR XML PATH('User'), TYPE)
						FROM [Security].[Session] AS [Session]
						WHERE [Guid] = @Guid
						FOR XML PATH('Session'), TYPE)
						
	RETURN @xmlResponse
END



