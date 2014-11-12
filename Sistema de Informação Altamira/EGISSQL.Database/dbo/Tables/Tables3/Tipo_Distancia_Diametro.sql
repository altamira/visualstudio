CREATE TABLE [dbo].[Tipo_Distancia_Diametro] (
    [cd_tipo_distancia_diam] INT          NOT NULL,
    [nm_tipo_distancia_diam] VARCHAR (40) NOT NULL,
    [sg_tipo_distancia_diam] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Distancia_Diametro] PRIMARY KEY CLUSTERED ([cd_tipo_distancia_diam] ASC) WITH (FILLFACTOR = 90)
);

