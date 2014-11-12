CREATE TABLE [dbo].[Maquina_Agenda] (
    [dt_agenda]              DATETIME     NOT NULL,
    [cd_maquina]             INT          NOT NULL,
    [qt_hora_maquina_agenda] FLOAT (53)   NULL,
    [nm_obs_maquina_agenda]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Agenda_maquina] PRIMARY KEY CLUSTERED ([dt_agenda] ASC, [cd_maquina] ASC) WITH (FILLFACTOR = 90)
);

