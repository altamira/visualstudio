-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (' + CAST(Id AS NVARCHAR(10)) + ', ''' + [Description] + ''')' + CHAR(13) + 'GO' + CHAR(13)
FROM [Gestao].[Contact].[Media]
ORDER BY Id
*/

PRINT 'Inserting Contact.[Media]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].Contact.[Media] ON

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (0, 'JÁ É CLIENTE')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (1, 'JÁ FOI VISITADO')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (2, 'CLIENTE NOVO')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (3, 'INDICAÇÃO')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (4, 'INTERNET')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (5, 'GOOGLE')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (6, 'PÁGINAS AMARELAS')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (7, 'LISTA OESP')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (8, 'FEIRAS')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (9, 'REVISTA P.S.')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (10, 'REVISTA NEI')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (11, 'REVISTA TECNOLOGISTICA')
GO

INSERT INTO Contact.[Media] ([Id], [Description]) VALUES (12, 'SITE')
GO

SET IDENTITY_INSERT [$(DatabaseName)].Contact.[Media] OFF
