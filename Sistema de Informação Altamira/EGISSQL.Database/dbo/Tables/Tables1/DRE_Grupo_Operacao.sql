CREATE TABLE [dbo].[DRE_Grupo_Operacao] (
    [cd_operacao]  INT      NOT NULL,
    [cd_dre_grupo] INT      NULL,
    [cd_usuario]   INT      NULL,
    [dt_usuario]   DATETIME NULL,
    CONSTRAINT [PK_DRE_Grupo_Operacao] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DRE_Grupo_Operacao_DRE_Grupo] FOREIGN KEY ([cd_dre_grupo]) REFERENCES [dbo].[DRE_Grupo] ([cd_dre_grupo])
);

