CREATE TABLE [dbo].[Tipo_Proposta] (
    [cd_tipo_proposta]          INT          NOT NULL,
    [nm_tipo_proposta]          VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_proposta]          CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ic_comercial_tp_proposta]  CHAR (1)     COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_tp_formulario_proposta] INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [qt_inicio_proposta]        INT          NULL,
    [qt_fim_proposta]           INT          NULL,
    [nm_obs_tipo_proposta]      VARCHAR (40) NULL,
    [nm_titulo_tipo_proposta]   VARCHAR (60) NULL,
    [sg_titulo_tipo_proposta]   VARCHAR (15) NULL,
    CONSTRAINT [PK_Tipo_Proposta] PRIMARY KEY CLUSTERED ([cd_tipo_proposta] ASC) WITH (FILLFACTOR = 90)
);

