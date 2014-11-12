CREATE TABLE [dbo].[Produto_Quimico] (
    [cd_produto_quimico]        INT           NOT NULL,
    [cd_produto]                INT           NOT NULL,
    [cd_fornecedor]             INT           NULL,
    [cd_fabricante]             INT           NULL,
    [cd_dcb_produto]            VARCHAR (30)  NULL,
    [cd_dci_produto]            VARCHAR (30)  NULL,
    [cd_cas_produto]            VARCHAR (100) NULL,
    [nm_obs_produto_quimico]    VARCHAR (40)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_insumo_produto_quimico] CHAR (1)      NULL,
    CONSTRAINT [PK_Produto_Quimico] PRIMARY KEY CLUSTERED ([cd_produto_quimico] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Quimico_Fabricante] FOREIGN KEY ([cd_fabricante]) REFERENCES [dbo].[Fabricante] ([cd_fabricante])
);

