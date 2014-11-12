
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_ALTERAR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_ALTERAR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_ALTERAR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_PESSOAIS_ALTERAR
	
	@Sequencia  int,
    @Data       smalldatetime,
	@Valor      money,
    @Descricao  varchar(40)
	
AS

BEGIN

	UPDATE CP_Pessoais
	   SET cpps_Data      = @Data,
	       cpps_Valor     = @Valor,
	       cpps_Descricao = @Descricao
         WHERE cpps_Sequencia= @Sequencia

END

