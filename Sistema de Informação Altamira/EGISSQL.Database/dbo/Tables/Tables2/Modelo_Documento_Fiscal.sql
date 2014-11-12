CREATE TABLE [dbo].[Modelo_Documento_Fiscal] (
    [cd_modelo_documento]       INT          NOT NULL,
    [nm_modelo_documento]       VARCHAR (80) NULL,
    [cd_identificacao_sintegra] VARCHAR (2)  NULL,
    [ds_modelo_documento]       TEXT         NULL,
    [cd_usuario]                INT          NULL,
    CONSTRAINT [PK_Modelo_Documento_Fiscal] PRIMARY KEY CLUSTERED ([cd_modelo_documento] ASC)
);

