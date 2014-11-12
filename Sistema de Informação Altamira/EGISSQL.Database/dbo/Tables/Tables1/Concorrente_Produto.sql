CREATE TABLE [dbo].[Concorrente_Produto] (
    [cd_concorrente]             INT          NOT NULL,
    [cd_concorrente_produto]     INT          NOT NULL,
    [nm_concorrente_produto]     VARCHAR (40) NULL,
    [nm_obs_concorrente_produto] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Concorrente_Produto] PRIMARY KEY CLUSTERED ([cd_concorrente] ASC, [cd_concorrente_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Concorrente_Produto_Concorrente] FOREIGN KEY ([cd_concorrente]) REFERENCES [dbo].[Concorrente] ([cd_concorrente])
);

