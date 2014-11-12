CREATE TABLE [dbo].[PesAgt] (
    [idPesAgt]            INT IDENTITY (1, 1) NOT NULL,
    [PesAgt_Codigo]       INT NULL,
    [PesAgt_Desabilitado] BIT NOT NULL,
    CONSTRAINT [PK_PesAgt] PRIMARY KEY CLUSTERED ([idPesAgt] ASC)
);

