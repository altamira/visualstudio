CREATE TABLE [dbo].[CO_BaixaMontagem] (
    [coba_Baixa]          INT           NOT NULL,
    [coba_Pedido]         INT           NOT NULL,
    [coba_ValorVenda]     MONEY         NULL,
    [coba_ValorAltamira]  MONEY         NULL,
    [coba_CodMontadora]   MONEY         NULL,
    [coba_Montadora]      VARCHAR (50)  NULL,
    [coba_ValorMontadora] MONEY         NULL,
    [coba_DataPendente]   SMALLDATETIME NULL,
    [coba_DataDaBaixa]    SMALLDATETIME NULL,
    [coba_Status]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_CO_BaixaMontagem] PRIMARY KEY NONCLUSTERED ([coba_Baixa] ASC, [coba_Pedido] ASC) WITH (FILLFACTOR = 90)
);

