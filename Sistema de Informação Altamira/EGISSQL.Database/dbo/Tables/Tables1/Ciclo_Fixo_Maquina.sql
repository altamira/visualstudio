CREATE TABLE [dbo].[Ciclo_Fixo_Maquina] (
    [cd_maquina]            INT          NULL,
    [cd_ciclo_fixo_maquina] INT          NOT NULL,
    [nm_parametro_01]       VARCHAR (50) NULL,
    [nm_parametro_02]       VARCHAR (50) NULL,
    [nm_parametro_03]       VARCHAR (50) NULL,
    [nm_parametro_04]       VARCHAR (50) NULL,
    [nm_parametro_05]       VARCHAR (50) NULL,
    [nm_parametro_06]       VARCHAR (50) NULL,
    [nm_parametro_07]       VARCHAR (50) NULL,
    [nm_parametro_08]       VARCHAR (50) NULL,
    [nm_parametro_09]       VARCHAR (50) NULL,
    [nm_parametro_10]       VARCHAR (50) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_ciclo_fixo_maquina] VARCHAR (40) NULL,
    [ds_obs_ciclo_maquina]  VARCHAR (60) NULL,
    CONSTRAINT [PK_Ciclo_Fixo_Maquina] PRIMARY KEY CLUSTERED ([cd_ciclo_fixo_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ciclo_Fixo_Maquina_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

