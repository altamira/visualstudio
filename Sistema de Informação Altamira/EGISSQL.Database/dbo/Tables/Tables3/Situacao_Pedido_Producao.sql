CREATE TABLE [dbo].[Situacao_Pedido_Producao] (
    [cd_situacao_pedido]     INT          NOT NULL,
    [nm_situacao_pedido]     VARCHAR (40) NULL,
    [sg_situacao_pedido]     CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_pad_situacao_pedido] CHAR (1)     NULL,
    CONSTRAINT [PK_Situacao_Pedido_Producao] PRIMARY KEY CLUSTERED ([cd_situacao_pedido] ASC) WITH (FILLFACTOR = 90)
);

