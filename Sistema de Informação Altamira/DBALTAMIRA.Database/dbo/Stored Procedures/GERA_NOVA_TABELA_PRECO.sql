/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE PROCEDURE GERA_NOVA_TABELA_PRECO(@TABELA_ATUAL AS NCHAR(2), @NOVA_TABELA AS NCHAR(2))
AS

INSERT INTO [DBALTAMIRA].[dbo].[PRE_Tabela]
SELECT @NOVA_TABELA
      ,CAST(GETDATE() AS DATE)
      ,[tab_TabelaAtiva]
      ,[tab_TabelaConfirmada]
      ,[tab_CodProduto]
      ,[tab_Unidade]
      ,[tab_Familia]
      ,[tab_ForCNPJ]
      ,[tab_ForAbreviado]
      ,[tab_Contribuinte]
      ,[tab_PrecoMedio]
      ,[tab_PrecoBasicoSI]
      ,[tab_ICMS]
      ,[tab_PIS]
      ,[tab_COFINS]
      ,[tab_PrazoMedio]
      ,[tab_OutrosI]
      ,[tab_IPI]
      ,[tab_OutrosNI]
      ,[tab_Estado]
      ,[tab_Isento]
  FROM [DBALTAMIRA].[dbo].[PRE_Tabela]
  WHERE [tab_NumeroTabela] = @TABELA_ATUAL

--BEGIN TRANSACTION

--UPDATE 
--	[DBALTAMIRA].[dbo].[PRE_Tabela] 
--SET
--	[tab_PrecoMedio] = [tab_PrecoMedio] * 1.1271,
--	[tab_PrecoBasicoSI] = [tab_PrecoBasicoSI] * 1.1271
--WHERE 
--	[tab_NumeroTabela] = 'BI' AND
--	[tab_CodProduto] LIKE 'ALPRGA%'

--COMMIT TRANSACTION

