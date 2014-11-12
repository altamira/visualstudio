CREATE TABLE [dbo].[Produto_Grade_Preco] (
    [cd_produto]             INT        NOT NULL,
    [cd_produto_grade]       INT        NOT NULL,
    [vl_produto_grade]       FLOAT (53) NULL,
    [vl_custo_produto_grade] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Produto_Grade_Preco] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_grade] ASC) WITH (FILLFACTOR = 90)
);

