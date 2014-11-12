CREATE TABLE [dbo].[CR_NotasFiscaisDetalhe] (
    [crnd_NotaFiscal]      INT           NOT NULL,
    [crnd_TipoNota]        CHAR (1)      NOT NULL,
    [crnd_Parcela]         SMALLINT      NOT NULL,
    [crnd_DataVencimento]  SMALLDATETIME NOT NULL,
    [crnd_DataPagamento]   SMALLDATETIME NULL,
    [crnd_DataProrrogacao] SMALLDATETIME NULL,
    [crnd_ValorParcela]    MONEY         NULL,
    [crnd_BaseCalculo]     MONEY         NULL,
    [crnd_ValorAcrescimo]  MONEY         NULL,
    [crnd_ValorDesconto]   MONEY         NULL,
    [crnd_ValorTotal]      MONEY         NULL,
    [crnd_TipoFaturamento] CHAR (1)      NULL,
    [crnd_Banco]           CHAR (3)      NULL,
    [crnd_Agencia]         CHAR (10)     NULL,
    [crnd_Contrato]        CHAR (20)     NULL,
    [crnd_TipoOperacao]    CHAR (1)      NULL,
    [crnd_NumeroBancario]  CHAR (20)     NULL,
    [crnd_DiasFaturamento] NUMERIC (18)  NULL,
    [crnd_DataBaixaRepres] SMALLDATETIME NULL,
    [crnd_Observacao]      VARCHAR (60)  NULL,
    [crnd_CNPJ]            CHAR (14)     NOT NULL,
    [crnd_EmissaoNF]       SMALLDATETIME NULL,
    [crnd_Representante]   CHAR (3)      NULL,
    [crnd_Comissao]        REAL          NULL,
    [crnd_Pedido]          INT           NULL,
    [crnd_BaixaDoBanco]    SMALLDATETIME NULL,
    [crnd_CodInstrução]    TINYINT       NULL,
    [crnd_ObsInstrução]    VARCHAR (250) NULL,
    [crnd_Baixado]         CHAR (1)      NULL,
    [crnd_Lock]            BINARY (8)    NULL,
    CONSTRAINT [PK_CR_NotasFiscaisDetalhe] PRIMARY KEY NONCLUSTERED ([crnd_NotaFiscal] ASC, [crnd_TipoNota] ASC, [crnd_Parcela] ASC, [crnd_DataVencimento] ASC, [crnd_CNPJ] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_CR_NotasFiscaisDetalhe]
    ON [dbo].[CR_NotasFiscaisDetalhe]([crnd_CNPJ] ASC) WITH (FILLFACTOR = 90);

