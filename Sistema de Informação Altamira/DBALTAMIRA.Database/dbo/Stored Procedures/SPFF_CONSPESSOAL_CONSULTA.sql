
/****** Object:  Stored Procedure dbo.SPFF_CONSPESSOAL_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CONSPESSOAL_CONSULTA    Script Date: 25/08/1999 20:11:34 ******/
CREATE PROCEDURE SPFF_CONSPESSOAL_CONSULTA

@Data      smalldatetime

AS

BEGIN

Select AuxTotPess =  ISNULL(sum(cpps_Valor), 0)
    From CP_Pessoais
    Where cpps_Data = @Data 
      

END	

