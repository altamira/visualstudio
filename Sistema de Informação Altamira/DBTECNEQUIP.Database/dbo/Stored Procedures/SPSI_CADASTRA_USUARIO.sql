
/****** Object:  Stored Procedure dbo.SPSI_CADASTRA_USUARIO    Script Date: 23/10/2010 15:32:32 ******/

/****** Object:  Stored Procedure dbo.SPSI_CADASTRA_USUARIO    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPSI_CADASTRA_USUARIO    Script Date: 13/08/1998 09:19:08 ******/
CREATE PROCEDURE SPSI_CADASTRA_USUARIO

   @Nome          char(20),
   @NomeCompleto  varchar(40),
   @Departamento  varchar(20),
   @Senha         char(45)

AS
	
BEGIN

   DECLARE @Codigo     int


   SELECT @Codigo = sius_Codigo + 1
     FROM SI_Usuario


   INSERT INTO SI_Usuario (sius_Codigo,
                           sius_Nome, 
                           sius_NomeCompleto,
                           sius_Departamento,
                           sius_Senha)

                VALUES (@Codigo,
                        @Nome,
                        @NomeCompleto,
                        @Departamento,
                        @Senha)
                                                   

END



