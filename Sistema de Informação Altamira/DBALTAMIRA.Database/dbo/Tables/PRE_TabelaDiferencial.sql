CREATE TABLE [dbo].[PRE_TabelaDiferencial] (
    [tab_NumeroTabela]  VARCHAR (10)  NOT NULL,
    [tab_DataTabela]    SMALLDATETIME NULL,
    [tab_TabelaAtiva]   VARCHAR (1)   NULL,
    [tab_CodProduto]    VARCHAR (20)  NOT NULL,
    [tab_Unidade]       VARCHAR (4)   NULL,
    [tab_Familia]       CHAR (10)     NULL,
    [tab_ForCNPJ]       VARCHAR (16)  NULL,
    [tab_ForAbreviado]  VARCHAR (30)  NULL,
    [tab_Contribuinte]  CHAR (1)      NULL,
    [tab_PrecoMedio]    MONEY         NULL,
    [tab_PrecoBasicoSI] MONEY         NULL,
    [tab_ICMS]          VARCHAR (5)   NULL,
    [tab_PIS]           FLOAT (53)    NULL,
    [tab_COFINS]        FLOAT (53)    NULL,
    [tab_PrazoMedio]    FLOAT (53)    NULL,
    [tab_OutrosI]       FLOAT (53)    NULL,
    [tab_IPI]           FLOAT (53)    NULL,
    [tab_OutrosNI]      FLOAT (53)    NULL,
    [tab_Estado]        CHAR (2)      NULL,
    [tab_isento]        INT           NULL
);

