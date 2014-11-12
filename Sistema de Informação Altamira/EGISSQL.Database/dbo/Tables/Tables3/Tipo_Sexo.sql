CREATE TABLE [dbo].[Tipo_Sexo] (
    [cd_tipo_sexo] INT          NOT NULL,
    [nm_tipo_sexo] VARCHAR (30) NULL,
    [sg_tipo_sexo] CHAR (1)     NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Sexo] PRIMARY KEY CLUSTERED ([cd_tipo_sexo] ASC) WITH (FILLFACTOR = 90)
);

