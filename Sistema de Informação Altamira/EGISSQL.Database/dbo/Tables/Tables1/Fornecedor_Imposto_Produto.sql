CREATE TABLE [dbo].[Fornecedor_Imposto_Produto] (
    [cd_fornecedor]             INT          NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [cd_classificacao_fiscal]   INT          NOT NULL,
    [pc_ipi_fornecedor_prod]    FLOAT (53)   NULL,
    [pc_icms_fornecedor_prod]   FLOAT (53)   NULL,
    [ic_credipi_forne_prod]     CHAR (1)     NULL,
    [pc_credipi_forne_prod]     FLOAT (53)   NULL,
    [nm_obs_fornecedor_produto] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Imposto_Produto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_produto] ASC, [cd_classificacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);

