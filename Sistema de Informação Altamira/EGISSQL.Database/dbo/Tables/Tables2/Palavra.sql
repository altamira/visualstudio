CREATE TABLE [dbo].[Palavra] (
    [cd_palavra]    INT           NOT NULL,
    [nm_palavra]    VARCHAR (100) NOT NULL,
    [ds_palavra]    TEXT          NULL,
    [cd_dicionario] INT           NULL,
    [cd_usuario]    INT           NULL,
    [dt_usuario]    DATETIME      NULL,
    CONSTRAINT [PK_Palavra] PRIMARY KEY CLUSTERED ([cd_palavra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Palavra_Dicionario] FOREIGN KEY ([cd_dicionario]) REFERENCES [dbo].[Dicionario] ([cd_dicionario])
);

