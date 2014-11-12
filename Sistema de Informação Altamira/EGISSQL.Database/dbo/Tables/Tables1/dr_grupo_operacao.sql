CREATE TABLE [dbo].[dr_grupo_operacao] (
    [cd_operacao] INT      NOT NULL,
    [cd_dr_grupo] INT      NOT NULL,
    [cd_usuario]  INT      NULL,
    [dt_usuario]  DATETIME NULL,
    CONSTRAINT [PK_dr_grupo_operacao] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_dr_grupo_operacao_Dr_Grupo] FOREIGN KEY ([cd_dr_grupo]) REFERENCES [dbo].[Dr_Grupo] ([cd_dr_grupo])
);

