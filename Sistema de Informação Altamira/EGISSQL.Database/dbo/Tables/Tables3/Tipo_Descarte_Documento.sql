CREATE TABLE [dbo].[Tipo_Descarte_Documento] (
    [cd_tipo_descarte] INT          NOT NULL,
    [nm_tipo_descarte] VARCHAR (40) NULL,
    [sg_tipo_descarte] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Descarte_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_descarte] ASC) WITH (FILLFACTOR = 90)
);

