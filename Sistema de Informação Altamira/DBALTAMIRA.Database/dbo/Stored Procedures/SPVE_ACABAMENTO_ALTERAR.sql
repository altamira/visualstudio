
/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_ALTERAR    Script Date: 25/08/1999 20:11:26 ******/
CREATE PROCEDURE SPVE_ACABAMENTO_ALTERAR
	
	@Codigo    tinyint,
	@Descricao varchar(46),
    @Custo     float 

AS

BEGIN

	UPDATE VE_Acabamento

	   SET veac_Descricao = @Descricao,
           veac_Custo = @Custo

         WHERE veac_Codigo = @Codigo

END


