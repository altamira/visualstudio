CREATE TABLE [dbo].[FA_Textos] (
    [fatx_Codigo] SMALLINT     NOT NULL,
    [fatx_Texto]  VARCHAR (53) NULL,
    [fatx_ICMS]   VARCHAR (10) NULL,
    CONSTRAINT [PK_FA_Textos] PRIMARY KEY NONCLUSTERED ([fatx_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_FA_Textos]
    ON [dbo].[FA_Textos]([fatx_Texto] ASC) WITH (FILLFACTOR = 90);

