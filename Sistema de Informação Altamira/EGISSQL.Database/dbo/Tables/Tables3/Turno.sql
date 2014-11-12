CREATE TABLE [dbo].[Turno] (
    [cd_turno]                  INT          NOT NULL,
    [nm_turno]                  VARCHAR (30) NULL,
    [sg_turno]                  CHAR (10)    NULL,
    [hr_inicio_turno]           VARCHAR (8)  NOT NULL,
    [hr_fim_turno]              VARCHAR (8)  NULL,
    [hr_intervalo_inicio_turno] VARCHAR (8)  NULL,
    [hr_intervalo_fim_turno]    VARCHAR (8)  NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_hora_mes_turno]         FLOAT (53)   NULL,
    [qt_hora_adic_mes_turno]    FLOAT (53)   NULL,
    [qt_coef_dep_acum_turno]    FLOAT (53)   NULL,
    [qt_operacao_turno]         FLOAT (53)   NULL,
    CONSTRAINT [PK_Turno] PRIMARY KEY CLUSTERED ([cd_turno] ASC) WITH (FILLFACTOR = 90)
);

