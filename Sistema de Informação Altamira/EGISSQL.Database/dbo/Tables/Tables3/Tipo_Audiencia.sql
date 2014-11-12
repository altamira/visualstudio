CREATE TABLE [dbo].[Tipo_Audiencia] (
    [cd_tipo_audiencia] INT          NOT NULL,
    [nm_tipo_audiencia] VARCHAR (40) NULL,
    [sg_tipo_audiencia] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Audiencia] PRIMARY KEY CLUSTERED ([cd_tipo_audiencia] ASC) WITH (FILLFACTOR = 90)
);

