CREATE TABLE [dbo].[PRE_OrcaSelecSituação] (
    [prsi_Orçamento]    INT           NOT NULL,
    [prsi_Situação]     SMALLINT      NOT NULL,
    [prsi_DataSituação] SMALLDATETIME NULL,
    [prsi_DataPrevisão] SMALLDATETIME NULL,
    [prsi_Projetista]   VARCHAR (50)  NULL,
    [prsi_Observação]   TEXT          NULL,
    CONSTRAINT [PK_PRE_OrcaSituação] PRIMARY KEY NONCLUSTERED ([prsi_Orçamento] ASC, [prsi_Situação] ASC) WITH (FILLFACTOR = 90)
);

