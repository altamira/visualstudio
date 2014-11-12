CREATE TABLE [dbo].[Tipo_Licenca] (
    [cd_tipo_licenca] INT          NOT NULL,
    [nm_tipo_licenca] VARCHAR (40) NULL,
    [sg_tipo_licenca] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Licenca] PRIMARY KEY CLUSTERED ([cd_tipo_licenca] ASC) WITH (FILLFACTOR = 90)
);

