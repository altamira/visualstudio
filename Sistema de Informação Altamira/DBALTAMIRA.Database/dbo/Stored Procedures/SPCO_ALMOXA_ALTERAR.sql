
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_ALTERAR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_ALTERAR    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPCO_ALMOXA_ALTERAR
	
	@Codigo    char(9),
	@Descricao char(100),
	@Unidade   char(2),
	@Saldo	  float,
	@QtdMinima int,
	@Pasta     tinyint,
             @Servico   tinyint,
	@Valor     money

AS


BEGIN


	UPDATE CO_Almoxarifado
	   SET coal_Descricao = @Descricao,
	       coal_Unidade   = @Unidade,
	       coal_Saldo     = @Saldo,
	       coal_QtdMinima = @QtdMinima,
	       coal_Pasta     = @Pasta,
                    coal_Servico   = @Servico,
  	       coal_Valor     = @Valor 
         WHERE coal_Codigo = @Codigo

END



