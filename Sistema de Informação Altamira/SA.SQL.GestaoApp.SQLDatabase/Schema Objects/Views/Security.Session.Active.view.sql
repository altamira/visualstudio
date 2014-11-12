CREATE VIEW [Security].[Session.Active]
AS
SELECT	[Session].Id, 
		[Session].[Guid], 
		[Session].[CreateDate], 
		[Session].[ExpireDate], 
		[Session].[Language], 
		[User].FirstName
FROM	Security.Session [Session] 
INNER JOIN Security.[User] [User] ON [Session].[CreateBy.Security.User.Id] = [User].[Id]
WHERE	(ExpireDate > GETDATE())


