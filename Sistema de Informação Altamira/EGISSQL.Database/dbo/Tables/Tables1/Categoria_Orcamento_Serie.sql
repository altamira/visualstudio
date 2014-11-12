CREATE TABLE [dbo].[Categoria_Orcamento_Serie] (
    [cd_categoria_orcamento]    INT        NOT NULL,
    [cd_serie_produto]          INT        NOT NULL,
    [pc_reducao_calc_orcamento] FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Categoria_Orcamento_Serie] PRIMARY KEY CLUSTERED ([cd_categoria_orcamento] ASC, [cd_serie_produto] ASC) WITH (FILLFACTOR = 90)
);

