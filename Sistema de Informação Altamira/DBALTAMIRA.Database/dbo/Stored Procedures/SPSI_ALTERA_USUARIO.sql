
/****** Object:  Stored Procedure dbo.SPSI_ALTERA_USUARIO    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPSI_ALTERA_USUARIO    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPSI_ALTERA_USUARIO

   @Codigo        int,
   @Nome          char(20),
   @NomeCompleto  varchar(40),
   @Departamento  varchar(20),
   @Senha         char(45)

AS
	
BEGIN

   UPDATE SI_Usuario
      SET sius_Nome = @Nome,
          sius_NomeCompleto = @NomeCompleto,
          sius_Departamento = @Departamento,
          sius_Senha = @Senha
    WHERE sius_Codigo = @Codigo

END


