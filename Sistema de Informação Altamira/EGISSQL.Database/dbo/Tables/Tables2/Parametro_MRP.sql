CREATE TABLE [dbo].[Parametro_MRP] (
    [cd_empresa]                INT      NOT NULL,
    [ic_estoque_minimo]         CHAR (1) NULL,
    [ic_lote_fabricacao]        CHAR (1) NULL,
    [ic_consumo_mensal]         CHAR (1) NULL,
    [ic_composicao_produto_mrp] CHAR (1) NULL,
    [ic_processo_padrao_mrp]    CHAR (1) NULL,
    [ic_formula_produto_mrp]    CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_MRP] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

