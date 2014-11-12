CREATE TABLE [dbo].[Tipo_Reajuste] (
    [cd_tipo_reajuste]        INT          NOT NULL,
    [nm_tipo_reajuste]        VARCHAR (30) COLLATE Latin1_General_CI_AS NOT NULL,
    [sg_tipo_reajuste]        CHAR (10)    COLLATE Latin1_General_CI_AS NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ic_manual_tipo_reajuste] CHAR (1)     NULL,
    [qt_mes_tipo_reajuste]    INT          NULL,
    [ic_custo_tipo_reajuste]  CHAR (1)     NULL,
    [nm_obs_tipo_reajuste]    VARCHAR (40) NULL,
    CONSTRAINT [PK_Tipo_Reajuste] PRIMARY KEY CLUSTERED ([cd_tipo_reajuste] ASC) WITH (FILLFACTOR = 90)
);

