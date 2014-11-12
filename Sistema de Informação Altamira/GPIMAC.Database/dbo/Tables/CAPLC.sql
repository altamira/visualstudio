CREATE TABLE [dbo].[CAPLC] (
    [Caplc0Cod]    CHAR (11)      NOT NULL,
    [Caplc0Nom]    CHAR (100)     NULL,
    [Caplc0Des]    VARCHAR (1000) NULL,
    [Caplc0Tip]    CHAR (1)       NULL,
    [CaPlc0Sel]    CHAR (1)       NULL,
    [CaPlC0SPlCod] CHAR (3)       NULL,
    [CaPlC0PlaCod] CHAR (3)       NULL,
    PRIMARY KEY CLUSTERED ([Caplc0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCAPLCA]
    ON [dbo].[CAPLC]([Caplc0Nom] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPLCB]
    ON [dbo].[CAPLC]([Caplc0Tip] ASC, [Caplc0Nom] ASC);


GO
CREATE NONCLUSTERED INDEX [UCAPLCC]
    ON [dbo].[CAPLC]([Caplc0Tip] ASC, [Caplc0Cod] ASC);

