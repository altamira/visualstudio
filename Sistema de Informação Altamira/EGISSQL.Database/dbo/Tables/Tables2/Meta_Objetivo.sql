CREATE TABLE [dbo].[Meta_Objetivo] (
    [cd_meta]                INT          NOT NULL,
    [dt_meta]                DATETIME     NULL,
    [nm_meta]                VARCHAR (60) NULL,
    [ds_meta]                TEXT         NULL,
    [cd_mascara_meta]        VARCHAR (20) NULL,
    [cd_objetivo]            INT          NULL,
    [dt_inicio_meta]         DATETIME     NULL,
    [dt_final_meta]          DATETIME     NULL,
    [dt_conclusao_meta]      DATETIME     NULL,
    [nm_obs_meta]            VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_indicador]           INT          NULL,
    [dt_aprovacao_meta]      DATETIME     NULL,
    [cd_usuario_aprovacao]   INT          NULL,
    [cd_usuario_responsavel] INT          NULL,
    [cd_status_meta]         INT          NULL,
    CONSTRAINT [PK_Meta_Objetivo] PRIMARY KEY CLUSTERED ([cd_meta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Objetivo_Indicador] FOREIGN KEY ([cd_indicador]) REFERENCES [dbo].[Indicador] ([cd_indicador]),
    CONSTRAINT [FK_Meta_Objetivo_Objetivo] FOREIGN KEY ([cd_objetivo]) REFERENCES [dbo].[Objetivo] ([cd_objetivo])
);

