CREATE TABLE [dbo].[Projeto_Material] (
    [cd_projeto]              INT          NULL,
    [cd_item_projeto]         INT          NULL,
    [cd_projeto_material]     INT          NOT NULL,
    [cd_desenho_projeto]      INT          NULL,
    [cd_produto]              INT          NULL,
    [qt_projeto_material]     FLOAT (53)   NULL,
    [nm_projeto_material]     VARCHAR (40) NULL,
    [nm_obs_projeto_material] VARCHAR (40) NULL,
    [ds_projeto_material]     TEXT         NULL,
    [ic_fabricado_projeto]    CHAR (1)     NULL,
    [cd_fornecedor]           INT          NULL,
    [cd_requisicao_compra]    INT          NULL,
    [cd_materia_prima]        INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Material] PRIMARY KEY CLUSTERED ([cd_projeto_material] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Material_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]),
    CONSTRAINT [FK_Projeto_Material_Materia_Prima] FOREIGN KEY ([cd_materia_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima]),
    CONSTRAINT [FK_Projeto_Material_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto]),
    CONSTRAINT [FK_Projeto_Material_Projeto] FOREIGN KEY ([cd_projeto]) REFERENCES [dbo].[Projeto] ([cd_projeto])
);

