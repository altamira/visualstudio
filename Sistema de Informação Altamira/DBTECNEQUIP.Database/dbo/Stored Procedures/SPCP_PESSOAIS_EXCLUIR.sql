
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_EXCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_EXCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_EXCLUIR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_PESSOAIS_EXCLUIR

	@Sequencia  int

AS

BEGIN

	DELETE FROM CP_Pessoais
	      WHERE cpps_Sequencia = @Sequencia

END


