CREATE TABLE [dbo].[Produto_Concorrente] (
    [cd_produto_concorrente]    VARCHAR (30) NOT NULL,
    [cd_concorrente]            INT          NOT NULL,
    [cd_grupo_produto]          INT          NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_produto]                INT          NULL,
    [vl_produto_concorrente]    FLOAT (53)   NULL,
    [nm_fantasia_prod_concorre] VARCHAR (30) NULL,
    [nm_produto_concorrente]    VARCHAR (50) NULL,
    [ds_produto_concorrente]    TEXT         NULL,
    [nm_marca_prod_concorre]    VARCHAR (30) NULL,
    [vl_custo_produto_concorre] FLOAT (53)   NULL,
    [cd_unidade_medida]         INT          NULL,
    [cd_status_produto]         INT          NULL,
    CONSTRAINT [PK_Produto_Concorrente] PRIMARY KEY CLUSTERED ([cd_produto_concorrente] ASC, [cd_concorrente] ASC) WITH (FILLFACTOR = 90)
);

