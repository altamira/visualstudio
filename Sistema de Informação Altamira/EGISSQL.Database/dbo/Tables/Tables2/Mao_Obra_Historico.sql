CREATE TABLE [dbo].[Mao_Obra_Historico] (
    [cd_mao_obra]               INT          NOT NULL,
    [dt_historico_mao_obra]     DATETIME     NULL,
    [vl_historico_mao_obra]     FLOAT (53)   NULL,
    [cd_tipo_reajuste]          INT          NULL,
    [cd_motivo_reajuste]        INT          NULL,
    [nm_obs_historico_mao_obra] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Mao_Obra_Historico] PRIMARY KEY CLUSTERED ([cd_mao_obra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Mao_Obra_Historico_Tipo_Reajuste] FOREIGN KEY ([cd_tipo_reajuste]) REFERENCES [dbo].[Tipo_Reajuste] ([cd_tipo_reajuste])
);

