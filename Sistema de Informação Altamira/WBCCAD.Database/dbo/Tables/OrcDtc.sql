CREATE TABLE [dbo].[OrcDtc] (
    [numeroOrcamento] CHAR (9)       NOT NULL,
    [ORCDTCGRUPO]     INT            NULL,
    [ORCDTCSUBGRUPO]  NVARCHAR (2)   NULL,
    [ORCDTCCORTE]     NVARCHAR (50)  NULL,
    [ORCDTCID]        INT            NULL,
    [ORCDTCDTC]       NVARCHAR (MAX) NULL,
    [idOrcDtc]        INT            IDENTITY (1, 1) NOT NULL,
    [orcdtcids]       NVARCHAR (MAX) NULL,
    [orcdtcitem]      VARCHAR (20)   NULL,
    CONSTRAINT [PK_OrcDtc] PRIMARY KEY CLUSTERED ([idOrcDtc] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_OrcDtc]
    ON [dbo].[OrcDtc]([numeroOrcamento] ASC, [idOrcDtc] ASC);

