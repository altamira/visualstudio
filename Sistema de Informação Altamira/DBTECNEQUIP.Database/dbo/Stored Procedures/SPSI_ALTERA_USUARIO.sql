
/****** Object:  Stored Procedure dbo.SPSI_ALTERA_USUARIO    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPSI_ALTERA_USUARIO    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPSI_ALTERA_USUARIO    Script Date: 13/08/1998 09:19:08 ******/
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


