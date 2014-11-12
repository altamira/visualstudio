CREATE TABLE [dbo].[Revenda_Sistema_Concorrente] (
    [cd_revenda]     INT      NOT NULL,
    [cd_concorrente] INT      NOT NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_Revenda_Sistema_Concorrente] PRIMARY KEY CLUSTERED ([cd_revenda] ASC, [cd_concorrente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Revenda_Sistema_Concorrente_Concorrente] FOREIGN KEY ([cd_concorrente]) REFERENCES [dbo].[Concorrente] ([cd_concorrente])
);

