CREATE TABLE [dbo].[Historico_Servico] (
    [cd_hist_servico]       INT          NOT NULL,
    [cd_tipo_servico]       INT          NULL,
    [ds_obs_tipo_servico]   TEXT         NULL,
    [dt_hist_servico]       DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_tipo_servico]       VARCHAR (25) NULL,
    [cd_contrato_concessao] INT          NULL,
    [cd_contrato]           INT          NULL,
    CONSTRAINT [PK_Historico_Servico] PRIMARY KEY CLUSTERED ([cd_hist_servico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Historico_Servico_Tipo_Servico] FOREIGN KEY ([cd_tipo_servico]) REFERENCES [dbo].[Tipo_Servico] ([cd_tipo_servico])
);

