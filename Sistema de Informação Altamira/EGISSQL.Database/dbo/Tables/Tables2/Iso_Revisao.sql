CREATE TABLE [dbo].[Iso_Revisao] (
    [cd_iso_processo]          INT           NOT NULL,
    [cd_iso_revisao]           INT           NOT NULL,
    [dt_iso_revisao]           DATETIME      NOT NULL,
    [cd_iso_ordem_revisao]     INT           NOT NULL,
    [nm_iso_revisao]           VARCHAR (60)  NOT NULL,
    [cd_usuario_aprovacao_iso] INT           NOT NULL,
    [dt_aprovacao_iso_revisao] DATETIME      NOT NULL,
    [cd_usuario]               INT           NOT NULL,
    [dt_usuario]               DATETIME      NOT NULL,
    [nm_documento_iso_revisao] VARCHAR (100) NULL,
    [nm_obs_iso_revisao]       VARCHAR (40)  NULL,
    [ds_iso_revisao]           TEXT          NULL,
    CONSTRAINT [PK_Iso_Revisao] PRIMARY KEY CLUSTERED ([cd_iso_processo] ASC, [cd_iso_revisao] ASC) WITH (FILLFACTOR = 90)
);

