CREATE TABLE [dbo].[Revenda_Sistema_Contato] (
    [cd_revenda]         INT          NOT NULL,
    [cd_contato_revenda] INT          NOT NULL,
    [nm_contato_revenda] VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Revenda_Sistema_Contato] PRIMARY KEY CLUSTERED ([cd_revenda] ASC, [cd_contato_revenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Revenda_Sistema_Contato_Revenda_Sistema] FOREIGN KEY ([cd_revenda]) REFERENCES [dbo].[Revenda_Sistema] ([cd_revenda])
);

