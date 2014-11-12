CREATE TABLE [dbo].[Tipo_Horario] (
    [cd_tipo_horario]      INT          NOT NULL,
    [nm_tipo_horario]      VARCHAR (40) NULL,
    [sg_tipo_horario]      CHAR (10)    NULL,
    [hr_inicio_horario]    VARCHAR (8)  NULL,
    [hr_fim_horario]       VARCHAR (8)  NULL,
    [ic_ativo_horario]     CHAR (1)     NULL,
    [nm_obs_horario]       VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [hr_inicio_internvalo] VARCHAR (8)  NULL,
    [hr_fim_intervalo]     VARCHAR (8)  NULL,
    CONSTRAINT [PK_Tipo_Horario] PRIMARY KEY CLUSTERED ([cd_tipo_horario] ASC) WITH (FILLFACTOR = 90)
);

