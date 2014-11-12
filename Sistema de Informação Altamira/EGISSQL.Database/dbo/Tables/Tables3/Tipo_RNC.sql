CREATE TABLE [dbo].[Tipo_RNC] (
    [cd_tipo_rnc] INT          NOT NULL,
    [nm_tipo_rnc] VARCHAR (40) NULL,
    [sg_tipo_rnc] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Tipo_RNC] PRIMARY KEY CLUSTERED ([cd_tipo_rnc] ASC) WITH (FILLFACTOR = 90)
);

