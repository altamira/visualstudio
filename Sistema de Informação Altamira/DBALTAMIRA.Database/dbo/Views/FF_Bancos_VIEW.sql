
/****** Object:  View dbo.FF_Bancos_VIEW    Script Date: 23/10/2010 13:58:20 ******/

CREATE VIEW [FF_Bancos_VIEW]
AS SELECT [FF_Bancos].[ffba_NomeBanco], [FF_ContaCorrente].[ffcc_Agencia], [FF_ContaCorrente].[ffcc_Conta], [FF_MovimentoCC].[ffmv_DataMovimento], [FF_MovimentoCC].[ffmv_Valor]
FROM [FF_Bancos], [FF_ContaCorrente]  RIGHT JOIN [FF_MovimentoCC] ON       ffmv_banco    = ffcc_banco 
and      ffmv_agencia = ffcc_agencia 
and      ffmv_conta     = ffcc_conta 

Where  ffcc_previsao =  '1' 
and      ffba_codigo    =  ffcc_banco
