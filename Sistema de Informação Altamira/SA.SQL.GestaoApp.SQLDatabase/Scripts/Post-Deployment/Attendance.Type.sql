-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (' + 
		CAST(Id AS NVARCHAR(10)) + ', ' + CAST([TypeGroupId] AS NVARCHAR(MAX)) + ', ''' + 
		LTRIM(RTRIM([Description])) + ''', ' + CAST([Enable] AS CHAR(1)) + ')' + CHAR(13) + 'GO' + CHAR(13)
FROM [Gestao].[Attendance].[Type]
ORDER BY [Id]
*/

PRINT 'Inserting [Attendance].[Type]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Type] ON

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (1, 1, 'ATENDIMENTO AO CLIENTE', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (2, 3, 'ASSISTÊNCIA TÉCNICA', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (3, 1, 'NEGOCIAÇÃO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (4, 2, 'RECLAMAÇÃO DO REPRESENTANTE', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (5, 1, 'MUDANÇA DE PROJETO/ORÇAMENTO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (6, 3, 'DÚVIDA TÉCNICA', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (7, 1, 'ORÇAMENTO ENVIADO AO REPRESENT.', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (8, 2, 'MATERIAL FALTANDO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (9, 2, 'MEDIDA ERRADA', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (10, 1, 'Solicitação de visitas', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (11, 1, 'Solicitação de orçamentos', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (12, 1, 'Posição de entrega', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (13, 1, 'Negociação de orçamentos', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (14, 3, 'Dúvidas técnicas', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Type] ([Id], [Type.Group.Id], [Description], [Enable]) VALUES (15, 2, 'Reclamações', 1)
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Type] OFF
