CREATE TABLE [dbo].[prcprdfat] (
    [Prcprdcab_descricao]    NVARCHAR (20) NOT NULL,
    [Produto]                NVARCHAR (20) NOT NULL,
    [Sigla_Cor]              NVARCHAR (10) NOT NULL,
    [variavel]               NVARCHAR (50) NOT NULL,
    [Preco]                  FLOAT (53)    NULL,
    [PRCPRD_ADICIONAL]       FLOAT (53)    NULL,
    [LP_PRCPRD_COMPRIMENTO]  FLOAT (53)    NULL,
    [LP_PRCPRD_ALTURA]       FLOAT (53)    NULL,
    [LP_PRCPRD_PROFUNDIDADE] FLOAT (53)    NULL,
    CONSTRAINT [PK_prcprdfat] PRIMARY KEY CLUSTERED ([Prcprdcab_descricao] ASC, [Produto] ASC, [Sigla_Cor] ASC, [variavel] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_prcprdfat]
    ON [dbo].[prcprdfat]([Prcprdcab_descricao] ASC, [Sigla_Cor] ASC, [variavel] ASC);

