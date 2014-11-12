

CREATE PROCEDURE [Manutencao].[Atualiza Celular do Representante no GPIMAC]
AS

UPDATE GPIMAC_Altamira.dbo.CAREP
--SET CVMAIL = ALTANET.dbo.Representante.Email
--SELECT GPIMAC_Altamira.dbo.CAREP.CVCOD, ALTANET.dbo.Representante.Email
	SET	GPIMAC_Altamira.dbo.CAREP.CVDD3 = Representante.[Telefones de Contato].value('(/Fone/AreaCode/text())[1]', 'NVARCHAR(3)'),
	GPIMAC_Altamira.dbo.CAREP.CVFON2 =	Representante.[Telefones de Contato].value('(/Fone/Prefix/text())[1]', 'NVARCHAR(5)') + 
				Representante.[Telefones de Contato].value('(/Fone/Number/text())[1]', 'NVARCHAR(4)')
FROM 
	ALTANET.dbo.Representante INNER JOIN GPIMAC_Altamira.dbo.CAREP 
	ON ALTANET.dbo.Representante.Código = GPIMAC_Altamira.dbo.CAREP.CVCOD
	

