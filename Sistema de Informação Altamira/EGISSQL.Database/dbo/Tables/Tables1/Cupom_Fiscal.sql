CREATE TABLE [dbo].[Cupom_Fiscal] (
    [cd_cupom_fiscal]   INT      NOT NULL,
    [dt_cupom_fiscal]   DATETIME NULL,
    [cd_operador_caixa] INT      NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    [cd_vendedor]       INT      NULL,
    CONSTRAINT [PK_Cupom_Fiscal] PRIMARY KEY CLUSTERED ([cd_cupom_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cupom_Fiscal_Operador_Caixa] FOREIGN KEY ([cd_operador_caixa]) REFERENCES [dbo].[Operador_Caixa] ([cd_operador_caixa]),
    CONSTRAINT [FK_Cupom_Fiscal_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

