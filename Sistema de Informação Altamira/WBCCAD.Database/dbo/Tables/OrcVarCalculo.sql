CREATE TABLE [dbo].[OrcVarCalculo] (
    [idOrcVarCalculo] INT            IDENTITY (1, 1) NOT NULL,
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [Chave]           NVARCHAR (MAX) NULL,
    [Valor]           MONEY          NULL,
    [ChaveImpressao]  NVARCHAR (MAX) NULL,
    [DistribuirValor] BIT            NULL,
    [Servico]         BIT            NULL,
    CONSTRAINT [PK_OrcVarCalculo] PRIMARY KEY CLUSTERED ([idOrcVarCalculo] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcVarCalculo]
    ON [dbo].[OrcVarCalculo]([numeroOrcamento] ASC, [idOrcVarCalculo] ASC);

