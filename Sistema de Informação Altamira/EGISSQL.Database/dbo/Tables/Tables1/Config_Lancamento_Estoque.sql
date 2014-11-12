CREATE TABLE [dbo].[Config_Lancamento_Estoque] (
    [cd_empresa]                INT      NOT NULL,
    [cd_tipo_movimento_estoque] INT      NOT NULL,
    [cd_departamento]           INT      NOT NULL,
    [cd_tipo_destinatario]      INT      NULL,
    [cd_centro_custo]           INT      NULL,
    [cd_historico_estoque]      INT      NULL,
    [cd_tipo_documento_estoque] INT      NULL,
    [ic_unidade_medida]         CHAR (1) NULL,
    [ic_lote_produto]           CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [ic_peps]                   CHAR (1) NULL,
    [ic_terceiro]               CHAR (1) NULL,
    [ic_consignacao]            CHAR (1) NULL,
    [ic_fob]                    CHAR (1) NULL,
    [ic_custo_contabil]         CHAR (1) NULL,
    [ic_fob_conv]               CHAR (1) NULL,
    CONSTRAINT [PK_Config_Lancamento_Estoque] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_tipo_movimento_estoque] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Lancamento_Estoque_Tipo_Documento_Estoque] FOREIGN KEY ([cd_tipo_documento_estoque]) REFERENCES [dbo].[Tipo_Documento_Estoque] ([cd_tipo_documento_estoque])
);

