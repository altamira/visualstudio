CREATE TABLE [dbo].[MetaCategoria] (
    [dt_inicial_validade_meta]    DATETIME   NOT NULL,
    [dt_final_validade_meta]      DATETIME   NOT NULL,
    [cd_categoria_produto]        CHAR (10)  NOT NULL,
    [vl_meta_categoria_produto]   FLOAT (53) NULL,
    [vl_meta_faturamento_produto] FLOAT (53) NULL,
    CONSTRAINT [PK_MetaCategoria] PRIMARY KEY CLUSTERED ([dt_inicial_validade_meta] ASC, [dt_final_validade_meta] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

