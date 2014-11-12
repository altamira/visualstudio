CREATE TABLE [dbo].[Custo_Maquina_Historico] (
    [cd_maquina]       INT        NOT NULL,
    [dt_custo_maquina] DATETIME   NOT NULL,
    [vl_custo_maquina] FLOAT (53) NULL,
    [cd_usuario]       INT        NULL,
    [dt_usuario]       DATETIME   NULL,
    CONSTRAINT [PK_Custo_Maquina_Historico] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [dt_custo_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Custo_Maquina_Historico_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

