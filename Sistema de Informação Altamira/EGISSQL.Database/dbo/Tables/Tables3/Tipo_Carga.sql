CREATE TABLE [dbo].[Tipo_Carga] (
    [cd_tipo_carga] INT          NOT NULL,
    [nm_tipo_carga] VARCHAR (40) NULL,
    [sg_tipo_carga] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Carga] PRIMARY KEY CLUSTERED ([cd_tipo_carga] ASC) WITH (FILLFACTOR = 90)
);

