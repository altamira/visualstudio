CREATE TABLE [dbo].[Vendedor_Parametro] (
    [cd_vendedor]              INT        NOT NULL,
    [pc_emissao_nota_comissao] FLOAT (53) NULL,
    [pc_baixa_comissao]        FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [pc_red_comissao_vendedor] FLOAT (53) NULL,
    CONSTRAINT [PK_Vendedor_Parametro] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Parametro_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

