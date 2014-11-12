CREATE TABLE [dbo].[RH_HistFolha] (
    [prfo_MesAno] CHAR (6) NOT NULL,
    [prfo_Folha]  MONEY    NULL,
    CONSTRAINT [PK_RH_HistFolha] PRIMARY KEY NONCLUSTERED ([prfo_MesAno] ASC) WITH (FILLFACTOR = 90)
);

