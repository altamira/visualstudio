CREATE TABLE [dbo].[Produto_Desenho_Revisao] (
    [cd_produto]                 INT           NOT NULL,
    [cd_item_produto_revisao]    INT           NOT NULL,
    [cd_tipo_revisao_desenho]    INT           NULL,
    [dt_revisao_produto]         DATETIME      NULL,
    [cd_projetista]              INT           NULL,
    [nm_desenho_produto_revisao] VARCHAR (50)  NULL,
    [nm_caminho_desenho]         VARCHAR (100) NULL,
    [nm_obs_produto_revisao]     VARCHAR (40)  NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [cd_rev_des_item_produto]    VARCHAR (5)   NULL,
    CONSTRAINT [PK_Produto_Desenho_Revisao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_item_produto_revisao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Desenho_Revisao_Projetista] FOREIGN KEY ([cd_projetista]) REFERENCES [dbo].[Projetista] ([cd_projetista])
);

