CREATE TABLE [dbo].[CP_DespesaImpostoDetalhe] (
    [cpdd_Sequencia]       INT           NOT NULL,
    [cpdd_Parcela]         SMALLINT      NOT NULL,
    [cpdd_DataVencimento]  SMALLDATETIME CONSTRAINT [DF_CP_DespesaImpostoDetalhe_cpdd_DataVencimento] DEFAULT (NULL) NULL,
    [cpdd_DataProrrogacao] SMALLDATETIME CONSTRAINT [DF_CP_DespesaImpostoDetalhe_cpdd_DataProrrogacao] DEFAULT (NULL) NULL,
    [cpdd_Valor]           MONEY         NOT NULL,
    [cpdd_ValorAcrescimo]  MONEY         NOT NULL,
    [cpdd_ValorDesconto]   MONEY         NOT NULL,
    [cpdd_ValorTotal]      MONEY         NOT NULL,
    [cpdd_NumeroCheque]    CHAR (15)     NULL,
    [cpdd_BancoCheque]     CHAR (3)      NOT NULL,
    [cpdd_CopiaCheque]     INT           NULL,
    [cpdd_DataPagamento]   SMALLDATETIME CONSTRAINT [DF_CP_DespesaImpostoDetalhe_cpdd_DataPagamento] DEFAULT (NULL) NULL,
    [cpdd_BancoPagamento]  CHAR (3)      NOT NULL,
    [cpdd_DataPreDatado]   SMALLDATETIME CONSTRAINT [DF_CP_DespesaImpostoDetalhe_cpdd_DataPreDatado] DEFAULT (NULL) NULL,
    [cpdd_Grupo]           TINYINT       NOT NULL,
    [cpdd_Destinacao]      TINYINT       NOT NULL,
    [cpdd_Observacao]      VARCHAR (50)  NULL,
    [cpdd_NumeroOP]        INT           NULL,
    [cpdd_DataOP]          SMALLDATETIME CONSTRAINT [DF_CP_DespesaImpostoDetalhe_cpdd_DataOP] DEFAULT (NULL) NULL,
    [cpdd_Valida]          SMALLINT      NULL,
    [cpdd_Lock]            BINARY (10)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_CP_DespesaImpostoDetalhe]
    ON [dbo].[CP_DespesaImpostoDetalhe]([cpdd_DataVencimento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_CP_DespesaImpostoDetalhe_1]
    ON [dbo].[CP_DespesaImpostoDetalhe]([cpdd_DataProrrogacao] ASC) WITH (FILLFACTOR = 90);

