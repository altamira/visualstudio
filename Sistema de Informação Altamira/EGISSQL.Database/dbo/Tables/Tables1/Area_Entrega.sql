CREATE TABLE [dbo].[Area_Entrega] (
    [cd_area_entrega]       INT          NOT NULL,
    [nm_area_entrega]       VARCHAR (40) NULL,
    [nm_identificacao_area] VARCHAR (15) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_criterio_visita]    INT          NULL,
    [cd_semana]             INT          NULL,
    [sg_area_entrega]       CHAR (10)    NULL,
    CONSTRAINT [PK_Area_Entrega] PRIMARY KEY CLUSTERED ([cd_area_entrega] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Area_Entrega_Criterio_Visita] FOREIGN KEY ([cd_criterio_visita]) REFERENCES [dbo].[Criterio_Visita] ([cd_criterio_visita]),
    CONSTRAINT [FK_Area_Entrega_Semana] FOREIGN KEY ([cd_semana]) REFERENCES [dbo].[Semana] ([cd_semana])
);

