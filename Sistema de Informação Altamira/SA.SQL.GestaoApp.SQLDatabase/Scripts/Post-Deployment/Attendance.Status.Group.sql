-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Attendance.[Status.Group] ([Id], [Description]) VALUES (' + CAST(Id AS NVARCHAR(10)) + ', ''' + [Description] + ''')' + CHAR(13) + 'GO' + CHAR(13)
FROM [Gestao].[Attendance].[StatusGroup]
ORDER BY Id
*/

PRINT 'Inserting [Attendance].[Status.Group]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Status.Group] ON

INSERT INTO Attendance.[Status.Group] ([Id], [Description]) VALUES (1, 'ATENDIDO')
GO

INSERT INTO Attendance.[Status.Group] ([Id], [Description]) VALUES (2, 'PENDENTE')
GO

INSERT INTO Attendance.[Status.Group] ([Id], [Description]) VALUES (3, 'CANCELADO')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Status.Group] OFF
