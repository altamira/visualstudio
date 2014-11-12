CREATE TABLE [dbo].[Despesa_Padrao_comex_item] (
    [cd_despesa_padrao_comex]   INT      NOT NULL,
    [cd_item_despesa_padrao]    INT      NOT NULL,
    [cd_tipo_despesa_comex]     INT      NOT NULL,
    [ic_ii_despesa_pad_comex]   CHAR (1) NULL,
    [ic_ipi_despesa_pad_comex]  CHAR (1) NULL,
    [ic_icms_despesa_pad_comex] CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Despesa_Padrao_comex_item] PRIMARY KEY CLUSTERED ([cd_despesa_padrao_comex] ASC, [cd_item_despesa_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Despesa_Padrao_comex_item_Tipo_Despesa_Comex] FOREIGN KEY ([cd_tipo_despesa_comex]) REFERENCES [dbo].[Tipo_Despesa_Comex] ([cd_tipo_despesa_comex])
);

