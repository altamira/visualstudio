
------------------------------------------------------------------------------------
--vw_CadeiaValor_Imagem
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISADMIN
--Objetivo	        : 
--Data                  : 22/01/2004    
--Atualização           : 09/12/2004 - Acerto o Cabeçalho da View - Sérgio Cardoso
------------------------------------------------------------------------------------

--Use EgisAdmin

CREATE VIEW vw_CadeiaValor_Imagem

AS
SELECT
   C.cd_cadeia_valor, C.nm_cadeia_valor, C.cd_ordem_cadeia_valor,
   cast( C.ds_cadeia_valor as varchar(200)) as cl_descricao,
   I.nm_arquivo_imagem, I.nm_local_imagem
FROM Cadeia_Valor C LEFT OUTER JOIN
   Imagem I ON (C.cd_imagem = I.cd_imagem)
WHERE ic_cadeia_valor_liberada = 'S'

