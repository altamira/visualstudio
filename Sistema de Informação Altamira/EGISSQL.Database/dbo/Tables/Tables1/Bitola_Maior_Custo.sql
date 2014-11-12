CREATE TABLE [dbo].[Bitola_Maior_Custo] (
    [cd_bitola]               INT        NOT NULL,
    [dt_maior_custo]          DATETIME   NULL,
    [cd_fornecedor]           INT        NULL,
    [cd_nota_entrada]         INT        NULL,
    [dt_nota_entrada]         DATETIME   NULL,
    [vl_maior_custo_anterior] FLOAT (53) NULL,
    [vl_maior_custo_periodo]  FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Bitola_Maior_Custo] PRIMARY KEY CLUSTERED ([cd_bitola] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Bitola_Maior_Custo_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

