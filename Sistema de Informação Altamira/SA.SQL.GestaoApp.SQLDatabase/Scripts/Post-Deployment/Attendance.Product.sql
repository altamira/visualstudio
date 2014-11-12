-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Attendance.Product ([Id], [Description]) VALUES (' + CAST(Id AS NVARCHAR(10)) + ', ''' + [Description] + ''')' + CHAR(13) + 'GO' + CHAR(13)
FROM [Gestao].[Sales].[Product]
ORDER BY Id
*/

PRINT 'Inserting [Attendance].[Product]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Product] ON

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (1, 'ESTANTES/BALCÕES')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (2, 'PORTA-PALETES')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (3, 'MEZANINO')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (4, 'PAINÉIS/DIVISÓRIAS')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (5, 'DRIVE-IN')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (6, 'PRODUTOS DIVERSOS')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (7, 'PRESTAÇÃO DE SERVIÇO')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (8, 'PRATELEIRAS')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (9, 'NÃO ESPECIFICADO')
GO

INSERT INTO Attendance.Product ([Id], [Description]) VALUES (10, 'PISO RESINDEK')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Product] OFF
