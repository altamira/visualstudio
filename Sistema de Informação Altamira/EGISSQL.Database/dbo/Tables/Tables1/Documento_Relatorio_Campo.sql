CREATE TABLE [dbo].[Documento_Relatorio_Campo] (
    [cd_documento_relatorio] INT          NOT NULL,
    [cd_campo_doc_relatorio] INT          NOT NULL,
    [nm_campo_doc_relatorio] VARCHAR (40) NOT NULL,
    [ds_campo_doc_relatorio] TEXT         NULL,
    [cd_tipo_campo]          INT          NULL,
    [qt_tamanho]             INT          NULL,
    [qt_decimal]             INT          NULL,
    [cd_inicio_posicao]      INT          NULL,
    [cd_fim_posicao]         INT          NULL,
    [cd_palavra]             INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Documento_Relatorio_Campo] PRIMARY KEY CLUSTERED ([cd_documento_relatorio] ASC, [cd_campo_doc_relatorio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Relatorio_Campo_Palavra] FOREIGN KEY ([cd_palavra]) REFERENCES [dbo].[Palavra] ([cd_palavra])
);

