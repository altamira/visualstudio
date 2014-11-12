CREATE TABLE [dbo].[Produto_Custo_Item_Temporario] (
    [cd_calculo_temporario] INT        NOT NULL,
    [cd_produto]            INT        NOT NULL,
    [vl_custo_calculado]    FLOAT (53) NULL,
    [ic_inconsistencia]     CHAR (1)   NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [vl_preco_calculado]    FLOAT (53) NULL,
    CONSTRAINT [PK_Produto_Custo_Item_Temporario] PRIMARY KEY CLUSTERED ([cd_calculo_temporario] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Custo_Item_Temporario_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

