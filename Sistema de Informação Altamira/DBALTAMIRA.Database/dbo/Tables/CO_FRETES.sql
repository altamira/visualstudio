CREATE TABLE [dbo].[CO_FRETES] (
    [cofr_Numero]     INT          NOT NULL,
    [cofr_CodTrans]   CHAR (14)    NOT NULL,
    [cofr_Item]       INT          NOT NULL,
    [cofr_NomeTrans]  VARCHAR (50) NULL,
    [cofr_Telefone]   CHAR (30)    NULL,
    [cofr_Contato]    CHAR (50)    NULL,
    [cofr_CondPagto]  VARCHAR (50) NULL,
    [cofr_ValorFrete] REAL         NULL,
    [cofr_PorcFrete]  REAL         NULL,
    [cofr_Status]     CHAR (1)     NULL,
    CONSTRAINT [PK_CO_FRETES] PRIMARY KEY NONCLUSTERED ([cofr_Numero] ASC, [cofr_CodTrans] ASC, [cofr_Item] ASC) WITH (FILLFACTOR = 90)
);

