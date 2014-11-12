-- =============================================
-- Script Template
-- =============================================

PRINT 'Import GPIMAC Data...'

/*
SELECT TOP 1000 [CCCGC]
      ,[CCNOM]
      ,[CCLIM]
      ,[CCINS]
      ,[CCPAG]
      ,[CCFAN]
      ,[CCBAI]
      ,[CCCID]
      ,[CCEND]
      ,[CCESO]
      ,[CCCEP]
      ,[CCSET]
      ,[CCFAX]
      ,[CCFDD]
      ,[CCCON]
      ,[CCFON]
      ,[CTCOD]
      ,[CPCOD]
      ,[CCENB]
      ,[CCCLA]
      ,[CCCEN]
      ,[CCCBA]
      ,[CCCCI]
      ,[CCCcEP]
      ,[CCCES]
      ,[CCDES]
      ,[CVCOD]
      ,[CCCOM]
      ,[CEMPCOD]
      ,[CCOBS]
      ,[CCTOT]
      ,[CCVE1]
      ,[CCVE2]
      ,[CCVEN1]
      ,[CCVEN2]
      ,[CCFRE]
      ,[CCLUG]
      ,[CCTKG]
      ,[CCOBS1]
      ,[CCtFO3]
      ,[CCFA2]
      ,[CCCO1]
      ,[CCDIV]
      ,[CCDD5]
      ,[CCDD6]
      ,[CCMAIL]
      ,[CECOD]
      ,[CCCRE]
      ,[CCTOT1]
      ,[CCDTA]
      ,[CCIQF]
      ,[CCPLACOD]
      ,[CCSPLCOD]
      ,[CCSIG]
      ,[CatCod]
      ,[CCSUF]
      ,[CCPACOM]
      ,[CCFOP]
      ,[CCDD1]
      ,[CCATCO]
      ,[CCATNO]
      ,[CCFINA]
      ,[CCBRES]
      ,[CCMIC]
      ,[CCICMSP]
      ,[CCICMSPALI]
      ,[CCICMSPCACODI]
      ,[CCICMSPOBS]
      ,[CCPc0Cod]
      ,[CCULTSEQ]
      ,[CCPES]
      ,[CCMAR]
      ,[CCDES1]
      ,[CCPRF]
      ,[CCVIS]
      ,[CCLogTip0CodP]
      ,[CCEndNum]
      ,[CCEndCpl]
      ,[CCLogTip0CodC]
      ,[CCCENNum]
      ,[CCCENCpl]
      ,[CCInsMun]
      ,[CCCIDIBGECOD]
      ,[CCCCIIBGECOD]
      ,[CCTIPCLI]
      ,[CCIPIIse]
      ,[CcCodAnt]
      ,[CCExpLocEmb]
      ,[CCExpUFEmb]
      ,[CCPai]
  FROM [GPIMAC_Altamira].[dbo].[CACLI]
  --WHERE CCCCIIBGECOD = 1100205
  ORDER BY CCCGC

SELECT [CCPc0Cod], CCCID, CCCES, CCCCIIBGECOD
FROM GPIMAC_Altamira.[dbo].[CACLI]
WHERE NOT EXISTS (SELECT * FROM GestaoApp2.Location.City WHERE Code = CCCIDIBGECOD)

SELECT LEFT(CCCGC, 10), MIN(CCFAN), MAX(CCFAN), MIN([CCNOM]), MAX([CCNOM]), COUNT(*)
FROM [GPIMAC_Altamira].[dbo].[CACLI] 
GROUP BY LEFT(CCCGC, 10)
ORDER BY COUNT(*) DESC

SELECT C.Code, C.Name, S.Acronym FROM GestaoApp2.Location.City C INNER JOIN GestaoApp2.Location.State S ON C.[Location.State.Id] = S.Id WHERE C.Name like '%TRINDADE%'
SELECT C.Code, C.Name, S.Acronym FROM GestaoApp2.Location.City C INNER JOIN GestaoApp2.Location.State S ON C.[Location.State.Id] = S.Id WHERE C.Name like '%PORTO VELHO%'
SELECT C.Code, C.Name, S.Acronym FROM GestaoApp2.Location.City C INNER JOIN GestaoApp2.Location.State S ON C.[Location.State.Id] = S.Id WHERE C.Name like '%AGOSTINHO%'
SELECT C.Code, C.Name, S.Acronym FROM GestaoApp2.Location.City C INNER JOIN GestaoApp2.Location.State S ON C.[Location.State.Id] = S.Id WHERE C.Name like '%MO%' AND C.Name like '%GUACU%'
SELECT C.Code, C.Name, S.Acronym FROM GestaoApp2.Location.City C INNER JOIN GestaoApp2.Location.State S ON C.[Location.State.Id] = S.Id WHERE C.Name like '%LAGO%' AND C.Name like '%NORTE%'
*/
/*
UPDATE GPIMAC_Altamira.[dbo].[CACLI] SET CCCIDIBGECOD = 2602902
WHERE LTRIM(RTRIM(CCCID)) = 'SANTO AGOSTINHO'

UPDATE GPIMAC_Altamira.[dbo].[CACLI] SET CCCIDIBGECOD = 3551009
WHERE CCCIDIBGECOD = 35510093

UPDATE GPIMAC_Altamira.[dbo].[CACLI] SET CCCIDIBGECOD = 1100205
WHERE [CCPc0Cod] = 2468
*/
