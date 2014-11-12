﻿CREATE TABLE [dbo].[Documento_Relatorio_Composicao] (
    [cd_documento_relatorio] INT           NOT NULL,
    [cd_campo_doc_relatorio] INT           NOT NULL,
    [ic_condensado]          CHAR (1)      NULL,
    [ic_negrito]             CHAR (1)      NULL,
    [ic_enfatizado]          CHAR (1)      NULL,
    [ic_italico]             CHAR (1)      NULL,
    [ic_sublinhado]          CHAR (1)      NULL,
    [ic_expandido]           CHAR (1)      NULL,
    [ic_shape]               CHAR (1)      NULL,
    [qt_linha]               INT           NULL,
    [qt_coluna]              INT           NULL,
    [cd_palavra]             INT           NULL,
    [qt_linha_final]         INT           NULL,
    [qt_tamanho_campo]       INT           NULL,
    [ic_alinhamento]         CHAR (1)      NULL,
    [ic_imprime]             CHAR (1)      NULL,
    [cd_tabela]              INT           NULL,
    [cd_view]                INT           NULL,
    [cd_procedure]           INT           NULL,
    [nm_sp_documento]        VARCHAR (100) NULL,
    [nm_sp_atributo]         VARCHAR (25)  NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Documento_Relatorio_Composicao] PRIMARY KEY CLUSTERED ([cd_documento_relatorio] ASC, [cd_campo_doc_relatorio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Relatorio_Composicao_Palavra] FOREIGN KEY ([cd_palavra]) REFERENCES [dbo].[Palavra] ([cd_palavra])
);

