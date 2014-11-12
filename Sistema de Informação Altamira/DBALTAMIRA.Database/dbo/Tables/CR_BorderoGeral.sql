CREATE TABLE [dbo].[CR_BorderoGeral] (
    [crbg_Codigo]      CHAR (3)      NOT NULL,
    [crbg_Banco]       CHAR (15)     NOT NULL,
    [crbg_Taxa]        CHAR (6)      NOT NULL,
    [crbg_Valor]       CHAR (16)     NULL,
    [crbg_Juros]       CHAR (16)     NULL,
    [crbg_IOF]         CHAR (16)     NULL,
    [crbg_Custos]      CHAR (16)     NULL,
    [crbg_Liquido]     CHAR (16)     NULL,
    [crbg_TotalDup]    CHAR (16)     NULL,
    [crbg_MediaDias]   REAL          NULL,
    [crbg_DataCalculo] SMALLDATETIME NOT NULL,
    [crbg_Lock]        BINARY (8)    NULL,
    CONSTRAINT [PK_CR_BorderoGeral] PRIMARY KEY NONCLUSTERED ([crbg_Codigo] ASC, [crbg_Taxa] ASC, [crbg_DataCalculo] ASC) WITH (FILLFACTOR = 90)
);

