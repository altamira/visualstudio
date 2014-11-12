
/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_VISUALIZA    Script Date: 25/08/1999 20:11:25 ******/
CREATE PROCEDURE SPCR_RECIBOS_VISUALIZA

AS

BEGIN


    Select crre_Numero  'Recibo', 
           crre_DataRecibo  'Data', 
           vecl_Nome  'Cliente', 
           'R$ ' + Convert(varchar, Round(crre_ValorRecibo, 2)) 'Valor Total' 
      
       From CR_Recibos, 
            VE_Clientes

        Where  crre_Cliente = vecl_Codigo
     
           Order By crre_Numero

END


