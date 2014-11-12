
CREATE VIEW [dbo].[View_EstCaPro]
AS
	SELECT  
	CEMPCOD VwEstCEmpCod, 
	CPROCOD VwEstCProCod, 
	CPRONOM VwEstCProNom, 
	ISNULL(( SELECT TOP (01) 
	              CASE WHEN MovTra = 'E' THEN MovEstAnt + MovQtd 
	              ELSE                        MovEstAnt - MovQtd 
	              END AS Est
             FROM dbo.LAMOVEST
             WHERE (MovProCod = CAPRO.CPROCOD) 
             AND   (MovProTip = 'PR') 
             AND   (MOVEMP    = CAEMP.CEMPCOD)
             ORDER BY MovProCod ASC, 
                      MovProTip ASC, 
                      MOVEMP    ASC, 
                      MOVLAN    DESC), 0) AS VwEstCProEst
                      
FROM dbo.CAPRO
CROSS JOIN CAEMP




GO
GRANT SELECT
    ON OBJECT::[dbo].[View_EstCaPro] TO [interclick]
    AS [dbo];

