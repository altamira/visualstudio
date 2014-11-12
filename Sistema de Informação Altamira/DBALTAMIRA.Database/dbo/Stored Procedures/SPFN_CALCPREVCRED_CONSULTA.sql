
/****** Object:  Stored Procedure dbo.SPFN_CALCPREVCRED_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_CALCPREVCRED_CONSULTA    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFN_CALCPREVCRED_CONSULTA

    @Data     Smalldatetime

AS


BEGIN

    SELECT fnpr_Descricao,
           fnpr_Valor
      FROM FN_Previsao
     WHERE fnpr_Tipo = 'C' 
       AND fnpr_Data = @Data

END

