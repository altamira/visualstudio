CREATE TABLE [dbo].[Evento_Incidencia] (
    [cd_evento]             INT      NOT NULL,
    [cd_incidencia_calculo] INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [ic_evento_incidencia]  CHAR (1) NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Evento_Incidencia] PRIMARY KEY CLUSTERED ([cd_evento] ASC, [cd_incidencia_calculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Evento_Incidencia_Incidencia_Calculo] FOREIGN KEY ([cd_incidencia_calculo]) REFERENCES [dbo].[Incidencia_Calculo] ([cd_incidencia_calculo])
);

