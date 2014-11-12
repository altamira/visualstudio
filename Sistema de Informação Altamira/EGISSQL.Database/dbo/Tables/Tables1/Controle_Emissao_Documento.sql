CREATE TABLE [dbo].[Controle_Emissao_Documento] (
    [cd_controle_emissao_doc] INT        NOT NULL,
    [cd_documento]            INT        NULL,
    [cd_tipo_documento]       INT        NULL,
    [cd_tipo_documento_comex] INT        NULL,
    [dt_emissao_documento]    DATETIME   NULL,
    [qt_vias_documento]       FLOAT (53) NULL,
    [ds_observacao_documento] TEXT       NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Controle_Emissao_Documento] PRIMARY KEY CLUSTERED ([cd_controle_emissao_doc] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Controle_Emissao_Documento_Tipo_Documento_Comex] FOREIGN KEY ([cd_tipo_documento_comex]) REFERENCES [dbo].[Tipo_Documento_Comex] ([cd_tipo_documento_comex])
);

