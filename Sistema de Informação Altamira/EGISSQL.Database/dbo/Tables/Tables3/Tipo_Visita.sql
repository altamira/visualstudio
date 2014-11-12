CREATE TABLE [dbo].[Tipo_Visita] (
    [cd_tipo_visita] INT          NOT NULL,
    [nm_tipo_visita] VARCHAR (30) NOT NULL,
    [sg_tipo_visita] CHAR (10)    NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Visita] PRIMARY KEY CLUSTERED ([cd_tipo_visita] ASC) WITH (FILLFACTOR = 90)
);

