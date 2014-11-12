
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_TESTE    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_TESTE    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_TESTE

AS
Declare
	@Banco         char(3),
             @DataVcto     smalldatetime,
             @DataPgto     smalldatetime,
             @Data         smalldatetime,
	@Valor         money



BEGIN
	SELECT @Banco  	=  crnd_banco, 
		 @Valor		=  crnd_valortotal, 
                           @Data 		=  CASE crnd_datavencimento 
                              when null  THEN  crnd_datapagamento
	                 else  crnd_datavencimento
                           END
	FROM CR_NotasFiscaisDetalhe
	WHERE crnd_datapagamento IS NULL AND 
	    	  crnd_tipooperacao = 1
	ORDER BY crnd_banco, crnd_datavencimento


	INSERT INTO FN_PosBancaria (fnpb_Banco,
			                    	fnpb_Data,
				          	fnpb_Valor)
                           				           
		      VALUES (	@Banco,
			          	@Data,
                      			@Valor)

END


