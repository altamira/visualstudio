CREATE TABLE [dbo].[PRE_ProcessosDeProdução] (
    [prpr_Codigo]    CHAR (7)     NOT NULL,
    [prpr_Sequencia] SMALLINT     NULL,
    [prpr_Descrição] VARCHAR (50) NULL,
    CONSTRAINT [PK_PRE_Processos] PRIMARY KEY NONCLUSTERED ([prpr_Codigo] ASC) WITH (FILLFACTOR = 90)
);

