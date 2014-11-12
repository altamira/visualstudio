CREATE TABLE [dbo].[Grupo_Preco_Produto] (
    [cd_grupo_preco_produto] INT          NOT NULL,
    [nm_grupo_preco_produto] VARCHAR (30) NULL,
    [sg_grupo_preco_produto] CHAR (10)    NULL,
    [cd_mascara_grupo_preco] VARCHAR (20) NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [cd_tipo_lucro]          INT          NULL,
    CONSTRAINT [PK_Grupo_Preco_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_preco_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Preco_Produto_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);

