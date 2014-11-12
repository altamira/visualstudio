CREATE TABLE [dbo].[RNC] (
    [cd_rnc]                   INT          NOT NULL,
    [cd_identificacao_rnc]     VARCHAR (15) NULL,
    [dt_rnc]                   DATETIME     NULL,
    [nm_rnc]                   VARCHAR (60) NULL,
    [cd_usuario_rnc]           INT          NULL,
    [cd_departamento]          INT          NULL,
    [cd_tipo_rnc]              INT          NULL,
    [ds_rnc]                   TEXT         NULL,
    [cd_processo_iso]          INT          NULL,
    [cd_criterio_acao]         INT          NULL,
    [cd_origem_rnc]            INT          NULL,
    [cd_usuario_aprovacao_rnc] INT          NULL,
    [dt_aprovacao_rnc]         DATETIME     NULL,
    [nm_obs_rnc]               VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_RNC] PRIMARY KEY CLUSTERED ([cd_rnc] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RNC_Criterio_Acao] FOREIGN KEY ([cd_criterio_acao]) REFERENCES [dbo].[Criterio_Acao] ([cd_criterio_acao])
);

