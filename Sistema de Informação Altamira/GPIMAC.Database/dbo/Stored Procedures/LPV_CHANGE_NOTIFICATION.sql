
CREATE PROCEDURE [dbo].[LPV_CHANGE_NOTIFICATION]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MAILTO AS NVARCHAR(MAX)
	DECLARE @BODY AS NVARCHAR(MAX)
	DECLARE @SUBJECT AS NVARCHAR(MAX)
	
	--SET @MAILTO = 'alessandro@altamira.com.br;anajulia.reis@altamira.com.br;financeiro2@altamira.com.br;fiscal@altamira.com.br;gisele.cruz@altamira.com.br;alexandre.giovannini@altamira.com.br'
	SET @MAILTO = 'alessandro@altamira.com.br;anajulia.reis@altamira.com.br'
	
	DECLARE @PEDIDO NVARCHAR(10)
	DECLARE @CLIENTE NVARCHAR(50)
	DECLARE @ACAO NVARCHAR(20)
	DECLARE @ALTERACAO NVARCHAR(MAX)
	
	DECLARE @DATETIME_STAMP DATETIME
	
	SET @DATETIME_STAMP = GETDATE()
	
	DECLARE LPV_CURSOR CURSOR STATIC FOR
	SELECT 
			CAST(CAST(SUBSTRING(M.[CMod0Id], 9, 10) AS INT) AS NVARCHAR) AS PEDIDO, 
			LTRIM(RTRIM(MIN(C.CCNOM))) AS CLIENTE,
			CASE	WHEN MAX(M.[CMod0Aca]) = 'DLT' THEN 'EXCLUSAO PEDIDO'	
					WHEN MAX(M.[CMod0Aca]) = 'INS' THEN 'NOVO PEDIDO' 
					WHEN MAX(M.[CMod0Aca]) = 'UPD' THEN 'ALTERACAO PEDIDO'
					END AS ACAO
		FROM 
			[GPIMAC_Altamira].[dbo].[MODCTR] M, 
			[GPIMAC_Altamira].[dbo].LPV P, 
			[GPIMAC_Altamira].[dbo].[CACLI] C
		WHERE 
			CAST(CAST(SUBSTRING(M.[CMod0Id], 9, 10) AS INT) AS NVARCHAR) = CAST(P.LPPED AS INT) AND P.[CCCGC] = C.[CCCGC] 
			AND M.[CMod0Tab] = 'LPV' 
			AND M.[CMod0EmlEnv] = 'S'
			AND M.[CMod0DtH] < @DATETIME_STAMP 
			--AND SUBSTRING(M.[CMod0Id], 20, 4) <> 'ITEM'		
			AND M.[CMod0Usu] = 'VENDAS05'
			AND P.[LpLib] = 'S'
		GROUP BY CAST(CAST(SUBSTRING(M.[CMod0Id], 9, 10) AS INT) AS NVARCHAR)/*, M.[CMod0Aca]*/	
		ORDER BY PEDIDO
		
	OPEN LPV_CURSOR
	FETCH NEXT FROM LPV_CURSOR INTO @PEDIDO, @CLIENTE, @ACAO, @ALTERACAO
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SUBJECT = @ACAO + N' ' + CAST(@PEDIDO AS NVARCHAR(10)) + N' - ' + @CLIENTE
		
		SET @ALTERACAO = N''

		SELECT @ALTERACAO = LTRIM(RTRIM(@ALTERACAO)) + N'<tr><td>' + LTRIM(RTRIM(M.[CMod0AttNom])) + N'</td><td>' + CASE WHEN LTRIM(RTRIM(M.[CMod0AttValAnt])) = 'INEXISTENTE' THEN N'' ELSE LTRIM(RTRIM(M.[CMod0AttValAnt])) END + N'</td><td>' + LTRIM(RTRIM(M.[CMod0AttValNov])) + N'</td></tr>'
		FROM 
			[GPIMAC_Altamira].[dbo].[MODCTR] M,
			[GPIMAC_Altamira].[dbo].LPV P 
		WHERE M.[CMod0Tab] = 'LPV' AND P.LPPED = @PEDIDO AND CAST(CAST(SUBSTRING(M.[CMod0Id], 9, 10) AS INT) AS NVARCHAR(20)) = P.LPPED
			AND M.[CMod0Tab] = 'LPV' 
			AND M.[CMod0EmlEnv] = 'S'
			AND M.[CMod0DtH] < @DATETIME_STAMP 
			--AND SUBSTRING(M.[CMod0Id], 20, 4) <> 'ITEM'		
			AND M.[CMod0Usu] = 'VENDAS05'
			AND P.[LpLib] = 'S'
			
		SELECT	@BODY = 
			N'<html><header><title>Pedido Alterado</title>' +
			N'<style><!--
			/* Font Definitions */
			@font-face
				{font-family:SimSun;
				panose-1:2 1 6 0 3 1 1 1 1 1;}
			@font-face
				{font-family:SimSun;
				panose-1:2 1 6 0 3 1 1 1 1 1;}
			@font-face
				{font-family:Calibri;
				panose-1:2 15 5 2 2 2 4 3 2 4;}
			@font-face
				{font-family:Tahoma;
				panose-1:2 11 6 4 3 5 4 4 2 4;}
			@font-face
				{font-family:Webdings;
				panose-1:5 3 1 2 1 5 9 6 7 3;}
			@font-face
				{font-family:"\@SimSun";
				panose-1:0 0 0 0 0 0 0 0 0 0;}
			/* Style Definitions */
			p, li, div
				{margin:0cm;
				margin-bottom:.0001pt;
				font-size:11.0pt;
				font-family:"Calibri","sans-serif";}
			td, tr, table
				{margin:0cm;
				margin-bottom:.0001pt;
				color:#1F497D;
				font-size:11.0pt;
				font-family:"Calibri","sans-serif";}
			a:link, span.MsoHyperlink
				{mso-style-priority:99;
				color:blue;
				text-decoration:underline;}
			a:visited, span.MsoHyperlinkFollowed
				{mso-style-priority:99;
				color:purple;
				text-decoration:underline;}
			--></style>' +
			N'</header>' + 
			N'<body lang=PT-BR link=blue vlink=purple style=''color:#1F497D''><p>Dados do Pedido:</p>' +  
			N'<table border=1>' + 
			N'<tr><td>Data</td><td>Numero</td><td>Cliente</td></tr>' + 
			N'<tr><td>' + CONVERT(NVARCHAR, GETDATE(), 103) + '</td><td>' + CAST(@PEDIDO AS NVARCHAR(10)) + '</td><td>' + @CLIENTE + '</td></tr>' + 
			N'</table>' + CASE WHEN @ACAO = 'ALTERACAO PEDIDO' THEN
			N'<br><p>Alterações realizadas neste pedido:</p>' +
			N'<table border=1><tr><td>Alteração</td><td>Valor anterior</td><td>Valor atual</td></tr>' +
			@ALTERACAO +
			N'</table>' ELSE N'' END +
			N'</body></html>'
			
		EXEC [msdb].dbo.sp_send_dbmail
			@profile_name = 'Sistema.GPIMAC',
			@recipients = @MAILTO,
			@subject = @SUBJECT,
			@body_format = 'HTML',
			@body =	@BODY;	
			
		FETCH NEXT FROM LPV_CURSOR INTO @PEDIDO, @CLIENTE, @ACAO		
	END
	
	CLOSE LPV_CURSOR
	DEALLOCATE LPV_CURSOR
	
	UPDATE [GPIMAC_Altamira].[dbo].[MODCTR] 
	SET [CMod0EmlEnv] = 'N'
	WHERE [CMod0EmlEnv] = 'S' AND [CMod0DtH] < @DATETIME_STAMP
	
END
