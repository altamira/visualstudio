CREATE TABLE [dbo].[Tipo_Registro_Obito] (
    [cd_tipo_registro_obito] INT          NOT NULL,
    [nm_tipo_registro_obito] VARCHAR (40) NULL,
    [sg_tipo_registro_obito] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Registro_Obito] PRIMARY KEY CLUSTERED ([cd_tipo_registro_obito] ASC) WITH (FILLFACTOR = 90)
);

