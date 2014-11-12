CREATE VIEW [dbo].[GPIMAC.PreCliente]
AS
SELECT     Pc0Cod AS Codigo, Pc0Cnpj AS CNPJ, Pc0IE AS InscricaoEstadual, Pc0Fan AS NomeFantasia, Pc0Nom AS Nome, Pc0LogTipCod AS [Endereco.TipoLogradouro.Codigo],
                       Pc0End AS [Endereco.Logradouro], Pc0EndNum AS [Endereco.Numero], Pc0EndCpl AS [Endereco.Complemento], Pc0Bai AS [Endereco.Bairro], 
                      Pc0Cid AS [Endereco.Cidade], Pc0UfCod AS [Endereco.UF], Pc0Cep AS [Endereco.CodigoPostal], Pc0TelDdd AS [Telefone.CodigoArea], 
                      Pc0TelNum AS [Telefone.Numero], Pc0TelRam AS [Telefone.Ramal], Pc0FaxDdd AS [Fax.CodigoArea], Pc0FaxNum AS [Fax.Numero], Pc0FaxRam AS [Fax.Ramal], 
                      Pc0CvCod AS [Vendedor.Codigo], Pc0Url AS Url, Pc0Eml AS Email, Pc0Ind AS Indicacao, Pc0Obs AS Observacao, Pc0Prf AS ClientePreferencial, 
                      Pc0VisPer AS PeriodicidadeVisitas, PC0Cla AS Classificacao, Pc0Tip AS Tipo
FROM         GPIMAC_Altamira.dbo.CAPCL AS PreCliente










