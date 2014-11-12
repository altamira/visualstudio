CREATE TABLE [dbo].[Tipo_Horario_Visita] (
    [cd_tipo_horario_visita] INT          NOT NULL,
    [nm_tipo_horario_visita] VARCHAR (40) NULL,
    [hr_inicio_visita]       VARCHAR (8)  NULL,
    [hr_fim_visita]          CHAR (8)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Horario_Visita] PRIMARY KEY CLUSTERED ([cd_tipo_horario_visita] ASC) WITH (FILLFACTOR = 90)
);

