
/****** Object:  Stored Procedure dbo.SPCP_OPATUALIZA_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPCP_OPATUALIZA_RELATORIO    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_OPATUALIZA_RELATORIO
	@Codigo       	char(14),
        	@TipoNota     	char(1),
        	@NotaFiscal   	char(6),
        	@Pedido       	int

        
AS

DECLARE

        	@NumeroOP   	int 

BEGIN

          Select @NumeroOP = SI_Valor + 1
             From SI_Auxiliar
             Where si_Nome = 'cpop_NumeroOP'

          		Update SI_Auxiliar 
              	Set si_Valor = si_Valor + 1
             		Where si_Nome = 'cpop_NumeroOP'

          		Update CP_NotaFiscalDetalhe 
             		Set 	cpnd_NumeroOP = @NumeroOP,
                 		cpnd_DataOP = GetDate()
             		Where 	cpnd_Fornecedor = @Codigo
               	And 	cpnd_TipoNota = @TipoNota
               	And 	cpnd_NotaFiscal = @NotaFiscal
               	And 	cpnd_Pedido = @Pedido

END	






