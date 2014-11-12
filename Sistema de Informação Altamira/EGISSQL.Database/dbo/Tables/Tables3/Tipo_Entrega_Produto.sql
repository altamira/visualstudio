CREATE TABLE [dbo].[Tipo_Entrega_Produto] (
    [cd_tipo_entrega_produto]   INT          NOT NULL,
    [nm_tipo_entrega_produto]   VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_entrega_produto]   CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_tipo_entrega_produto]   CHAR (1)     NULL,
    [ic_fataut_entrega_produto] CHAR (1)     NULL,
    [ic_padrao_forma_entrega]   CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Entrega_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_entrega_produto] ASC) WITH (FILLFACTOR = 90)
);

