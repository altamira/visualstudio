CREATE TABLE [dbo].[PRE_Projetistas] (
    [prpr_Codigo] SMALLINT     NOT NULL,
    [prpr_Nome]   VARCHAR (50) NULL,
    CONSTRAINT [PK_PRE_Projetistas] PRIMARY KEY NONCLUSTERED ([prpr_Codigo] ASC) WITH (FILLFACTOR = 90)
);

