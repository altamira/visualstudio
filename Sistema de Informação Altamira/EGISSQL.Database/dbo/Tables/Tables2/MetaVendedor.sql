CREATE TABLE [dbo].[MetaVendedor] (
    [cd_vendedor]              INT        NOT NULL,
    [cd_categoria_produto]     CHAR (10)  NOT NULL,
    [vl_meta_categoria]        FLOAT (53) NULL,
    [dt_inicial_validade_meta] DATETIME   NULL,
    [dt_final_validade_meta]   DATETIME   NULL,
    CONSTRAINT [PK_MetaVendedor] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

