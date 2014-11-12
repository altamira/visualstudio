CREATE TABLE [dbo].[ORCPRCVAR] (
    [idOrcPrcVar]     INT            IDENTITY (1, 1) NOT NULL,
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [VARIAVEL]        NVARCHAR (50)  NULL,
    [PRODUTO]         NVARCHAR (100) NULL,
    [COR]             NVARCHAR (20)  NULL,
    [PRECO]           MONEY          NULL,
    [LISTA]           MONEY          NULL,
    [ADICIONAL]       MONEY          NULL,
    [COMPRIMENTO]     MONEY          NULL,
    [ALTURA]          MONEY          NULL,
    [PROFUNDIDADE]    MONEY          NULL,
    CONSTRAINT [PK_OrcPrcVar] PRIMARY KEY CLUSTERED ([idOrcPrcVar] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ORCPRCVAR]
    ON [dbo].[ORCPRCVAR]([numeroOrcamento] ASC, [idOrcPrcVar] ASC);

