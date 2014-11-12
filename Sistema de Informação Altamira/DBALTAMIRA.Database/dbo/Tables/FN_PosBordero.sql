CREATE TABLE [dbo].[FN_PosBordero] (
    [fnpb_NotaFiscal]      INT           NOT NULL,
    [fnpb_TipoN]           CHAR (1)      NOT NULL,
    [fnpb_Parcela]         SMALLINT      NOT NULL,
    [fnpb_DataVencimento]  SMALLDATETIME NULL,
    [fnpb_DataProrrogacao] SMALLDATETIME NULL,
    [fnpb_ValorTotal]      MONEY         NULL,
    [fnpb_Cliente]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_FN_PosBordero] PRIMARY KEY NONCLUSTERED ([fnpb_NotaFiscal] ASC, [fnpb_TipoN] ASC, [fnpb_Parcela] ASC) WITH (FILLFACTOR = 90)
);

