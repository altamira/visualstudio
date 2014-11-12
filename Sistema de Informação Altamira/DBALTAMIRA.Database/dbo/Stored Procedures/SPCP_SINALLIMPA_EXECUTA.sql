
/****** Object:  Stored Procedure dbo.SPCP_SINALLIMPA_EXECUTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_SINALLIMPA_EXECUTA    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_SINALLIMPA_EXECUTA

AS


BEGIN

    DELETE FROM CP_SinalPedido 
          WHERE cpsp_Exclusao = '1'


END

