CREATE TABLE [dbo].[Grupo_Maquina_Maquina] (
    [cd_grupo_maquina] INT      NOT NULL,
    [cd_maquina]       INT      NOT NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Grupo_Maquina_Maquina] PRIMARY KEY CLUSTERED ([cd_grupo_maquina] ASC, [cd_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Maquina_Maquina_Grupo_Maquina] FOREIGN KEY ([cd_grupo_maquina]) REFERENCES [dbo].[Grupo_Maquina] ([cd_grupo_maquina]),
    CONSTRAINT [FK_Grupo_Maquina_Maquina_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

