CREATE TABLE [dbo].[Guia_Fracionamento_Item] (
    [cd_guia_fracionamento]      INT          NOT NULL,
    [cd_item_guia_fracionamento] INT          NOT NULL,
    [cd_produto_fracionamento]   INT          NULL,
    [qt_fracionada]              FLOAT (53)   NULL,
    [dt_fracionamento]           DATETIME     NULL,
    [cd_operador]                INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_produto]                 INT          NULL,
    [qt_real_fracionada]         FLOAT (53)   NULL,
    [qt_dif_fracionada]          FLOAT (53)   NULL,
    [qt_sobra_fracionada]        FLOAT (53)   NULL,
    [qt_sobra_fracionamento]     FLOAT (53)   NULL,
    [cd_lote_fracionamento]      VARCHAR (25) NULL,
    [cd_laudo]                   INT          NULL,
    CONSTRAINT [PK_Guia_Fracionamento_Item] PRIMARY KEY CLUSTERED ([cd_guia_fracionamento] ASC, [cd_item_guia_fracionamento] ASC) WITH (FILLFACTOR = 90)
);

