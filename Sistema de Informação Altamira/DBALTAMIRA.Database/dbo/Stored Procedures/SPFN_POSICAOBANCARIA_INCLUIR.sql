
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_INCLUIR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_INCLUIR

	@Banco         char(3),
             @Data         smalldatetime,
	@Valor         money
AS


BEGIN
	INSERT INTO FN_PosBancaria (fnpb_Banco,
			                    	fnpb_Data,
				          	fnpb_Valor)
                           				           
		      VALUES (	@Banco,
			          	@Data,
                      			@Valor)

END



