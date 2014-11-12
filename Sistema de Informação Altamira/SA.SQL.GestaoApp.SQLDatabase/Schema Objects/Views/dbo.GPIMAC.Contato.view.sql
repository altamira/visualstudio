CREATE VIEW [dbo].[GPIMAC.Contato]
AS
SELECT     Pc0Cod AS Cliente, Pc1Cod AS Codigo, Pc1Nom AS Nome, Pc1TelDdd AS [Telefone.CodigoArea], Pc1TelNum AS [Telefone.Numero], Pc1TelRam AS [Telefone.Ramal], 
                      Pc1FaxDdd AS [Fax.CodigoArea], Pc1FaxNum AS [Fax.Numero], Pc1FaxRam AS [Fax.Ramal], Pc1CelDdd AS [Celular.CodigoArea], Pc1CelNum AS [Celular.Numero], 
                      Pc1Dep AS Departamento, Pc1Cgo AS Cargo, Pc1Eml AS Email
FROM         GPIMAC_Altamira.dbo.CAPCL1 AS Contato










