CREATE TABLE [dbo].[Grupo_Atividade_Implantacao] (
    [cd_grupo_atividade]   INT          NOT NULL,
    [nm_grupo_atividade]   VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [qt_ordem_atividade]   INT          NULL,
    [sg_grupo_atividade]   CHAR (10)    NULL,
    [cd_departamento]      INT          NULL,
    [ic_treinamento_grupo] CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_Atividade_Implantacao] PRIMARY KEY CLUSTERED ([cd_grupo_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Atividade_Implantacao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

