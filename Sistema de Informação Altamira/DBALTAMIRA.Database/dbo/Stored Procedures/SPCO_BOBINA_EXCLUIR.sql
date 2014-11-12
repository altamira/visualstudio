
/****** Object:  Stored Procedure dbo.SPCO_BOBINA_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE SPCO_BOBINA_EXCLUIR
	(@CodBobina 	char)

AS 
DELETE From CO_Bobina

WHERE 
	(CodBobina	 = @CodBobina)
DELETE From CO_PlanoDeCorte
  	Where
		(CodBobina = @CodBobina)




