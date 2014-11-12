CREATE TABLE [dbo].[VE_Carros] (
    [veca_Placa]             CHAR (10)    NOT NULL,
    [veca_Abreviado]         CHAR (15)    NULL,
    [veca_DescriçãoCompleta] VARCHAR (50) NULL,
    CONSTRAINT [PK_VE_Carros] PRIMARY KEY NONCLUSTERED ([veca_Placa] ASC) WITH (FILLFACTOR = 90)
);

