
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_INCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_PESSOAIS_INCLUIR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_PESSOAIS_INCLUIR 

	@Sequencia  int,
    @Data       smalldatetime,
	@Valor      money,
    @Descricao  varchar(40)

AS

BEGIN

	INSERT INTO CP_Pessoais(cpps_Sequencia,
			                cpps_Data,
				            cpps_Valor,
				            cpps_Descricao)
		      VALUES (@Sequencia,
                      @Data,
                      @Valor,
   		              @Descricao)

END			      
      

