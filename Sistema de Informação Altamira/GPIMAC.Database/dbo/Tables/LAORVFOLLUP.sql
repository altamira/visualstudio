CREATE TABLE [dbo].[LAORVFOLLUP] (
    [Lo0Emp]    CHAR (2)       NOT NULL,
    [Lo0PED]    INT            NOT NULL,
    [Fu0Cod]    INT            NOT NULL,
    [Fu0Tip]    CHAR (3)       NULL,
    [Fu0Dat]    DATETIME       NULL,
    [Fu0Hor]    CHAR (8)       NULL,
    [Fu0CvCod]  CHAR (3)       NULL,
    [Fu0Des]    VARCHAR (5000) NULL,
    [Fu0DtH]    DATETIME       NULL,
    [Fu0Usu]    CHAR (20)      NULL,
    [Fu0Sta]    CHAR (20)      NULL,
    [Fu0StaMot] CHAR (50)      NULL,
    PRIMARY KEY CLUSTERED ([Lo0Emp] ASC, [Lo0PED] ASC, [Fu0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAORVFOLLUPB]
    ON [dbo].[LAORVFOLLUP]([Fu0CvCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAORVFOLLUPA]
    ON [dbo].[LAORVFOLLUP]([Fu0Dat] DESC, [Fu0Hor] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAORVFLLUPB]
    ON [dbo].[LAORVFOLLUP]([Lo0Emp] ASC, [Lo0PED] ASC, [Fu0Cod] DESC);

