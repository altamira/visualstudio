CREATE TABLE [dbo].[Previa_Faturamento] (
    [cd_previa_faturamento]     INT          NOT NULL,
    [dt_previa_faturamento]     DATETIME     NULL,
    [qt_pedido_previa_faturam]  FLOAT (53)   NULL,
    [vl_pedido_previa_faturam]  FLOAT (53)   NULL,
    [ds_pedido_previa_faturam]  TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [vl_previa_faturamento]     FLOAT (53)   NULL,
    [nm_previa_faturamento]     VARCHAR (40) NULL,
    [ic_fatura_previa_faturam]  CHAR (1)     NULL,
    [cd_previa_anterior_sap]    INT          NULL,
    [qt_pedido_previa_faturame] FLOAT (53)   NULL,
    [vl_pedido_previa_faturame] FLOAT (53)   NULL,
    [ic_previa_imediato]        CHAR (1)     NULL,
    CONSTRAINT [PK_Previa_Faturamento] PRIMARY KEY CLUSTERED ([cd_previa_faturamento] ASC) WITH (FILLFACTOR = 90)
);

