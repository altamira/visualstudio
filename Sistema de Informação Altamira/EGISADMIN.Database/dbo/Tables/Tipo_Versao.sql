CREATE TABLE [dbo].[Tipo_Versao] (
    [cd_tipo_versao] INT          NOT NULL,
    [nm_tipo_versao] VARCHAR (40) NULL,
    [sg_tipo_versao] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Versao] PRIMARY KEY CLUSTERED ([cd_tipo_versao] ASC) WITH (FILLFACTOR = 90)
);

