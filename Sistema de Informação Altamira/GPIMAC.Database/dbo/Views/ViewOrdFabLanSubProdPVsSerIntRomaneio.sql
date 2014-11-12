﻿ CREATE VIEW [ViewOrdFabLanSubProdPVsSerIntRomaneio] AS SELECT OPROMITEM.OPR1OPEmp, OPROMITEM.OPR1OPCod, OPROMITEM.OPR1CPbCod, OPROM.OPR0CSerCod, ISNULL(SUM(DISTINCT OPROMITEM.OPR1Qtd), 0) AS Op0QtdPrd, ISNULL(SUM(OPROMITEMBAIXA.OPR2BaiQtd), 0) AS Opr0QtdBai, CASE     WHEN ISNULL(SUM(DISTINCT OPROMITEM.OPR1Qtd), 0) - ISNULL(SUM(OPROMITEMBAIXA.OPR2BaiQtd), 0) > 0          THEN ISNULL(SUM(DISTINCT OPROMITEM.OPR1Qtd), 0) - ISNULL(SUM(OPROMITEMBAIXA.OPR2BaiQtd), 0)          ELSE 0 END AS Opr0QtdSal, MAX(DISTINCT CAPRO_SUBPRODUTO.CPROPES) AS Opr0PesUni, MAX(DISTINCT CAPRO_SUBPRODUTO.CPROPES) * ISNULL(SUM(DISTINCT OPROMITEM.OPR1Qtd ), 0) AS Opr0PesTotPrd, MAX(DISTINCT CAPRO_SUBPRODUTO.CPROPES) * ISNULL(SUM(OPROMITEMBAIXA.OPR2BaiQtd  ), 0) AS Opr0PesTotBai, MAX(DISTINCT CAPRO_SUBPRODUTO.CPROPES) * ISNULL(SUM(DISTINCT OPROMITEM.OPR1Qtd ), 0) -  MAX(DISTINCT CAPRO_SUBPRODUTO.CPROPES) * ISNULL(SUM(OPROMITEMBAIXA.OPR2BaiQtd  ), 0) AS Opr0PesTotSal FROM              OPROM INNER  JOIN       OPROMITEM ON     OPROM.OPR0Emp           = OPROMITEM.OPR0Emp AND    OPROM.OPR0Cod           = OPROMITEM.OPR0Cod INNER  JOIN  CAPRO AS CAPRO_SUBPRODUTO ON     OPROMITEM.OPR1CPbCod    = CAPRO_SUBPRODUTO.CPROCOD LEFT   OUTER JOIN OPROMITEMBAIXA ON     OPROMITEM.OPR0Emp       = OPROMITEMBAIXA.OPR0Emp AND    OPROMITEM.OPR0Cod       = OPROMITEMBAIXA.OPR0Cod AND    OPROMITEM.OPR1OPEmp     = OPROMITEMBAIXA.OPR1OPEmp AND    OPROMITEM.OPR1OPCod     = OPROMITEMBAIXA.OPR1OPCod AND    OPROMITEM.OPR1CPbCod    = OPROMITEMBAIXA.OPR1CPbCod WHERE (OPROMITEM.OPR1Ini       = 'S') GROUP BY OPROMITEM.OPR1OPEmp, OPROMITEM.OPR1OPCod, OPROMITEM.OPR1CPbCod, OPROM.OPR0CSerCod
GO
GRANT SELECT
    ON OBJECT::[dbo].[ViewOrdFabLanSubProdPVsSerIntRomaneio] TO [interclick]
    AS [dbo];

