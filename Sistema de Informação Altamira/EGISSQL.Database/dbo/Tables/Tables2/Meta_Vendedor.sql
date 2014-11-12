CREATE TABLE [dbo].[Meta_Vendedor] (
    [cd_meta_vendedor]         INT        NOT NULL,
    [cd_vendedor]              INT        NOT NULL,
    [cd_categoria_produto]     INT        NOT NULL,
    [vl_meta_categoria]        FLOAT (53) NULL,
    [dt_inicial_validade_meta] DATETIME   NULL,
    [dt_final_validade_meta]   DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Meta_Vendedor] PRIMARY KEY CLUSTERED ([cd_meta_vendedor] ASC, [cd_vendedor] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

