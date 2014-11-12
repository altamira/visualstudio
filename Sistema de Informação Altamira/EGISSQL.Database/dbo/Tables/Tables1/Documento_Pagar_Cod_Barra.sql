CREATE TABLE [dbo].[Documento_Pagar_Cod_Barra] (
    [cd_documento_pagar]        INT          NOT NULL,
    [cd_tipo_codigo_barra]      INT          NULL,
    [nm_codigo_barra_documento] VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Documento_Pagar_Cod_Barra] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC) WITH (FILLFACTOR = 90)
);

