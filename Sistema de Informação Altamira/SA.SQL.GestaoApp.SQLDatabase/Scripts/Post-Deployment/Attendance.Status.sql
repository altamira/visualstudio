-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (' + 
		CAST(Id AS NVARCHAR(10)) + ', ' + CAST([Status.Group.Id] AS NVARCHAR(MAX)) + ', ''' + 
		LTRIM(RTRIM([Description])) + ''', ' + CAST([Enable] AS CHAR(1)) + ')' + CHAR(13) + 'GO' + CHAR(13)
FROM [GestaoApp].[Attendance].[Status]
ORDER BY [Id]
*/

PRINT 'Inserting [Attendance].[Status]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Status] ON

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (1, 3, 'PENDENTE', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (2, 1, 'PRE-ORÇAMENTO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (3, 1, 'ORÇAMENTO', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (4, 1, 'ATENDIDO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (5, 2, 'CANCELADO', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (6, 1, 'Projeto', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (7, 1, 'Elaboração de orçamento', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (8, 1, 'Financeiro', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (9, 1, 'Encaminhado ao cliente', 0)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (10, 1, 'Negociação', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (11, 1, 'Alteração', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (12, 1, 'Nova visita', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (13, 1, 'Pedido', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (14, 1, 'Produção', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (15, 1, 'Expedição', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (16, 1, 'Entrega', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (17, 1, 'Montagem', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (18, 1, 'Perdido', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (19, 1, 'Orçamento Cancelado', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (20, 1, 'Fora de nossa linha de produção', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (21, 2, 'Representante está sem tempo', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (22, 2, 'Representante fez contato, porém o cliente não tinha disponibilidade de recebê-lo', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (23, 2, 'Representante fez contato, porém não obteveretorno', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (24, 2, 'Agendou visita, mas o cliente não pode recebê-lo', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (25, 2, 'Agendou visita, mas o representante não compareceu (Motivo)', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (26, 2, 'Recusou-se a atender, por achar que “nãovale a pena”', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (27, 3, 'Pelo cliente (Motivo)', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (28, 3, 'Pelo representante (Motivo)', 1)
GO

INSERT INTO [$(DatabaseName)].[Attendance].[Status] ([Id], [Status.Group.Id], [Description], [Enable]) VALUES (29, 1, 'Representante fez contato', 1)
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Attendance].[Status] OFF

