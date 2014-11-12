CREATE TABLE [dbo].[Atividade_Analista] (
    [cd_atividade_analista] INT          NOT NULL,
    [nm_atividade_analista] VARCHAR (40) NULL,
    [sg_atividade_analista] CHAR (10)    NULL,
    [ds_atividade_analista] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_servico]            INT          NULL,
    [qt_hora_atividade]     FLOAT (53)   NULL,
    [ic_execucao_atividade] CHAR (1)     NULL,
    [cd_grupo_atividade]    INT          NULL,
    [qt_ordem_atividade]    INT          NULL,
    CONSTRAINT [PK_Atividade_Analista] PRIMARY KEY CLUSTERED ([cd_atividade_analista] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atividade_Analista_Grupo_Atividade_Implantacao] FOREIGN KEY ([cd_grupo_atividade]) REFERENCES [dbo].[Grupo_Atividade_Implantacao] ([cd_grupo_atividade])
);

