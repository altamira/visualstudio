CREATE TABLE [dbo].[Requisicao_Compra_Fornecedor] (
    [cd_requisicao_compra]      INT          NOT NULL,
    [cd_item_req_fornecedor]    INT          NOT NULL,
    [cd_fornecedor]             INT          NULL,
    [nm_compra_fornecedor]      VARCHAR (40) NULL,
    [cd_ddd_compra_fornecedor]  VARCHAR (4)  NULL,
    [cd_fone_compra_fornecedor] VARCHAR (15) NULL,
    [ic_compra_fornecedor]      CHAR (1)     NULL,
    [nm_obs_compra_fornecedor]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_contato_fornecedor]     INT          NULL,
    [cd_ddi_compra_fornecedor]  VARCHAR (4)  NULL,
    [nm_contato_fornecedor]     VARCHAR (40) NULL,
    CONSTRAINT [PK_Requisicao_Compra_Fornecedor] PRIMARY KEY CLUSTERED ([cd_requisicao_compra] ASC, [cd_item_req_fornecedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Compra_Fornecedor_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

