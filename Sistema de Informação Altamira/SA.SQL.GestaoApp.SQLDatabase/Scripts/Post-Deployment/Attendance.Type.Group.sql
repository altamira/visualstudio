-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Attendance.[Type.Group] ([Id], [Description]) VALUES (' + CAST(Id AS NVARCHAR(10)) + ', ''' + [Description] + ''')' + CHAR(13) + 'GO' + CHAR(13)
FROM [Gestao].[Attendance].[TypeGroup]
ORDER BY Id
*/

PRINT 'Inserting [Attendance].[Type.Group]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Type.Group] ON

INSERT INTO Attendance.[Type.Group] ([Id], [Description]) VALUES (1, 'ATENDIMENTO')
GO

INSERT INTO Attendance.[Type.Group] ([Id], [Description]) VALUES (2, 'RECLAMACÃO')
GO

INSERT INTO Attendance.[Type.Group] ([Id], [Description]) VALUES (3, 'POS-VENDA')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Type.Group] OFF
