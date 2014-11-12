
/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_SELECIONA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_SELECIONA    Script Date: 16/10/01 13:41:43 ******/
/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_SELECIONA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_BAIXACHAPA_SELECIONA

AS
	
BEGIN

      SELECT coal_Codigo,
             coal_Descricao,
             coal_Unidade, 
             coal_Saldo

         FROM CO_Almoxarifado 
             
         WHERE SUBSTRING(coal_Codigo, 1, 3) = 'WCB'

         AND coal_Saldo > 0

END

