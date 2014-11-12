CREATE TABLE [dbo].[Projeto_Documento] (
    [cd_projeto]               INT           NOT NULL,
    [cd_projeto_documento]     INT           NOT NULL,
    [nm_projeto_documento]     VARCHAR (50)  NULL,
    [dt_projeto_documento]     DATETIME      NULL,
    [nm_caminho_documento]     VARCHAR (200) NULL,
    [nm_obs_projeto_documento] VARCHAR (60)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Projeto_Documento] PRIMARY KEY CLUSTERED ([cd_projeto] ASC, [cd_projeto_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Documento_Projeto] FOREIGN KEY ([cd_projeto]) REFERENCES [dbo].[Projeto] ([cd_projeto]) ON DELETE CASCADE ON UPDATE CASCADE
);

