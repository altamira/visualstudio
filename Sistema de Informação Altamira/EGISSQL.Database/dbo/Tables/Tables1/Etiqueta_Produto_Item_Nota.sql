CREATE TABLE [dbo].[Etiqueta_Produto_Item_Nota] (
    [cd_Etiqueta_Produto_Item_Nota] INT           NOT NULL,
    [nm_Etiqueta_Produto_Item_Nota] VARCHAR (40)  NOT NULL,
    [ic_condensado]                 CHAR (1)      NULL,
    [cd_linha]                      INT           NULL,
    [cd_coluna]                     INT           NULL,
    [ic_tipo_impressora]            CHAR (1)      NOT NULL,
    [nm_procedure]                  VARCHAR (50)  NULL,
    [cd_tamanho_fonte]              INT           NULL,
    [nm_impressora_etiqueta]        VARCHAR (300) NULL,
    [nm_fonte_etiqueta]             VARCHAR (100) NULL,
    [ic_posicao_etiqueta]           CHAR (1)      NULL,
    [ic_completa_etiqueta]          CHAR (1)      NULL,
    [ic_padrao_etiqueta]            CHAR (1)      NULL,
    [qt_total_item_etiqueta]        INT           NULL,
    CONSTRAINT [PK_Etiqueta_Produto_Item_Nota] PRIMARY KEY CLUSTERED ([cd_Etiqueta_Produto_Item_Nota] ASC) WITH (FILLFACTOR = 90)
);

