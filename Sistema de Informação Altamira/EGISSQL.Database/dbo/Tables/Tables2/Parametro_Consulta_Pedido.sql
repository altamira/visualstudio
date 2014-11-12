CREATE TABLE [dbo].[Parametro_Consulta_Pedido] (
    [cd_empresa]         INT      NOT NULL,
    [ic_consignacao]     CHAR (1) NULL,
    [ic_cancelamento]    CHAR (1) NULL,
    [ic_faturamento]     CHAR (1) NULL,
    [ic_exportacao]      CHAR (1) NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    [ic_estoque_produto] CHAR (1) NULL,
    [ic_margem_venda]    CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Consulta_Pedido] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

