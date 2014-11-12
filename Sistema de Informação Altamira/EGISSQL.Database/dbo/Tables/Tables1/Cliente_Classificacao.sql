CREATE TABLE [dbo].[Cliente_Classificacao] (
    [cd_cliente]               INT        NOT NULL,
    [cd_ano]                   INT        NOT NULL,
    [qt_cliente_classificacao] INT        NULL,
    [vl_total_venda_cliente]   FLOAT (53) NULL,
    [vl_consulta_cliente]      FLOAT (53) NULL,
    [vl_lucro_cliente]         FLOAT (53) NULL,
    [vl_margem_cliente]        FLOAT (53) NULL,
    [pc_venda_cliente]         FLOAT (53) NULL,
    [pc_faturamento_cliente]   FLOAT (53) NULL,
    [pc_lucro_cliente]         FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_classificacao_cliente] INT        NULL,
    CONSTRAINT [FK_Cliente_Classificacao_Classificacao_Cliente] FOREIGN KEY ([cd_classificacao_cliente]) REFERENCES [dbo].[Classificacao_Cliente] ([cd_classificacao_cliente])
);

