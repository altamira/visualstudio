CREATE TABLE [dbo].[Etiqueta_Produto_Item_Nota_Campo] (
    [cd_Etiqueta_Produto_Item_Nota] INT           NOT NULL,
    [cd_Etiqueta_Produto_Campo]     INT           NOT NULL,
    [nm_Etiqueta_Produto_Campo]     VARCHAR (40)  NULL,
    [ic_condensa]                   CHAR (1)      NULL,
    [ic_negrito]                    CHAR (1)      NULL,
    [ic_enfatizado]                 CHAR (1)      NULL,
    [cd_linha_campo]                INT           NULL,
    [cd_coluna_campo]               INT           NULL,
    [cd_tamanho_linha]              INT           NULL,
    [cd_tamanho_coluna]             INT           NULL,
    [ic_alinhamento]                CHAR (1)      NULL,
    [nm_atributo]                   VARCHAR (40)  NULL,
    [ic_imprime]                    CHAR (1)      NULL,
    [nm_valor_fixo]                 VARCHAR (100) NULL,
    [cd_tamanho_fonte]              INT           NULL,
    [nm_fonte_campo]                VARCHAR (100) NULL,
    [ic_codigo_barra]               CHAR (1)      NULL,
    [ic_tipo_codigo_barra]          CHAR (1)      NULL,
    CONSTRAINT [PK_Etiqueta_Produto_Item_Nota_Campo] PRIMARY KEY CLUSTERED ([cd_Etiqueta_Produto_Item_Nota] ASC, [cd_Etiqueta_Produto_Campo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Etiqueta_Produto_Item_Nota_Campo_Etiqueta_Produto_Item_Nota] FOREIGN KEY ([cd_Etiqueta_Produto_Item_Nota]) REFERENCES [dbo].[Etiqueta_Produto_Item_Nota] ([cd_Etiqueta_Produto_Item_Nota])
);

