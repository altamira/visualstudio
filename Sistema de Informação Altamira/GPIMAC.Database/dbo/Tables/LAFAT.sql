CREATE TABLE [dbo].[LAFAT] (
    [PV0EMP]      CHAR (2)       NOT NULL,
    [PV0NUM]      INT            NOT NULL,
    [PV0Tip]      CHAR (1)       NOT NULL,
    [PV0ENT]      CHAR (1)       NULL,
    [PV1GER]      CHAR (1)       NULL,
    [CCCGC]       CHAR (18)      NULL,
    [CCCRO]       CHAR (40)      NULL,
    [PV0SPE]      CHAR (15)      NULL,
    [PV0TIPVEN]   SMALLINT       NULL,
    [PV0CECOD]    CHAR (2)       NULL,
    [PV0CEICM]    SMALLMONEY     NULL,
    [PV0VEN]      CHAR (3)       NULL,
    [PV0DATPED]   DATETIME       NULL,
    [PV0DATENT]   DATETIME       NULL,
    [PV0DATPAG]   DATETIME       NULL,
    [COCOD]       CHAR (6)       NULL,
    [PV0TRA]      CHAR (5)       NULL,
    [PV0PAG]      CHAR (3)       NULL,
    [PV0EMPCOD]   CHAR (2)       NULL,
    [CACODI]      SMALLINT       NULL,
    [PV0FRE]      CHAR (1)       NULL,
    [PV0MOE]      CHAR (1)       NULL,
    [PV0PC0]      SMALLMONEY     NULL,
    [PV0PC1]      CHAR (1)       NULL,
    [PV0STA]      CHAR (1)       NULL,
    [PV0CON]      CHAR (20)      NULL,
    [PV0PBR]      MONEY          NULL,
    [PV0PLQ]      MONEY          NULL,
    [PV0QVO]      INT            NULL,
    [PV0ESP]      CHAR (20)      NULL,
    [PV1IPE]      CHAR (2)       NULL,
    [PV1NOT]      INT            NULL,
    [PV0PED]      INT            NULL,
    [PV0PSI]      CHAR (1)       NULL,
    [PV0DES]      SMALLMONEY     NULL,
    [PV0SUF]      SMALLMONEY     NULL,
    [PV0EST]      CHAR (1)       NULL,
    [PV0ELI]      CHAR (1)       NULL,
    [PV0EOB]      VARCHAR (200)  NULL,
    [PV0BAS]      SMALLMONEY     NULL,
    [PV0VFRE]     MONEY          NULL,
    [PV0BAN]      CHAR (3)       NULL,
    [PV0ULT]      INT            NULL,
    [PV0TIPI]     MONEY          NULL,
    [PV2TOT]      MONEY          NULL,
    [PV2ICM]      MONEY          NULL,
    [PV2ALI]      MONEY          NULL,
    [PV2CEM]      MONEY          NULL,
    [PV0ULTSEQ]   SMALLINT       NULL,
    [Pv0DatEmi]   DATETIME       NULL,
    [Pv0CPrS0Cod] INT            NULL,
    [Pv0PrSDes]   CHAR (30)      NULL,
    [Pv0ISSAli]   SMALLMONEY     NULL,
    [PV0RPSSit]   CHAR (1)       NULL,
    [Pv0ISSRet]   SMALLINT       NULL,
    [Pv0TotSer]   MONEY          NULL,
    [Pv0TotDed]   MONEY          NULL,
    [Pv0RPSDes]   VARCHAR (5000) NULL,
    [Pv0Obs]      VARCHAR (2000) NULL,
    [PV0NumOri]   INT            NULL,
    [PV0ComTip]   CHAR (1)       NULL,
    [Pv0SusIcm]   SMALLINT       NULL,
    [PV0GUI]      INT            NULL,
    [PV0OutDes]   MONEY          NULL,
    [PV0Seg]      MONEY          NULL,
    [CCEnd1Seq]   SMALLINT       NULL,
    [Pv0PedBai]   CHAR (1)       NULL,
    [PV0NVOL]     CHAR (50)      NULL,
    [PV0MAR]      CHAR (50)      NULL,
    PRIMARY KEY CLUSTERED ([PV0EMP] ASC, [PV0NUM] ASC, [PV0Tip] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAFATB]
    ON [dbo].[LAFAT]([PV0BAN] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATC]
    ON [dbo].[LAFAT]([PV0EMPCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATD]
    ON [dbo].[LAFAT]([PV0PAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATE]
    ON [dbo].[LAFAT]([PV0TRA] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATF]
    ON [dbo].[LAFAT]([PV0VEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATG]
    ON [dbo].[LAFAT]([PV0CECOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATH]
    ON [dbo].[LAFAT]([CACODI] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFATI]
    ON [dbo].[LAFAT]([COCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFAT2]
    ON [dbo].[LAFAT]([CCCGC] ASC, [CCEnd1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFATA]
    ON [dbo].[LAFAT]([PV0DATENT] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFATB]
    ON [dbo].[LAFAT]([PV0DATENT] DESC);


GO
CREATE NONCLUSTERED INDEX [ULAFATC]
    ON [dbo].[LAFAT]([PV0NUM] DESC, [PV0EMP] ASC, [PV0Tip] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFATD]
    ON [dbo].[LAFAT]([PV0EMP] ASC, [PV0Tip] ASC, [PV0NUM] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFATE]
    ON [dbo].[LAFAT]([PV0EMP] ASC, [PV0Tip] ASC, [PV0NUM] DESC);


GO
CREATE NONCLUSTERED INDEX [ILAFAT]
    ON [dbo].[LAFAT]([Pv0CPrS0Cod] ASC);

