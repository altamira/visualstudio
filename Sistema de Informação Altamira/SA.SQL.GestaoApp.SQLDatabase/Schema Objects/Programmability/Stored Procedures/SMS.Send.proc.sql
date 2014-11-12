/****** Object:  StoredProcedure [SMS].[Send]    Script Date: 09/16/2011 11:33:32 ******/
/****** Object:  StoredProcedure [SMS].[Send]    Script Date: 09/21/2011 17:29:30 ******/
/****** Object:  StoredProcedure [SMS].[Send]    Script Date: 01/17/2012 12:44:45 ******/
CREATE PROCEDURE [SMS].[Send]
	@TextMessage [nvarchar](max),
	@From [nvarchar](max),
	@Mobile [nvarchar](max),
	@MessageGuid [uniqueidentifier]
AS
EXTERNAL NAME [SA.SQL.GestaoApp.SQLAssembly].[Utils.SMS].[Send]













