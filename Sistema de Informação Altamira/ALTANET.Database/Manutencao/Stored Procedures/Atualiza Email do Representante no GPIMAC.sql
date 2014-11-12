
CREATE PROCEDURE [Manutencao].[Atualiza Email do Representante no GPIMAC]
AS

UPDATE CAREP
SET CVMAIL = ALTANET.dbo.Representante.Email
--SELECT GPIMAC_Altamira.dbo.CAREP.CVCOD, ALTANET.dbo.Representante.Email
FROM 
	ALTANET.dbo.Representante INNER JOIN GPIMAC_Altamira.dbo.CAREP 
	ON ALTANET.dbo.Representante.Código = GPIMAC_Altamira.dbo.CAREP.CVCOD
	
