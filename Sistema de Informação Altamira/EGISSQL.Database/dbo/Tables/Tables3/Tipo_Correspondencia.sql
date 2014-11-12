CREATE TABLE [dbo].[Tipo_Correspondencia] (
    [cd_tipo_correspondencia] INT          NOT NULL,
    [nm_tipo_correspondencia] VARCHAR (30) NULL,
    [sg_tipo_correspondencia] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Correspondencia] PRIMARY KEY CLUSTERED ([cd_tipo_correspondencia] ASC) WITH (FILLFACTOR = 90)
);

