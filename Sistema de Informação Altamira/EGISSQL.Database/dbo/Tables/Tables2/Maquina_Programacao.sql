CREATE TABLE [dbo].[Maquina_Programacao] (
    [cd_maquina]                 INT          NOT NULL,
    [ds_texto_ordem_servico]     TEXT         NULL,
    [nm_obs_maquina_programacao] VARCHAR (60) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Maquina_Programacao] PRIMARY KEY CLUSTERED ([cd_maquina] ASC),
    CONSTRAINT [FK_Maquina_Programacao_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

