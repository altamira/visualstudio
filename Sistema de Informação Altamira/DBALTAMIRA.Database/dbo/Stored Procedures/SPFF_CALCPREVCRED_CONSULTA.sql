
/****** Object:  Stored Procedure dbo.SPFF_CALCPREVCRED_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CALCPREVCRED_CONSULTA    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_CALCPREVCRED_CONSULTA    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_CALCPREVCRED_CONSULTA

    @Data     Smalldatetime

AS


BEGIN

    SELECT ffpr_Descricao,
           ffpr_Valor
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'C' 
       AND ffpr_Data = @Data

END


