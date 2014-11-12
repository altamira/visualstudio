CREATE TABLE [dbo].[Item] (
    [idItem]      INT            IDENTITY (1, 1) NOT NULL,
    [idRelatorio] INT            NULL,
    [idSecao]     INT            NULL,
    [idTipoItem]  INT            NULL,
    [Item]        NVARCHAR (255) NULL,
    [Campo]       NVARCHAR (255) NULL,
    [Ordem]       INT            NULL,
    [Valor]       NVARCHAR (255) NULL,
    CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED ([idItem] ASC)
);

