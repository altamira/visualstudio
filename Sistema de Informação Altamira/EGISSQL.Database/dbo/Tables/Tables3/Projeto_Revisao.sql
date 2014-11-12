CREATE TABLE [dbo].[Projeto_Revisao] (
    [cd_projeto]              INT           NOT NULL,
    [cd_item_projeto]         INT           NOT NULL,
    [cd_projeto_revisao]      INT           NOT NULL,
    [dt_projeto_revisao]      DATETIME      NULL,
    [cd_tipo_projeto_revisao] INT           NULL,
    [nm_projeto_revisao]      VARCHAR (40)  NULL,
    [ds_projeto_revisao]      TEXT          NULL,
    [nm_desenho_revisao]      VARCHAR (50)  NULL,
    [nm_caminho_revisao]      VARCHAR (100) NULL,
    [nm_obs_projeto_revisao]  VARCHAR (40)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_tipo_revisao_projeto] INT           NULL,
    [cd_desenho_projeto]      INT           NULL,
    [cd_projetista]           INT           NULL,
    CONSTRAINT [PK_Projeto_Revisao] PRIMARY KEY CLUSTERED ([cd_projeto] ASC, [cd_item_projeto] ASC, [cd_projeto_revisao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Revisao_Projeto] FOREIGN KEY ([cd_projeto]) REFERENCES [dbo].[Projeto] ([cd_projeto]),
    CONSTRAINT [FK_Projeto_Revisao_Tipo_Revisao_Projeto] FOREIGN KEY ([cd_tipo_projeto_revisao]) REFERENCES [dbo].[Tipo_Revisao_Projeto] ([cd_tipo_revisao_projeto])
);

