
/****** Object:  Stored Procedure dbo.SPCP_SINALLIMPA_EXECUTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_SINALLIMPA_EXECUTA    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_SINALLIMPA_EXECUTA    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_SINALLIMPA_EXECUTA

    

AS


BEGIN

    DELETE FROM CP_SinalPedido 
          WHERE cpsp_Exclusao = 1


END

