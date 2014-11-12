﻿CREATE TABLE [dbo].[Movimento_Produto_Terceiro] (
    [cd_movimento_produto_terceiro] INT          NOT NULL,
    [cd_produto]                    INT          NULL,
    [cd_nota_entrada]               INT          NULL,
    [cd_serie_nota_fiscal]          INT          NULL,
    [cd_tipo_destinatario]          INT          NULL,
    [cd_destinatario]               INT          NULL,
    [cd_operacao_fiscal]            INT          NULL,
    [cd_nota_saida]                 INT          NULL,
    [dt_movimento_terceiro]         DATETIME     NULL,
    [qt_movimento_terceiro]         FLOAT (53)   NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [cd_item_nota_fiscal]           INT          NULL,
    [ic_tipo_movimento]             CHAR (1)     NULL,
    [cd_movimento_origem]           INT          NULL,
    [cd_fase_produto_terceiro]      INT          NULL,
    [cd_tipo_documento_terceiro]    INT          NULL,
    [cd_documento_terceiro]         INT          NULL,
    [nm_destinatario]               VARCHAR (40) NULL,
    [nm_historico_movimento]        VARCHAR (40) NULL,
    [cd_tipo_movimento_terceiro]    INT          NULL,
    [ic_movimento_terceiro]         CHAR (1)     NULL,
    CONSTRAINT [PK_Movimento_Produto_Terceiro] PRIMARY KEY CLUSTERED ([cd_movimento_produto_terceiro] ASC) WITH (FILLFACTOR = 90)
);

