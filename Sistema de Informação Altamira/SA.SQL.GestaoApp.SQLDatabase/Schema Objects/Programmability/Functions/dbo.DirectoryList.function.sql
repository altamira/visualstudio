/****** Object:  UserDefinedFunction [dbo].[DirectoryList]    Script Date: 01/17/2012 12:44:43 ******/
CREATE FUNCTION [dbo].[DirectoryList](@root_directory [nvarchar](max), @wildcard [nvarchar](max), @subdirectories [bit])
RETURNS  TABLE (
	[FileName] [nvarchar](max) NULL,
	[Extension] [nvarchar](4) NULL,
	[Length] [bigint] NULL,
	[Create] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Directory] [nvarchar](max) NULL
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [GestaoApp.SQLAssembly].[Utils.FileSystem].[DirectoryList]



GO