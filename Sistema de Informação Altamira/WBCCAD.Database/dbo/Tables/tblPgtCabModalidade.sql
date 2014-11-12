CREATE TABLE [dbo].[tblPgtCabModalidade] (
    [idTblPgtCabModalidade] INT            IDENTITY (1, 1) NOT NULL,
    [Modalidade]            NVARCHAR (255) NOT NULL,
    [Observacoes]           TEXT           NULL,
    [Ativa]                 BIT            NOT NULL
);

