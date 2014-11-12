﻿CREATE TABLE [dbo].[LAFLU] (
    [LFLUREG]       INT            NOT NULL,
    [LFLUDOC]       DECIMAL (10)   NULL,
    [CCCGC]         CHAR (18)      NULL,
    [LFLUEMI]       DATETIME       NULL,
    [LFLUVEN]       DATETIME       NULL,
    [LFLUVAL]       MONEY          NULL,
    [CSETCOD]       CHAR (3)       NULL,
    [LFLUPAG]       CHAR (1)       NULL,
    [LFLUOBS]       VARCHAR (5000) NULL,
    [LFLUSIT]       CHAR (1)       NULL,
    [LFLUNOM]       CHAR (50)      NULL,
    [LFLUABE]       CHAR (1)       NULL,
    [LFLUBAI]       DATETIME       NULL,
    [LFLUENP]       CHAR (2)       NULL,
    [LFLUELI]       CHAR (1)       NULL,
    [C1PLA]         CHAR (3)       NULL,
    [C2PLA]         CHAR (3)       NULL,
    [LFLUDO1]       CHAR (3)       NULL,
    [LFLUPED]       INT            NULL,
    [LFLUVAC]       MONEY          NULL,
    [LFLUICM]       MONEY          NULL,
    [CDCOD]         CHAR (6)       NULL,
    [LFLUDOTOTPAR]  CHAR (3)       NULL,
    [LFLUDUP]       CHAR (1)       NULL,
    [LFLUREL]       CHAR (1)       NULL,
    [LFLUIPJ]       SMALLINT       NULL,
    [LFLUCBASAL]    MONEY          NULL,
    [LFluLib]       CHAR (1)       NULL,
    [LFluCarDup]    CHAR (1)       NULL,
    [LFluDat]       DATETIME       NULL,
    [LFLUSAI]       DATETIME       NULL,
    [LFLUCAN]       DATETIME       NULL,
    [LFluUsuCri]    CHAR (20)      NULL,
    [LFluDthCri]    DATETIME       NULL,
    [LFluUsuAlt]    CHAR (20)      NULL,
    [LFluDthAlt]    DATETIME       NULL,
    [LFluCNABRem]   INT            NULL,
    [LFLU0CBAC]     CHAR (3)       NULL,
    [LFluComCvCod]  CHAR (3)       NULL,
    [LFLUVCO]       DATETIME       NULL,
    [LFluCaPlC0Cod] CHAR (11)      NULL,
    [LFluBaiAnoMes] INT            NULL,
    [LFluVenAnoMes] INT            NULL,
    [LFluEmiAnoMes] INT            NULL,
    [LFluDatAnoMes] INT            NULL,
    [LFluEstorno]   CHAR (1)       NULL,
    [LFLUDESRed]    MONEY          NULL,
    [LFLUJURRed]    MONEY          NULL,
    [LFLUTOTRed]    MONEY          NULL,
    [LFLUVAL1Red]   MONEY          NULL,
    [LFluSalRed]    MONEY          NULL,
    [LFluDDPDel]    SMALLINT       NULL,
    PRIMARY KEY CLUSTERED ([LFLUREG] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ILAFLUB]
    ON [dbo].[LAFLU]([CSETCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUC]
    ON [dbo].[LAFLU]([CCCGC] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUA]
    ON [dbo].[LAFLU]([LFLUVEN] ASC, [LFLUABE] ASC, [LFLUENP] ASC, [LFLUPAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUB]
    ON [dbo].[LAFLU]([LFLUABE] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUC]
    ON [dbo].[LAFLU]([LFLUPED] ASC, [LFLUREG] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUD]
    ON [dbo].[LAFLU]([LFLUEMI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUE]
    ON [dbo].[LAFLU]([LFLUBAI] ASC, [LFLUEMI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUF]
    ON [dbo].[LAFLU]([LFLUDOC] ASC, [LFLUDO1] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUD]
    ON [dbo].[LAFLU]([C2PLA] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUG]
    ON [dbo].[LAFLU]([C1PLA] ASC, [C2PLA] ASC, [LFLUVEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUF]
    ON [dbo].[LAFLU]([CDCOD] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUH]
    ON [dbo].[LAFLU]([C1PLA] ASC, [C2PLA] ASC, [LFLUEMI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUI]
    ON [dbo].[LAFLU]([LFLUENP] ASC, [LFLUDOC] ASC, [LFLUDO1] ASC, [LFLUSIT] ASC, [LFLUPAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUJ]
    ON [dbo].[LAFLU]([LFLUDOC] ASC, [LFLUPAG] ASC, [LFLUSIT] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUK]
    ON [dbo].[LAFLU]([LFLUENP] ASC, [LFLUABE] ASC, [LFLUELI] ASC, [LFLUBAI] ASC, [C1PLA] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUL]
    ON [dbo].[LAFLU]([LFLUPAG] ASC, [LFLUABE] ASC, [LFLUVEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUM]
    ON [dbo].[LAFLU]([LFLUNOM] ASC, [LFLUVEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUN]
    ON [dbo].[LAFLU]([C1PLA] ASC, [C2PLA] ASC, [LFLUBAI] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUO]
    ON [dbo].[LAFLU]([LFLUENP] ASC, [LFLUDOC] ASC, [LFLUPAG] ASC, [LFLUSIT] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLU]
    ON [dbo].[LAFLU]([LFLU0CBAC] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUH]
    ON [dbo].[LAFLU]([LFLU0CBAC] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUI]
    ON [dbo].[LAFLU]([LFluComCvCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ULAFLUP]
    ON [dbo].[LAFLU]([LFLUENP] ASC, [LFLUPED] ASC, [LFLUREG] ASC);


GO
CREATE NONCLUSTERED INDEX [ILAFLUK]
    ON [dbo].[LAFLU]([LFluCaPlC0Cod] ASC);

