CREATE TABLE [dbo].[Tipo_Contrato_Cambio] (
    [cd_tipo_contrato_cambio] INT          NOT NULL,
    [nm_tipo_contrato_cambio] VARCHAR (40) NULL,
    [sg_tipo_contrato_cambio] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Contrato_Cambio] PRIMARY KEY CLUSTERED ([cd_tipo_contrato_cambio] ASC) WITH (FILLFACTOR = 90)
);

