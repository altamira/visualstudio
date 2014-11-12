CREATE TABLE [dbo].[LPV] (
    [LPEMP]              CHAR (2)       NOT NULL,
    [LPPED]              INT            NOT NULL,
    [CCATU]              CHAR (1)       NULL,
    [LPOB1]              CHAR (80)      NULL,
    [LPFEI]              CHAR (20)      NULL,
    [lptra]              CHAR (5)       NULL,
    [LPPAG]              CHAR (3)       NULL,
    [LPCLI]              CHAR (15)      NULL,
    [CCCGC]              CHAR (18)      NULL,
    [LPOBS]              CHAR (80)      NULL,
    [LPENT]              DATETIME       NULL,
    [LPVEN]              CHAR (3)       NULL,
    [LPULTSEQ]           INT            NULL,
    [LPLo0Emp]           CHAR (2)       NULL,
    [LPLo0Ped]           INT            NULL,
    [Lpc2pla]            CHAR (3)       NULL,
    [Lpc2nom]            CHAR (30)      NULL,
    [Lpv0Imp]            CHAR (1)       NULL,
    [LPVGERCOD]          CHAR (3)       NULL,
    [LPVGERDES]          CHAR (50)      NULL,
    [LPVCVUSU]           CHAR (20)      NULL,
    [LPALT]              SMALLINT       NULL,
    [LPTIPO]             CHAR (2)       NULL,
    [CCEnd1Seq]          SMALLINT       NULL,
    [CCSEQ]              SMALLINT       NULL,
    [LpMonCnpj]          CHAR (18)      NULL,
    [LpPrj]              CHAR (30)      NULL,
    [LpOrc]              CHAR (30)      NULL,
    [LpCom]              SMALLMONEY     NULL,
    [LpFre]              CHAR (1)       NULL,
    [CTpMCod]            CHAR (5)       NULL,
    [LpObsPgto]          VARCHAR (1000) NULL,
    [LPWBCCADORCNUM]     CHAR (8)       NULL,
    [CAc0Cod]            SMALLINT       NULL,
    [Lp0SaiRed]          DATETIME       NULL,
    [LPTSARED]           MONEY          NULL,
    [LpMonVal]           MONEY          NULL,
    [LPEtEntDtHCri]      DATETIME       NULL,
    [LPEtEntUsuCri]      CHAR (20)      NULL,
    [LPEtEnt]            CHAR (1)       NULL,
    [LpMonBai]           CHAR (1)       NULL,
    [LpMonDtB]           DATETIME       NULL,
    [LpMonDtP]           DATETIME       NULL,
    [LPEtSitRed]         CHAR (50)      NULL,
    [LPAcaAltRed]        CHAR (10)      NULL,
    [LPDtHAltRed]        DATETIME       NULL,
    [LPDatAltRed]        DATETIME       NULL,
    [LPUsuAltRed]        CHAR (20)      NULL,
    [LPObsNF]            VARCHAR (1000) NULL,
    [LpLib]              CHAR (1)       NULL,
    [LPObsOP]            VARCHAR (1000) NULL,
    [LPEtSitSeqRed]      SMALLINT       NULL,
    [LpLibUsu]           CHAR (20)      NULL,
    [LpLibDtH]           DATETIME       NULL,
    [LpLibDat]           DATETIME       NULL,
    [LpBlockCodRed]      SMALLINT       NULL,
    [LpBlockRed]         CHAR (1)       NULL,
    [LpEtSitUsuRed]      CHAR (20)      NULL,
    [LPEtSitDatRed]      DATETIME       NULL,
    [LPObsInt]           VARCHAR (1000) NULL,
    [LPTOTPedRed]        MONEY          NULL,
    [LPTIPRed]           MONEY          NULL,
    [LPTGERed]           MONEY          NULL,
    [LpDDPFluGer]        CHAR (1)       NULL,
    [LpDDPFluGerDat]     DATETIME       NULL,
    [LpDDPFluGerDtH]     DATETIME       NULL,
    [LpDDPFluGerUsu]     CHAR (20)      NULL,
    [LpCPg0OkRed]        CHAR (1)       NULL,
    [LpCPg0ProTotRed]    MONEY          NULL,
    [LpCPg0ImpTotRed]    MONEY          NULL,
    [LpCPg0ParTotRed]    MONEY          NULL,
    [LPPagImp]           SMALLINT       NULL,
    [LpBlockExpedCodRed] SMALLINT       NULL,
    [LpBlockExpedRed]    CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([LPEMP] ASC, [LPPED] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ULPVA]
    ON [dbo].[LPV]([LPPED] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPVC]
    ON [dbo].[LPV]([LPVEN] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPVD]
    ON [dbo].[LPV]([LPPAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPVE]
    ON [dbo].[LPV]([lptra] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVB]
    ON [dbo].[LPV]([LPPED] DESC);


GO
CREATE NONCLUSTERED INDEX [ULPVC]
    ON [dbo].[LPV]([LPLo0Emp] ASC, [LPLo0Ped] ASC, [CCATU] ASC);


GO
CREATE NONCLUSTERED INDEX [ULPVD]
    ON [dbo].[LPV]([Lpc2pla] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV]
    ON [dbo].[LPV]([CCCGC] ASC, [CCEnd1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV1]
    ON [dbo].[LPV]([CCCGC] ASC, [CCSEQ] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV2]
    ON [dbo].[LPV]([LpMonCnpj] ASC, [CCSEQ] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV3]
    ON [dbo].[LPV]([LpMonCnpj] ASC, [CCEnd1Seq] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV4]
    ON [dbo].[LPV]([CTpMCod] ASC);


GO
CREATE NONCLUSTERED INDEX [ILPV5]
    ON [dbo].[LPV]([CAc0Cod] ASC);


GO

CREATE TRIGGER [dbo].[LPV_INSERT_NOTIFY_TRIGGER]
   ON  [GPIMAC_Altamira].[dbo].[LPV] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @mailTo AS NVARCHAR(MAX)
	DECLARE @body AS NVARCHAR(MAX)
	DECLARE @subject AS NVARCHAR(MAX)
	
	SET @mailTo = 'alessandro@altamira.com.br'
	
	DECLARE @NUMERO INT
	DECLARE @DATAENTRADA DATETIME
	
	SET @NUMERO = (SELECT TOP 1 LPPED FROM inserted)
	SET @DATAENTRADA = (SELECT TOP 1 LPENT FROM inserted)
	
	SET @subject = N'Novo Pedido ' + CAST(@NUMERO AS NVARCHAR(10)) 
	
	SET	@body = 
		N'<HTML><HEADER><TITLE>Inclusão de Pedido</TITLE></HEADER><BODY><B>Novo Pedido:</B><BR><BR>' + CHAR(13) + CHAR(13) + 
		N'<TABLE>' + CHAR(13) +
		N'<TR><TD><B>Data</B></TD><TD><B>Numero</B></TD></TR>' + CHAR(13) +
		N'<TR><TD>' + CONVERT(nvarchar, @DATAENTRADA, 113) + '</TD><TD>' + CAST(@NUMERO AS NVARCHAR(10)) + '</TD></TR>' + CHAR(13) +
		N'</TABLE></BODY></HTML>' 			
		
	EXEC [msdb].dbo.sp_send_dbmail
		@profile_name = 'Sistema.GPIMAC',
		@recipients = @mailTo,
		@subject = @subject,
		@body_format = 'HTML',
		@body =	@body;	
		
END

GO
DISABLE TRIGGER [dbo].[LPV_INSERT_NOTIFY_TRIGGER]
    ON [dbo].[LPV];


GO


CREATE TRIGGER [dbo].[LPV_UPDATE_NOTIFY_TRIGGER]
   ON  [GPIMAC_Altamira].[dbo].[LPV] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @mailTo AS NVARCHAR(MAX)
	DECLARE @body AS NVARCHAR(MAX)
	DECLARE @subject AS NVARCHAR(MAX)
	
	SET @mailTo = 'alessandro@altamira.com.br'
	
	DECLARE @NUMERO INT
	DECLARE @DATAENTRADA DATETIME
	
	SET @NUMERO = (SELECT TOP 1 LPPED FROM inserted)
	SET @DATAENTRADA = (SELECT TOP 1 LPENT FROM inserted)
	
	SET @subject = N'ALTERAÇÃO DE PEDIDO ' + CAST(@NUMERO AS NVARCHAR(10)) 
	
	SET	@body = 
		N'<HTML><HEADER><TITLE>Pedido Alterado</TITLE></HEADER><BODY><B>Dados do Pedido:</B><BR><BR>' + CHAR(13) + CHAR(13) + 
		N'<TABLE>' + CHAR(13) +
		N'<TR><TD><B>Data</B></TD><TD><B>Numero</B></TD></TR>' + CHAR(13) +
		N'<TR><TD>' + CONVERT(nvarchar, @DATAENTRADA, 113) + '</TD><TD>' + CAST(@NUMERO AS NVARCHAR(10)) + '</TD></TR>' + CHAR(13) +
		N'</TABLE></BODY></HTML>' 			
		
	EXEC [msdb].dbo.sp_send_dbmail
		@profile_name = 'Sistema.GPIMAC',
		@recipients = @mailTo,
		@subject = @subject,
		@body_format = 'HTML',
		@body =	@body;	
END


GO
DISABLE TRIGGER [dbo].[LPV_UPDATE_NOTIFY_TRIGGER]
    ON [dbo].[LPV];


GO
GRANT SELECT
    ON OBJECT::[dbo].[LPV] TO [ALTAMIRA\marcelo.parra]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[LPV] TO [altanet]
    AS [dbo];

