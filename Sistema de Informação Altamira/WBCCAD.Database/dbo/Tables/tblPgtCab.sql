CREATE TABLE [dbo].[tblPgtCab] (
    [descricao]            NVARCHAR (100) NULL,
    [Fator]                FLOAT (53)     NULL,
    [codigo]               NVARCHAR (50)  NULL,
    [PGTCAB_CANAL_VENDA]   NVARCHAR (20)  NULL,
    [PGTCAB_VALOR_MINIMO]  MONEY          NULL,
    [PGTCAB_VALOR_MAXIMO]  MONEY          NULL,
    [PGTCAB_INTEGRACAO]    NVARCHAR (20)  NULL,
    [PGTCAB_PARCELAS]      INT            NULL,
    [PGTCAB_TX_FINANCEIRA] MONEY          NULL,
    [PGTCAB_FLAG_ESPECIAL] BIT            NULL,
    [PGTCAB_PRIMEIRA]      MONEY          NULL,
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [condicaoPagamento]    NVARCHAR (MAX) NULL
);

