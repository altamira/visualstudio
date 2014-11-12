CREATE TABLE [dbo].[Criterio_Visita] (
    [cd_criterio_visita]      INT          NOT NULL,
    [nm_criterio_visita]      VARCHAR (30) NOT NULL,
    [sg_criterio_visita]      CHAR (10)    NOT NULL,
    [qt_dia_criterio_visita]  INT          NOT NULL,
    [ic_agenda_automatica]    CHAR (1)     NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [sg_area_criterio_visita] CHAR (10)    NULL,
    CONSTRAINT [PK_Criterio_Visita] PRIMARY KEY CLUSTERED ([cd_criterio_visita] ASC) WITH (FILLFACTOR = 90)
);

