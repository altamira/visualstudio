CREATE TABLE [dbo].[tblOpcao] (
    [OpcaoChave]  NVARCHAR (50)  NULL,
    [OpcaoValor1] NVARCHAR (255) NULL,
    [grupo]       NVARCHAR (50)  NULL,
    [lista]       NVARCHAR (50)  NULL,
    [id]          INT            IDENTITY (1, 1) NOT NULL
);

