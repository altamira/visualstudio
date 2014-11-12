
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_ALTERAR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_ALTERAR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_ALTERAR    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_ALMOXA_ALTERAR
	
	@Codigo    char(9),
	@Descricao char(40),
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

