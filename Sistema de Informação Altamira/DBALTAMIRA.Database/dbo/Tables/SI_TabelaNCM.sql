﻿CREATE TABLE [dbo].[SI_TabelaNCM] (
    [COD_NCM]  CHAR (8)      NOT NULL,
    [NOME_NCM] NVARCHAR (53) NULL,
    CONSTRAINT [PK_SI_TabelaNCM] PRIMARY KEY NONCLUSTERED ([COD_NCM] ASC) WITH (FILLFACTOR = 90)
);

