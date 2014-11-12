CREATE TABLE [dbo].[Processo_Sistema] (
    [cd_processo]           INT           NOT NULL,
    [dt_processo]           DATETIME      NULL,
    [nm_processo]           VARCHAR (40)  NULL,
    [ds_processo]           TEXT          NULL,
    [nm_documento_processo] VARCHAR (100) NULL,
    [nm_obs_processo]       VARCHAR (40)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [nm_fluxo_processo]     VARCHAR (100) NULL,
    CONSTRAINT [PK_Processo_Sistema] PRIMARY KEY CLUSTERED ([cd_processo] ASC) WITH (FILLFACTOR = 90)
);

