CREATE TABLE [dbo].[Produto_Desenho] (
    [cd_produto]              INT           NOT NULL,
    [cd_tipo_desenho]         INT           NOT NULL,
    [nm_ref_produto_desenho]  VARCHAR (25)  NULL,
    [dt_produto_desenho]      DATETIME      NULL,
    [nm_doc_produto_desenho]  VARCHAR (100) NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_fabricacao_produto]   VARCHAR (30)  NULL,
    [cd_projetista]           INT           NULL,
    [cd_desenho_item_produto] VARCHAR (30)  NULL,
    [cd_rev_des_item_produto] VARCHAR (5)   NULL,
    CONSTRAINT [PK_Produto_Desenho] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_tipo_desenho] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Desenho_Projetista] FOREIGN KEY ([cd_projetista]) REFERENCES [dbo].[Projetista] ([cd_projetista]),
    CONSTRAINT [FK_Produto_Desenho_Tipo_Desenho_Produto] FOREIGN KEY ([cd_tipo_desenho]) REFERENCES [dbo].[Tipo_Desenho_Produto] ([cd_tipo_desenho])
);

