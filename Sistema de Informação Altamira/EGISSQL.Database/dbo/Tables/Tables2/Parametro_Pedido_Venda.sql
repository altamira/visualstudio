CREATE TABLE [dbo].[Parametro_Pedido_Venda] (
    [cd_empresa]     INT      NOT NULL,
    [ic_fator_custo] CHAR (1) NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_Parametro_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

