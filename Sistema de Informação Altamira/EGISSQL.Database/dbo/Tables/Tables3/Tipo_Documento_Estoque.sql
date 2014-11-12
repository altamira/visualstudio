CREATE TABLE [dbo].[Tipo_Documento_Estoque] (
    [cd_tipo_documento_estoque] INT          NOT NULL,
    [nm_tipo_documento_estoque] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_documento_estoque] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_transferencia_fase]     CHAR (1)     NULL,
    [ic_documento_obrigatorio]  CHAR (1)     NULL,
    [ic_situacao_documento]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Documento_Estoque] PRIMARY KEY CLUSTERED ([cd_tipo_documento_estoque] ASC) WITH (FILLFACTOR = 90)
);

