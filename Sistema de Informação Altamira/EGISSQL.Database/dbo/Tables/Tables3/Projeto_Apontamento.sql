CREATE TABLE [dbo].[Projeto_Apontamento] (
    [cd_apontamento_projeto] INT          NOT NULL,
    [cd_projeto]             INT          NOT NULL,
    [cd_item_projeto]        INT          NOT NULL,
    [cd_projetista]          INT          NULL,
    [dt_inicio_projeto]      DATETIME     NULL,
    [dt_final_projeto]       DATETIME     NULL,
    [qt_hora_projeto]        FLOAT (53)   NULL,
    [nm_obs_apontamento]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_tarefa_projeto]      INT          NULL,
    [ic_improdutiva_projeto] CHAR (1)     NULL,
    CONSTRAINT [PK_Projeto_Apontamento] PRIMARY KEY CLUSTERED ([cd_apontamento_projeto] ASC, [cd_projeto] ASC, [cd_item_projeto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Apontamento_Projetista] FOREIGN KEY ([cd_projetista]) REFERENCES [dbo].[Projetista] ([cd_projetista]),
    CONSTRAINT [FK_Projeto_Apontamento_Tarefa_Projeto] FOREIGN KEY ([cd_tarefa_projeto]) REFERENCES [dbo].[Tarefa_Projeto] ([cd_tarefa_projeto])
);

