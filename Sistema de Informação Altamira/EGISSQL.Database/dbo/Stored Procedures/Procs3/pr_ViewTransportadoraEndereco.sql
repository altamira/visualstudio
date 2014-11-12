

/****** Object:  Stored Procedure dbo.pr_ViewTransportadoraEndereco    Script Date: 13/12/2002 15:08:10 ******/
CREATE PROCEDURE pr_ViewTransportadoraEndereco
@cd_transportadora int
AS
  
SELECT  Transportadora.cd_transportadora, Transportadora.nm_transportadora, Transportadora.nm_fantasia, Transportadora_Endereco.cd_cnpj, 
        Transportadora_Endereco.cd_insc_estadual, Transportadora_Endereco.cd_insc_municipal, Transportadora_Endereco.cd_cep, Pais.nm_pais, 
        Estado.nm_estado, Cidade.nm_cidade, Transportadora_Endereco.nm_bairro, Transportadora_Endereco.nm_complemento_endereco, 
        Transportadora_Endereco.cd_numero_endereco, Transportadora_Endereco.nm_endereco, Transportadora_Endereco.cd_ddd, 
        Transportadora_Endereco.cd_telefone, Transportadora_Endereco.cd_fax
FROM    Transportadora_Endereco INNER JOIN
        Transportadora ON Transportadora_Endereco.cd_transportadora = Transportadora.cd_transportadora INNER JOIN
        Pais ON Transportadora_Endereco.cd_pais = Pais.cd_pais INNER JOIN
        Estado ON Transportadora_Endereco.cd_estado = Estado.cd_estado AND Pais.cd_pais = Estado.cd_pais INNER JOIN
        Cidade ON Transportadora_Endereco.cd_cidade = Cidade.cd_cidade AND Estado.cd_estado = Cidade.cd_estado
WHERE   (Transportadora.cd_transportadora = @cd_transportadora)


