CREATE TABLE [dbo].[Fluxo_Caixa] (
    [CODCONTA]  INT          NULL,
    [SUMARIZAR] CHAR (1)     NULL,
    [TIPO]      INT          NULL,
    [CODIGO]    INT          NULL,
    [GRUPO]     VARCHAR (40) NULL,
    [CONTA]     VARCHAR (50) NULL,
    [INICIAL]   FLOAT (53)   NULL,
    [1]         FLOAT (53)   NULL,
    [2]         FLOAT (53)   NULL,
    [3]         FLOAT (53)   NULL,
    [4]         FLOAT (53)   NULL,
    [5]         FLOAT (53)   NULL,
    [6/7/8]     FLOAT (53)   NULL,
    [9]         FLOAT (53)   NULL,
    [10]        FLOAT (53)   NULL,
    [11]        FLOAT (53)   NULL,
    [12]        FLOAT (53)   NULL,
    [13/14/15]  FLOAT (53)   NULL,
    [16]        FLOAT (53)   NULL,
    [17]        FLOAT (53)   NULL,
    [18]        FLOAT (53)   NULL,
    [19]        FLOAT (53)   NULL,
    [20/21/22]  FLOAT (53)   NULL,
    [23]        FLOAT (53)   NULL,
    [24]        FLOAT (53)   NULL,
    [25]        FLOAT (53)   NULL,
    [26]        FLOAT (53)   NULL,
    [27/28/29]  FLOAT (53)   NULL,
    [30]        FLOAT (53)   NULL,
    [31]        FLOAT (53)   NULL,
    [TOTAL]     FLOAT (53)   NULL,
    [PERC]      FLOAT (53)   NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_Fluxo_Caixa]
    ON [dbo].[Fluxo_Caixa]([CODCONTA] ASC) WITH (FILLFACTOR = 90);

