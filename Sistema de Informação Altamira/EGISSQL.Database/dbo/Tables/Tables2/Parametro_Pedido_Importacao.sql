CREATE TABLE [dbo].[Parametro_Pedido_Importacao] (
    [cd_empresa]        INT      NOT NULL,
    [ic_tipo_numeracao] CHAR (1) NULL,
    [ic_packing_pedido] CHAR (1) NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Parametro_Pedido_Importacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

