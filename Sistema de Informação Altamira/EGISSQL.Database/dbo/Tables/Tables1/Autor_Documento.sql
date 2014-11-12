CREATE TABLE [dbo].[Autor_Documento] (
    [cd_autor]   INT          NOT NULL,
    [nm_autor]   VARCHAR (40) NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Autor_Documento] PRIMARY KEY CLUSTERED ([cd_autor] ASC) WITH (FILLFACTOR = 90)
);

