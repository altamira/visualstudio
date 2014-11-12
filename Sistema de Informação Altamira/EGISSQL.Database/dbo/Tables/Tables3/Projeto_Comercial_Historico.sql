CREATE TABLE [dbo].[Projeto_Comercial_Historico] (
    [cd_projeto_historico] INT          NOT NULL,
    [cd_projeto_comercial] INT          NOT NULL,
    [dt_projeto_historico] DATETIME     NULL,
    [nm_projeto_historico] VARCHAR (60) NULL,
    [ds_projeto_historico] TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Comercial_Historico] PRIMARY KEY CLUSTERED ([cd_projeto_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Comercial_Historico_Projeto_Comercial] FOREIGN KEY ([cd_projeto_comercial]) REFERENCES [dbo].[Projeto_Comercial] ([cd_projeto_comercial])
);

