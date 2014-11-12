CREATE TABLE [dbo].[CartasRTF] (
    [idCartaRTF]      INT            IDENTITY (1, 1) NOT NULL,
    [Carta]           NVARCHAR (255) NOT NULL,
    [RTF]             TEXT           NULL,
    [RTFImagem]       IMAGE          NULL,
    [numeroOrcamento] NCHAR (9)      NULL,
    CONSTRAINT [PK_CartasRTF] PRIMARY KEY CLUSTERED ([Carta] ASC)
);

