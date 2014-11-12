
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_ALTERAR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_ALTERAR
	
	@Banco            char(3),
	@Data             smalldatetime,
	@Valor            money

AS

BEGIN

	UPDATE FN_PosBancaria
	   SET fnpb_Valor = @Valor
         WHERE fnpb_Banco = @Banco
           And fnpb_Data  = @Data

END

