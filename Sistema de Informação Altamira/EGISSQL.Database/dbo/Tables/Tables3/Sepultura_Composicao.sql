CREATE TABLE [dbo].[Sepultura_Composicao] (
    [cd_sepultura_composicao] INT          NOT NULL,
    [cd_sepultura]            INT          NULL,
    [nm_sepultura_composicao] VARCHAR (30) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Sepultura_Composicao] PRIMARY KEY CLUSTERED ([cd_sepultura_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sepultura_Composicao_Sepultura] FOREIGN KEY ([cd_sepultura]) REFERENCES [dbo].[Sepultura] ([cd_sepultura])
);

