CREATE TABLE [dbo].[Dicionario] (
    [cd_dicionario] INT          NOT NULL,
    [nm_dicionario] VARCHAR (40) NOT NULL,
    [dt_dicionario] DATETIME     NULL,
    [cd_autor]      INT          NULL,
    [ds_dicionario] TEXT         NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_dicionario] PRIMARY KEY CLUSTERED ([cd_dicionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Autor] FOREIGN KEY ([cd_autor]) REFERENCES [dbo].[Autor] ([cd_autor])
);

