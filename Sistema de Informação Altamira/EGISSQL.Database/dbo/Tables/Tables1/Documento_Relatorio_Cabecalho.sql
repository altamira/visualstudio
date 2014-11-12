CREATE TABLE [dbo].[Documento_Relatorio_Cabecalho] (
    [cd_documento_relatorio] INT      NOT NULL,
    [ic_razao_social]        CHAR (1) NULL,
    [ic_logotipo]            CHAR (1) NULL,
    [ic_endereco]            CHAR (1) NULL,
    [ic_pagina]              CHAR (1) NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Documento_Relatorio_Cabecalho] PRIMARY KEY CLUSTERED ([cd_documento_relatorio] ASC) WITH (FILLFACTOR = 90)
);

