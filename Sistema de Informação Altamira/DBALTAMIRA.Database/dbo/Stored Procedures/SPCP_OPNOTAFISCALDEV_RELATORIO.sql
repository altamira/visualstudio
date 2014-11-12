
/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALDEV_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/

/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALDEV_RELATORIO    Script Date: 25/10/2001 20:11:55 ******/
CREATE PROCEDURE SPCP_OPNOTAFISCALDEV_RELATORIO

	@NumeroOP 	int

AS

BEGIN
          	Update SI_Auxiliar 
             	Set si_Valor = @NumeroOp
             	Where si_Nome = 'cpop_NumeroOP'

          	Update CP_NotaFiscalDetalhe 
             Set 	cpnd_NumeroOP 	= Null ,
                 	cpnd_DataOP 		= Null
             	Where 	cpnd_NumeroOp           >  @NumeroOP
END



