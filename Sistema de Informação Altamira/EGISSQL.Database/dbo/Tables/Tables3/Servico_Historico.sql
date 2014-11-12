CREATE TABLE [dbo].[Servico_Historico] (
    [cd_servico_historico]     INT          NOT NULL,
    [cd_servico]               INT          NOT NULL,
    [dt_servico_historico]     DATETIME     NULL,
    [cd_tipo_reajuste]         INT          NULL,
    [vl_servico_historico]     FLOAT (53)   NULL,
    [nm_obs_servico_historico] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_moeda]                 INT          NULL,
    [cd_motivo_reajuste]       INT          NULL,
    CONSTRAINT [PK_Servico_Historico] PRIMARY KEY CLUSTERED ([cd_servico_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Historico_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

