CREATE TABLE [dbo].[Maquina_Estampo] (
    [cd_maquina]                INT        NOT NULL,
    [qt_tonelagem_maquina]      FLOAT (53) NULL,
    [qt_diametro_externo]       FLOAT (53) NULL,
    [qt_espessura]              FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [qt_diametro_externo_final] FLOAT (53) NULL,
    CONSTRAINT [PK_Maquina_Estampo] PRIMARY KEY CLUSTERED ([cd_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Estampo_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

