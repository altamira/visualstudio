CREATE TABLE [dbo].[Tipo_Obreiro] (
    [cd_tipo_obreiro] INT          NOT NULL,
    [nm_tipo_obreiro] VARCHAR (40) NULL,
    [sg_tipo_obreiro] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Obreiro] PRIMARY KEY CLUSTERED ([cd_tipo_obreiro] ASC) WITH (FILLFACTOR = 90)
);

