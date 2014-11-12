







CREATE PROCEDURE [dbo].[GPSP_AvisoLiberacaoPedido]
	@PEDIDO	AS INT OUTPUT

AS

	SET NOCOUNT ON;
	
	DECLARE @CLIENTE		NVARCHAR(50)
	DECLARE @ENTREGA		NVARCHAR(10)
	
	DECLARE @MAILTO AS NVARCHAR(MAX)
	DECLARE @BODY AS NVARCHAR(MAX)
	DECLARE @SUBJECT AS NVARCHAR(MAX)
	
	SET @MAILTO = 'financeiro@altamira.com.br;faturamento.fiscal@altamira.com.br;ritadecassia.miranda@altamira.com.br'

	SET @CLIENTE = NULL
	
	SELECT TOP 1
		@CLIENTE = LTRIM(RTRIM(C.CCNOM)),
		@ENTREGA = CONVERT(NVARCHAR(10), P.Lp0SaiRed, 103)
	FROM 
		LPV P WITH (NOLOCK) INNER JOIN 
		[CACLI] C WITH (NOLOCK) ON P.[CCCGC] = C.[CCCGC]
	WHERE 
		P.LPPED = @PEDIDO
		
	IF @@ROWCOUNT > 0 AND NOT @PEDIDO IS NULL AND NOT @CLIENTE IS NULL
	BEGIN
		SET @SUBJECT = N'PEDIDO LIBERADO ' + CAST(@PEDIDO AS NVARCHAR(10)) + N' - ' + @CLIENTE
		
		SELECT	@BODY = 
			N'<html><header><title>PEDIDO LIBERADO</title>' +
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
			N'<body><p>Pedido Liberado para Cobrança/Faturamento:</p><BR>' + 
			N'<table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-left:-1.15pt;border-collapse:collapse">' +
			N'<tbody>' + 
			N'<tr style="height:15.0pt">' +
			N'<td width=70 nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">Data Entrega<o:p></o:p></span></b></td>' +
			N'<td width=70 nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-left:none;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">Pedido<o:p></o:p></span></b></td>' +
			N'<td width="100%" nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-left:none;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">CLIENTE<o:p></o:p></span></b></td>' +
			'</tr><tr style="height:15.0pt">' +
			N'<td nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-top:none;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + @ENTREGA + '<o:p></o:p></span></td>' +
			N'<td nowrap="" valign="bottom" style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid #4F81BD 1.0pt;border-right:solid #4F81BD 1.0pt;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + CAST(@PEDIDO AS NVARCHAR(10)) + '<o:p></o:p></span></td>' +
			N'<td nowrap="" valign="bottom" style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid #4F81BD 1.0pt;border-right:solid #4F81BD 1.0pt;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + @CLIENTE + '<o:p></o:p></span></td>' +
			N'</tr></tbody></table>' + 
			N'<br><p style="font-size:9.0pt;color:#000000">* Email enviado automaticamente pelo sistema GPIMAC.</p>' +
			N'</body></html>'
			
			EXEC [msdb].dbo.sp_send_dbmail
				@profile_name = 'Sistema.GPIMAC',
				@recipients = @MAILTO,	
				@blind_copy_recipients = 'sistemas.ti@altamira.com.br',			
				@subject = @SUBJECT,
				@body_format = 'HTML',
				@body =	@BODY;	
				
		DECLARE @Representante AS NCHAR(3)
		DECLARE @Numero		AS NVARCHAR(14)
		DECLARE @Email		AS NVARCHAR(MAX)
		DECLARE @Mensagem	AS NVARCHAR(MAX)
		DECLARE @DataEntrega AS DATE
		
		SET @Representante = (SELECT LPVEN FROM LPV WHERE LPPED = @PEDIDO)
		
		SELECT 
			@Email = LTRIM(RTRIM(CVMAIL)),
			@Numero = '55' + LTRIM(RTRIM(REPLACE(REPLACE(CAREP.CVDD3, ')',''), '(', ''))) + 
						LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(CAREP.CVFON2, '-', ''), ' ', ''), '.', '')))
		FROM 
			CAREP 
		WHERE 
			CAREP.CVCOD = @Representante

		IF ISNULL(LEN(@Email), 0) > 0
		BEGIN
			
			SELECT	@BODY = 
				N'<html><header><title>PEDIDO LIBERADO</title>' +
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
				N'<body><p>Para seu conhecimento segue as informações do pedido liberado pelo departamento de vendas da ALTAMIRA:</p><BR>' + 
				N'<table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-left:-1.15pt;border-collapse:collapse">' +
				N'<tbody>' + 
				N'<tr style="height:15.0pt">' +
				N'<td width=70 nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">Data Entrega<o:p></o:p></span></b></td>' +
				N'<td width=70 nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-left:none;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">Pedido<o:p></o:p></span></b></td>' +
				N'<td width="100%" nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-left:none;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><b><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">CLIENTE<o:p></o:p></span></b></td>' +
				'</tr><tr style="height:15.0pt">' +
				N'<td nowrap="" valign="bottom" style="border:solid #4F81BD 1.0pt;border-top:none;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + @ENTREGA + '<o:p></o:p></span></td>' +
				N'<td nowrap="" valign="bottom" style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid #4F81BD 1.0pt;border-right:solid #4F81BD 1.0pt;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + CAST(@PEDIDO AS NVARCHAR(10)) + '<o:p></o:p></span></td>' +
				N'<td nowrap="" valign="bottom" style="width:48.0pt;border-top:none;border-left:none;border-bottom:solid #4F81BD 1.0pt;border-right:solid #4F81BD 1.0pt;background:#DCE6F1;padding:0cm 3.5pt 0cm 3.5pt;height:15.0pt"><span style="font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black">' + @CLIENTE + '<o:p></o:p></span></td>' +
				N'</tr></tbody></table>' + 
				N'<br><p style="font-size:11.0pt;color:#000000">Para consultar ou imprimir a cópia do pedido acesse <a href="http://vendas.altamira.com.br:8080">http://vendas.altamira.com.br:8080/</a>.</p>' +
				N'<br><p style="font-size:9.0pt;color:#000000">* Email enviado automaticamente pelo sistema GPIMAC.</p>' +
				N'</body></html>'
				
				EXEC [msdb].dbo.sp_send_dbmail
					@profile_name = 'Sistema.GPIMAC',
					@recipients = @Email,
					@blind_copy_recipients = 'sistemas.ti@altamira.com.br',			
					@subject = @SUBJECT,
					@body_format = 'HTML',
					@body =	@BODY;	
		
		END
		
		IF ISNULL(LEN(@Numero), 0) > 10
		BEGIN
			SET @Mensagem = N'PEDIDO LIBERADO: ' + CAST(@PEDIDO AS NVARCHAR(10)) + N' - ' + @CLIENTE + N'. Cópia do pedido em http://vendas.altamira.com.br:8080/'
			
			IF ISNULL(LEN(@Mensagem), 0) > 0
			BEGIN
				INSERT INTO GESTAOAPP.SMS.[Log] ([From], [Mobile], [Message])
				VALUES (N'GPIMAC.MODCTR', @Numero, @Mensagem)
				
				/*INSERT INTO GESTAOAPP.SMS.[Log] ([From], [Mobile], [Message])
				VALUES (N'GPIMAC.MODCTR', N'5511984420440', @Mensagem)*/
			END
		END
				
	END










GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_AvisoLiberacaoPedido] TO [interclick]
    AS [dbo];

