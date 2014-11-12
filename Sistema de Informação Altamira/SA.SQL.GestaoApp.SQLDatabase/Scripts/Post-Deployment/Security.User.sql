-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) ' +
'VALUES ' + '(' + CAST(Id AS NVARCHAR(MAX)) + ', ' + 
--CAST([CreateDate] AS NVARCHAR(MAX)) + ''', ' +
CAST([CreateBy] AS NVARCHAR(MAX)) + ', ' +
--CAST([LastUpdateDate] AS NVARCHAR(MAX)) + ''', ' +
CAST([LastUpdateBy] AS NVARCHAR(MAX)) + ', ''' + 
--CAST([LastLoginDate] AS NVARCHAR(MAX)) + ''', ''' +
[FirstName] + ''', ''' + 
CASE WHEN [LastName] IS NULL THEN '' ELSE [LastName] END + ''', ''' + 
[UserName] + ''', ''' + 
[Password] + ''', ''' + 
CASE WHEN [Email] IS NULL THEN '' ELSE [Email] END + ''', ' + 
CAST([Perfil] AS NVARCHAR(MAX)) + ', ''' + 
[Rules] + ''')' 
--+ CHAR(13) + 'GO' + CHAR(13)
--SELECT *
FROM Gestao.Security.[User] WHERE NOT LastLoginDate IS NULL AND Perfil = 0
*/

PRINT 'Inserting [Security].[User]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [Security].[User] ON

/*
INSERT INTO [$(DatabaseName)].[Security].[User] ([Id], [CreateDate], [CreateBy], [LastUpdateDate], [LastUpdateBy], [LastLoginDate], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil]) 
VALUES (1, GETDATE(), 1, GETDATE(), 1, GETDATE(), 'Admin', '', 'admin', '5DBA68E39C95C8B9C0A0F14385180B26188063F4', NULL, 0)
*/

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (1, 1, 1, 'Admin', '', 'admin', '5DBA68E39C95C8B9C0A0F14385180B26188063F4', '', 0, '*')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (2, 1, 1, 'Agnaldo', '', 'amafa', '4FA5EBB40EF9A261740619F4763E79C21A0FEC80', '', 0, '*')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (3, 1, 1, 'vendas', '', 'atendimento', 'C09A23B13D61164E9C0C02BF09858C07E1708E7E', '', 0, 'Attendance Register, Attendance Message, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (4, 1, 1, 'Simone', '', 'simone', 'E400B91BF1C4FF53C2C06543767060E7F9DAE8BC', 'simone.tristao@altamira.com.br', 0, 'Bid Register, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (5, 1, 1, 'Maiorano', '', 'maiorano', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', 'maiorano@altamira.com.br', 0, 'Bid Register, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (6, 1, 1, 'Engenharia', '', 'engenharia', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', '', 0, '')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (7, 1, 1, 'Alexandre', '', 'alexandre', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', '', 0, 'Attendance Register, Bid Register, Attendance Message, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (8, 1, 1, 'Jose Augusto', '', 'joseaugusto', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', '', 0, 'Attendance Register, Bid Register, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (9, 1, 1, 'Jose Roberto', '', 'joseroberto', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', '', 0, 'Attendance Register, Bid Register, Client Register, Vendor Register')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (10, 1, 1, 'Camila', '', 'camila', 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709', '', 0, '')
GO

INSERT INTO [Security].[User] ([Id], [CreateBy], [LastUpdateBy], [FirstName], [LastName], [UserName], [Password], [Email], [Perfil], [Rules]) VALUES (11, 1, 1, 'Marcelo Parra', '', 'marceloparra', '8B4E7A90DA544636AA22CF2B61A522D2BFBCA5DD', '', 0, 'Bid Register')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Security].[User] OFF

