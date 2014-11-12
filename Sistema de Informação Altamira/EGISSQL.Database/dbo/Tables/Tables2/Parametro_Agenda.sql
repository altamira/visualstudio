CREATE TABLE [dbo].[Parametro_Agenda] (
    [cd_empresa]            INT        NOT NULL,
    [qt_hora_diaria_agenda] FLOAT (53) NULL,
    [qt_hora_mes_agenda]    FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Parametro_Agenda] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

