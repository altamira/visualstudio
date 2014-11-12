CREATE TABLE [dbo].[CADMSGGMPS] (
    [codgpms]   DECIMAL (18) NOT NULL,
    [GpmsUsu]   CHAR (20)    NULL,
    [GpmsMsg]   CHAR (999)   NULL,
    [GpmsRemet] CHAR (20)    NULL,
    PRIMARY KEY CLUSTERED ([codgpms] ASC)
);


GO
CREATE NONCLUSTERED INDEX [UCADMSGGMPSA]
    ON [dbo].[CADMSGGMPS]([GpmsUsu] ASC, [codgpms] ASC);


GO
CREATE NONCLUSTERED INDEX [UCADMSGGMPSB]
    ON [dbo].[CADMSGGMPS]([GpmsUsu] ASC, [codgpms] DESC);

