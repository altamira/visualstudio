
/****** Object:  Stored Procedure dbo.SPVE_INDICES_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_INDICES_ALTERAR    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_INDICES_ALTERAR
	
	@Codigo        tinyint,
	@Inflacao      numeric(6,3),
	@Juros         numeric(6,3),
	@Icms          numeric(6,3),
	@Iss           numeric(6,3),
    	@Cofins        numeric(6,3),
	@Pis           numeric(6,3),
    	@Montagem      numeric(6,3),
    	@Transporte      numeric(6,3),
    	@Outros      numeric(6,3),
    	@Embalagem      numeric(6,3),
    	@Terceirizacao     numeric(6,3),
    	@Comissao      numeric(6,3)
AS
BEGIN
	UPDATE VE_IndicesFinanceiros
	   SET vein_Inflacao   = @Inflacao,
	       vein_Juros      = @Juros,
	       vein_Icms       = @Icms,
	       vein_Iss        = @Iss,
	       vein_Cofins     = @Cofins,
           	vein_Pis        = @Pis,
           	vein_Montagem   = @Montagem,
           	vein_Transporte   = @Transporte,
           	vein_Outros 	= @Outros,
          	vein_Embalagem 	= @Embalagem,
           	vein_Terceirizacao =  @Terceirizacao,
           	vein_Comissao   = @Comissao
          
         WHERE vein_Codigo = @Codigo

END




