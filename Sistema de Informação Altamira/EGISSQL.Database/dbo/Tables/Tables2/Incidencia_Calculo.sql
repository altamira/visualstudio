CREATE TABLE [dbo].[Incidencia_Calculo] (
    [cd_incidencia_calculo]      INT           NOT NULL,
    [nm_incidencia_calculo]      VARCHAR (40)  NOT NULL,
    [sg_incidencia_calculo]      CHAR (10)     NULL,
    [nm_obs_incidencia_calculo]  VARCHAR (40)  NULL,
    [nm_rotina_incidencia_cal]   VARCHAR (100) NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [ic_tipo_incidencia_calculo] CHAR (1)      NULL,
    CONSTRAINT [PK_Incidencia_Calculo] PRIMARY KEY CLUSTERED ([cd_incidencia_calculo] ASC) WITH (FILLFACTOR = 90)
);

