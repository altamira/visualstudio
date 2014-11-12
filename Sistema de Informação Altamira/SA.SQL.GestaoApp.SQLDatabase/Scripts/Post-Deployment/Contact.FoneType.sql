-- =============================================
-- Script Template
-- =============================================

PRINT 'Inserting [Contact].[FoneType]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Contact].[FoneType] ON

INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (1, 'TELEFONE')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (2, 'FAX')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (3, 'TELEFONE/FAX')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (4, 'CELULAR')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (5, 'PABX')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (6, 'DDR')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (7, 'RADIO/NEXTEL')
GO
INSERT INTO [$(DatabaseName)].[Contact].[FoneType] ([Id], [Description]) VALUES (8, 'PAGER')
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Contact].[FoneType] OFF