CREATE TABLE [dbo].[Pedido_Importacao_Despesa] (
    [cd_pedido_importacao]      INT        NOT NULL,
    [cd_despesa_pedido_import]  INT        NOT NULL,
    [vl_despesa_pedido_import]  FLOAT (53) NOT NULL,
    [dt_despesa_pedido_import]  DATETIME   NOT NULL,
    [ic_importacao_desp_pedido] CHAR (1)   NOT NULL,
    [ic_ipi_despesa_pedido]     CHAR (1)   NOT NULL,
    [ic_icms_despesa_pedido]    CHAR (1)   NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    [cd_tipo_despesa_comex]     INT        NULL,
    CONSTRAINT [PK_Pedido_Importacao_Despesa] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_despesa_pedido_import] ASC) WITH (FILLFACTOR = 90)
);

