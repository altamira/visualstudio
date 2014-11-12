CREATE TABLE [dbo].[PRE_ProgramaçãoExplosão] (
    [prex_ORCNUM] CHAR (8)      NOT NULL,
    [prex_PRDCOD] VARCHAR (35)  NOT NULL,
    [prex_ORCITM] INT           NOT NULL,
    [prex_ORCQTD] FLOAT (53)    NULL,
    [prex_PRDDSC] VARCHAR (300) NULL,
    [prex_CORCOD] VARCHAR (50)  NOT NULL,
    [prex_ORCPES] FLOAT (53)    NULL,
    CONSTRAINT [PK_PRE_ProgramaçãoExplosão] PRIMARY KEY NONCLUSTERED ([prex_ORCNUM] ASC, [prex_PRDCOD] ASC, [prex_ORCITM] ASC, [prex_CORCOD] ASC) WITH (FILLFACTOR = 90)
);

