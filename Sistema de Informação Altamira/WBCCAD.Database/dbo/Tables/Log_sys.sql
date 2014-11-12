CREATE TABLE [dbo].[Log_sys] (
    [AcaoNumero] INT            IDENTITY (1, 1) NOT NULL,
    [Data]       DATETIME       NULL,
    [Hora]       DATETIME       NULL,
    [Acao]       NVARCHAR (255) NULL,
    [Modulo]     NVARCHAR (50)  NULL,
    [Usuário]    NVARCHAR (50)  NULL,
    [Supervisor] NVARCHAR (50)  NULL,
    [Maquina]    NVARCHAR (255) NULL
);

