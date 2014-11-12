CREATE TABLE [dbo].[ATD] (
    [Atd0Cod]      INT            IDENTITY (22109, 1) NOT NULL,
    [Atd0Dat]      DATETIME       NULL,
    [Atd0DtH]      DATETIME       NULL,
    [Atd0Aut]      CHAR (20)      NULL,
    [Atd0Pc0Cod]   INT            NOT NULL,
    [Atd0Pc1Cod]   SMALLINT       NOT NULL,
    [Atd0CvCod]    CHAR (3)       NOT NULL,
    [Atd0TpA0Cod]  INT            NOT NULL,
    [Atd0StA0Cod]  INT            NOT NULL,
    [Atd0MdA0Cod]  INT            NOT NULL,
    [Atd0Obs]      VARCHAR (2000) NULL,
    [Atd0SmsTxt]   VARCHAR (1000) NULL,
    [Atd0SmsEnv]   CHAR (1)       NULL,
    [Atd0SmsOkUsu] CHAR (20)      NULL,
    [Atd0SmsOkDtH] DATETIME       NULL,
    [Atd0SmsOk]    CHAR (1)       NULL,
    CONSTRAINT [PK_ATD] PRIMARY KEY CLUSTERED ([Atd0Cod] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IATDB]
    ON [dbo].[ATD]([Atd0CvCod] ASC);


GO
CREATE NONCLUSTERED INDEX [IATDC]
    ON [dbo].[ATD]([Atd0Pc0Cod] ASC, [Atd0Pc1Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [IATDD]
    ON [dbo].[ATD]([Atd0MdA0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [IATDE]
    ON [dbo].[ATD]([Atd0StA0Cod] ASC);


GO
CREATE NONCLUSTERED INDEX [IATDF]
    ON [dbo].[ATD]([Atd0TpA0Cod] ASC);


GO


CREATE TRIGGER [dbo].[Envia SMS]
   ON  [dbo].[ATD]
   AFTER INSERT, UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @Envia	AS CHAR(1)
	
	SET @Envia = (SELECT [Atd0SmsEnv] FROM inserted)
	
	IF @Envia = 'S'
	BEGIN
		DECLARE @Codigo		AS CHAR(3)
		DECLARE @Numero		AS NVARCHAR(14)
		DECLARE @Mensagem	AS NVARCHAR(MAX)
		
		SET @Codigo = (SELECT TOP 1 LTRIM(RTRIM([Atd0CvCod])) FROM inserted)
		
		SELECT @Numero = '55' + LTRIM(RTRIM(REPLACE(REPLACE(GPIMAC_Altamira.dbo.CAREP.CVDD3, ')',''), '(', ''))) + 
						LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(GPIMAC_Altamira.dbo.CAREP.CVFON2, '-', ''), ' ', ''), '.', '')))
		FROM GPIMAC_Altamira.dbo.CAREP 
		WHERE GPIMAC_Altamira.dbo.CAREP.CVCOD = @Codigo

		IF ISNULL(LEN(@Numero), 0) > 10
		BEGIN
			SET @Mensagem = (SELECT TOP 1 LTRIM(RTRIM([Atd0SmsTxt])) FROM inserted)
			
			IF ISNULL(LEN(@Mensagem), 0) > 0
			BEGIN
				INSERT INTO GESTAOAPP.SMS.[Log] ([From], [Mobile], [Message])
				VALUES ('GPIMAC.ATD', @Numero, @Mensagem)
			END
		END
	END

END



GO






CREATE TRIGGER [dbo].[Envia E-Mail Representante]
   ON  [dbo].[ATD]
   AFTER INSERT, UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @Envia	AS CHAR(1)
	
	SET @Envia = (SELECT [Atd0SmsEnv] FROM inserted)
	
	IF ISNULL(@Envia, '') = 'S'
	BEGIN
		DECLARE @Representante		AS CHAR(3)
		DECLARE @Email				AS NVARCHAR(MAX)
		DECLARE @Mensagem			AS NVARCHAR(MAX)
		
		SET @Representante = (SELECT TOP 1 LTRIM(RTRIM([Atd0CvCod])) FROM inserted)
		
		SELECT TOP 1 
			@Email = LTRIM(RTRIM(GPIMAC_Altamira.dbo.CAREP.CVMAIL))
		FROM 
			GPIMAC_Altamira.dbo.CAREP 
		WHERE 
			GPIMAC_Altamira.dbo.CAREP.CVCOD = @Representante

		IF ISNULL(LEN(LTRIM(RTRIM(@Email))), 0) > 0
		BEGIN
			DECLARE @Tipo		AS NVARCHAR(50)
			DECLARE @Nome		AS NVARCHAR(50)
			DECLARE @Contato	AS NVARCHAR(50)
			DECLARE @Depto		AS NVARCHAR(20)
			DECLARE @Telefone	AS NVARCHAR(20)
			DECLARE @Emails		AS NVARCHAR(50)
			DECLARE @Endereco	AS NVARCHAR(100)
			DECLARE @Numero		AS NVARCHAR(20)
			DECLARE @Compl		AS NVARCHAR(20)
			DECLARE @Bairro		AS NVARCHAR(50)
			DECLARE @Cidade		AS NVARCHAR(50)
			DECLARE @CEP		AS NVARCHAR(10)
			DECLARE @Observacao	AS NVARCHAR(MAX)
			
			SELECT 
				@Tipo = [CATPA].CTpA0Nom,
				@Nome = [CAPCL].[Pc0Nom],
				@Contato = [CAPCL1].Pc1Nom,
				@Depto = [CAPCL1].Pc1Dep,
				@Telefone = '(' + LTRIM(RTRIM([CAPCL1].Pc1TelDdd)) + ') ' + LTRIM(RTRIM([CAPCL1].Pc1TelNum)),
				@Emails = [CAPCL1].Pc1Eml,
				@Endereco = [CAPCL].Pc0End,
				@Numero = [CAPCL].Pc0EndNum,
				@Compl = [CAPCL].Pc0EndCpl,
				@Bairro = [CAPCL].Pc0Bai,
				@Cidade = [CAPCL].Pc0Cid,
				@CEP = [CAPCL].Pc0Cep,
				@Observacao = [ATD].Atd0Obs
			FROM
				[GPIMAC_Altamira].[dbo].[ATD] 
				INNER JOIN [GPIMAC_Altamira].dbo.[CAPCL] ON [GPIMAC_Altamira].[dbo].[ATD].[Atd0Pc0Cod] = [GPIMAC_Altamira].dbo.[CAPCL].[Pc0Cod]
				INNER JOIN [GPIMAC_Altamira].dbo.[CAPCL1] ON [GPIMAC_Altamira].[dbo].[ATD].[Atd0Pc0Cod] = [GPIMAC_Altamira].dbo.[CAPCL1].Pc0Cod AND [GPIMAC_Altamira].[dbo].[ATD].Atd0Pc1Cod = [GPIMAC_Altamira].dbo.[CAPCL1].Pc1Cod
				INNER JOIN [GPIMAC_Altamira].dbo.[CATPA] ON [GPIMAC_Altamira].[dbo].[ATD].Atd0TpA0Cod = [GPIMAC_Altamira].[dbo].[CATPA].[CTpA0Cod] 
				INNER JOIN [GPIMAC_Altamira].dbo.[CASTA] ON [GPIMAC_Altamira].[dbo].[ATD].Atd0StA0Cod = [GPIMAC_Altamira].[dbo].[CASTA].CSta0Cod
				
			
			SET	@Mensagem = --'Email: ' + @mailTo  + CHAR(13) + CHAR(13) + */
				N'<html><header><title>Solicitação de Atendimento ao Cliente</title>' +
				N'<style><!--
				/* Style Definitions */
				p, li, div
					{margin:0cm;
					margin-bottom:.0001pt;
					font-size:11.0pt;
					font-family:"Calibri","sans-serif";}
				td, tr, table, body
					{margin:0cm;
					margin-bottom:.0001pt;
					color:#1F497D;
					font-size:11.0pt;
					font-family:"Calibri","sans-serif";}
				--></style>' +
				N'</header>' + 
				N'<body>' +
				N'<B>Solicitação de Atendimento ao Cliente:</B><BR><BR>' + CHAR(13) + CHAR(13) + 
				N'<TABLE>' + CHAR(13) +
				N'<TR><TD><B>Data: </B></TD>' + N'<TD>' + CONVERT(NVARCHAR(10), GETDATE(), 103) + N'</TD></TR>' + CHAR(13) + 
				N'<TR><TD><B>Tipo: </B></TD>' + N'<TD>' + @Tipo + N'</TD></TR>' + CHAR(13) +
				N'<TR><TD><B>Nome: </B></TD>' + N'<TD>' + @Nome + N'</TD></TR>' + CHAR(13)			
				
			SELECT	@Mensagem = @Mensagem + 
					N'<TR><TD><B>Contato: </B></TD>' + N'<TD>' + @Contato + N'</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>Depto: </B></TD>' + N'<TD>' + @Depto + N'</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>Telefone: </B></TD>' + N'<TD>' + @Telefone + N'</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>Email(s): </B></TD>' + N'<TD>' +@Emails + N'</TD></TR>' + CHAR(13)

			SET @Mensagem = @Mensagem +			
				N'<TR><TD><B>Endereço: </B></TD>' +	'<TD>' + @Endereco + N'</TD></TR>' + CHAR(13) +
				N'<TR><TD><B>Numero: </B></TD>' + '<TD>' + LTRIM(RTRIM(@Numero)) + N'</TD></TR>' + CHAR(13) +
				N'<TR><TD><B>Complemento: </B></TD>' + '<TD>' + LTRIM(RTRIM(@Compl)) + N'</TD></TR>' + CHAR(13) +
				N'<TR><TD><B>Bairro: </B></TD>' + '<TD>' + @Bairro + N'</TD></TR>' + CHAR(13) +
				N'<TR><TD><B>CEP: </B></TD>' + '<TD>' + @CEP + N'</TD></TR>' + CHAR(13) + 
				N'<TR><TD><B>Cidade: </B></TD>' + '<TD>' + @Cidade + N'</TD></TR>' + CHAR(13) 
		
			/*SELECT @Mensagem = @Mensagem +					
				N'<TR><TD><B>Produto(s): </B></TD>' + '<TD>' +
				REPLACE(REPLACE(CAST(x.item.query('for $e in Product return concat(data($e/Description[1]), "<BR>")') AS NVARCHAR(MAX)), '&lt;', '<'), '&gt;', '>') + 
				N'</TD></TR>' + CHAR(13)
			FROM @xmlRequest.nodes('/Register/Products') AS x(item)*/
			
			SET @Mensagem = @Mensagem +
				N'<TR><TD><B>Observação: </B></TD>' + N'<TD>' + @Observacao + N'</TD></TR></TABLE><BR>' + CHAR(13) +
				--N'<B>*** Enviado automaticamente pelo Sistema de Atendimento ao Cliente da Altamira. ***</B></BODY></HTML>' 
				N'</body></html>'
										
			EXEC [msdb].dbo.sp_send_dbmail
				@profile_name = 'Atendimento',
				@recipients = @Email,
				--@blind_copy_recipients = 'vendas.comercial@altamira.com.br;sistemas.ti@altamira.com.br',	
				@blind_copy_recipients = 'orcamento.comercial@altamira.com.br',	
				@subject = 'Altamira - Solicitação de Atendimento ao Cliente',
				@body_format = 'HTML',
				@body =	@Mensagem;

		END
	END

END







GO
GRANT SELECT
    ON OBJECT::[dbo].[ATD] TO [altanet]
    AS [dbo];

