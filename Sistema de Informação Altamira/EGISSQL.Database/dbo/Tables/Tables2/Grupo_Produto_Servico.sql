CREATE TABLE [dbo].[Grupo_Produto_Servico] (
    [cd_grupo_produto]         INT          NOT NULL,
    [nm_grupo_produto_servico] VARCHAR (30) NOT NULL,
    [ds_grupo_produto_servico] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Servico] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);

