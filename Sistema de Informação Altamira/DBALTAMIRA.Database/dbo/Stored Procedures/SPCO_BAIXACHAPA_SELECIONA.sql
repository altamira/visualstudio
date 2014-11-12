
/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_SELECIONA    Script Date: 25/08/1999 20:11:38 ******/
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

