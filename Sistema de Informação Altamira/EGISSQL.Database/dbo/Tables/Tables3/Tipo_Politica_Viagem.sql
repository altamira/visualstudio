CREATE TABLE [dbo].[Tipo_Politica_Viagem] (
    [cd_tipo_politica_viagem] INT          NOT NULL,
    [nm_tipo_politica_viagem] VARCHAR (40) NULL,
    [sg_tipo_politica_viagem] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Politica_Viagem] PRIMARY KEY CLUSTERED ([cd_tipo_politica_viagem] ASC) WITH (FILLFACTOR = 90)
);

