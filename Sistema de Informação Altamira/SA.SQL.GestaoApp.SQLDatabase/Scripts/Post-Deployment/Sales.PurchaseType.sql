-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Sales.[PurchaseType] ([Id], [Description]) VALUES (' + CAST(Id AS NVARCHAR(10)) + ', ''' + [Description] + ''')' + CHAR(13) + 'GO' + CHAR(13)
FROM [GestaoApp].Sales.[PurchaseType]
ORDER BY Id
*/

PRINT 'Inserting [Sales].[PurchaseType]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Sales].[PurchaseType] ON

INSERT INTO Sales.[PurchaseType] ([Id], [Description]) VALUES (1, 'EXPORTACAO')
GO

INSERT INTO Sales.[PurchaseType] ([Id], [Description]) VALUES (2, 'MERCANTIL')
GO

INSERT INTO Sales.[PurchaseType] ([Id], [Description]) VALUES (3, 'NAO CONTRIBUINTE')
GO

INSERT INTO Sales.[PurchaseType] ([Id], [Description]) VALUES (4, 'ZONA FRANCA')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Sales].[PurchaseType] OFF
