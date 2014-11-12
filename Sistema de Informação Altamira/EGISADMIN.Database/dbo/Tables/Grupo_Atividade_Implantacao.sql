CREATE TABLE [dbo].[Grupo_Atividade_Implantacao] (
    [cd_grupo_atividade] INT          NOT NULL,
    [nm_grupo_atividade] VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [qt_ordem_atividade] INT          NULL,
    CONSTRAINT [PK_Grupo_Atividade_Implantacao] PRIMARY KEY CLUSTERED ([cd_grupo_atividade] ASC) WITH (FILLFACTOR = 90)
);

