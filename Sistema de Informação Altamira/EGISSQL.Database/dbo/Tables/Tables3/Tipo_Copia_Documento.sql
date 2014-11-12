CREATE TABLE [dbo].[Tipo_Copia_Documento] (
    [cd_tipo_copia_documento] INT          NOT NULL,
    [nm_tipo_copia_documento] VARCHAR (40) NULL,
    [sg_tipo_copia_documento] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Copia_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_copia_documento] ASC) WITH (FILLFACTOR = 90)
);

