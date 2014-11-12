CREATE TABLE [dbo].[Consulta_Item_Embalagem] (
    [cd_consulta]             INT        NOT NULL,
    [cd_item_consulta]        INT        NOT NULL,
    [cd_tipo_embalagem]       INT        NULL,
    [qt_embalagem]            FLOAT (53) NULL,
    [ic_incluso_embalagem]    CHAR (1)   NULL,
    [ic_aluguel_embalagem]    CHAR (1)   NULL,
    [qt_dia_cobrar_aluguel]   INT        NULL,
    [ic_embalagem_cliente]    CHAR (1)   NULL,
    [qt_capacidade_embalagem] FLOAT (53) NULL,
    [qt_peso_embalagem]       FLOAT (53) NULL,
    [ic_tipo_retira]          CHAR (1)   NULL,
    [ic_frete_cliente]        CHAR (1)   NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Consulta_Item_Embalagem] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

