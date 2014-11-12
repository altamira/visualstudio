CREATE TABLE [dbo].[Fax_Cli] (
    [cd_cliente]         INT      NOT NULL,
    [ic_fax_transmitido] CHAR (1) NULL,
    CONSTRAINT [PK_Fax_Cli] PRIMARY KEY NONCLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90)
);

