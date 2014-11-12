CREATE TABLE [dbo].[Pedido_Importacao_Proforma] (
    [cd_pedido_importacao]      INT          NOT NULL,
    [cd_proforma_pedido_import] INT          NOT NULL,
    [nm_proforma_pedido_import] VARCHAR (36) NOT NULL,
    [dt_proforma_pedido_import] DATETIME     NOT NULL,
    [dt_receb_proforma_pedido]  DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Pedido_Importacao_Proforma] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_proforma_pedido_import] ASC) WITH (FILLFACTOR = 90)
);

