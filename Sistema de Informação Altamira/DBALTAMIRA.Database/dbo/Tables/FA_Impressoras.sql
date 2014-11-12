CREATE TABLE [dbo].[FA_Impressoras] (
    [faim_NomeImpressora] CHAR (40)  NOT NULL,
    [faim_Dispositivo]    CHAR (100) NULL,
    [faim_Padrao]         CHAR (1)   NULL,
    [faim_Descricao]      CHAR (40)  NULL,
    [faim_lock]           BINARY (8) NULL,
    CONSTRAINT [PK_FA_Impressoras] PRIMARY KEY NONCLUSTERED ([faim_NomeImpressora] ASC) WITH (FILLFACTOR = 90)
);

